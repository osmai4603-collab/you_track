import { createClient } from "@supabase/supabase-js";
import { readFileSync } from "fs";

const SUPABASE_URL = process.env.SUPABASE_URL!;
const SUPABASE_KEY = process.env.SUPABASE_KEY!;

const supabase = createClient(SUPABASE_URL, SUPABASE_KEY, {
  auth: { persistSession: false },
});

async function seed() {
  // Try anonymous sign-in (may work for some keys)
  const { data: authData } = await supabase.auth.signInAnonymously();
  const userId = authData?.user?.id || "c8100558-f751-4561-be0a-236ae53a0b97";
  console.log(`Using user: ${userId}`);

  // 1. Insert settings
  console.log("\n1. Inserting settings...");
  const settings = [
    { key: "app_name", value: "YouTrack", description: "Application display name", updated_by: userId },
    { key: "default_priority", value: "Normal", description: "Default priority for new issues", updated_by: userId },
    { key: "default_issue_type", value: "Task", description: "Default type for new issues", updated_by: userId },
    { key: "max_attachments_size_mb", value: "10", description: "Maximum attachment size in MB", updated_by: userId },
    { key: "issue_auto_numbering", value: "true", description: "Auto-generate issue sequence numbers", updated_by: userId },
    { key: "allow_guest_access", value: "false", description: "Allow unauthenticated users to view issues", updated_by: userId },
  ];

  const { error: sErr } = await supabase.from("settings").upsert(
    settings.map(s => ({ ...s })),
    { onConflict: "key", ignoreDuplicates: false }
  );
  if (sErr) {
    console.error("  settings error:", sErr.message);
    console.error("  (table may not exist yet - run SQL from supabase/migrations/20260725000001_create_settings_table.sql)");
  } else {
    console.log(`  ✓ ${settings.length} settings inserted`);
  }

  // 2. Insert projects
  console.log("\n2. Inserting projects...");
  const projects = [
    { key: "YT", name: "YouTrack Mobile", description: "Mobile application for YouTrack issue tracking", owner_id: userId },
    { key: "WEB", name: "Website Redesign", description: "Complete redesign of the company website", owner_id: userId },
    { key: "API", name: "API Gateway", description: "Internal API gateway service for microservices", owner_id: userId },
    { key: "INFRA", name: "Infrastructure", description: "Cloud infrastructure and DevOps tasks", owner_id: userId },
    { key: "MOBILE", name: "Mobile App v2", description: "Version 2 of the mobile application", owner_id: userId },
  ];

  const { data: projData, error: pErr } = await supabase.from("projects").insert(projects).select();
  if (pErr) {
    console.error("  projects error:", pErr.message);
    process.exit(1);
  }
  console.log(`  ✓ ${projData.length} projects inserted`);

  const projMap: Record<string, string> = {};
  for (const p of projData) {
    projMap[p.key as string] = p.id as string;
  }

  // 3. Insert project members
  console.log("\n3. Inserting project members...");
  const members = Object.values(projMap).map(projectId => ({
    project_id: projectId,
    user_id: userId,
    role: "admin",
  }));

  const { data: memData, error: mErr } = await supabase.from("project_members").insert(members).select();
  if (mErr) {
    console.error("  members error:", mErr.message);
    process.exit(1);
  }
  console.log(`  ✓ ${memData.length} members inserted`);

  // 4. Insert issues
  console.log("\n4. Inserting issues...");
  const issues = [
    // YT - YouTrack Mobile
    { project_id: projMap["YT"], title: "Fix login crash on Android 14", description: "App crashes on Android 14 when attempting Google sign-in", reporter_id: userId, assignee_id: userId, state: "Open", priority: "Critical", issue_type: "Bug" },
    { project_id: projMap["YT"], title: "Add dark mode support", description: "Users have requested dark mode. Follow system theme by default.", reporter_id: userId, assignee_id: userId, state: "In Progress", priority: "Normal", issue_type: "Feature" },
    { project_id: projMap["YT"], title: "Improve notification system", description: "Rewrite notification service to use FCM v2", reporter_id: userId, assignee_id: userId, state: "Open", priority: "Major", issue_type: "Task" },
    { project_id: projMap["YT"], title: "Fix pull-to-refresh animation", description: "Animation stutters on Android. Optimize timing.", reporter_id: userId, assignee_id: userId, state: "Fixed", priority: "Minor", issue_type: "Bug" },
    { project_id: projMap["YT"], title: "Add issue attachment preview", description: "Preview image attachments inline before downloading.", reporter_id: userId, assignee_id: userId, state: "Verified", priority: "Normal", issue_type: "Feature" },
    // WEB - Website Redesign
    { project_id: projMap["WEB"], title: "Update hero section design", description: "New hero section with animated background", reporter_id: userId, assignee_id: userId, state: "Open", priority: "Normal", issue_type: "Improvement" },
    { project_id: projMap["WEB"], title: "SEO optimization for product pages", description: "Add meta tags, structured data, improve load times", reporter_id: userId, assignee_id: userId, state: "Open", priority: "Major", issue_type: "Task" },
    { project_id: projMap["WEB"], title: "Fix mobile navigation menu", description: "Hamburger menu does not close when clicking outside", reporter_id: userId, assignee_id: userId, state: "In Progress", priority: "Normal", issue_type: "Bug" },
    { project_id: projMap["WEB"], title: "Implement lazy loading for images", description: "Product images should lazy load with blur placeholder", reporter_id: userId, assignee_id: userId, state: "Open", priority: "Minor", issue_type: "Improvement" },
    { project_id: projMap["WEB"], title: "Add contact form with validation", description: "Form with client/server validation, reCAPTCHA", reporter_id: userId, assignee_id: userId, state: "Open", priority: "Normal", issue_type: "Task" },
    // API - API Gateway
    { project_id: projMap["API"], title: "Rate limiting implementation", description: "Token bucket rate limiting: 1000 req/hour default", reporter_id: userId, assignee_id: userId, state: "In Progress", priority: "Critical", issue_type: "Feature" },
    { project_id: projMap["API"], title: "Add request validation middleware", description: "Validate requests with Zod schemas", reporter_id: userId, assignee_id: userId, state: "Verified", priority: "Normal", issue_type: "Task" },
    { project_id: projMap["API"], title: "Implement API key rotation", description: "Key rotation with 24h grace period", reporter_id: userId, assignee_id: userId, state: "Open", priority: "Major", issue_type: "Feature" },
    { project_id: projMap["API"], title: "Add structured request logging", description: "JSON logs with correlation IDs", reporter_id: userId, assignee_id: userId, state: "Fixed", priority: "Normal", issue_type: "Task" },
    { project_id: projMap["API"], title: "Health check endpoint", description: "/health with DB, cache, downstream checks", reporter_id: userId, assignee_id: userId, state: "Verified", priority: "Normal", issue_type: "Task" },
  ];

  const { data: issueData, error: iErr } = await supabase.from("issues").insert(issues).select();
  if (iErr) {
    console.error("  issues error:", iErr.message);
    process.exit(1);
  }
  console.log(`  ✓ ${issueData.length} issues inserted`);

  console.log("\n" + "=".repeat(50));
  console.log("✅  All data inserted successfully!");
  console.log("=".repeat(50));
  console.log(`  Settings:  ${settings.length}`);
  console.log(`  Projects:  ${projData.length}`);
  console.log(`  Members:   ${memData.length}`);
  console.log(`  Issues:    ${issueData.length}`);
  console.log("=".repeat(50));

  process.exit(0);
}

seed().catch((err) => {
  console.error("Seed failed:", err);
  process.exit(1);
});
