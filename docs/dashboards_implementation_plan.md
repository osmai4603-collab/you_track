# بناء ميزة لوحات المتابعة (Dashboards) — YouTrack Clone

## وصف الميزة

بناء نظام لوحات متابعة (Dashboards) متكامل مستوحى من واجهة **YouTrack by JetBrains**، يتيح للمستخدمين إنشاء لوحات مخصصة تحتوي على ودجات (Widgets) متنوعة لمراقبة المشاريع والمهام والتقارير في مكان واحد.

---

## 📊 تحليل واجهة YouTrack - قسم Dashboards

### 🏗️ هيكلية الصفحة (Page Layout)

```
┌──────────────────────────────────────────────────────────┐
│  🔝 شريط التنقل العلوي (Top Navigation Bar)              │
│  Logo | Dashboards ▼ | Issues | Boards | ... | 🔔 👤    │
├──────────┬───────────────────────────────────────────────┤
│          │  📌 شريط أدوات اللوحة (Dashboard Toolbar)    │
│ الشريط   │  ⭐ Dashboard Name ▼ | 🔄 | ⚙️ | 👥 Share  │
│ الجانبي  │  + Add widget                                 │
│ (Sidebar)├───────────────────────────────────────────────┤
│          │                                               │
│ لوحاتي   │   ┌─────────────┐  ┌─────────────────────┐   │
│ ├ My Work │   │ 📋 Issue    │  │ 📊 Issue Distribution│  │
│ ├ Sprint  │   │    List     │  │    Report (Chart)    │   │
│ ├ Team    │   │  ┌─────┐   │  │  ┌──────────────┐   │   │
│           │   │  │item1│   │  │  │ ████ Bug      │   │   │
│ مفضلة    │   │  │item2│   │  │  │ ██ Task       │   │   │
│ ├ ...     │   │  │item3│   │  │  │ █████ Feature │   │   │
│           │   │  └─────┘   │  │  └──────────────┘   │   │
│ + إنشاء   │   └─────────────┘  └─────────────────────┘   │
│  لوحة     │                                               │
│ جديدة    │   ┌─────────────┐  ┌─────────────────────┐   │
│          │   │ 📝 Quick    │  │ 📈 Agile Board      │   │
│ 🔍 بحث   │   │    Notes    │  │    Status            │   │
│          │   │             │  │  Progress: ████░ 80% │   │
│          │   │ Free text   │  │                       │   │
│          │   │ & markdown  │  │  Sprint: v2.1         │   │
│          │   └─────────────┘  └─────────────────────┘   │
└──────────┴───────────────────────────────────────────────┘
```

### 📋 العمليات المدعومة (Supported Operations)

#### عمليات اللوحة (Dashboard Operations)
| العملية | الوصف | الاختصار |
|---------|-------|---------|
| إنشاء لوحة جديدة | إنشاء dashboard فارغ بإسم مخصص | `Alt+Shift+N` |
| إعادة تسمية | تغيير اسم اللوحة | - |
| حذف اللوحة | حذف اللوحة وجميع ودجاتها | - |
| مشاركة اللوحة | مشاركة مع مستخدمين/فرق محددة | - |
| تفضيل اللوحة | إضافة/إزالة من المفضلة (⭐) | - |
| تعيين كافتراضية | جعل اللوحة هي الافتراضية عند فتح القسم | - |

#### عمليات الودجات (Widget Operations)
| العملية | الوصف |
|---------|-------|
| إضافة ودجت | اختيار نوع الودجت وتكوينه |
| تعديل إعدادات | تغيير عنوان/إعدادات الودجت |
| حذف ودجت | إزالة الودجت من اللوحة |
| تحديث بيانات | إعادة تحميل بيانات الودجت |
| نسخ ودجت | استنساخ الودجت بنفس الإعدادات |
| تحريك ودجت | سحب وإفلات لتغيير الترتيب |
| تغيير حجم | تغيير عرض وارتفاع الودجت في الشبكة |

### 🎨 أنواع الودجات (Widget Types)

| النوع | الوصف | البيانات المعروضة |
|-------|-------|-------------------|
| **Issue List** | قائمة المهام | قائمة Issues مع فلاتر (مشروع، حالة، أولوية) |
| **Issue Distribution** | توزيع المهام | رسم بياني (Bar/Pie) لتوزيع المهام حسب حقل (State, Priority, Type) |
| **Quick Notes** | ملاحظات سريعة | نص حر (Markdown) |
| **Project Summary** | ملخص المشروع | عدد المهام المفتوحة/المغلقة، الأعضاء |
| **Activity Feed** | سجل النشاط | آخر التغييرات والتعليقات |
| **Agile Board Status** | حالة لوحة العمل | شريط تقدم Sprint/Board |

