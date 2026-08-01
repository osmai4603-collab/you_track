-- Migration: add_custom_fields_visibility_access_control
-- Created: 2026-07-31

ALTER TABLE custom_fields
  ADD COLUMN IF NOT EXISTS visibility TEXT NOT NULL DEFAULT 'show'
    CHECK (visibility IN ('show', 'hide'));

ALTER TABLE custom_fields
  ADD COLUMN IF NOT EXISTS access_control JSONB NOT NULL DEFAULT '{"type": "everyone"}'::jsonb;

CREATE INDEX IF NOT EXISTS idx_custom_fields_access_control
  ON custom_fields USING GIN (access_control);
