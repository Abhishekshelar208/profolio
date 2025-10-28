import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Reusable loading widget that displays the rocket Lottie animation
class LottieLoadingWidget extends StatelessWidget {
  final String? loadingText;
  final double? size;
  final Color? backgroundColor;

  const LottieLoadingWidget({
    super.key,
    this.loadingText,
    this.size = 200,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottieAnimations/rocketAnimation.json',
              width: size,
              height: size,
              fit: BoxFit.contain,
              // Show a fallback if the animation fails to load
              errorBuilder: (context, error, stackTrace) {
                return SizedBox(
                  width: size,
                  height: size,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
            if (loadingText != null) ...[
              const SizedBox(height: 20),
              Text(
                loadingText!,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Scaffold version of the loading widget for full-screen loading
class LottieLoadingScaffold extends StatelessWidget {
  final String? loadingText;
  final double? size;
  final Color? backgroundColor;

  const LottieLoadingScaffold({
    super.key,
    this.loadingText,
    this.size = 300,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      body: LottieLoadingWidget(
        loadingText: loadingText,
        size: size,
        backgroundColor: backgroundColor,
      ),
    );
  }
}