---

## 🗃️ بنية قاعدة البيانات (Database Schema)

### جداول جديدة مطلوبة

```sql
-- جدول لوحات المتابعة
CREATE TABLE public.dashboards (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name TEXT NOT NULL DEFAULT 'New Dashboard',
    owner_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
    is_default BOOLEAN DEFAULT FALSE,
    is_favorite BOOLEAN DEFAULT FALSE,
    layout_config JSONB DEFAULT '{}',  -- تكوين الشبكة (grid)
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- جدول الودجات
CREATE TABLE public.dashboard_widgets (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    dashboard_id UUID REFERENCES public.dashboards(id) ON DELETE CASCADE NOT NULL,
    widget_type TEXT NOT NULL,        -- 'issue_list', 'issue_distribution', 'quick_notes', 'project_summary', 'activity_feed', 'agile_status'
    title TEXT NOT NULL DEFAULT 'Widget',
    config JSONB DEFAULT '{}',        -- إعدادات الودجت الخاصة بالنوع
    position_x INTEGER DEFAULT 0,     -- موقع في الشبكة (عمود)
    position_y INTEGER DEFAULT 0,     -- موقع في الشبكة (صف)
    width INTEGER DEFAULT 1,          -- عرض بعدد الأعمدة (1-3)
    height INTEGER DEFAULT 1,         -- ارتفاع بعدد الصفوف (1-3)
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- جدول مشاركة اللوحات
CREATE TABLE public.dashboard_shares (
    dashboard_id UUID REFERENCES public.dashboards(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    permission TEXT NOT NULL DEFAULT 'view', -- 'view', 'edit'
    PRIMARY KEY (dashboard_id, user_id)
);
```

### RLS و Triggers
```sql
-- RLS
ALTER TABLE public.dashboards ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.dashboard_widgets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.dashboard_shares ENABLE ROW LEVEL SECURITY;

-- سياسات الأمان
CREATE POLICY "Users can view own dashboards" ON public.dashboards
  FOR SELECT USING (auth.uid() = owner_id);
CREATE POLICY "Users can view shared dashboards" ON public.dashboards
  FOR SELECT USING (
    id IN (SELECT dashboard_id FROM public.dashboard_shares WHERE user_id = auth.uid())
  );
CREATE POLICY "Users can manage own dashboards" ON public.dashboards
  FOR ALL USING (auth.uid() = owner_id);

-- Auto-update timestamps
CREATE TRIGGER update_dashboards_updated_at
  BEFORE UPDATE ON public.dashboards
  FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_widgets_updated_at
  BEFORE UPDATE ON public.dashboard_widgets
  FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

-- فهارس
CREATE INDEX idx_dashboards_owner ON public.dashboards(owner_id);
CREATE INDEX idx_widgets_dashboard ON public.dashboard_widgets(dashboard_id);
CREATE INDEX idx_dashboard_shares_user ON public.dashboard_shares(user_id);
```

---

## 📁 هيكلية الملفات المقترحة

```
lib/
├── components/
│   ├── dashboard/
│   │   ├── dashboard_page.dart          # [NEW] الصفحة الرئيسية للوحات
│   │   ├── dashboard_sidebar.dart       # [NEW] الشريط الجانبي (قائمة اللوحات)
│   │   ├── dashboard_toolbar.dart       # [NEW] شريط أدوات اللوحة
│   │   ├── dashboard_grid.dart          # [NEW] شبكة الودجات (Grid Layout)
│   │   ├── dashboard_empty_state.dart   # [NEW] حالة اللوحة الفارغة
│   │   ├── create_dashboard_dialog.dart # [NEW] نافذة إنشاء لوحة
│   │   ├── share_dashboard_dialog.dart  # [NEW] نافذة مشاركة اللوحة
│   │   ├── add_widget_dialog.dart       # [NEW] نافذة إضافة ودجت
│   │   └── widgets/
│   │       ├── widget_card.dart         # [NEW] غلاف الودجت (Header + Menu + Content)
│   │       ├── widget_menu.dart         # [NEW] قائمة خيارات الودجت (Edit, Clone, Remove, Refresh)
│   │       ├── issue_list_widget.dart   # [NEW] ودجت قائمة المهام
│   │       ├── issue_distribution_widget.dart # [NEW] ودجت توزيع المهام (Chart)
│   │       ├── quick_notes_widget.dart  # [NEW] ودجت الملاحظات السريعة
│   │       ├── project_summary_widget.dart   # [NEW] ودجت ملخص المشروع
│   │       ├── activity_feed_widget.dart     # [NEW] ودجت سجل النشاط
│   │       └── agile_status_widget.dart      # [NEW] ودجت حالة لوحة العمل
│   └── shared/
│       ├── icon_button.dart             # [NEW] زر أيقونة مشترك
│       ├── dropdown_menu.dart           # [NEW] قائمة منسدلة مشتركة
│       ├── modal_dialog.dart            # [NEW] نافذة حوارية مشتركة
│       ├── search_field.dart            # [NEW] حقل بحث مشترك
│       └── tooltip.dart                 # [NEW] تلميح مشترك
├── services/
│   └── dashboard_service.dart           # [NEW] خدمة CRUD مع Supabase
├── models/
│   ├── dashboard_model.dart             # [NEW] موديل اللوحة
│   ├── widget_model.dart                # [NEW] موديل الودجت
│   └── dashboard_share_model.dart       # [NEW] موديل المشاركة
├── styles/
│   └── dashboard_styles.dart            # [NEW] أنماط CSS خاصة بالداشبورد
```

