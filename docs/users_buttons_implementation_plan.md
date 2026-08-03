# 📋 الخطة التنفيذية — تفعيل أزرار واجهة المستخدمين

> **المرجع**: تحليل أزرار واجهة المستخدمين وربطها بـ `UserEntity`
> **التاريخ**: 2026-07-31
> **النطاق**: تفعيل 10 أزرار معطّلة في صفحة المستخدمين

---

## 📊 ملخص الوضع الحالي

### ✅ ما هو جاهز ويمكن إعادة استخدامه

| المكوّن | الموقع | الملاحظات |
|---------|--------|-----------|
| `UsersRepository.deleteUser(id)` | [users_repository.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/users/domain/repositories/users_repository.dart) | جاهز للاستخدام المباشر |
| `UsersRepository.updateUser(user)` | نفس الملف | يمكن استخدامه لـ Ban/Edit |
| `UsersRemoteDataSource` (جميع الدوال) | [users_remote_data_source.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/users/data/datasources/users_remote_data_source.dart) | CRUD كامل مع Supabase |
| `UsersSqliteDataSourceImpl` (جميع الدوال) | [users_sqlite_data_source_impl.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/users/data/datasources/users_sqlite_data_source_impl.dart) | CRUD كامل مع SQLite |
| `AddGroupMembers` UseCase | [add_group_members.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/groups/domain/usecases/add_group_members.dart) | جاهز — يقبل `groupId` + `List<userIds>` |
| `GetGroups` UseCase | [get_groups.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/groups/domain/usecases/get_groups.dart) | جاهز — لجلب قائمة المجموعات |
| `GroupsRepository.addGroupMembers()` | [groups_repository.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/groups/domain/repositories/groups_repository.dart) | جاهز |

### ❌ ما هو مفقود

| المكوّن المفقود | السبب |
|----------------|-------|
| آلية التحديد المتعدد (Multi-Select) | الـ Checkbox ثابت `false` — لا يوجد `selectedUserIds` في State |
| `DeleteUserEvent` / `BanUserEvent` / `EditUserEvent` / `MergeUsersEvent` | لا توجد Events في الـ Bloc |
| `DeleteUser` / `BanUser` / `EditUser` / `MergeUsers` UseCases | لا توجد حالات استخدام |
| `RemoveGroupMembers` في Groups | فقط `addGroupMembers` موجود، لا يوجد remove |
| Dialog تعديل المستخدم (Edit User) | لا يوجد |
| Dialog تأكيد الحذف / الحظر | لا يوجد |

---

## 🏗️ المراحل التنفيذية

---

### المرحلة 0: البنية التحتية — التحديد المتعدد (Multi-Select)

> **الأولوية**: 🔴 حرجة — جميع الأزرار الجماعية تعتمد عليها
> **التبعيات**: لا شيء
> **المهارات المطلوبة**: `إدارة الحالة (State Management)`

هذه المرحلة هي الأساس الذي تبنى عليه جميع المراحل اللاحقة. بدون آلية تحديد متعدد، لا يمكن لأي زر جماعي أن يعمل.

#### 0.1 — تعديل `UsersState`

**الملف**: [users_state.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/users/presentation/bloc/users_state.dart)

**التغييرات**:
```dart
class UsersLoaded extends UsersState {
  final List<UserEntity> users;
  final String? selectedUserId;          // ← موجود (للتحديد الفردي)
  final Set<String> selectedUserIds;     // ← جديد (للتحديد المتعدد)

  const UsersLoaded({
    required this.users,
    this.selectedUserId,
    this.selectedUserIds = const {},     // ← جديد
  });

  /// هل كل المستخدمين محددين؟
  bool get isAllSelected =>
      users.isNotEmpty && selectedUserIds.length == users.length;

  /// هل يوجد تحديد جزئي؟
  bool get hasSelection => selectedUserIds.isNotEmpty;

  UsersLoaded copyWith({
    List<UserEntity>? users,
    String? selectedUserId,
    bool clearSelected = false,
    Set<String>? selectedUserIds,        // ← جديد
  }) {
    return UsersLoaded(
      users: users ?? this.users,
      selectedUserId:
          clearSelected ? null : (selectedUserId ?? this.selectedUserId),
      selectedUserIds: selectedUserIds ?? this.selectedUserIds,
    );
  }

  @override
  List<Object?> get props => [users, selectedUserId, selectedUserIds];
}
```

#### 0.2 — إضافة Events للتحديد

