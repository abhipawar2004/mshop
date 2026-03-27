import 'package:flutter/material.dart';
import 'package:hyper_local/utils/widgets/custom_circular_progress_indicator.dart';

class WholePageProgress extends StatelessWidget {
  const WholePageProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => {
        if(!didPop){

        }
      },
      child: AbsorbPointer(
        child: Container(
          width: double.infinity,
          color: Colors.black.withValues(alpha:0.5),
          child: CustomCircularProgressIndicator(),
        ),
      ),
    );
  }
}