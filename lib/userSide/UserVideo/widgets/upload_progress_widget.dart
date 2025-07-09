import 'package:flutter/material.dart';

class UploadProgressWidget extends StatelessWidget {
  final double progress;
  final String statusText;
  final String? subText;
  final bool isComplete;
  final VoidCallback? onCancel;

  const UploadProgressWidget({
    Key? key,
    required this.progress,
    required this.statusText,
    this.subText,
    this.isComplete = false,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF6699CC);
    final secondaryColor = const Color(0xFF7FB2DE);

    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Card(
          elevation: 12,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Container(
            width: 320,
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Progress circle with percentage
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Stack(
                    children: [
                      // Background circle
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator(
                          value: 1.0,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.grey[200]!),
                          strokeWidth: 8,
                        ),
                      ),
                      // Progress circle
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator(
                          value: progress,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isComplete ? Colors.green[600]! : primaryColor,
                          ),
                          strokeWidth: 8,
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      // Percentage text
                      Positioned.fill(
                        child: Center(
                          child: isComplete
                              ? Icon(
                                  Icons.check_circle,
                                  color: Colors.green[600],
                                  size: 36,
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${(progress * 100).toStringAsFixed(0)}%',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                      ),
                                    ),
                                    if (progress > 0)
                                      Text(
                                        'Complete',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Status text
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isComplete ? Colors.green[700] : primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),

                if (subText != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    subText!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],

                const SizedBox(height: 24),

                // Progress steps indicator
                _buildProgressSteps(),

                if (onCancel != null && !isComplete) ...[
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: onCancel,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[600],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                    ),
                    child: const Text('Cancel Upload'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSteps() {
    final steps = [
      'Processing',
      'Compressing',
      'Uploading',
      'Finalizing',
    ];

    final currentStep =
        (progress * steps.length).floor().clamp(0, steps.length - 1);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(steps.length, (index) {
        final isActive = index <= currentStep;
        final isCurrent = index == currentStep && !isComplete;

        return Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? (isComplete || index < currentStep
                        ? Colors.green[600]
                        : const Color(0xFF6699CC))
                    : Colors.grey[300],
                border: isCurrent
                    ? Border.all(color: const Color(0xFF6699CC), width: 2)
                    : null,
              ),
              child: isActive && (isComplete || index < currentStep)
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    )
                  : isCurrent
                      ? Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        )
                      : null,
            ),
            if (index < steps.length - 1)
              Container(
                width: 24,
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                color: index < currentStep
                    ? (isComplete ? Colors.green[600] : const Color(0xFF6699CC))
                    : Colors.grey[300],
              ),
          ],
        );
      }),
    );
  }
}
