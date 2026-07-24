import 'package:flutter/material.dart';

sealed class AppIcons {
  const AppIcons._();

  // أيقونة الصفحة الرئيسية
  static const IconData home = Icons.home_rounded;
  // أيقونة الإعدادات
  static const IconData settings = Icons.settings_rounded;
  // أيقونة القائمة
  static const IconData menu = Icons.menu_rounded;
  // أيقونة إضافة جديدة (مشكلة أو مشروع)
  static const IconData add = Icons.add_rounded;
  // أيقونة البحث
  static const IconData search = Icons.search_rounded;
  // أيقونة الإشعارات
  static const IconData notifications = Icons.notifications_rounded;
  // أيقونة المشاريع
  static const IconData projects = Icons.folder_rounded;
  // أيقونة المهام/المشاكل
  static const IconData issues = Icons.bug_report_rounded;
  // أيقونة لوحة العمل
  static const IconData board = Icons.dashboard_rounded;
}
