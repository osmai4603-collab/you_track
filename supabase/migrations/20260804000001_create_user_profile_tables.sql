create extension if not exists "uuid-ossp";

-- ── 1.1 Add timezone column to users (General tab) ──
alter table public.users
  add column if not exists timezone text not null default 'UTC';

-- ── 1.2 user_preferences (Workspace tab) ──
create table if not exists public.user_preferences (
  id uuid not null default gen_random_uuid() primary key,
  user_id uuid not null,
  theme text not null default 'dark',
  links_panel_position text not null default 'below_description',
  show_recent_issues boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint fk_user_preferences_user
    foreign key (user_id) references public.users(id) on delete cascade,
  constraint user_preferences_user_id_unique unique (user_id)
);

-- ── 1.3 user_notification_settings (Notifications tab) ──
create table if not exists public.user_notification_settings (
  id uuid not null default gen_random_uuid() primary key,
  user_id uuid not null,
  email_enabled boolean not null default true,
  email_format text not null default 'html',
  telegram_enabled boolean not null default false,
  telegram_connected boolean not null default false,
  notify_changes_by_me boolean not null default false,
  notify_mentions boolean not null default false,
  notify_duplicate_changes boolean not null default false,
  notify_email_created boolean not null default false,
  notify_vcs_updates boolean not null default false,
  notify_vcs_failed_commands boolean not null default false,
  star_on_comment boolean not null default true,
  star_on_create boolean not null default true,
  star_on_update boolean not null default true,
  star_on_assigned boolean not null default true,
  star_on_vote boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint fk_user_notification_settings_user
    foreign key (user_id) references public.users(id) on delete cascade,
  constraint user_notification_settings_user_id_unique unique (user_id)
);

-- ── 1.4 saved_searches (Tags and Saved Searches tab) ──
create table if not exists public.saved_searches (
  id uuid not null default gen_random_uuid() primary key,
  user_id uuid not null,
  name text not null,
  query text not null,
  is_favorite boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint fk_saved_searches_user
    foreign key (user_id) references public.users(id) on delete cascade
);

create index if not exists idx_saved_searches_user_id on public.saved_searches(user_id);
create index if not exists idx_user_preferences_user_id on public.user_preferences(user_id);
create index if not exists idx_user_notification_settings_user_id on public.user_notification_settings(user_id);

-- ── RLS: user_preferences ──
alter table public.user_preferences enable row level security;

create policy if not exists "users_select_own_preferences" on public.user_preferences
  for select to authenticated
  using (user_id = auth.uid());

create policy if not exists "users_upsert_own_preferences" on public.user_preferences
  for all to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

-- ── RLS: user_notification_settings ──
alter table public.user_notification_settings enable row level security;

create policy if not exists "users_select_own_notification_settings" on public.user_notification_settings
  for select to authenticated
  using (user_id = auth.uid());

create policy if not exists "users_upsert_own_notification_settings" on public.user_notification_settings
  for all to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

-- ── RLS: saved_searches ──
alter table public.saved_searches enable row level security;

create policy if not exists "users_select_own_saved_searches" on public.saved_searches
  for select to authenticated
  using (user_id = auth.uid());

create policy if not exists "users_manage_own_saved_searches" on public.saved_searches
  for all to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());
