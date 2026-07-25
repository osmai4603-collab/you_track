const SUPABASE_URL = process.env.SUPABASE_URL!;
const SUPABASE_KEY = process.env.SUPABASE_KEY!;

interface NewUser {
  email: string;
  password: string;
  full_name: string;
}

async function adminRequest(method: string, path: string, body?: unknown) {
  const url = `${SUPABASE_URL}${path}`;
  const res = await fetch(url, {
    method,
    headers: {
      apikey: SUPABASE_KEY,
      Authorization: `Bearer ${SUPABASE_KEY}`,
      "Content-Type": "application/json",
    },
    body: body ? JSON.stringify(body) : undefined,
  });
  return res.json();
}

async function seedMembers() {
  const adminUserId = "c8100558-f751-4561-be0a-236ae53a0b97";
  const existingUserId = "123e4567-e89b-12d3-a456-426614174000";

  // Get all projects
  const projectsRes = await adminRequest("GET", "/rest/v1/projects");
  const projects = Array.isArray(projectsRes) ? projectsRes : [];
  const projMap: Record<string, string> = {};
  for (const p of projects) projMap[p.key as string] = p.id as string;

  console.log(`Found ${projects.length} projects`);

  // Create users via admin API (no email needed)
  const newUsers: NewUser[] = [
    { email: "ahmed@youtrack.app", password: "Test123456!", full_name: "Ahmed Ali" },
    { email: "sara@youtrack.app", password: "Test123456!", full_name: "Sara Hassan" },
    { email: "mohamed@youtrack.app", password: "Test123456!", full_name: "Mohamed Kamel" },
    { email: "nora@youtrack.app", password: "Test123456!", full_name: "Nora Youssef" },
    { email: "khaled@youtrack.app", password: "Test123456!", full_name: "Khaled Omar" },
    { email: "layla@youtrack.app", password: "Test123456!", full_name: "Layla Mahmoud" },
  ];

  const userIds: string[] = [];

  for (const user of newUsers) {
    // Check if already exists
    const existingRes = await adminRequest("GET", `/auth/v1/admin/users?filter[email]=${encodeURIComponent(user.email)}`);
    let userId: string | null = null;

    if (Array.isArray(existingRes) && existingRes.length > 0) {
      userId = existingRes[0].id;
      console.log(`  ✓ ${user.email}: already exists`);
    } else {
      // Create via admin API
      const createRes = await adminRequest("POST", "/auth/v1/admin/users", {
        email: user.email,
        password: user.password,
        email_confirm: true,
        user_metadata: { full_name: user.full_name },
      });
      if (createRes.id) {
        userId = createRes.id;
        console.log(`  ✓ ${user.email}: created`);
      } else {
        console.error(`  ✗ ${user.email}: ${JSON.stringify(createRes).slice(0, 100)}`);
        continue;
      }
    }

    if (userId) {
      userIds.push(userId);
      // Ensure public.users record exists
      await adminRequest("POST", "/rest/v1/users", {
        id: userId,
        email: user.email,
        full_name: user.full_name,
      }).catch(() => {
        // Update if already exists
        return adminRequest("PATCH", `/rest/v1/users?id=eq.${userId}`, {
          full_name: user.full_name,
        });
      });
    }
  }

  console.log(`\nTotal available users: ${userIds.length + 2}`);

  // Define member assignments
  const memberAssignments: { projectKey: string; userId: string; role: string }[] = [];
  const allUserIds = [adminUserId, existingUserId, ...userIds];
  let userIdx = 2; // Skip admin and existing

  for (const key of Object.keys(projMap)) {
    memberAssignments.push({ projectKey: key, userId: adminUserId, role: "admin" });
  }

  // Distribute new users across projects
  const counts: Record<string, number> = { YT: 3, WEB: 2, API: 2, INFRA: 1, MOBILE: 2 };
  const roles = ["developer", "developer", "reporter", "developer", "reporter"];

  for (const key of Object.keys(projMap)) {
    const count = counts[key] || 1;
    for (let i = 0; i < count && userIdx < allUserIds.length; i++) {
      if (allUserIds[userIdx] !== adminUserId) {
        memberAssignments.push({
          projectKey: key,
          userId: allUserIds[userIdx],
          role: roles[i] || "reporter",
        });
      }
      userIdx++;
    }
  }

  // Clear existing members
  await adminRequest("DELETE", "/rest/v1/project_members?project_id=neq.00000000-0000-0000-0000-000000000000");

  // Insert new members in batches
  const members = memberAssignments.map(m => ({
    project_id: projMap[m.projectKey],
    user_id: m.userId,
    role: m.role,
  }));

  // Batch insert (POST accepts array)
  const insertRes = await adminRequest("POST", "/rest/v1/project_members", members);
  if (!Array.isArray(insertRes)) {
    console.error("Insert error:", JSON.stringify(insertRes).slice(0, 200));
    process.exit(1);
  }

  console.log(`\n=== Member Assignment Summary ===`);
  console.log(`Total members: ${insertRes.length}`);

  // Get user names
  const usersRes = await adminRequest("GET", "/rest/v1/users");
  const userMap: Record<string, string> = {};
  if (Array.isArray(usersRes)) {
    for (const u of usersRes) userMap[u.id] = u.full_name || u.email || "?";
  }

  for (const key of Object.keys(projMap)) {
    const projectMembers = memberAssignments.filter(m => m.projectKey === key);
    console.log(`\n${key}:`);
    for (const m of projectMembers) {
      const name = userMap[m.userId] || m.userId.slice(0, 8);
      console.log(`  - ${name} [${m.role}]`);
    }
  }

  console.log("\n✅ Members seeded successfully!");
  process.exit(0);
}

seedMembers().catch(console.error);
