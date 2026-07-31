# Entity Relationship Diagram (ERD) - Access Control & Governance

هذا المخطط يوضح العلاقات بين المستخدمين (`users`)، المشروعات (`projects`)، المجموعات (`groups`)، والأدوار (`roles`) والجداول الوسيطة التي تربط بينها.

```mermaid
erDiagram
    users {
        uuid id PK
        text email UK
        text user_name
        text avatar_url
        text full_name
        timestamptz created_at
    }

    projects {
        uuid id PK
        text project_id UK
        text name
        text description
        uuid owner_id FK
        bool is_archived
        bool is_favorite
        int4 starting_number
        timestamptz created_at
    }

    groups {
        uuid id PK
        text name
        text description
        text logo
        bool auto_join
        text auto_join_domains
        text two_factor_auth
        jsonb visible_to
        text updatable_by
        text group_type
        text avatar_url
        timestamptz created_at
        timestamptz updated_at
    }

    roles {
        text name PK
        _text permissions
        text description
    }

    project_members {
        uuid id PK
        uuid project_id FK
        uuid user_id FK
        text role
        bool is_owner
    }

    group_members {
        uuid id PK
        uuid group_id FK
        uuid user_id FK
    }

    group_projects {
        uuid id PK
        uuid group_id FK
        uuid project_id FK
    }

    group_roles {
        uuid id PK
        uuid group_id FK
        uuid project_id FK
        text role_name FK
    }

    %% Relationships
    users ||--o{ projects : "owns"
    users ||--o{ project_members : "belongs to project"
    projects ||--o{ project_members : "has members"

    users ||--o{ group_members : "belongs to group"
    groups ||--o{ group_members : "has members"

    groups ||--o{ group_projects : "associated with"
    projects ||--o{ group_projects : "assigned to group"

    groups ||--o{ group_roles : "assigned role"
    projects ||--o{ group_roles : "role scoped to"
    roles ||--o{ group_roles : "defines permissions for"
```

## شرح العلاقات في المخطط

1. **`users` ↔ `projects` (إمّا عبر `owner_id` أو `project_members`)**:
   - `users` إلى `projects` عبر `owner_id`: يحدد مالك المشروع الأساسي.
   - `users` إلى `project_members` إلى `projects`: تعيين مستخدمين أفراد مباشرة للمشروع بدور مخصص (`role`) وصلاحية ملكية محددة (`is_owner`).

2. **`users` ↔ `groups` (عبر `group_members`)**:
   - علاقة الكثير إلى الكثير (Many-to-Many) تتيح للمستخدم الانضمام لأكثر من مجموعة، وللمجموعة تضمين عدة مستخدمين.

3. **`groups` ↔ `projects` (عبر `group_projects`)**:
   - علاقة ربط بين المجموعات والمشاريع التي تملك هذه المجموعات وصولاً إليها بشكل عام.

4. **`groups` ↔ `roles` ↔ `projects` (عبر `group_roles`)**:
   - جدول وسيط يربط المجموعة (`group_id`) بدور معين (`role_name`) محدد لنطاق مشروع خاص (`project_id`).
