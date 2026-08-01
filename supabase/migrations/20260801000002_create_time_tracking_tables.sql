create extension if not exists "uuid-ossp";

create table if not exists public.time_tracking_configs (
  project_id uuid not null primary key,
  enabled boolean not null default false,
  estimation_field_id uuid null,
  spent_time_field_id uuid null,
  aggregate_spent_time boolean not null default false,
  aggregate_estimation boolean not null default false,
  updated_at timestamptz not null default now(),
  constraint fk_time_tracking_configs_project
    foreign key (project_id) references public.projects(id) on delete cascade
);

create table if not exists public.work_types (
  id uuid not null default gen_random_uuid() primary key,
  project_id uuid not null,
  name text not null,
  description text null,
  is_active boolean not null default true,
  sort_order integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint fk_work_types_project
    foreign key (project_id) references public.projects(id) on delete cascade
);

create table if not exists public.custom_work_item_attributes (
  id uuid not null default gen_random_uuid() primary key,
  project_id uuid not null,
  name text not null,
  field_type text not null,
  is_required boolean not null default false,
  options jsonb null,
  sort_order integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint fk_custom_work_item_attributes_project
    foreign key (project_id) references public.projects(id) on delete cascade
);

alter table public.time_tracking_configs enable row level security;
alter table public.work_types enable row level security;
alter table public.custom_work_item_attributes enable row level security;

create policy if not exists "time_tracking_configs_select" on public.time_tracking_configs
  for select using (true);
create policy if not exists "time_tracking_configs_insert" on public.time_tracking_configs
  for insert with check (true);
create policy if not exists "time_tracking_configs_update" on public.time_tracking_configs
  for update using (true) with check (true);
create policy if not exists "time_tracking_configs_delete" on public.time_tracking_configs
  for delete using (true);

create policy if not exists "work_types_select" on public.work_types
  for select using (true);
create policy if not exists "work_types_insert" on public.work_types
  for insert with check (true);
create policy if not exists "work_types_update" on public.work_types
  for update using (true) with check (true);
create policy if not exists "work_types_delete" on public.work_types
  for delete using (true);

create policy if not exists "custom_work_item_attributes_select" on public.custom_work_item_attributes
  for select using (true);
create policy if not exists "custom_work_item_attributes_insert" on public.custom_work_item_attributes
  for insert with check (true);
create policy if not exists "custom_work_item_attributes_update" on public.custom_work_item_attributes
  for update using (true) with check (true);
create policy if not exists "custom_work_item_attributes_delete" on public.custom_work_item_attributes
  for delete using (true);
