# مخطط الكيانات والعلاقات (ERD) لمشروع issues_tracking

هذا المستند يعرض الهيكلية المنطقية لقاعدة بيانات النظام، المعتمدة على PostgreSQL عبر Supabase.

## 📊 مخطط Mermaid

```mermaid
erDiagram
    USERS {
        uuid id PK
        string email
        string full_name
        string avatar_url
        timestamp created_at
    }

    PROJECTS {
        uuid id PK
        string key "e.g., YT"
        string name
        string description
        uuid owner_id FK
        timestamp created_at
    }

    PROJECT_MEMBERS {
        uuid project_id PK, FK
        uuid user_id PK, FK
        string role "Admin, Developer, Reporter"
    }

    ISSUES {
        uuid id PK
        uuid project_id FK
        string issue_key "e.g., YT-12"
        string title
        text description
        uuid reporter_id FK
        uuid assignee_id FK
        string state "Open, In Progress, Closed"
        string priority "Low, Normal, High, Critical"
        string issue_type "Bug, Task, Feature"
        timestamp created_at
        timestamp updated_at
    }

    COMMENTS {
        uuid id PK
        uuid issue_id FK
        uuid user_id FK
        text content
        timestamp created_at
        timestamp updated_at
    }

    ATTACHMENTS {
        uuid id PK
        uuid issue_id FK
        uuid user_id FK
        string file_url
        string file_name
        string file_type
        int file_size
        timestamp created_at
    }

    ISSUE_LINKS {
        uuid id PK
        uuid source_issue_id FK
        uuid target_issue_id FK
        string link_type "Relates to, Duplicates, Blocks"
    }
    
    NOTIFICATIONS {
        uuid id PK
        uuid user_id FK
        string title
        string content
        uuid related_issue_id FK
        boolean is_read
        timestamp created_at
    }

    USERS ||--o{ PROJECTS : "owns"
    USERS ||--o{ PROJECT_MEMBERS : "is member of"
    PROJECTS ||--o{ PROJECT_MEMBERS : "has"
    
    PROJECTS ||--o{ ISSUES : "contains"
    USERS ||--o{ ISSUES : "reports"
    USERS ||--o{ ISSUES : "is assigned to"
    
    ISSUES ||--o{ COMMENTS : "has"
    USERS ||--o{ COMMENTS : "writes"
    
    ISSUES ||--o{ ATTACHMENTS : "has"
    USERS ||--o{ ATTACHMENTS : "uploads"
    
    ISSUES ||--o{ ISSUE_LINKS : "source of"
    ISSUES ||--o{ ISSUE_LINKS : "target of"
    
    USERS ||--o{ NOTIFICATIONS : "receives"
    ISSUES ||--o{ NOTIFICATIONS : "triggers"
```

## 📝 تفاصيل الجداول والعلاقات

1. **USERS (المستخدمون):** يخزن بيانات المستخدمين الأساسية (تتكامل مع Supabase Auth).
2. **PROJECTS (المشاريع):** المشاريع التي تحتوي على المهام، ولكل مشروع مفتاح فريد `key` يستخدم لتوليد أرقام المشاكل (مثل `YT-1`, `YT-2`).
3. **PROJECT_MEMBERS (أعضاء المشاريع):** جدول ربط (Many-to-Many) بين المستخدمين والمشاريع لتحديد صلاحية كل مستخدم (Role) داخل المشروع المعين.
4. **ISSUES (المشاكل/المهام):** الكيان الرئيسي في النظام. يرتبط بالمشروع، والمُبلّغ، والمعيّن له، ويحتوي على بيانات الحالة والأولوية. يتم حساب `issue_key` برمجياً أو باستخدام Sequence/Trigger.
5. **COMMENTS (التعليقات):** تعليقات المستخدمين على مشكلة معينة.
6. **ATTACHMENTS (المرفقات):** الملفات المرفوعة لمشكلة معينة، تخزن الروابط (URL) التي تشير إلى Supabase Storage.
7. **ISSUE_LINKS (روابط المشاكل):** علاقة المشاكل ببعضها (Self-referencing)، مثل تحديد مشكلة تمنع (Blocks) مشكلة أخرى.
8. **NOTIFICATIONS (الإشعارات):** تسجيل الإشعارات المرسلة للمستخدمين سواء كانت مقروءة أم لا.
