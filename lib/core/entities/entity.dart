import 'package:equatable/equatable.dart';

abstract class Entity extends Equatable {
  const Entity();

  // دالة النسخ الأساسية ليتم تجاوزها في الأبناء
  Entity copyWith();

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props;
}