---

## 🎨 التصميم المرئي (Visual Design)

### نظام الألوان (مطابق لـ YouTrack Dark Theme)
```css
:root {
  /* Dashboard-specific variables */
  --dashboard-bg: #1e1e1e;
  --dashboard-sidebar-bg: #252526;
  --dashboard-card-bg: #2d2d30;
  --dashboard-card-border: #3e3e42;
  --dashboard-card-hover: #383838;
  --dashboard-toolbar-bg: #1e1e1e;
  --dashboard-accent: #6C63FF;
  --dashboard-star: #FFB800;
  --dashboard-success: #4CAF50;
  --dashboard-warning: #FF9800;
  --dashboard-danger: #F44336;
  --dashboard-info: #2196F3;
  
  /* Chart Colors */
  --chart-blue: #4FC3F7;
  --chart-green: #81C784;
  --chart-orange: #FFB74D;
  --chart-red: #E57373;
  --chart-purple: #BA68C8;
  --chart-teal: #4DB6AC;
}
```

### مواصفات تصميم الشبكة (Grid Specifications)
- **نظام الشبكة**: CSS Grid مع 3 أعمدة
- **حجم العمود الواحد**: `1fr` (مرن)
- **الفجوة بين الودجات**: `16px`
- **حشوة الودجت**: `16px`
- **انحناء الحواف**: `8px`
- **الظل**: `0 1px 3px rgba(0,0,0,0.3)`

### مواصفات بطاقة الودجت (Widget Card)
```
┌──────────────────────────────────┐
│ 📊 Widget Title          ⋮ ⟳   │  ← Header (40px)
├──────────────────────────────────┤
│                                  │
│        Widget Content            │  ← Content (مرن)
│                                  │
│                                  │
└──────────────────────────────────┘

قائمة ⋮ (More Menu):
  ├── ✏️ Edit settings
  ├── 📋 Clone widget
  ├── 🔄 Refresh
  └── 🗑️ Remove widget
```

---

## 📝 التغييرات المقترحة

### المكون 1: قاعدة البيانات (Database)
#### [MODIFY] [schema.sql](file:///home/osmsoftwareengineering/flutter_projects/you_track_web/docs/schema.sql)
- إضافة جداول `dashboards`, `dashboard_widgets`, `dashboard_shares`
- إضافة RLS policies و triggers و indexes

---

### المكون 2: النماذج (Models)
#### [NEW] `lib/models/dashboard_model.dart`
- كلاس `DashboardModel` مع `fromJson` و `toJson`
- حقول: `id`, `name`, `ownerId`, `isDefault`, `isFavorite`, `layoutConfig`, `createdAt`, `updatedAt`

#### [NEW] `lib/models/widget_model.dart`
- كلاس `DashboardWidgetModel` مع `fromJson` و `toJson`
- حقول: `id`, `dashboardId`, `widgetType`, `title`, `config`, `positionX`, `positionY`, `width`, `height`
- Enum `WidgetType` لأنواع الودجات

#### [NEW] `lib/models/dashboard_share_model.dart`
- كلاس `DashboardShareModel` مع `fromJson` و `toJson`

---