**الملف**: [users_event.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/users/presentation/bloc/users_event.dart)

**الإضافات**:
```dart
/// تبديل تحديد مستخدم واحد (Toggle)
class ToggleUserSelection extends UsersEvent {
  final String userId;
  const ToggleUserSelection(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// تحديد/إلغاء تحديد الكل
class ToggleSelectAll extends UsersEvent {
  const ToggleSelectAll();
}

/// مسح جميع التحديدات
class ClearSelection extends UsersEvent {
  const ClearSelection();
}
```

#### 0.3 — تسجيل Handlers في الـ Bloc

**الملف**: [users_bloc.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/users/presentation/bloc/users_bloc.dart)

**الإضافات**:
```dart
// في الـ Constructor:
on<ToggleUserSelection>(_onToggleUserSelection);
on<ToggleSelectAll>(_onToggleSelectAll);
on<ClearSelection>(_onClearSelection);

// الـ Handlers:
void _onToggleUserSelection(ToggleUserSelection event, Emitter<UsersState> emit) {
  if (state is UsersLoaded) {
    final current = state as UsersLoaded;
    final updated = Set<String>.from(current.selectedUserIds);
    if (updated.contains(event.userId)) {
      updated.remove(event.userId);
    } else {
      updated.add(event.userId);
    }
    emit(current.copyWith(selectedUserIds: updated));
  }
}

void _onToggleSelectAll(ToggleSelectAll event, Emitter<UsersState> emit) {
  if (state is UsersLoaded) {
    final current = state as UsersLoaded;
    if (current.isAllSelected) {
      emit(current.copyWith(selectedUserIds: {}));
    } else {
      emit(current.copyWith(
        selectedUserIds: current.users.map((u) => u.id).toSet(),
      ));
    }
  }
}

void _onClearSelection(ClearSelection event, Emitter<UsersState> emit) {
  if (state is UsersLoaded) {
    emit((state as UsersLoaded).copyWith(selectedUserIds: {}));
  }
}
```

#### 0.4 — تحديث واجهة الجدول

**الملفات**:
- [user_table_row.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/users/presentation/widgets/user_table_row.dart) — ربط الـ Checkbox بـ `ToggleUserSelection`
- [users_table_view.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/users/presentation/widgets/users_table_view.dart) — ربط Checkbox الـ Header بـ `ToggleSelectAll`
- [users_page.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/users/presentation/pages/users_page.dart) — تعطيل/تفعيل أزرار الشريط بناءً على `hasSelection`

**تفاصيل تعديل `UserTableRow`**:
- إضافة `onCheckChanged` callback أو استخدام الـ Bloc مباشرة
- تغيير `Checkbox(value: false, onChanged: null)` إلى:
```dart
Checkbox(
  value: widget.isSelected,
  onChanged: (_) => context.read<UsersBloc>().add(ToggleUserSelection(widget.user.id)),
  visualDensity: VisualDensity.compact,
)
```

**تفاصيل تعديل شريط الأزرار في `UsersPage`**:
- تعطيل الأزرار عندما لا يوجد تحديد (`state.hasSelection == false`)
- تغيير لون الأزرار المعطّلة

---

### المرحلة 1: زر الحذف (Delete)

> **الأولوية**: 🟡 عالية
> **التبعيات**: المرحلة 0 (Multi-Select)
> **المهارات المطلوبة**: `إضافة حالة استخدام (Use Case Development)`، `إدارة الحالة (State Management)`

#### 1.1 — إنشاء `DeleteUser` UseCase

**الملف الجديد**: `lib/features/users/domain/usecases/delete_user.dart`

```dart
class DeleteUserParams extends Params {
  final String userId;
  const DeleteUserParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class DeleteUser extends UseCase<void, DeleteUserParams> {
  final UsersRepository repository;
  DeleteUser(this.repository);

  @override
  Future<Either<Failure, void>> call({required DeleteUserParams params}) {
    return repository.deleteUser(params.userId);
  }
}
```

#### 1.2 — إضافة `DeleteUsersEvent` في الـ Bloc

**الملف**: [users_event.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/users/presentation/bloc/users_event.dart)

```dart
/// حذف مستخدم واحد أو أكثر
class DeleteUsersEvent extends UsersEvent {
  final List<String> userIds;
  const DeleteUsersEvent(this.userIds);

  @override
  List<Object?> get props => [userIds];
}
```

#### 1.3 — تسجيل Handler في الـ Bloc

