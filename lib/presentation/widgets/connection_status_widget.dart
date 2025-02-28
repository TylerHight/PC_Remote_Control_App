import 'package:flutter/material.dart';
import 'package:pc_remote_control_app/presentation/widgets/device_list_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pc_remote_control_app/business_logic/blocs/connection/connection_bloc.dart';
import 'package:pc_remote_control_app/business_logic/blocs/connection/connection_event.dart';
import 'package:pc_remote_control_app/business_logic/blocs/connection/connection_state.dart' as connection_state;
import 'package:pc_remote_control_app/data/models/device.dart';

class ConnectionStatusWidget extends StatelessWidget {
  const ConnectionStatusWidget({super.key});

  void _showDeviceListDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => const DeviceListDialog(),
    );
  }

  Widget _buildAppBarConnectionStatus(BuildContext context, connection_state.ConnectionState state) {
    final status = state.status;
    final device = state.device;

    if (status == connection_state.ConnectionStatus.connected && device != null) {
      // Connected status
      return InkWell(
        onTap: () => _showDeviceListDialog(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bluetooth_connected, color: Colors.green, size: 16),
            const SizedBox(width: 4),
            Text(device.name, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.arrow_drop_down, size: 16),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'disconnect',
                  child: const Text('Disconnect'),
                  onTap: () {
                    context.read<ConnectionBloc>().add(DisconnectFromDevice());
                  },
                ),
                PopupMenuItem(
                  value: 'scan',
                  child: const Text('Scan for devices'),
                  onTap: () {
                    Future.delayed(const Duration(milliseconds: 100), () {
                      _showDeviceListDialog(context);
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      );
    } else if (status == connection_state.ConnectionStatus.connecting) {
      // Connecting status
      return InkWell(
        onTap: () => _showDeviceListDialog(context),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
            SizedBox(width: 4),
            Text('Connecting...', style: TextStyle(fontSize: 14)),
          ],
        ),
      );
    } else if (status == connection_state.ConnectionStatus.scanning) {
      // Scanning status
      return InkWell(
        onTap: () => _showDeviceListDialog(context),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
            SizedBox(width: 4),
            Text('Scanning...', style: TextStyle(fontSize: 14)),
          ],
        ),
      );
    } else {
      // Disconnected or other status
      return InkWell(
        onTap: () => _showDeviceListDialog(context),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bluetooth_disabled, color: Colors.grey, size: 16),
            SizedBox(width: 4),
            Text('Not connected', style: TextStyle(fontSize: 14)),
            SizedBox(width: 4),
            Icon(Icons.arrow_drop_down, size: 16),
          ],
        ),
      );
    }
  }

  Widget _buildDetailedConnectionStatus(BuildContext context, connection_state.ConnectionState state) {
    final status = state.status;
    final device = state.device;

    if (status == connection_state.ConnectionStatus.connected && device != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.circle, color: Colors.green, size: 12),
            const SizedBox(width: 8),
            Text(
              'Connected to ${device.name}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 16),
              onPressed: () {
                context.read<ConnectionBloc>().add(DisconnectFromDevice());
              },
            ),
          ],
        ),
      );
    } else if (status == connection_state.ConnectionStatus.connecting) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
            SizedBox(width: 8),
            Text('Connecting...'),
          ],
        ),
      );
    } else if (status == connection_state.ConnectionStatus.error) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 16),
            const SizedBox(width: 8),
            Text(
              state.errorMessage ?? 'Connection Error',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.red,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.circle, color: Colors.grey, size: 12),
            const SizedBox(width: 8),
            const Text('Disconnected'),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => _showDeviceListDialog(context),
              child: const Text('Connect'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectionBloc, connection_state.ConnectionState>(
      builder: (context, state) {
        // Check if we're in the app bar (based on parent widget)
        final bool isInAppBar = context.findAncestorWidgetOfExactType<AppBar>() != null;
        
        if (isInAppBar) {
          return _buildAppBarConnectionStatus(context, state);
        } else {
          return _buildDetailedConnectionStatus(context, state);
        }
      },
    );
  }
}
