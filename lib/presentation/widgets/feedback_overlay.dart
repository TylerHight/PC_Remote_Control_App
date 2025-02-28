import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pc_remote_control_app/business_logic/blocs/remote_control/remote_control_bloc.dart';
import 'package:pc_remote_control_app/business_logic/blocs/remote_control/remote_control_state.dart';

class FeedbackOverlay extends StatelessWidget {
  final Widget child;

  const FeedbackOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        BlocBuilder<RemoteControlBloc, RemoteControlState>(
          builder: (context, state) {
            if (state.status == CommandStatus.sending) {
              return const _LoadingIndicator();
            } else if (state.status == CommandStatus.error) {
              return _ErrorOverlay(errorMessage: state.errorMessage);
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _ErrorOverlay extends StatefulWidget {
  final String? errorMessage;

  const _ErrorOverlay({this.errorMessage});

  @override
  State<_ErrorOverlay> createState() => _ErrorOverlayState();
}

class _ErrorOverlayState extends State<_ErrorOverlay> {
  @override
  void initState() {
    super.initState();
    _scheduleRemoval();
  }

  void _scheduleRemoval() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red.withOpacity(0.3),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error, color: Colors.white, size: 48),
              const SizedBox(height: 16),
              Text(
                widget.errorMessage ?? 'An error occurred',
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
