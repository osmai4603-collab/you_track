import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";
import { createClient, SupabaseClient } from "@supabase/supabase-js";
import { z } from "zod";

const SUPABASE_URL = process.env.SUPABASE_URL!;
const SUPABASE_KEY = process.env.SUPABASE_KEY!;

if (!SUPABASE_URL || !SUPABASE_KEY) {
  console.error("Missing SUPABASE_URL or SUPABASE_KEY environment variables");
  process.exit(1);
}

const supabase: SupabaseClient = createClient(SUPABASE_URL, SUPABASE_KEY, {
  auth: { persistSession: false },
});

const isServiceRole = SUPABASE_KEY.includes("service_role");

// Try anonymous sign-in if using anon key (needed for RLS)
if (!isServiceRole) {
  supabase.auth.signInAnonymously().catch(() => {});
}

// ── Zod Schemas ──────────────────────────────────────────────────────────────
// Matches the actual DB schema (docs/schema.sql)

const ProjectCreateSchema = z.object({
  name: z.string().min(1),
  key: z.string().min(2).max(10),
  description: z.string().optional().nullable(),
  owner_id: z.string(),
});

const ProjectUpdateSchema = z.object({
  id: z.string().uuid(),
  name: z.string().optional(),
  key: z.string().optional(),
  description: z.string().optional().nullable(),
  owner_id: z.string().optional(),
});

const ProjectMemberSchema = z.object({
  project_id: z.string().uuid(),
  user_id: z.string().uuid(),
  role: z.string().default("reporter"),
});

const IssueCreateSchema = z.object({
  project_id: z.string().uuid(),
  title: z.string().min(1),
  description: z.string().optional().nullable(),
  reporter_id: z.string().uuid(),
  assignee_id: z.string().uuid().optional().nullable(),
  state: z.string().default("Open"),
  priority: z.string().default("Normal"),
  issue_type: z.string().default("Task"),
});

const IssueUpdateSchema = z.object({
  id: z.string().uuid(),
  title: z.string().optional(),
  description: z.string().optional().nullable(),
  assignee_id: z.string().uuid().optional().nullable(),
  state: z.string().optional(),
  priority: z.string().optional(),
  issue_type: z.string().optional(),
});

const SettingSchema = z.object({
  key: z.string().min(1),
  value: z.string(),
  description: z.string().optional().nullable(),
  updated_by: z.string().uuid().optional().nullable(),
});

// ── Tool Handler ─────────────────────────────────────────────────────────────

const toolHandlers: Record<string, (args: Record<string, unknown>) => Promise<{ content: { type: "text"; text: string }[] }>> = {};

// ── Projects ─────────────────────────────────────────────────────────────────

toolHandlers.list_projects = async () => {
  const { data, error } = await supabase.from("projects").select("*").order("created_at", { ascending: false });
  if (error) throw new Error(error.message);
  return { content: [{ type: "text", text: JSON.stringify(data, null, 2) }] };
};

toolHandlers.get_project = async (args) => {
  const { id } = z.object({ id: z.string().uuid() }).parse(args);
  const { data, error } = await supabase.from("projects").select("*").eq("id", id).single();
  if (error) throw new Error(error.message);
  return { content: [{ type: "text", text: JSON.stringify(data, null, 2) }] };
};

toolHandlers.create_project = async (args) => {
  const project = ProjectCreateSchema.parse(args);
  const { data, error } = await supabase.from("projects").insert(project).select().single();
  if (error) throw new Error(error.message);
  return { content: [{ type: "text", text: JSON.stringify(data, null, 2) }] };
};

toolHandlers.update_project = async (args) => {
  const { id, ...updates } = ProjectUpdateSchema.parse(args);
  const { data, error } = await supabase.from("projects").update(updates).eq("id", id).select().single();
  if (error) throw new Error(error.message);
  return { content: [{ type: "text", text: JSON.stringify(data, null, 2) }] };
};

toolHandlers.delete_project = async (args) => {
  const { id } = z.object({ id: z.string().uuid() }).parse(args);
  const { error } = await supabase.from("projects").delete().eq("id", id);
  if (error) throw new Error(error.message);
  return { content: [{ type: "text", text: JSON.stringify({ success: true, id }) }] };
};

// ── Project Members ──────────────────────────────────────────────────────────

toolHandlers.list_project_members = async (args) => {
  const { project_id } = z.object({ project_id: z.string().uuid() }).parse(args);
  const { data, error } = await supabase.from("project_members").select("*").eq("project_id", project_id);
  if (error) throw new Error(error.message);
  return { content: [{ type: "text", text: JSON.stringify(data, null, 2) }] };
};

