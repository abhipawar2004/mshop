import 'package:circular_gradient_spinner/circular_gradient_spinner.dart';
import 'package:flutter/material.dart';
import 'package:hyper_local/config/theme.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  const CustomCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 25,
        width: 25,
        child: CircularGradientSpinner(
          strokeWidth: 3.5,
          color: AppTheme.primaryColor,
          size: 30,
          duration: Duration(milliseconds: 500),
        ),
      ),
    );
  }
}