**الملف**: [users_bloc.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/users/presentation/bloc/users_bloc.dart)

- إضافة `DeleteUser` UseCase كتبعية في الـ Constructor
- تسجيل `on<DeleteUsersEvent>(_onDeleteUsers)`
- Handler يحذف كل مستخدم بالتتابع ثم يعيد تحميل القائمة:

```dart
Future<void> _onDeleteUsers(DeleteUsersEvent event, Emitter<UsersState> emit) async {
  for (final userId in event.userIds) {
    final result = await deleteUser(params: DeleteUserParams(userId: userId));
    if (result.isLeft()) {
      emit(UsersError(result.getLeft().getOrElse(() => const ServerFailure()).message));
      return;
    }
  }
  add(const LoadUsers());
}
```

#### 1.4 — إنشاء Dialog تأكيد الحذف

**الملف الجديد**: `lib/features/users/presentation/widgets/confirm_action_dialog.dart`

- Dialog عام قابل لإعادة الاستخدام (لـ Delete و Ban و Merge)
- يقبل: `title`, `message`, `confirmLabel`, `confirmColor`, `onConfirm`
- يعرض عدد المستخدمين المحددين

#### 1.5 — ربط زر Delete في الواجهة

**الملفات**:
- [users_page.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/users/presentation/pages/users_page.dart) — الزر الجماعي (L66)
- [user_table_row.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/users/presentation/widgets/user_table_row.dart) — الزر في PopupMenu (L180)

**السيناريو**:
1. المستخدم يحدد مستخدمًا أو أكثر ← يضغط Delete
2. يظهر `ConfirmActionDialog` مع رسالة تأكيد
3. عند التأكيد ← إرسال `DeleteUsersEvent(selectedUserIds.toList())`
4. الـ Bloc يحذف ← يعيد تحميل ← يمسح التحديدات

---

### المرحلة 2: زر الحظر (Ban / Unban)

> **الأولوية**: 🟡 عالية
> **التبعيات**: المرحلة 0 (Multi-Select)
> **المهارات المطلوبة**: `إضافة حالة استخدام (Use Case Development)`، `إدارة الحالة (State Management)`

#### 2.1 — إنشاء `BanUser` UseCase

**الملف الجديد**: `lib/features/users/domain/usecases/ban_user.dart`

```dart
class BanUserParams extends Params {
  final String userId;
  final bool isBanned;  // true = حظر، false = إلغاء حظر
  const BanUserParams({required this.userId, required this.isBanned});

  @override
  List<Object?> get props => [userId, isBanned];
}

class BanUser extends UseCase<UserEntity, BanUserParams> {
  final UsersRepository repository;
  BanUser(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call({required BanUserParams params}) async {
    // 1. جلب المستخدم الحالي
    final userResult = await repository.getUserById(params.userId);
    return userResult.fold(
      (failure) => Left(failure),
      (user) => repository.updateUser(user.copyWith(isBanned: params.isBanned)),
    );
  }
}
```

#### 2.2 — إضافة `BanUsersEvent` في الـ Bloc

**الملف**: [users_event.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/users/presentation/bloc/users_event.dart)

```dart
class BanUsersEvent extends UsersEvent {
  final List<String> userIds;
  final bool ban;  // true = حظر، false = إلغاء حظر
  const BanUsersEvent({required this.userIds, required this.ban});

  @override
  List<Object?> get props => [userIds, ban];
}
```

#### 2.3 — تسجيل Handler في الـ Bloc

- إضافة `BanUser` UseCase كتبعية
- Handler يحظر/يلغي حظر كل مستخدم ثم يعيد التحميل

#### 2.4 — ربط الواجهة

**التعديلات**:
- زر `Ban` في الشريط الجماعي (L62) — يعرض Dialog تأكيد ثم يرسل `BanUsersEvent`
- زر `Ban` في PopupMenu الصف (L181) — يرسل `BanUsersEvent` لمستخدم واحد
- **إضافة زر Unban**: عندما يكون المستخدم المحدد `isBanned == true`، يتغير نص الزر إلى "Unban"

---

### المرحلة 3: أزرار المجموعات (Add to group / Remove from group)

> **الأولوية**: 🟡 عالية
> **التبعيات**: المرحلة 0 (Multi-Select) + ميزة Groups الموجودة
> **المهارات المطلوبة**: `إضافة حالة استخدام (Use Case Development)`، `إضافة واجهة مستودع (Repository Interface Development)`

