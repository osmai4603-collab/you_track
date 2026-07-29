-- سكريبت بناء قاعدة بيانات issues_tracking على Supabase (PostgreSQL)

-- تفعيل امتداد uuid 
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

---------------------------------------------------------------------------
-- 1. الجداول (Tables)
---------------------------------------------------------------------------

-- جدول المستخدمين (امتداد لـ auth.users الخاص بـ Supabase)
CREATE TABLE public.users (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    email TEXT UNIQUE,
    full_name TEXT,
    avatar_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- جدول المشاريع
CREATE TABLE public.projects (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    key TEXT UNIQUE NOT NULL CHECK (char_length(key) BETWEEN 2 AND 10),
    name TEXT NOT NULL,
    description TEXT,
    owner_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- جدول البناء (Builds)
CREATE TABLE public.builds (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name TEXT NOT NULL,
    date TIMESTAMPTZ,
    project_id UUID REFERENCES public.projects(id) ON DELETE CASCADE NOT NULL
);

-- جدول أعضاء المشروع (Roles: admin, developer, reporter)
CREATE TABLE public.project_members (
    project_id UUID REFERENCES public.projects(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    role TEXT NOT NULL DEFAULT 'reporter',
    PRIMARY KEY (project_id, user_id)
);

-- جدول المهام والمشاكل
CREATE TABLE public.issues (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    project_id UUID REFERENCES public.projects(id) ON DELETE CASCADE NOT NULL,
    issue_sequence INTEGER NOT NULL, -- سيتم توليده عبر Trigger
    issue_key TEXT UNIQUE, -- e.g. YT-1, سيتم حسابه
    title TEXT NOT NULL,
    description TEXT,
    reporter_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    assignee_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
    state TEXT DEFAULT 'to-do', -- Open, In Progress, Resolved, Closed
    priority TEXT DEFAULT 'normal', -- Low, Normal, High, Critical
    issue_type TEXT DEFAULT 'task', -- Bug, Task, Feature
    build_id UUID REFERENCES public.builds(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- جدول التعليقات
CREATE TABLE public.comments (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    issue_id UUID REFERENCES public.issues(id) ON DELETE CASCADE NOT NULL,
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- جدول المرفقات
CREATE TABLE public.attachments (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    issue_id UUID REFERENCES public.issues(id) ON DELETE CASCADE NOT NULL,
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
    file_url TEXT NOT NULL,
    file_name TEXT NOT NULL,
    file_type TEXT,
    file_size INTEGER,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- جدول روابط المهام (العلاقات بين المهام)
CREATE TABLE public.issue_links (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    source_issue_id UUID REFERENCES public.issues(id) ON DELETE CASCADE NOT NULL,
    target_issue_id UUID REFERENCES public.issues(id) ON DELETE CASCADE NOT NULL,
    link_type TEXT NOT NULL, -- e.g. relates_to, blocks, duplicated_by
    UNIQUE (source_issue_id, target_issue_id, link_type)
);

-- جدول الإشعارات
CREATE TABLE public.notifications (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
    title TEXT NOT NULL,
    content TEXT,
    related_issue_id UUID REFERENCES public.issues(id) ON DELETE CASCADE,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

---------------------------------------------------------------------------
-- 2. الوظائف والمشغلات (Functions & Triggers)
---------------------------------------------------------------------------

-- دالة لتحديث updated_at تلقائياً
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = NOW();
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_issues_updated_at
BEFORE UPDATE ON public.issues
FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_comments_updated_at
BEFORE UPDATE ON public.comments
FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

-- دالة لتوليد رقم التسلسل للمشكلة ومفتاحها (ProjectKey-Sequence)
CREATE OR REPLACE FUNCTION set_issue_sequence_and_key()
RETURNS TRIGGER AS $$
DECLARE
    next_seq INTEGER;
    proj_key TEXT;
BEGIN
    -- الحصول على مفتاح المشروع
    SELECT key INTO proj_key FROM public.projects WHERE id = NEW.project_id;
    
    -- حساب التسلسل الجديد
    SELECT COALESCE(MAX(issue_sequence), 0) + 1 INTO next_seq 
    FROM public.issues 
    WHERE project_id = NEW.project_id;
    
    NEW.issue_sequence = next_seq;
    NEW.issue_key = proj_key || '-' || next_seq::TEXT;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_issues
BEFORE INSERT ON public.issues
FOR EACH ROW EXECUTE PROCEDURE set_issue_sequence_and_key();

-- إنشاء مستخدم في public.users تلقائياً عند التسجيل في auth.users
CREATE OR REPLACE FUNCTION handle_new_user() 
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email, full_name, avatar_url)
  VALUES (NEW.id, NEW.email, NEW.raw_user_meta_data->>'full_name', NEW.raw_user_meta_data->>'avatar_url')
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE handle_new_user();

---------------------------------------------------------------------------
-- 3. سياسات الأمان (Row Level Security - RLS)
---------------------------------------------------------------------------

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.project_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.issues ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.attachments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.issue_links ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

-- سياسات جدول المشاريع (يمكن للجميع رؤية المشاريع مبدئياً)
CREATE POLICY "Anyone can view projects" ON public.projects FOR SELECT USING (true);
CREATE POLICY "Authenticated users can create projects" ON public.projects FOR INSERT TO authenticated WITH CHECK (true);

-- سياسات جدول المهام (الجميع يمكنه الرؤية، المسجلون يمكنهم الإضافة)
CREATE POLICY "Anyone can view issues" ON public.issues FOR SELECT USING (true);
CREATE POLICY "Authenticated users can create issues" ON public.issues FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Users can update issues they reported or assigned to or if they are admin" ON public.issues FOR UPDATE TO authenticated USING (
    auth.uid() = reporter_id OR auth.uid() = assignee_id
    -- هنا يمكن إضافة استعلام للتحقق من الصلاحيات من جدول project_members
);

-- سياسات التعليقات
CREATE POLICY "Anyone can view comments" ON public.comments FOR SELECT USING (true);
CREATE POLICY "Authenticated users can insert comments" ON public.comments FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own comments" ON public.comments FOR UPDATE TO authenticated USING (auth.uid() = user_id);

-- سياسات الإشعارات (المستخدم يرى إشعاراته فقط)
CREATE POLICY "Users can view own notifications" ON public.notifications FOR SELECT TO authenticated USING (auth.uid() = user_id);
CREATE POLICY "Users can update own notifications" ON public.notifications FOR UPDATE TO authenticated USING (auth.uid() = user_id);

---------------------------------------------------------------------------
-- 4. الفهارس (Indexes)
---------------------------------------------------------------------------

CREATE INDEX idx_issues_project_id ON public.issues(project_id);
CREATE INDEX idx_issues_assignee_id ON public.issues(assignee_id);
CREATE INDEX idx_issues_state ON public.issues(state);
CREATE INDEX idx_comments_issue_id ON public.comments(issue_id);
CREATE INDEX idx_notifications_user_id ON public.notifications(user_id);
