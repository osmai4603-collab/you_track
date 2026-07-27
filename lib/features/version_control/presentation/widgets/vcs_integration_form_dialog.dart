import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/enums/server_type_enum.dart';
import 'package:issues_tracking/core/enums/vcs_auth_mode_enum.dart';
import 'package:issues_tracking/features/version_control/domain/entities/vcs_integration_entity.dart';
import 'package:issues_tracking/features/version_control/presentation/cubits/vcs_integrations_cubit.dart';

class VcsIntegrationFormDialog extends StatefulWidget {
  final String projectId;
  final VcsIntegrationEntity? existingIntegration;

  const VcsIntegrationFormDialog({
    super.key,
    required this.projectId,
    this.existingIntegration,
  });

  @override
  State<VcsIntegrationFormDialog> createState() =>
      _VcsIntegrationFormDialogState();
}

class _VcsIntegrationFormDialogState extends State<VcsIntegrationFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _orgController = TextEditingController();
  final _repoController = TextEditingController();
  final _serverUrlController = TextEditingController();
  final _tokenController = TextEditingController();
  final _sshKeyController = TextEditingController();
  final _passphraseController = TextEditingController();
  final _branchSpecController = TextEditingController(text: '+:*');

  VcsProviderType _selectedProvider = VcsProviderType.github;
  VcsAuthMode _selectedAuthMode = VcsAuthMode.token;
  bool _parseCommits = false;
  bool _silentProcessing = false;
  bool _pullRequestAutomation = false;
  bool _autoUserMapping = true;
  bool _isSubmitting = false;
  bool _isSelfHosted = false;

  bool get _isEditing => widget.existingIntegration != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _populateFromExisting(widget.existingIntegration!);
    }
  }

  void _populateFromExisting(VcsIntegrationEntity e) {
    _nameController.text = e.integrationName;
    _orgController.text = e.organizationOwner;
    _repoController.text = e.repositoryName;
    _serverUrlController.text = e.serverUrl ?? '';
    _branchSpecController.text = e.branchSpecification;
    _selectedProvider = e.providerType;
    _selectedAuthMode = e.authMode;
    _parseCommits = e.parseCommitsForCommands;
    _silentProcessing = e.silentProcessing;
    _pullRequestAutomation = e.pullRequestAutomation;
    _autoUserMapping = e.automaticUserMapping;
    _isSelfHosted = e.serverUrl != null && e.serverUrl!.isNotEmpty;
    if (e.encryptedToken != null) _tokenController.text = '••••••••';
    if (e.sshPrivateKey != null) _sshKeyController.text = '••••••••';
    if (e.passphrase != null) _passphraseController.text = '••••••••';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 680),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.large),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _isEditing ? 'Edit Integration' : 'Add Repository',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.large),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(
                        controller: _nameController,
                        label: 'Integration name',
                        hint: 'e.g. Main Repository',
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: AppSpacing.medium),
                      _buildProviderDropdown(colors),
                      const SizedBox(height: AppSpacing.medium),
                      _buildSelfHostedToggle(colors),
                      if (_isSelfHosted) ...[
                        const SizedBox(height: AppSpacing.medium),
                        _buildTextField(
                          controller: _serverUrlController,
                          label: 'Server URL',
                          hint: 'https://git.example.com',
                          validator: (v) =>
                              _isSelfHosted && (v == null || v.trim().isEmpty)
                              ? 'Required for self-hosted'
                              : null,
                        ),
                      ],
                      const SizedBox(height: AppSpacing.medium),
                      _buildTextField(
                        controller: _orgController,
                        label: 'Organization / Owner',
                        hint: 'e.g. my-org',
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: AppSpacing.medium),
                      _buildTextField(
                        controller: _repoController,
                        label: 'Repository name',
                        hint: 'e.g. my-repo',
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: AppSpacing.medium),
                      _buildAuthModeDropdown(colors),
                      const SizedBox(height: AppSpacing.medium),
                      if (_selectedAuthMode == VcsAuthMode.token)
                        _buildTextField(
                          controller: _tokenController,
                          label: 'Personal Access Token',
                          obscure: true,
                          validator: (v) {
                            if (_isEditing && v == '••••••••') {
                              return null;
                            }
                            return v == null || v.trim().isEmpty
                                ? 'Required'
                                : null;
                          },
                        ),
                      if (_selectedAuthMode == VcsAuthMode.ssh) ...[
                        _buildTextField(
                          controller: _sshKeyController,
                          label: 'SSH Private Key',
                          obscure: true,
                          maxLines: 3,
                          validator: (v) {
                            if (_isEditing && v == '••••••••') {
                              return null;
                            }
                            return v == null || v.trim().isEmpty
                                ? 'Required'
                                : null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.medium),
                        _buildTextField(
                          controller: _passphraseController,
                          label: 'Passphrase (optional)',
                          obscure: true,
                        ),
                      ],
                      const SizedBox(height: AppSpacing.medium),
                      _buildTextField(
                        controller: _branchSpecController,
                        label: 'Branch specification',
                        hint: '+:*',
                      ),
                      const SizedBox(height: AppSpacing.large),
                      _buildToggles(colors),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.large),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isSubmitting
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: AppSpacing.small),
                    FilledButton(
                      onPressed: _isSubmitting ? null : _submit,
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(_isEditing ? 'Save' : 'Add'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    bool obscure = false,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        isDense: true,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildProviderDropdown(ColorScheme colors) {
    return DropdownButtonFormField<VcsProviderType>(
      initialValue: _selectedProvider,
      decoration: const InputDecoration(
        labelText: 'Provider',
        isDense: true,
        border: OutlineInputBorder(),
      ),
      items: VcsProviderType.values.map((p) {
        return DropdownMenuItem(value: p, child: Text(_providerDisplayName(p)));
      }).toList(),
      onChanged: (v) {
        if (v != null) {
          setState(() {
            _selectedProvider = v;
            _isSelfHosted = v.isSelfHosted;
          });
        }
      },
    );
  }

  Widget _buildSelfHostedToggle(ColorScheme colors) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text('Self-hosted instance'),
      subtitle: const Text('Enable if using a private server'),
      value: _isSelfHosted,
      onChanged: (v) => setState(() => _isSelfHosted = v),
    );
  }

  Widget _buildAuthModeDropdown(ColorScheme colors) {
    return DropdownButtonFormField<VcsAuthMode>(
      initialValue: _selectedAuthMode,
      decoration: const InputDecoration(
        labelText: 'Authentication mode',
        isDense: true,
        border: OutlineInputBorder(),
      ),
      items: VcsAuthMode.values.map((m) {
        return DropdownMenuItem(value: m, child: Text(_authModeDisplayName(m)));
      }).toList(),
      onChanged: (v) {
        if (v != null) setState(() => _selectedAuthMode = v);
      },
    );
  }

  Widget _buildToggles(ColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Options', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: AppSpacing.small),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          title: const Text('Parse commit messages for commands'),
          value: _parseCommits,
          onChanged: (v) => setState(() => _parseCommits = v),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          title: const Text('Pull request automation'),
          value: _pullRequestAutomation,
          onChanged: (v) => setState(() => _pullRequestAutomation = v),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          title: const Text('Silent processing (no emails)'),
          value: _silentProcessing,
          onChanged: (v) => setState(() => _silentProcessing = v),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          title: const Text('Automatic user mapping'),
          value: _autoUserMapping,
          onChanged: (v) => setState(() => _autoUserMapping = v),
        ),
      ],
    );
  }

  String _providerDisplayName(VcsProviderType type) {
    switch (type) {
      case VcsProviderType.github:
        return 'GitHub';
      case VcsProviderType.gitlab:
        return 'GitLab';
      case VcsProviderType.bitbucket:
        return 'Bitbucket Cloud';
      case VcsProviderType.bitbucketServer:
        return 'Bitbucket Server';
      case VcsProviderType.gitea:
        return 'Gitea';
      default:
        return 'Custom Git';
    }
  }

  String _authModeDisplayName(VcsAuthMode mode) {
    switch (mode) {
      case VcsAuthMode.oauth:
        return 'OAuth 2.0';
      case VcsAuthMode.token:
        return 'Token';
      case VcsAuthMode.ssh:
        return 'SSH Key';
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final now = DateTime.now();

    String? encryptedToken;
    String? sshKey;
    String? passphrase;

    if (_selectedAuthMode == VcsAuthMode.token &&
        _tokenController.text != '••••••••') {
      encryptedToken = _tokenController.text;
    }
    if (_selectedAuthMode == VcsAuthMode.ssh &&
        _sshKeyController.text != '••••••••') {
      sshKey = _sshKeyController.text;
    }
    if (_passphraseController.text.isNotEmpty &&
        _passphraseController.text != '••••••••') {
      passphrase = _passphraseController.text;
    }

    final integration = VcsIntegrationEntity(
      id: _isEditing ? widget.existingIntegration!.id : '',
      projectId: widget.projectId,
      integrationName: _nameController.text.trim(),
      providerType: _selectedProvider,
      serverUrl: _isSelfHosted && _serverUrlController.text.isNotEmpty
          ? _serverUrlController.text.trim()
          : null,
      authMode: _selectedAuthMode,
      encryptedToken:
          encryptedToken ?? widget.existingIntegration?.encryptedToken,
      sshPrivateKey: sshKey ?? widget.existingIntegration?.sshPrivateKey,
      passphrase: passphrase ?? widget.existingIntegration?.passphrase,
      organizationOwner: _orgController.text.trim(),
      repositoryName: _repoController.text.trim(),
      branchSpecification: _branchSpecController.text.trim().isEmpty
          ? '+:*'
          : _branchSpecController.text.trim(),
      parseCommitsForCommands: _parseCommits,
      silentProcessing: _silentProcessing,
      pullRequestAutomation: _pullRequestAutomation,
      automaticUserMapping: _autoUserMapping,
      visibleToRoles: _isEditing
          ? widget.existingIntegration!.visibleToRoles
          : [],
      createdAt: _isEditing ? widget.existingIntegration!.createdAt : now,
      updatedAt: now,
    );

    final cubit = context.read<VcsIntegrationsCubit>();
    if (_isEditing) {
      cubit.updateIntegration(integration);
    } else {
      cubit.createIntegration(integration);
    }

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _orgController.dispose();
    _repoController.dispose();
    _serverUrlController.dispose();
    _tokenController.dispose();
    _sshKeyController.dispose();
    _passphraseController.dispose();
    _branchSpecController.dispose();
    super.dispose();
  }
}
