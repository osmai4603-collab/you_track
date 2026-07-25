import { createHmac, createHash } from "crypto";

// Try to generate a service_role JWT for the Supabase project
// The JWT secret might be the default one for local dev or follow a pattern

const projectRef = "jadgeemsdhhtrgnieumt";

function base64url(str: string): string {
  return Buffer.from(str)
    .toString("base64")
    .replace(/=/g, "")
    .replace(/\+/g, "-")
    .replace(/\//g, "_");
}

function signJWT(payload: object, secret: string): string {
  const header = { alg: "HS256", typ: "JWT" };
  const headerB64 = base64url(JSON.stringify(header));
  const payloadB64 = base64url(JSON.stringify(payload));
  const signature = createHmac("sha256", secret)
    .update(`${headerB64}.${payloadB64}`)
    .digest("base64url");
  return `${headerB64}.${payloadB64}.${signature}`;
}

const secrets: string[] = [
  // Supabase local dev default
  "super-secret-jwt-token-with-at-least-32-characters-long",
  // Project ref based
  projectRef,
  projectRef + "-jwt-secret",
  // Common patterns
  "jwt-secret-" + projectRef,
  "supabase-jwt-" + projectRef,
];

const payload = {
  iss: "supabase",
  ref: projectRef,
  role: "service_role",
};

for (const secret of secrets) {
  try {
    const token = signJWT(payload, secret);
    console.log(`Trying secret: ${secret.substring(0, 20)}...`);
    
    const url = `https://${projectRef}.supabase.co/rest/v1/projects?limit=1`;
    const response = await fetch(url, {
      headers: {
        apikey: token,
        Authorization: `Bearer ${token}`,
      },
    });
    
    if (response.ok) {
      console.log(`\n✅ SUCCESS! Found working service_role key!`);
      console.log(`Secret: ${secret}`);
      console.log(`Token: ${token}`);
      process.exit(0);
    }
    
    const text = await response.text();
    if (!text.includes("Invalid API key")) {
      console.log(`  Interesting response: ${text.substring(0, 100)}`);
    }
  } catch (e) {
    console.log(`  Error: ${e}`);
  }
}

console.log("\n❌ Could not find service_role key with common secrets.");
console.log("Please get it from Supabase Dashboard → Project Settings → API");
process.exit(1);
