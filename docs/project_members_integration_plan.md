# خطة تنفيذية: دمج المجموعات والأدوار في صفحة أعضاء المشروع

بناءً على التحليل السابق لصفحة `ProjectMembersPage` وحوار `AddProjectMembersPage`، تم وضع هذه الخطة التفصيلية لمعالجة الفجوات وربط الصفحة بنظام المجموعات (`Groups`) والأدوار (`Roles`) بشكل صحيح بدلاً من القيم الثابتة (Hardcoded).

## User Review Required

> [!WARNING]
> تعديلات الجذور (Core Changes)
> سيتم تعديل `ProjectMembersCubit` ليتعامل مع واجهات أنظمة متعددة (المجموعات والأدوار). يُرجى مراجعة الخطة والتأكد من توافقها مع الرؤية المعمارية للمشروع قبل الموافقة على التنفيذ.

## Open Questions

> [!IMPORTANT]
> 1. هل نفضل دمج المجموعات والأفراد في قائمة واحدة داخل UI (مع أيقونة تميز المجموعة عن الفرد)، أم فصلهم في قسمين مختلفين (مثلاً: "Project Team Users" و "Project Team Groups")؟ (تم افتراض الدمج في نفس القائمة في هذه الخطة).
> 2. عند إضافة مجموعة لمشروع بدور معين، هل نحتاج أيضاً لجلب تفاصيل أعضاء تلك المجموعة وعرضهم كأفراد في المشروع، أم نكتفي بعرض اسم المجموعة ككيان واحد؟ (تم افتراض عرض كيان المجموعة فقط لتجنب التكرار والتعقيد).

---

## Proposed Changes

### 1. طبقة النطاق وإدارة الحالة (Domain & State Management)

سنقوم بتوسيع `ProjectMembersCubit` ليكون قادراً على التعامل مع المجموعات وإضافة أدوارها، مع الاستفادة من الـ Use Cases الموجودة في نظام المجموعات والأدوار.

#### [MODIFY] `lib/features/projects/presentation/cubits/project_members_cubit.dart`
- **الحالة (`ProjectMembersState`)**:
  - إضافة `List<RoleEntity> availableRoles` لحفظ الأدوار الحقيقية.
  - إضافة `List<GroupEntity> availableGroups` لحفظ المجموعات المتاحة للإضافة.
  - إضافة `List<GroupRoleAssignmentEntity> projectGroups` لحفظ المجموعات المضافة فعلياً للمشروع.
- **التوابع (Methods)**:
  - إضافة `loadDependencies()` لجلب الأدوار والمجموعات عند فتح حوار الإضافة (بالتنسيق مع `GetRoles` و `GetGroups`).
  - إضافة `loadProjectGroups(String projectId)` لجلب المجموعات المرتبطة بالمشروع.
  - إضافة `addGroupToProject(String projectId, String groupId, String roleName)` الذي سيقوم باستدعاء Use Cases نظام المجموعات لربط المجموعة وتعيين دورها.

---

### 2. طبقة عرض حوار الإضافة (AddProjectMembers Dialog)

سيتم التخلص من القيم الثابتة (Hardcoded) وربط الحوار بالبيانات الحية.

#### [MODIFY] `lib/features/projects/presentation/pages/add_project_members_page.dart`
- استبدال `_availableRoles` الثابتة بقائمة تُقرأ من حالة الـ Cubit (أو الـ `RolesBloc` إذا كان متوفراً).
- استبدال `_groups` الثابتة بالقائمة الفعلية للمجموعات القادمة من قاعدة البيانات.
- تعديل بناء الواجهة `_buildGroupRow` ليتعامل مع الكائن الحقيقي للمجموعة وليس مجرد `String`.
- **منطق `_invite()`**:
  - تحديثه ليقوم بالدوران على الكيانات المحددة.
  - إذا كان الكيان فرداً -> استدعاء `addMember`.
  - إذا كان الكيان مجموعة -> استدعاء `addGroupToProject` بالدور المحدد.

---

### 3. طبقة عرض صفحة الأعضاء (Project Members Page)

ستحتاج الصفحة إلى عرض الكيانات المدمجة (أفراد + مجموعات).

#### [MODIFY] `lib/features/projects/presentation/pages/project_members_page.dart`
#### [MODIFY] `lib/features/projects/presentation/widgets/settings_sections/project_people_settings_section.dart`
- توحيد قائمة العرض لتشمل الأفراد (`ProjectMemberEntity`) والمجموعات (`GroupRoleAssignmentEntity`).
- تعديل قسم `Project Team` ليحتوي على:
  - الأفراد الذين هم `isOwner` أو لديهم دور إداري.
  - المجموعات التي تم تعيين أدوار إدارية لها في هذا المشروع.
- تعديل دالة `_buildMemberTile` لتقبل كائناً عاماً (أو إنشاء Widget مخصص للمجموعات `_buildGroupTile`) يعرض أيقونة المجموعة بدلاً من الأفاتار الفردي.
- استخدام نصوص الترجمة (`AppLocalizations`) بدلاً من النصوص الثابتة المتبقية.

---

## Verification Plan

### Automated Tests
سيتم تحديث / كتابة اختبارات الوحدة (Unit Tests) لـ `ProjectMembersCubit` للتأكد من:
- جلب الأدوار والمجموعات بشكل صحيح.
- التعامل السليم مع إضافة فرد مقابل إضافة مجموعة.

### Manual Verification
1. الدخول إلى صفحة إعدادات المشروع (أو صفحة People).
2. فتح حوار "Add People".
3. التأكد من ظهور المجموعات الحقيقية المُنشأة في النظام.
4. التأكد من ظهور الأدوار الحقيقية في قائمة منسدلة.
5. اختيار مجموعة واختيار مستخدم فردي، وتحديد دور لكل منهما ثم الضغط على "Invite".
6. التأكد من ظهور كل من المستخدم الفردي والمجموعة ضمن قائمة المشروع الأساسية بأدوارهم الصحيحة.
