-- Add visibility column to custom_fields table
ALTER TABLE custom_fields
ADD COLUMN visibility TEXT NOT NULL DEFAULT 'show'
CHECK (visibility IN ('show', 'hide'));

-- Add access_control column to custom_fields table
ALTER TABLE custom_fields
ADD COLUMN access_control JSONB NOT NULL DEFAULT '{"type": "everyone"}';

-- Create index for access_control queries
CREATE INDEX idx_custom_fields_access_control ON custom_fields USING GIN (access_control);

-- Create index for visibility queries
CREATE INDEX idx_custom_fields_visibility ON custom_fields(visibility);
