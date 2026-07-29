-- Create Sprints table
CREATE TABLE IF NOT EXISTS public.sprints (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    project_id UUID REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    start_date TIMESTAMPTZ,
    release_date TIMESTAMPTZ,
    is_released BOOLEAN DEFAULT FALSE,
    description TEXT,
    color INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Junction table for Issues and Sprints (ManyToMany)
CREATE TABLE IF NOT EXISTS public.issue_sprints (
    issue_id UUID REFERENCES public.issues(id) ON DELETE CASCADE,
    sprint_id UUID REFERENCES public.sprints(id) ON DELETE CASCADE,
    PRIMARY KEY (issue_id, sprint_id)
);

-- Enable RLS
ALTER TABLE public.sprints ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.issue_sprints ENABLE ROW LEVEL SECURITY;

-- RLS Policies for Sprints
CREATE POLICY "Anyone can view sprints" ON public.sprints FOR SELECT USING (true);
CREATE POLICY "Authenticated users can manage sprints" ON public.sprints FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- RLS Policies for issue_sprints
CREATE POLICY "Anyone can view issue_sprints" ON public.issue_sprints FOR SELECT USING (true);
CREATE POLICY "Authenticated users can manage issue_sprints" ON public.issue_sprints FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- Indexes
CREATE INDEX idx_sprints_project_id ON public.sprints(project_id);
CREATE INDEX idx_issue_sprints_issue_id ON public.issue_sprints(issue_id);
CREATE INDEX idx_issue_sprints_sprint_id ON public.issue_sprints(sprint_id);

-- Trigger for updated_at
CREATE TRIGGER update_sprints_updated_at
BEFORE UPDATE ON public.sprints
FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();
