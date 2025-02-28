import 'package:flutter/material.dart';
import 'package:pc_remote_control_app/presentation/widgets/control_button.dart';

class EpisodeControls extends StatelessWidget {
  final VoidCallback onNextEpisodePressed;
  final VoidCallback onPreviousEpisodePressed;

  const EpisodeControls({
    super.key,
    required this.onNextEpisodePressed,
    required this.onPreviousEpisodePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ControlButton(
          icon: Icons.skip_previous,
          onPressed: onPreviousEpisodePressed,
          label: 'Previous Episode',
          isCircular: false,
        ),
        const SizedBox(width: 24),
        ControlButton(
          icon: Icons.skip_next,
          onPressed: onNextEpisodePressed,
          label: 'Next Episode',
          isCircular: false,
        ),
      ],
    );
  }
}
