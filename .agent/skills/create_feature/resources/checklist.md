# قائمة مراجعة إنشاء ميزة (Feature Checklist)

عند إنشاء ميزة جديدة، تأكد من إتمام هذه النقاط:

- [ ] تعريف الكيان (Entity) في `domain/entities/`.
- [ ] تعريف الـ Repository كـ Abstract class في `domain/repositories/`.
- [ ] إنشاء الـ Models مع `fromJson`/`toJson` في `data/models/`.
- [ ] تنفيذ الـ DataSource وتجربته.
- [ ] تنفيذ الـ Repository Impl وربطه بالـ DataSource.
- [ ] تسجيل جميع التبعات في `init_dependencies.dart`.
- [ ] إنشاء الـ Bloc/Cubit ومعالجة الحالات (Loading, Success, Error).
- [ ] بناء الواجهة (Pages) واستخدام الـ `BlocBuilder` أو `BlocListener`.
- [ ] التأكد من استخدام نصوص مترجمة (Localization) وأيقونات موحدة (AppIcons).
