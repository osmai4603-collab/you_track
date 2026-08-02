import os
import re

files_to_fix = [
    "/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/custom_fields/domain/usecases/replace_field_value_use_case.dart",
    "/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/groups/domain/usecases/add_group_members.dart",
    "/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/groups/domain/usecases/add_group_projects.dart",
    "/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/groups/domain/usecases/assign_role.dart",
    "/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/groups/domain/usecases/get_group_by_id.dart",
    "/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/groups/domain/usecases/get_group_members.dart",
    "/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/groups/domain/usecases/get_group_roles.dart",
    "/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/groups/domain/usecases/get_groups.dart",
    "/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/groups/domain/usecases/remove_group_members.dart",
    "/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/domain/usecases/get_issues.dart",
    "/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/knowledge_base/domain/usecases/create_article.dart",
    "/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/knowledge_base/domain/usecases/delete_article.dart",
    "/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/knowledge_base/domain/usecases/delete_comment.dart",
    "/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/knowledge_base/domain/usecases/get_article_by_id.dart",
    "/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/knowledge_base/domain/usecases/get_article_tree.dart",
    "/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/knowledge_base/domain/usecases/get_comments_for_article.dart",
    "/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/knowledge_base/domain/usecases/publish_article.dart",
    "/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/knowledge_base/domain/usecases/reorder_articles.dart",
    "/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/knowledge_base/domain/usecases/resolve_comment.dart",
    "/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/knowledge_base/domain/usecases/search_articles.dart",
    "/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/knowledge_base/domain/usecases/update_article.dart",
    "/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/roles/domain/usecases/delete_role.dart",
    "/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/roles/domain/usecases/get_roles.dart",
    "/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/version_control/domain/usecases/create_integration_use_case.dart",
    "/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/version_control/domain/usecases/delete_integration_use_case.dart",
    "/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/version_control/domain/usecases/get_integrations_use_case.dart",
    "/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/version_control/domain/usecases/manage_user_mapping_use_case.dart",
    "/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/version_control/domain/usecases/sync_commits_use_case.dart",
    "/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/version_control/domain/usecases/test_connection_use_case.dart",
    "/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/version_control/domain/usecases/update_integration_use_case.dart"
]

for file_path in files_to_fix:
    with open(file_path, "r") as f:
        content = f.read()
    
    if "permission_enum.dart" in content:
        continue
        
    match = re.search(r'import\s+[^;]+;', content)
    if not match:
        print(f"Failed to find import in {file_path}")
        continue
        
    insert_pos = match.end()
    
    injection = "\nimport 'package:issues_tracking/core/enums/permission_enum.dart';"
    
    content = content[:insert_pos] + injection + content[insert_pos:]
    
    with open(file_path, "w") as f:
        f.write(content)

print("Done")
