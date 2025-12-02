import 'package:flutter/material.dart';
import 'package:planme/theme/app_colors.dart';

class AllTasksCard extends StatelessWidget {
  const AllTasksCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(36),
        child: Center(
          child: Column(
            children: [
              Image.asset('assets/images/zero_tasks.png', height: 200),
              const SizedBox(height: 24),
              const Text(
                'All tasks completed',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
              const SizedBox(height: 8),
              const Text(
                'Nice work!',
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
