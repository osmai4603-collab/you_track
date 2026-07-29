-- Migration: create_roles_table
-- Created: 2026-07-29

CREATE TABLE roles (
  name TEXT PRIMARY KEY,
  permissions TEXT[] NOT NULL DEFAULT '{}'
);