#### 3.1 — إضافة `removeGroupMembers` في Groups Domain

**الملف**: [groups_repository.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/groups/domain/repositories/groups_repository.dart)

```dart
// إضافة الدالة التالية إلى الواجهة:
Future<Either<Failure, void>> removeGroupMembers(String groupId, List<String> userIds);
```

#### 3.2 — إنشاء `RemoveGroupMembers` UseCase

**الملف الجديد**: `lib/features/groups/domain/usecases/remove_group_members.dart`

```dart
class RemoveGroupMembersParams extends Params {
  final String groupId;
  final List<String> userIds;
  const RemoveGroupMembersParams({required this.groupId, required this.userIds});

  @override
  List<Object?> get props => [groupId, userIds];
}

class RemoveGroupMembers extends UseCase<void, RemoveGroupMembersParams> {
  final GroupsRepository repository;
  RemoveGroupMembers(this.repository);

  @override
  Future<Either<Failure, void>> call({required RemoveGroupMembersParams params}) {
    return repository.removeGroupMembers(params.groupId, params.userIds);
  }
}
```

#### 3.3 — تنفيذ `removeGroupMembers` في Groups Data Layer

**الملفات المتأثرة**:
- DataSource Interface — إضافة الدالة
- DataSource Impl (Supabase / SQLite) — تنفيذ الحذف
- Repository Impl — تمرير الطلب

#### 3.4 — إضافة Events في Users Bloc

**الملف**: [users_event.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/users/presentation/bloc/users_event.dart)

```dart
class AddUsersToGroupEvent extends UsersEvent {
  final List<String> userIds;
  final String groupId;
  const AddUsersToGroupEvent({required this.userIds, required this.groupId});

  @override
  List<Object?> get props => [userIds, groupId];
}

class RemoveUsersFromGroupEvent extends UsersEvent {
  final List<String> userIds;
  final String groupId;
  const RemoveUsersFromGroupEvent({required this.userIds, required this.groupId});

  @override
  List<Object?> get props => [userIds, groupId];
}
```

#### 3.5 — تسجيل Handlers في الـ Bloc

- إضافة `AddGroupMembers` و `RemoveGroupMembers` و `GetGroups` كتبعيات
- Handler لكل Event يستدعي الـ UseCase المناسب ثم يعيد تحميل المستخدمين

#### 3.6 — إنشاء Groups Selection Dialog

**الملف الجديد**: `lib/features/users/presentation/widgets/group_selection_dialog.dart`

- يجلب قائمة المجموعات المتاحة عبر `GetGroups`
- يعرضها في Dialog مع Radio buttons (اختيار مجموعة واحدة)
- يعيد الـ `groupId` المختار

#### 3.7 — ربط أزرار Dropdown في الواجهة

**الملف**: [users_page.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/users/presentation/pages/users_page.dart)

- `Add to group` (L58): عند الضغط ← فتح `GroupSelectionDialog` ← إرسال `AddUsersToGroupEvent`
- `Remove from group` (L60): عند الضغط ← فتح Dialog بمجموعات المستخدمين المشتركة ← إرسال `RemoveUsersFromGroupEvent`

---

### المرحلة 4: زر التعديل (Edit User)

> **الأولوية**: 🟢 متوسطة
> **التبعيات**: المرحلة 0
> **المهارات المطلوبة**: `إضافة حالة استخدام (Use Case Development)`، `بناء صفحة واجهة مستخدم (UI Page)`

#### 4.1 — إنشاء `UpdateUser` UseCase

**الملف الجديد**: `lib/features/users/domain/usecases/update_user.dart`

```dart
class UpdateUserParams extends Params {
  final UserEntity user;
  const UpdateUserParams({required this.user});

  @override
  List<Object?> get props => [user];
}

class UpdateUser extends UseCase<UserEntity, UpdateUserParams> {
  final UsersRepository repository;
  UpdateUser(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call({required UpdateUserParams params}) {
    return repository.updateUser(params.user);
  }
}
```

#### 4.2 — إضافة `EditUserEvent`

**الملف**: [users_event.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/users/presentation/bloc/users_event.dart)

```dart
class EditUserEvent extends UsersEvent {
  final UserEntity updatedUser;
  const EditUserEvent(this.updatedUser);

  @override
  List<Object?> get props => [updatedUser];
}
```

#### 4.3 — إنشاء Edit User Dialog

**الملف الجديد**: `lib/features/users/presentation/pages/edit_user_dialog.dart`