toolHandlers.add_project_member = async (args) => {
  const member = ProjectMemberSchema.parse(args);
  const { data, error } = await supabase.from("project_members").insert(member).select().single();
  if (error) throw new Error(error.message);
  return { content: [{ type: "text", text: JSON.stringify(data, null, 2) }] };
};

toolHandlers.remove_project_member = async (args) => {
  const { project_id, user_id } = z.object({ project_id: z.string().uuid(), user_id: z.string().uuid() }).parse(args);
  const { error } = await supabase.from("project_members").delete().eq("project_id", project_id).eq("user_id", user_id);
  if (error) throw new Error(error.message);
  return { content: [{ type: "text", text: JSON.stringify({ success: true }) }] };
};

// ── Issues ───────────────────────────────────────────────────────────────────

toolHandlers.list_issues = async (args) => {
  let query = supabase.from("issues").select("*");
  if (args.project_id) query = query.eq("project_id", args.project_id);
  if (args.state) query = query.eq("state", args.state);
  if (args.priority) query = query.eq("priority", args.priority);
  if (args.assignee_id) query = query.eq("assignee_id", args.assignee_id);
  query = query.order("created_at", { ascending: false });
  const { data, error } = await query;
  if (error) throw new Error(error.message);
  return { content: [{ type: "text", text: JSON.stringify(data, null, 2) }] };
};

toolHandlers.get_issue = async (args) => {
  const { id } = z.object({ id: z.string().uuid() }).parse(args);
  const { data, error } = await supabase.from("issues").select("*").eq("id", id).single();
  if (error) throw new Error(error.message);
  return { content: [{ type: "text", text: JSON.stringify(data, null, 2) }] };
};

toolHandlers.create_issue = async (args) => {
  const issue = IssueCreateSchema.parse(args);
  const { data, error } = await supabase.from("issues").insert(issue).select().single();
  if (error) throw new Error(error.message);
  return { content: [{ type: "text", text: JSON.stringify(data, null, 2) }] };
};

toolHandlers.update_issue = async (args) => {
  const { id, ...updates } = IssueUpdateSchema.parse(args);
  const { data, error } = await supabase.from("issues").update(updates).eq("id", id).select().single();
  if (error) throw new Error(error.message);
  return { content: [{ type: "text", text: JSON.stringify(data, null, 2) }] };
};

toolHandlers.delete_issue = async (args) => {
  const { id } = z.object({ id: z.string().uuid() }).parse(args);
  const { error } = await supabase.from("issues").delete().eq("id", id);
  if (error) throw new Error(error.message);
  return { content: [{ type: "text", text: JSON.stringify({ success: true, id }) }] };
};

// ── Settings ─────────────────────────────────────────────────────────────────

toolHandlers.list_settings = async () => {
  const { data, error } = await supabase.from("settings").select("*").order("key");
  if (error) throw new Error(error.message);
  return { content: [{ type: "text", text: JSON.stringify(data, null, 2) }] };
};

toolHandlers.get_setting = async (args) => {
  const { key } = z.object({ key: z.string() }).parse(args);
  const { data, error } = await supabase.from("settings").select("*").eq("key", key).single();
  if (error) throw new Error(error.message);
  return { content: [{ type: "text", text: JSON.stringify(data, null, 2) }] };
};

toolHandlers.set_setting = async (args) => {
  const setting = SettingSchema.parse(args);
  const { data, error } = await supabase.from("settings").upsert(setting, { onConflict: "key" }).select().single();
  if (error) throw new Error(error.message);
  return { content: [{ type: "text", text: JSON.stringify(data, null, 2) }] };
};

toolHandlers.delete_setting = async (args) => {
  const { key } = z.object({ key: z.string() }).parse(args);
  const { error } = await supabase.from("settings").delete().eq("key", key);
  if (error) throw new Error(error.message);
  return { content: [{ type: "text", text: JSON.stringify({ success: true, key }) }] };
};

// ── Users ────────────────────────────────────────────────────────────────────

toolHandlers.list_users = async () => {
  const { data, error } = await supabase.from("users").select("*");
  if (error) throw new Error(error.message);
  return { content: [{ type: "text", text: JSON.stringify(data, null, 2) }] };
};

// ── Tool Definitions ─────────────────────────────────────────────────────────