### المكون 3: خدمة البيانات (Data Service)
#### [NEW] `lib/services/dashboard_service.dart`
عمليات CRUD كاملة:
- `fetchDashboards()` — جلب جميع لوحات المستخدم (ملكية + مشاركة)
- `createDashboard(name)` — إنشاء لوحة جديدة
- `updateDashboard(id, data)` — تحديث اسم/إعدادات اللوحة
- `deleteDashboard(id)` — حذف اللوحة
- `toggleFavorite(id)` — تفضيل/إلغاء تفضيل
- `setDefault(id)` — تعيين كافتراضية
- `fetchWidgets(dashboardId)` — جلب ودجات اللوحة
- `addWidget(dashboardId, type, config)` — إضافة ودجت
- `updateWidget(id, data)` — تحديث ودجت
- `removeWidget(id)` — حذف ودجت
- `cloneWidget(id)` — استنساخ ودجت
- `updateWidgetPosition(id, x, y, w, h)` — تحديث موقع/حجم
- `shareDashboard(id, userId, permission)` — مشاركة اللوحة
- `fetchIssuesForWidget(config)` — جلب بيانات المهام للودجت
- `fetchProjectSummary(projectId)` — جلب ملخص المشروع
- `fetchActivityFeed(config)` — جلب سجل النشاط

---

### المكون 4: الأنماط (Styles)
#### [NEW] `lib/styles/dashboard_styles.dart`
- متغيرات CSS خاصة بالداشبورد
- أنماط الشبكة (Grid)
- أنماط البطاقات
- أنماط الشريط الجانبي
- أنماط شريط الأدوات
- تأثيرات الحركة (Transitions)

#### [MODIFY] [styles.css](file:///home/osmsoftwareengineering/flutter_projects/you_track_web/web/styles.css)
- إضافة متغيرات CSS الخاصة بالداشبورد
- أنماط CSS للمكونات الجديدة

---

### المكون 5: المكونات المشتركة (Shared Components)
#### [NEW] `lib/components/shared/icon_button.dart`
- زر أيقونة قابل لإعادة الاستخدام مع tooltip

#### [NEW] `lib/components/shared/dropdown_menu.dart`
- قائمة منسدلة مع عناصر قابلة للضغط

#### [NEW] `lib/components/shared/modal_dialog.dart`
- نافذة حوارية مع overlay وanimations

#### [NEW] `lib/components/shared/search_field.dart`
- حقل بحث مع أيقونة وclear button

---

### المكون 6: مكونات الداشبورد الرئيسية (Dashboard Core Components)
#### [NEW] `lib/components/dashboard/dashboard_page.dart`
- الصفحة الرئيسية: تجمع Sidebar + Toolbar + Grid
- إدارة الحالة المحلية (اللوحة المحددة، الودجات)
- تحميل البيانات عند بدء التشغيل

#### [NEW] `lib/components/dashboard/dashboard_sidebar.dart`
- قائمة اللوحات مع أيقونة ⭐ للمفضلة
- زر "+ New Dashboard"
- حقل بحث للتصفية
- قسم "My Dashboards" و "Shared with me"

#### [NEW] `lib/components/dashboard/dashboard_toolbar.dart`
- اسم اللوحة الحالية (قابل للتعديل)
- أزرار: Share, Settings, Add Widget
- زر Favorite (⭐)

#### [NEW] `lib/components/dashboard/dashboard_grid.dart`
- شبكة CSS Grid ثلاثية الأعمدة
- عرض الودجات حسب مواقعها
- حالة الفارغة (Empty State) عندما لا توجد ودجات

#### [NEW] `lib/components/dashboard/dashboard_empty_state.dart`
- رسالة ترحيبية وزر "Add your first widget"

#### [NEW] `lib/components/dashboard/create_dashboard_dialog.dart`
- حقل إدخال اسم اللوحة
- زر إنشاء/إلغاء

#### [NEW] `lib/components/dashboard/share_dashboard_dialog.dart`
- حقل بحث عن مستخدمين
- قائمة المشاركين مع أدوارهم
- إمكانية تغيير الصلاحية أو إزالة المشارك

#### [NEW] `lib/components/dashboard/add_widget_dialog.dart`
- شبكة أنواع الودجات المتاحة مع أيقونات
- نموذج تكوين خاص بكل نوع

---

### المكون 7: مكونات الودجات (Widget Components)
#### [NEW] `lib/components/dashboard/widgets/widget_card.dart`
- غلاف مشترك: Header (عنوان + أزرار) + Content area
- قائمة "More" (⋮) مع خيارات: Edit, Clone, Refresh, Remove

