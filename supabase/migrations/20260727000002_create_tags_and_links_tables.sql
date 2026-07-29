-- Tags definition table
CREATE TABLE IF NOT EXISTS public.tags (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name TEXT NOT NULL,
    owner_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    project_id UUID REFERENCES public.projects(id) ON DELETE CASCADE,
    shared BOOLEAN DEFAULT TRUE,
    remove_on_resolution BOOLEAN DEFAULT TRUE,
    favorite BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    created_by UUID REFERENCES public.users(id)
);

-- Tag Permissions table
CREATE TABLE IF NOT EXISTS public.tag_permissions (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    tag_id UUID REFERENCES public.tags(id) ON DELETE CASCADE,
    permission_type TEXT NOT NULL,
    scope TEXT NOT NULL,
    user_ids UUID[] -- Storing as array as per TagPermission entity
);

-- Tag Subscriptions table
CREATE TABLE IF NOT EXISTS public.tag_subscriptions (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    tag_id UUID REFERENCES public.tags(id) ON DELETE CASCADE,
    event_type TEXT NOT NULL
);

-- Junction table for Issues and Tags
CREATE TABLE IF NOT EXISTS public.issue_tags (
    issue_id UUID REFERENCES public.issues(id) ON DELETE CASCADE,
    tag_id UUID REFERENCES public.tags(id) ON DELETE CASCADE,
    PRIMARY KEY (issue_id, tag_id)
);

-- Issue Links table
CREATE TABLE IF NOT EXISTS public.issue_links (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    issue_id UUID REFERENCES public.issues(id) ON DELETE CASCADE NOT NULL,
    link_type TEXT NOT NULL,
    issue_linked_id UUID REFERENCES public.issues(id) ON DELETE CASCADE NOT NULL,
    UNIQUE (issue_id, issue_linked_id, link_type)
);

-- Enable RLS
ALTER TABLE public.tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tag_permissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tag_subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.issue_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.issue_links ENABLE ROW LEVEL SECURITY;

-- RLS Policies (Basic authenticated access)
CREATE POLICY "Anyone can view tags" ON public.tags FOR SELECT USING (true);
CREATE POLICY "Authenticated users can manage tags" ON public.tags FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "Anyone can view tag_permissions" ON public.tag_permissions FOR SELECT USING (true);
CREATE POLICY "Authenticated users can manage tag_permissions" ON public.tag_permissions FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "Anyone can view tag_subscriptions" ON public.tag_subscriptions FOR SELECT USING (true);
CREATE POLICY "Authenticated users can manage tag_subscriptions" ON public.tag_subscriptions FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "Anyone can view issue_tags" ON public.issue_tags FOR SELECT USING (true);
CREATE POLICY "Authenticated users can manage issue_tags" ON public.issue_tags FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "Anyone can view issue_links" ON public.issue_links FOR SELECT USING (true);
CREATE POLICY "Authenticated users can manage issue_links" ON public.issue_links FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- Indexes
CREATE INDEX idx_tags_project_id ON public.tags(project_id);
CREATE INDEX idx_issue_tags_issue_id ON public.issue_tags(issue_id);
CREATE INDEX idx_issue_links_issue_id ON public.issue_links(issue_id);
CREATE INDEX idx_issue_links_issue_linked_id ON public.issue_links(issue_linked_id);
