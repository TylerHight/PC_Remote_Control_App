import 'package:flutter/material.dart';
import 'package:pc_remote_control_app/presentation/widgets/control_button.dart';

class VolumeControls extends StatelessWidget {
  final VoidCallback onVolumeUpPressed;
  final VoidCallback onVolumeDownPressed;
  final VoidCallback onMutePressed;

  const VolumeControls({
    super.key,
    required this.onVolumeUpPressed,
    required this.onVolumeDownPressed,
    required this.onMutePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ControlButton(
          icon: Icons.volume_up,
          onPressed: onVolumeUpPressed,
          label: 'Volume Up',
        ),
        const SizedBox(height: 16),
        ControlButton(
          icon: Icons.volume_off,
          onPressed: onMutePressed,
          label: 'Mute',
        ),
        const SizedBox(height: 16),
        ControlButton(
          icon: Icons.volume_down,
          onPressed: onVolumeDownPressed,
          label: 'Volume Down',
        ),
      ],
    );
  }
}
