import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pc_remote_control_app/presentation/widgets/control_button.dart';

class MediaControls extends StatelessWidget {
  final VoidCallback onPlayPausePressed;
  final VoidCallback onStopPressed;
  final VoidCallback onPreviousPressed;
  final VoidCallback onNextPressed;
  final VoidCallback onRewindPressed;
  final VoidCallback onForwardPressed;

  const MediaControls({
    super.key,
    required this.onPlayPausePressed,
    required this.onStopPressed,
    required this.onPreviousPressed,
    required this.onNextPressed,
    required this.onRewindPressed,
    required this.onForwardPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ControlButton(
              icon: FontAwesomeIcons.backward,
              onPressed: onRewindPressed,
              label: 'Rewind',
            ),
            const SizedBox(width: 16),
            ControlButton(
              icon: Icons.play_arrow,
              onPressed: onPlayPausePressed,
              size: 70,
              color: Theme.of(context).colorScheme.primary,
              label: 'Play/Pause',
            ),
            const SizedBox(width: 16),
            ControlButton(
              icon: FontAwesomeIcons.forward,
              onPressed: onForwardPressed,
              label: 'Forward',
            ),
          ],
        ),
      ],
    );
  }
}