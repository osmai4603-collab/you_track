import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../custom_field/presentation/cubits/custom_field_panel_cubit.dart';
import '../widgets/sliding_panel.dart';
import '../widgets/panel_overlay.dart';

class AddCustomFieldPage extends StatelessWidget {
  const AddCustomFieldPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CustomFieldPanelCubit(),
      child: const AddCustomFieldView(),
    );
  }
}

class AddCustomFieldView extends StatelessWidget {
  const AddCustomFieldView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomFieldPanelCubit, CustomFieldPanelState>(
      builder: (context, state) {
        return Stack(
          children: [
            // Background content (could be project settings)
            Positioned.fill(
              child: Container(
                color: Colors.grey[100],
                child: const Center(
                  child: Text('Project Settings'),
                ),
              ),
            ),
            // Overlay
            PanelOverlay(
              isVisible: state.isPanelOpen,
              onTap: () => context.read<CustomFieldPanelCubit>().closePanel(),
            ),
            // Sliding panel
            SlidingPanel(
              isOpen: state.isPanelOpen,
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Add Custom Field',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => context
                                .read<CustomFieldPanelCubit>()
                                .closePanel(),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    // Panel content will be added in later tasks
                    Expanded(
                      child: Center(
                        child: Text('Panel content coming soon'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Floating action button to open panel
            if (!state.isPanelOpen)
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton.extended(
                  onPressed: () =>
                      context.read<CustomFieldPanelCubit>().openPanel(),
                  label: const Text('Add field'),
                  icon: const Icon(Icons.add),
                ),
              ),
          ],
        );
      },
    );
  }
}