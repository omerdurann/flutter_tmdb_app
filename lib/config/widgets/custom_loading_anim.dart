import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../items/colors/app_colors.dart';
import '../utility/enums/json_constants.dart';

class LoadingAnimationWidget extends StatefulWidget {
  final double width;
  final double height;

  const LoadingAnimationWidget({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  // ignore: library_private_types_in_public_api
  _LoadingAnimationWidgetState createState() => _LoadingAnimationWidgetState();
}

class _LoadingAnimationWidgetState extends State<LoadingAnimationWidget> {
  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      JsonConstants.loadingAnim.toJson,
      width: widget.width,
      height: widget.height,
      delegates: LottieDelegates(
        values: [
          ValueDelegate.color(
            const ['**'],
            value: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }
}
