import 'package:flutter/material.dart';
import 'package:pc_remote_control_app/presentation/widgets/control_button.dart';

class NavigationControls extends StatelessWidget {
  final VoidCallback onHomePressed;
  final VoidCallback onBackPressed;
  final VoidCallback onMenuPressed;
  final VoidCallback onInfoPressed;

  const NavigationControls({
    super.key,
    required this.onHomePressed,
    required this.onBackPressed,
    required this.onMenuPressed,
    required this.onInfoPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ControlButton(
          icon: Icons.home,
          onPressed: onHomePressed,
          label: 'Home',
        ),
        ControlButton(
          icon: Icons.arrow_back,
          onPressed: onBackPressed,
          label: 'Back',
        ),
        ControlButton(
          icon: Icons.menu,
          onPressed: onMenuPressed,
          label: 'Menu',
        ),
        ControlButton(
          icon: Icons.info,
          onPressed: onInfoPressed,
          label: 'Info',
        ),
      ],
    );
  }
}
