import 'dart:io';

void main() {
  final files = [
    '/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/groups/data/models/group_model.dart',
    '/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/groups/data/models/group_project_model.dart',
    '/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/groups/data/models/group_member_model.dart',
    '/home/osmsoftwareengineering/flutter_projects/you_track/lib/core/models/user_data_model.dart',
    '/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/groups/data/models/group_role_assignment_model.dart',
    '/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/data/models/build_model.dart',
    '/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/data/models/issue_model.dart',
    '/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/data/models/tag_model.dart',
    '/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/data/models/sprint_model.dart',
    '/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/data/models/issue_link_model.dart',
    '/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/dashboards/data/models/dashboard_model.dart',
    '/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/dashboards/data/models/dashboard_widget_model.dart',
    '/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/time_tracking/data/models/time_tracking_config_model.dart',
    '/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/time_tracking/data/models/work_type_model.dart',
    '/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/time_tracking/data/models/time_entry_model.dart',
    '/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/time_tracking/data/models/custom_work_item_attribute_model.dart',
    '/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/projects/data/models/project_member_model.dart',
    '/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/projects/data/models/project_model.dart',
    '/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/projects/data/models/project_template_model.dart',
    '/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/agile_boards/data/models/board_card_model.dart',
    '/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/version_control/data/models/vcs_commit_model.dart',
    '/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/version_control/data/models/vcs_pull_request_model.dart',
    '/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/version_control/data/models/vcs_integration_model.dart',
    '/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/version_control/data/models/vcs_user_mapping_model.dart',
    '/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/custom_fields/data/models/custom_field_model.dart',
    '/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/custom_fields/data/models/custom_field_value_model.dart',
    '/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/custom_fields/data/models/simple_custom_field_model.dart',
    '/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/roles/data/models/role_model.dart',
    '/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/knowledge_base/data/models/article_notification_model.dart',
    '/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/knowledge_base/data/models/article_model.dart',
    '/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/knowledge_base/data/models/article_comment_model.dart',
  ];

  for (final path in files) {
    final file = File(path);
    if (!file.existsSync()) continue;
    String content = file.readAsStringSync();

    // Check if it already has printMap
    if (content.contains('printMap(')) continue;

    // Check if import exists
    if (!content.contains('package:issues_tracking/core/utils/printing.dart')) {
      // Find the last import and add this one after it
      final lastImportIndex = content.lastIndexOf('import ');
      if (lastImportIndex != -1) {
        final endOfLine = content.indexOf('\n', lastImportIndex);
        if (endOfLine != -1) {
          content =
              "${content.substring(0, endOfLine + 1)}import 'package:issues_tracking/core/utils/printing.dart';\n${content.substring(endOfLine + 1)}";
        }
      } else {
        content =
            "import 'package:issues_tracking/core/utils/printing.dart';\n$content";
      }
    }

    // Replace fromJson
    final regex = RegExp(
      r'factory\s+([A-Za-z0-9_]+)\.fromJson\s*\(\s*Map<String,\s*dynamic>\s+([a-zA-Z0-9_]+)\s*\)\s*\{',
    );

    content = content.replaceAllMapped(regex, (match) {
      final className = match.group(1);
      final paramName = match.group(2);

      // Clean up class name for display (e.g. GroupModel -> Group)
      String title = className!;
      if (title.endsWith('Model')) {
        title = title.substring(0, title.length - 5);
      }

      return '${match.group(0)}\n    printMap(title: \'$title\', data: $paramName);';
    });

    file.writeAsStringSync(content);
    print('Updated $path');
  }
}
