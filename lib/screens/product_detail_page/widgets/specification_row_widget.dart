import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SpecificationRowWidget extends StatelessWidget {
  final String label;
  final String value;
  const SpecificationRowWidget({
    super.key,
    required this.label,
    required this.value
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                // color: Colors.grey[600],
                color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.7)
              ),
            ),
          ),
          Text(': ', style: TextStyle(color: Colors.grey[600])),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.9)
                // color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