#### [NEW] `lib/components/dashboard/widgets/widget_menu.dart`
- القائمة المنبثقة لخيارات الودجت

#### [NEW] `lib/components/dashboard/widgets/issue_list_widget.dart`
- عرض قائمة المهام المصفاة
- كل عنصر يعرض: Issue Key, Title, State badge, Priority icon, Assignee avatar
- إعدادات: Project filter, State filter, Max items

#### [NEW] `lib/components/dashboard/widgets/issue_distribution_widget.dart`
- رسم بياني (Bar Chart / Pie Chart) بإستخدام CSS
- توزيع حسب: State, Priority, Type, Assignee
- ألوان مخصصة لكل فئة
- إعدادات: Project, Group by field, Chart type

#### [NEW] `lib/components/dashboard/widgets/quick_notes_widget.dart`
- محرر نص بسيط
- حفظ تلقائي للمحتوى

#### [NEW] `lib/components/dashboard/widgets/project_summary_widget.dart`
- اسم المشروع وعدد الأعضاء
- عدادات: Open, In Progress, Resolved, Closed
- شريط تقدم ملون

#### [NEW] `lib/components/dashboard/widgets/activity_feed_widget.dart`
- قائمة آخر الأنشطة (تغييرات حالة، تعليقات)
- كل عنصر: Avatar, User, Action, Issue, Time ago

#### [NEW] `lib/components/dashboard/widgets/agile_status_widget.dart`
- شريط تقدم Sprint
- عدد المهام: Done / Total
- نسبة الإنجاز

---

### المكون 8: التنقل (Navigation)
#### [MODIFY] [app.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track_web/lib/app.dart)
- إضافة مسار `/dashboard` لصفحة الداشبورد
- توجيه المستخدم بعد تسجيل الدخول إلى `/dashboard` بدلاً من `/home`

---

## 🔗 التبعيات والمهارات المطلوبة

| التبعية | النوع | الغرض |
|---------|------|-------|
| `jaspr` | حزمة | إطار العمل الأساسي |
| `jaspr_router` | حزمة | التنقل |
| `supabase` | حزمة | قاعدة البيانات والمصادقة |

> [!NOTE]
> لا توجد حاجة لحزم إضافية. سيتم بناء الرسوم البيانية (Charts) باستخدام CSS فقط (CSS Bar Charts & Pie Charts) دون مكتبات خارجية.

---

## ✅ خطة التحقق (Verification Plan)

### التحقق اليدوي
1. تشغيل التطبيق والتأكد من عرض صفحة الداشبورد بعد تسجيل الدخول
2. اختبار إنشاء لوحة جديدة وإضافة ودجات
3. اختبار تعديل وحذف ونسخ الودجات
4. اختبار تفضيل اللوحة والبحث في الشريط الجانبي
5. التأكد من توافق التصميم مع Dark/Light themes
6. اختبار عرض البيانات الحقيقية في الودجات (Issue List, Distribution, etc.)

### التشغيل
```bash
cd /home/osmsoftwareengineering/flutter_projects/you_track_web
dart run jaspr serve
```

---

## ⚠️ مراجعة مطلوبة من المستخدم

> [!IMPORTANT]
> **جداول قاعدة البيانات**: هل تريد أن أقوم بتنفيذ الجداول الجديدة مباشرة على Supabase عبر `execute_sql`، أم تفضل إضافتها يدوياً أو عبر migration file؟

> [!IMPORTANT]
> **أنواع الودجات**: القائمة تتضمن 6 أنواع (Issue List, Issue Distribution, Quick Notes, Project Summary, Activity Feed, Agile Status). هل تريد إضافة أنواع أخرى أو الاكتفاء بهذه المجموعة للمرحلة الأولى؟

> [!WARNING]
> **Drag & Drop**: إطار Jaspr لا يدعم Drag & Drop بشكل أصلي. سيتم تنفيذ تغيير الترتيب عبر أزرار أسهم (Move Up/Down/Left/Right) بدلاً من السحب والإفلات. هل هذا مقبول؟

## أسئلة مفتوحة

1. **هل تريد أن يكون التصميم Dark Theme فقط أم يدعم Light/Dark حسب إعدادات النظام؟** (التصميم الحالي يدعم الوضعين)
2. **هل هناك لوحة افتراضية يجب إنشاؤها تلقائياً عند تسجيل مستخدم جديد؟** (مثل "My Work" dashboard)
3. **هل تريد دعم Real-time updates للودجات عبر Supabase Realtime؟** (تحديث تلقائي عند تغيير البيانات)
