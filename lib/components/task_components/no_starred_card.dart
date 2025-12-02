import 'package:flutter/material.dart';
import 'package:planme/theme/app_colors.dart';

class NoStarredCard extends StatelessWidget {
  const NoStarredCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card.filled(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(36),
          child: Column(
            children: [
              Image.asset('assets/images/starred.png', height: 200),
              const SizedBox(height: 24),
              const Text(
                'No starred tasks',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
              const SizedBox(height: 8),
              const Text(
                'Mark important tasks with a star so you can easily find them here',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.gray600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
