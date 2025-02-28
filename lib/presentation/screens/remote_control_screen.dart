import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pc_remote_control_app/business_logic/blocs/connection/connection_bloc.dart';
import 'package:pc_remote_control_app/business_logic/blocs/connection/connection_event.dart';
import 'package:pc_remote_control_app/business_logic/blocs/remote_control/remote_control_bloc.dart';
import 'package:pc_remote_control_app/business_logic/blocs/remote_control/remote_control_event.dart';
import 'package:pc_remote_control_app/data/models/device.dart';
import 'package:pc_remote_control_app/data/models/remote_command.dart';
import 'package:pc_remote_control_app/presentation/widgets/connection_status_widget.dart';
import 'package:pc_remote_control_app/presentation/widgets/d_pad.dart';
import 'package:pc_remote_control_app/presentation/widgets/episode_controls.dart';
import 'package:pc_remote_control_app/presentation/widgets/media_controls.dart';
import 'package:pc_remote_control_app/presentation/widgets/navigation_controls.dart';
import 'package:pc_remote_control_app/presentation/widgets/volume_controls.dart';
import 'package:pc_remote_control_app/presentation/widgets/feedback_overlay.dart';

class RemoteControlScreen extends StatefulWidget {
  const RemoteControlScreen({super.key});

  @override
  State<RemoteControlScreen> createState() => _RemoteControlScreenState();
}

class _RemoteControlScreenState extends State<RemoteControlScreen> {
  // Mock device for demo purposes
  final _mockDevice = const Device(
    id: '1',
    name: 'Living Room TV',
    ipAddress: '192.168.1.100',
  );

  @override
  void initState() {
    super.initState();
    // Auto-connect to mock device for demo purposes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConnectionBloc>().add(ConnectToDevice(_mockDevice));
    });
  }

  void _sendCommand(CommandType commandType) {
    final command = RemoteCommand(type: commandType);
    context.read<RemoteControlBloc>().add(SendCommand(command));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote Control'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings screen (not implemented in this demo)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings not implemented in demo')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Connection status
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConnectionStatusWidget(),
                ],
              ),
            ),
            // Main remote control interface
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Navigation controls (Home, Back, Menu, Info)
                    NavigationControls(
                      onHomePressed: () => _sendCommand(CommandType.home),
                      onBackPressed: () => _sendCommand(CommandType.back),
                      onMenuPressed: () => _sendCommand(CommandType.menu),
                      onInfoPressed: () => _sendCommand(CommandType.info),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // D-Pad for navigation
                    DPad(
                      onUpPressed: () => _sendCommand(CommandType.up),
                      onDownPressed: () => _sendCommand(CommandType.down),
                      onLeftPressed: () => _sendCommand(CommandType.left),
                      onRightPressed: () => _sendCommand(CommandType.right),
                      onCenterPressed: () => _sendCommand(CommandType.select),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Media controls
                    MediaControls(
                      onPlayPausePressed: () => _sendCommand(CommandType.playPause),
                      onStopPressed: () => _sendCommand(CommandType.stop),
                      onPreviousPressed: () => _sendCommand(CommandType.previous),
                      onNextPressed: () => _sendCommand(CommandType.next),
                      onRewindPressed: () => _sendCommand(CommandType.rewind),
                      onForwardPressed: () => _sendCommand(CommandType.forward),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Volume and episode controls in a row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Volume controls
                        VolumeControls(
                          onVolumeUpPressed: () => _sendCommand(CommandType.volumeUp),
                          onVolumeDownPressed: () => _sendCommand(CommandType.volumeDown),
                          onMutePressed: () => _sendCommand(CommandType.mute),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