- يشبه `NewUserDialog` في التصميم
- حقول: `fullName`, `username`, `email`, `avatarUrl`
- يستقبل `UserEntity` الحالي ويملأ الحقول تلقائياً
- عند الحفظ يرسل `EditUserEvent`

#### 4.4 — ربط زر Edit في PopupMenu

**الملف**: [user_table_row.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/users/presentation/widgets/user_table_row.dart) (L179)

- عند اختيار 'edit' ← فتح `EditUserDialog` مع بيانات المستخدم الحالي

---

### المرحلة 5: زر الدمج (Merge Users)

> **الأولوية**: 🔵 منخفضة (الأكثر تعقيداً)
> **التبعيات**: المرحلة 0 + المرحلة 1 (Delete) + المرحلة 4 (Edit)
> **المهارات المطلوبة**: `إضافة حالة استخدام (Use Case Development)`

#### 5.1 — إنشاء `MergeUsers` UseCase

**الملف الجديد**: `lib/features/users/domain/usecases/merge_users.dart`

```dart
class MergeUsersParams extends Params {
  final String primaryUserId;    // الحساب الذي سيبقى
  final String secondaryUserId;  // الحساب الذي سيُحذف
  const MergeUsersParams({required this.primaryUserId, required this.secondaryUserId});

  @override
  List<Object?> get props => [primaryUserId, secondaryUserId];
}

class MergeUsers extends UseCase<UserEntity, MergeUsersParams> {
  final UsersRepository repository;
  MergeUsers(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call({required MergeUsersParams params}) async {
    // 1. جلب كلا المستخدمَين
    final primaryResult = await repository.getUserById(params.primaryUserId);
    final secondaryResult = await repository.getUserById(params.secondaryUserId);

    return primaryResult.fold(
      (failure) => Left(failure),
      (primary) => secondaryResult.fold(
        (failure) => Left(failure),
        (secondary) async {
          // 2. دمج groups + projects من الثانوي إلى الأساسي
          final mergedGroups = {...primary.groups, ...secondary.groups}.toList();
          final mergedProjects = {...primary.projects, ...secondary.projects}.toList();

          final merged = primary.copyWith(
            groups: mergedGroups,
            projects: mergedProjects,
          );

          // 3. تحديث الأساسي
          final updateResult = await repository.updateUser(merged);

          // 4. حذف الثانوي
          await repository.deleteUser(params.secondaryUserId);

          return updateResult;
        },
      ),
    );
  }
}
```

#### 5.2 — إضافة `MergeUsersEvent`

```dart
class MergeUsersEvent extends UsersEvent {
  final String primaryUserId;
  final String secondaryUserId;
  const MergeUsersEvent({required this.primaryUserId, required this.secondaryUserId});

  @override
  List<Object?> get props => [primaryUserId, secondaryUserId];
}
```

#### 5.3 — إنشاء Merge Users Dialog

**الملف الجديد**: `lib/features/users/presentation/widgets/merge_users_dialog.dart`

- **شرط التفعيل**: يظهر فقط عند تحديد **مستخدمَين بالضبط**
- يعرض بيانات المستخدمَين جنباً إلى جنب
- يسمح باختيار الحساب الأساسي (الذي سيبقى)
- معاينة النتيجة النهائية (groups + projects المدمجة)
- زر تأكيد الدمج

#### 5.4 — ربط الواجهة

- زر `Merge` (L64): يُفعّل فقط عند `selectedUserIds.length == 2`
- عند الضغط ← فتح `MergeUsersDialog`

---

### المرحلة 6: إدارة السمات المخصصة (Manage Custom Attributes)

> **الأولوية**: 🔵 منخفضة
> **التبعيات**: المرحلة 4 (Edit)

> [!WARNING]
> هذه المرحلة تتطلب تغييرات في الكينونة وقاعدة البيانات، ويُفضّل تأجيلها إلى مرحلة لاحقة لأنها تؤثر على بنية البيانات الأساسية.

#### 6.1 — توسيع `UserEntity`

```dart
// إضافة حقل جديد:
final Map<String, dynamic> customAttributes;  // default: const {}
```

#### 6.2 — تحديث `UserModel` / DataSource / Schema

- تحديث `fromJson` / `toJson` لمعالجة الحقل الجديد
- تحديث جدول `users` في SQLite (إضافة عمود `custom_attributes TEXT`)
- تحديث جدول Supabase (إضافة عمود `custom_attributes JSONB`)

