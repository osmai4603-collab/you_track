import 'package:flutter/material.dart';
import '../../domain/entities/field_type.dart';

class CustomTabBar extends StatelessWidget {
  final FieldType selectedType;
  final ValueChanged<FieldType> onTypeSelected;

  const CustomTabBar({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        children: FieldType.values.map((type) {
          final isSelected = type == selectedType;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTypeSelected(type),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    type.value,
                    style: TextStyle(
                      color: isSelected ? Colors.blue : Colors.grey,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 2,
                    color: isSelected ? Colors.blue : Colors.transparent,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}