# هيكل ميزة المنتجات (Products Feature Example)

يوضح هذا المثال التقسيم الصحيح للمجلدات والملفات داخل ميزة جديدة:

```text
lib/features/products/
├── data/
│   ├── datasources/
│   │   ├── products_local_datasource.dart
│   │   └── products_local_datasource_impl.dart
│   ├── models/
│   │   └── product_model.dart
│   └── repositories/
│       └── products_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── product_entity.dart
│   ├── repositories/
│   │   └── products_repository.dart
│   └── usecases/
│       ├── add_product.dart
│       └── get_products.dart
└── presentation/
    ├── bloc/
    │   ├── products_bloc.dart
    ├── states/
    │   └── products_state.dart
    ├── events/
    │   ├── products_event.dart
    ├── cubits/
    │   ├── products_cubit.dart
    ├── pages/
    │   └── products_page.dart
    └── widgets/
        └── product_card.dart
```

## ملاحظات:
*   الـ **Data Model** يجب أن يمتد من الـ **Entity**.
*   الـ **Usecase** يجب أن يعتمد على الـ **Repository Interface** (من الدومين) وليس الـ Implementation.
