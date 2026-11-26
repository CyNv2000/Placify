import { spawnSync } from "node:child_process";
import { existsSync, unlinkSync, writeFileSync } from "node:fs";
import { resolve } from "node:path";

const configuredApiUrl = process.env.PLACIFY_API_URL?.trim();

if (!configuredApiUrl) {
  throw new Error(
    "PLACIFY_API_URL is required to build the production frontend. Set it to the backend API base URL ending in /api."
  );
}

let apiUrl;
try {
  apiUrl = new URL(configuredApiUrl);
} catch {
  throw new Error("PLACIFY_API_URL must be a valid absolute URL.");
}

while (apiUrl.pathname.endsWith("/")) {
  apiUrl.pathname = apiUrl.pathname.slice(0, -1);
}

if (apiUrl.protocol !== "https:" || !apiUrl.pathname.endsWith("/api")) {
  throw new Error("PLACIFY_API_URL must use HTTPS and end with /api.");
}

const generatedEnvironmentPath = resolve(
  "src/environments/environment.netlify.generated.ts"
);
const generatedEnvironment = [
  "export const environment =",
  JSON.stringify({ production: true, apiUrl: apiUrl.toString() }, null, 2),
  ";"
].join("\n") + "\n";

writeFileSync(generatedEnvironmentPath, generatedEnvironment, "utf8");

const angularCliPath = resolve("node_modules/@angular/cli/bin/ng.js");
if (!existsSync(angularCliPath)) {
  unlinkSync(generatedEnvironmentPath);
  throw new Error("Angular CLI is missing. Install frontend dependencies before building.");
}

const build = spawnSync(
  process.execPath,
  [angularCliPath, "build", ...process.argv.slice(2)],
  { stdio: "inherit" }
);

if (existsSync(generatedEnvironmentPath)) {
  unlinkSync(generatedEnvironmentPath);
}

if (build.error) {
  throw build.error;
}

process.exitCode = build.status ?? 1;
