-- Migration: add_projects_columns
-- Adds missing columns to projects table to match updated data model

ALTER TABLE projects
  ADD COLUMN IF NOT EXISTS is_archived BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS is_template BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS template_id TEXT,
  ADD COLUMN IF NOT EXISTS is_favorite BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS starting_number INTEGER DEFAULT 1;