#### 6.3 — إنشاء صفحة إدارة السمات

**الملف الجديد**: `lib/features/users/presentation/pages/manage_attributes_page.dart`

- تعريف السمات المخصصة (الاسم، النوع، القيمة الافتراضية)
- إضافة/تعديل/حذف سمات
- ربطها بالـ TextButton (L68-L76)

---

## 📁 ملخص الملفات

### ملفات جديدة (مُرتّبة حسب المرحلة)

| المرحلة | الملف | الوصف |
|---------|-------|-------|
| 1 | `domain/usecases/delete_user.dart` | UseCase حذف مستخدم |
| 1 | `presentation/widgets/confirm_action_dialog.dart` | Dialog تأكيد عام |
| 2 | `domain/usecases/ban_user.dart` | UseCase حظر/إلغاء حظر |
| 3 | `groups/.../usecases/remove_group_members.dart` | UseCase إزالة أعضاء من مجموعة |
| 3 | `presentation/widgets/group_selection_dialog.dart` | Dialog اختيار مجموعة |
| 4 | `domain/usecases/update_user.dart` | UseCase تحديث مستخدم |
| 4 | `presentation/pages/edit_user_dialog.dart` | Dialog تعديل مستخدم |
| 5 | `domain/usecases/merge_users.dart` | UseCase دمج مستخدمَين |
| 5 | `presentation/widgets/merge_users_dialog.dart` | Dialog دمج المستخدمين |
| 6 | `presentation/pages/manage_attributes_page.dart` | صفحة إدارة السمات |

### ملفات موجودة تحتاج تعديل

| الملف | المراحل المتأثرة | نوع التغيير |
|-------|-----------------|-------------|
| [users_state.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/users/presentation/bloc/users_state.dart) | 0 | إضافة `selectedUserIds` |
| [users_event.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/users/presentation/bloc/users_event.dart) | 0, 1, 2, 3, 4, 5 | إضافة Events جديدة |
| [users_bloc.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/users/presentation/bloc/users_bloc.dart) | 0, 1, 2, 3, 4, 5 | إضافة UseCases + Handlers |
| [users_page.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/users/presentation/pages/users_page.dart) | 0, 1, 2, 3, 5, 6 | ربط الأزرار بـ Events |
| [user_table_row.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/users/presentation/widgets/user_table_row.dart) | 0, 1, 2, 4 | Checkbox + PopupMenu handlers |
| [users_table_view.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/users/presentation/widgets/users_table_view.dart) | 0 | Checkbox الـ Header |
| [groups_repository.dart](file:///home/osmsoftwareengineering/flutter_projects/you_track/lib/features/groups/domain/repositories/groups_repository.dart) | 3 | إضافة `removeGroupMembers` |

---

## 🔄 مخطط التبعيات بين المراحل

```
المرحلة 0 (Multi-Select) ← أساس كل شيء
    ├── المرحلة 1 (Delete)
    ├── المرحلة 2 (Ban/Unban)
    ├── المرحلة 3 (Groups) ← تعتمد أيضاً على ميزة Groups الموجودة
    ├── المرحلة 4 (Edit)
    │       └── المرحلة 6 (Custom Attributes) ← تعتمد على Edit
    └── المرحلة 5 (Merge) ← تعتمد على Delete + Edit
```

> [!TIP]
> **ترتيب التنفيذ المقترح**: 0 → 1 → 2 → 4 → 3 → 5 → 6
> بحيث يمكن تنفيذ المراحل 1 و 2 و 4 بالتوازي بعد إكمال المرحلة 0.

---

## ✅ خطة التحقق

| المرحلة | طريقة التحقق |
|---------|-------------|
| 0 | تحديد/إلغاء تحديد مستخدمين من الجدول — التأكد من تغيّر حالة الـ Checkbox |
| 1 | تحديد مستخدم ← Delete ← التأكد من اختفائه من القائمة |
| 2 | تحديد مستخدم ← Ban ← التأكد من ظهور شارة "banned" ← Unban ← التأكد من اختفائها |
| 3 | تحديد مستخدم ← Add to group ← التأكد من ظهور المجموعة في عمود Groups |
| 4 | فتح Edit ← تعديل الاسم ← الحفظ ← التأكد من التحديث في الجدول |
| 5 | تحديد مستخدمَين ← Merge ← التأكد من بقاء حساب واحد بالبيانات المدمجة |
| 6 | إضافة سمة مخصصة ← التأكد من ظهورها في بيانات المستخدم |
