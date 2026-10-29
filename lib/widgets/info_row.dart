import 'package:flutter/material.dart';
import 'package:posca/app/theme.dart';

/// A `label    value` row for profile details.
class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 30,
        child: Row(
          children: [
            SizedBox(width: 80, child: Text(label, style: AppTextStyles.label)),
            Expanded(child: Text(value, style: AppTextStyles.value)),
          ],
        ),
      ),
    );
  }
}
