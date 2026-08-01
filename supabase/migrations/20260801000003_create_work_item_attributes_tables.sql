create extension if not exists "uuid-ossp";

create table if not exists public.work_item_attributes (
  id uuid not null default gen_random_uuid() primary key,
  project_id uuid not null,
  name text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint fk_work_item_attributes_project
    foreign key (project_id) references public.projects(id) on delete cascade
);

create table if not exists public.attribute_values (
  id uuid not null default gen_random_uuid() primary key,
  attribute_id uuid not null,
  value text not null,
  color text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint fk_attribute_values_attribute
    foreign key (attribute_id) references public.work_item_attributes(id) on delete cascade
);

alter table public.work_item_attributes enable row level security;
alter table public.attribute_values enable row level security;

create policy if not exists "work_item_attributes_select" on public.work_item_attributes
  for select using (true);
create policy if not exists "work_item_attributes_insert" on public.work_item_attributes
  for insert with check (true);
create policy if not exists "work_item_attributes_update" on public.work_item_attributes
  for update using (true) with check (true);
create policy if not exists "work_item_attributes_delete" on public.work_item_attributes
  for delete using (true);

create policy if not exists "attribute_values_select" on public.attribute_values
  for select using (true);
create policy if not exists "attribute_values_insert" on public.attribute_values
  for insert with check (true);
create policy if not exists "attribute_values_update" on public.attribute_values
  for update using (true) with check (true);
create policy if not exists "attribute_values_delete" on public.attribute_values
  for delete using (true);