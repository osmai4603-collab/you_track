-- Migration: create_groups_table
-- Created: 2026-07-29

CREATE TABLE groups (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  logo TEXT,
  auto_join BOOLEAN NOT NULL DEFAULT false,
  auto_join_domains TEXT,
  two_factor_auth TEXT NOT NULL DEFAULT 'optional' CHECK (two_factor_auth IN ('required', 'optional')),
  visible_to JSONB DEFAULT '[]'::jsonb,
  updatable_by TEXT NOT NULL DEFAULT 'all_users',
  group_type TEXT NOT NULL DEFAULT 'users' CHECK (group_type IN ('users', 'teams')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
