import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QaCard extends StatelessWidget {
  final String question;
  final String answer;
  const QaCard({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Question Section (Top Partition)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer.withValues(alpha: 0.4),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(11.r),
                topRight: Radius.circular(11.r),
              ),
            ),
            child: Text(
              question,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
                height: 1.3,
              ),
            ),
          ),
          // Divider
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey.shade300,
          ),
          // Answer Section (Bottom Partition)
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                height: 1.4,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 20,
            ),
          ),
        ],
      ),
    );
  }
}