const toolDefinitions = [
  // Projects
  {
    name: "list_projects",
    description: "List all projects",
    inputSchema: { type: "object", properties: {} },
  },
  {
    name: "get_project",
    description: "Get a project by ID",
    inputSchema: { type: "object", properties: { id: { type: "string" } }, required: ["id"] },
  },
  {
    name: "create_project",
    description: "Create a new project",
    inputSchema: {
      type: "object",
      properties: {
        name: { type: "string" },
        key: { type: "string", description: "Unique project key (2-10 chars)" },
        description: { type: "string" },
        owner_id: { type: "string", description: "User UUID" },
      },
      required: ["name", "key", "owner_id"],
    },
  },
  {
    name: "update_project",
    description: "Update a project",
    inputSchema: {
      type: "object",
      properties: {
        id: { type: "string" },
        name: { type: "string" },
        key: { type: "string" },
        description: { type: "string" },
        owner_id: { type: "string" },
      },
      required: ["id"],
    },
  },
  {
    name: "delete_project",
    description: "Delete a project",
    inputSchema: { type: "object", properties: { id: { type: "string" } }, required: ["id"] },
  },
  // Project Members
  {
    name: "list_project_members",
    description: "List all members of a project",
    inputSchema: { type: "object", properties: { project_id: { type: "string" } }, required: ["project_id"] },
  },
  {
    name: "add_project_member",
    description: "Add a member to a project",
    inputSchema: {
      type: "object",
      properties: {
        project_id: { type: "string" },
        user_id: { type: "string" },
        role: { type: "string", enum: ["admin", "developer", "reporter"] },
      },
      required: ["project_id", "user_id"],
    },
  },
  {
    name: "remove_project_member",
    description: "Remove a member from a project",
    inputSchema: { type: "object", properties: { project_id: { type: "string" }, user_id: { type: "string" } }, required: ["project_id", "user_id"] },
  },
  // Issues
  {
    name: "list_issues",
    description: "List issues, with optional filters",
    inputSchema: {
      type: "object",
      properties: {
        project_id: { type: "string" },
        state: { type: "string", description: "Open, In Progress, Fixed, Verified, etc." },
        priority: { type: "string", description: "Critical, Major, Normal, Minor" },
        assignee_id: { type: "string" },
      },
    },
  },
  {
    name: "get_issue",
    description: "Get an issue by ID",
    inputSchema: { type: "object", properties: { id: { type: "string" } }, required: ["id"] },
  },
  {
    name: "create_issue",
    description: "Create a new issue",
    inputSchema: {
      type: "object",
      properties: {
        project_id: { type: "string" },
        title: { type: "string" },
        description: { type: "string" },
        reporter_id: { type: "string" },
        assignee_id: { type: "string" },
        state: { type: "string", enum: ["Open", "In Progress", "Fixed", "Verified", "Won't Fix", "Duplicate"] },
        priority: { type: "string", enum: ["Show-stopper", "Critical", "Major", "Normal", "Minor"] },
        issue_type: { type: "string", enum: ["Bug", "Task", "Feature", "Improvement", "Epic"] },
      },
      required: ["project_id", "title", "reporter_id"],
    },
  },
  {
    name: "update_issue",
    description: "Update an issue",
    inputSchema: {
      type: "object",
      properties: {
        id: { type: "string" },
        title: { type: "string" },
        description: { type: "string" },
        assignee_id: { type: "string" },
        state: { type: "string" },
        priority: { type: "string" },
        issue_type: { type: "string" },
      },
      required: ["id"],
    },
  },
  {
    name: "delete_issue",
    description: "Delete an issue",
    inputSchema: { type: "object", properties: { id: { type: "string" } }, required: ["id"] },
  },
  // Settings
  {
    name: "list_settings",
    description: "List all application settings",
    inputSchema: { type: "object", properties: {} },
  },
  {
    name: "get_setting",
    description: "Get a setting by key",
    inputSchema: { type: "object", properties: { key: { type: "string" } }, required: ["key"] },
  },
  {
    name: "set_setting",
    description: "Create or update a setting",
    inputSchema: {
      type: "object",
      properties: {
        key: { type: "string" },
        value: { type: "string" },
        description: { type: "string" },
        updated_by: { type: "string" },
      },
      required: ["key", "value"],
    },
  },
  {
    name: "delete_setting",
    description: "Delete a setting by key",
    inputSchema: { type: "object", properties: { key: { type: "string" } }, required: ["key"] },
  },
  // Users
  {
    name: "list_users",
    description: "List all users",
    inputSchema: { type: "object", properties: {} },
  },
];

// ── Server Setup ─────────────────────────────────────────────────────────────

const server = new Server(
  { name: "mcp-supabase", version: "2.0.0" },
  { capabilities: { tools: {} } },
);

server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: toolDefinitions,
}));

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;
  const handler = toolHandlers[name];
  if (!handler) {
    throw new Error(`Unknown tool: ${name}`);
  }
  try {
    return await handler(args ?? {});
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    return {
      content: [{ type: "text", text: `Error: ${message}` }],
      isError: true,
    };
  }
});

const transport = new StdioServerTransport();
await server.connect(transport);
