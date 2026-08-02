import os
import re

files_to_fix = [
    ("/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/custom_fields/domain/usecases/replace_field_value_use_case.dart", "projectUpdateProject"),
    ("/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/groups/domain/usecases/add_group_members.dart", "systemLowLevelAdminWrite"),
    ("/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/groups/domain/usecases/add_group_projects.dart", "systemLowLevelAdminWrite"),
    ("/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/groups/domain/usecases/assign_role.dart", "systemLowLevelAdminWrite"),
    ("/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/groups/domain/usecases/get_group_by_id.dart", "systemLowLevelAdminRead"),
    ("/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/groups/domain/usecases/get_group_members.dart", "systemLowLevelAdminRead"),
    ("/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/groups/domain/usecases/get_group_roles.dart", "systemLowLevelAdminRead"),
    ("/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/groups/domain/usecases/get_groups.dart", "systemLowLevelAdminRead"),
    ("/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/groups/domain/usecases/remove_group_members.dart", "systemLowLevelAdminWrite"),
    ("/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/issues/domain/usecases/get_issues.dart", "issueReadIssue"),
    ("/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/knowledge_base/domain/usecases/create_article.dart", "articleCreateArticle"),
    ("/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/knowledge_base/domain/usecases/delete_article.dart", "articleDeleteArticle"),
    ("/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/knowledge_base/domain/usecases/delete_comment.dart", "commentDeleteArticleComment"),
    ("/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/knowledge_base/domain/usecases/get_article_by_id.dart", "articleReadArticle"),
    ("/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/knowledge_base/domain/usecases/get_article_tree.dart", "articleReadArticle"),
    ("/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/knowledge_base/domain/usecases/get_comments_for_article.dart", "commentReadArticleComment"),
    ("/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/knowledge_base/domain/usecases/publish_article.dart", "articleUpdateArticle"),
    ("/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/knowledge_base/domain/usecases/reorder_articles.dart", "articleUpdateArticle"),
    ("/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/knowledge_base/domain/usecases/resolve_comment.dart", "commentUpdateArticleComment"),
    ("/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/knowledge_base/domain/usecases/search_articles.dart", "articleReadArticle"),
    ("/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/knowledge_base/domain/usecases/update_article.dart", "articleUpdateArticle"),
    ("/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/roles/domain/usecases/delete_role.dart", "systemLowLevelAdminWrite"),
    ("/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/roles/domain/usecases/get_roles.dart", "systemLowLevelAdminRead"),
    ("/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/version_control/domain/usecases/create_integration_use_case.dart", "projectUpdateProject"),
    ("/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/version_control/domain/usecases/delete_integration_use_case.dart", "projectUpdateProject"),
    ("/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/version_control/domain/usecases/get_integrations_use_case.dart", "projectReadProjectBasic"),
    ("/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/version_control/domain/usecases/manage_user_mapping_use_case.dart", "projectUpdateProject"),
    ("/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/version_control/domain/usecases/sync_commits_use_case.dart", "projectUpdateProject"),
    ("/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/version_control/domain/usecases/test_connection_use_case.dart", "projectReadProjectBasic"),
    ("/home/osmsoftwareengineering/flutter_projects/you_track/lib/features/version_control/domain/usecases/update_integration_use_case.dart", "projectUpdateProject")
]

for file_path, perm in files_to_fix:
    with open(file_path, "r") as f:
        content = f.read()
    
    if "Permission get requiredPermission" in content:
        continue
        
    # Find the class declaration that extends UseCasePermission
    match = re.search(r'class \w+\s*extends UseCasePermission<[^>]+>\s*{', content)
    if not match:
        print(f"Failed to find UseCasePermission in {file_path}")
        continue
        
    insert_pos = match.end()
    
    # insert the override block right after class declaration
    injection = f"\n  @override\n  Permission get requiredPermission => Permission.{perm};\n"
    
    content = content[:insert_pos] + injection + content[insert_pos:]
    
    with open(file_path, "w") as f:
        f.write(content)

print("Done")
