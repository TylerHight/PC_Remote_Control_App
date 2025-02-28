import 'package:flutter/material.dart';
import 'package:pc_remote_control_app/presentation/widgets/control_button.dart';

class VolumeControls extends StatefulWidget {
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
  State<VolumeControls> createState() => _VolumeControlsState();
}

class _VolumeControlsState extends State<VolumeControls> {
  double _volume = 0.5;
  bool _isMuted = false;

  void _handleVolumeChange(double value) {
    setState(() {
      _volume = value;
    });
    if (value > _volume) {
      widget.onVolumeUpPressed();
    } else {
      widget.onVolumeDownPressed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ControlButton(
            icon: _isMuted ? Icons.volume_off : Icons.volume_up,
            onPressed: () {
              setState(() => _isMuted = !_isMuted);
              widget.onMutePressed();
            },
            size: 40,
          ),
          SizedBox(
            width: 250,
            child: Slider(
              value: _volume,
              onChanged: _handleVolumeChange,
              activeColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}