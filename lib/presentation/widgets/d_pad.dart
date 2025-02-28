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
    return SizedBox(
      width: 180,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Center button
          ControlButton(
            icon: Icons.circle,
            onPressed: onCenterPressed,
            size: 60,
            color: Theme.of(context).colorScheme.primary,
          ),
          // Up button
          Positioned(
            top: 0,
            child: ControlButton(
              icon: Icons.keyboard_arrow_up,
              onPressed: onUpPressed,
              size: 60,
            ),
          ),
          // Down button
          Positioned(
            bottom: 0,
            child: ControlButton(
              icon: Icons.keyboard_arrow_down,
              onPressed: onDownPressed,
              size: 60,
            ),
          ),
          // Left button
          Positioned(
            left: 0,
            child: ControlButton(
              icon: Icons.keyboard_arrow_left,
              onPressed: onLeftPressed,
              size: 60,
            ),
          ),
          // Right button
          Positioned(
            right: 0,
            child: ControlButton(
              icon: Icons.keyboard_arrow_right,
              onPressed: onRightPressed,
              size: 60,
            ),
          ),
        ],
      ),
    );
  }
}
