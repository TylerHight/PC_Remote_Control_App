import 'package:flutter/material.dart';
import 'package:pc_remote_control_app/presentation/widgets/control_button.dart';

class DPad extends StatelessWidget {
  final VoidCallback onUpPressed;
  final VoidCallback onDownPressed;
  final VoidCallback onLeftPressed;
  final VoidCallback onRightPressed;
  final VoidCallback onCenterPressed;

  const DPad({
    super.key,
    required this.onUpPressed,
    required this.onDownPressed,
    required this.onLeftPressed,
    required this.onRightPressed,
    required this.onCenterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Cross background pattern
          CustomPaint(
            size: const Size(180, 180),
            painter: _CrossPainter(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ),
          ),
          // Center button
          ControlButton(
            icon: Icons.circle,
            onPressed: onCenterPressed,
            size: 65,
            color: Theme.of(context).colorScheme.primary, // Match the D-Pad background color
            isCircular: false, // Make the button square
          ),
          // Up button
          Positioned(
            top: 0,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onUpPressed,
                  child: const Icon(Icons.keyboard_arrow_up, color: Colors.white),
                ),
              ),
            ),
          ),
          // Down button
          Positioned(
            bottom: 0,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onDownPressed,
                  child: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                ),
              ),
            ),
          ),
          // Left button
          Positioned(
            left: 0,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onLeftPressed,
                  child: const Icon(Icons.keyboard_arrow_left, color: Colors.white),
                ),
              ),
            ),
          ),
          // Right button
          Positioned(
            right: 0,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onRightPressed,
                  child: const Icon(Icons.keyboard_arrow_right, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CrossPainter extends CustomPainter {
  final Color color;

  _CrossPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final horizontalRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width,
        height: 20,
      ),
      const Radius.circular(10),
    );

    final verticalRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: 20,
        height: size.height,
      ),
      const Radius.circular(10),
    );

    canvas.drawRRect(horizontalRect, paint);
    canvas.drawRRect(verticalRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}