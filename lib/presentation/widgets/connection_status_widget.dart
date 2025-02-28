import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pc_remote_control_app/business_logic/blocs/connection/connection_bloc.dart';
import 'package:pc_remote_control_app/business_logic/blocs/connection/connection_event.dart';
import 'package:pc_remote_control_app/business_logic/blocs/connection/connection_state.dart' as connection_state;
import 'package:pc_remote_control_app/data/models/device.dart';

class ConnectionStatusWidget extends StatelessWidget {
  const ConnectionStatusWidget({super.key});

  void _showConnectionMenu(BuildContext context, connection_state.ConnectionState state) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset offset = button.localToGlobal(Offset.zero);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + button.size.height,
        offset.dx + button.size.width,
        offset.dy + button.size.height + 10,
      ),
      items: [
        if (state.status == connection_state.ConnectionStatus.connected)
          PopupMenuItem(
            onTap: () {
              context.read<ConnectionBloc>().add(DisconnectFromDevice());
            },
            child: const Row(
              children: [
                Icon(Icons.close),
                SizedBox(width: 8),
                Text('Disconnect'),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildConnectedStatus(BuildContext context, Device device) {
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
        ],
      ),
    );
  }

  Widget _buildConnectingStatus() {
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
  }

  Widget _buildDisconnectingStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.2),
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
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
          ),
          SizedBox(width: 8),
          Text('Disconnecting...'),
        ],
      ),
    );
  }

  Widget _buildErrorStatus(BuildContext context, String? errorMessage) {
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
            errorMessage ?? 'Connection Error',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisconnectedStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, color: Colors.grey, size: 12),
          SizedBox(width: 8),
          Text('Disconnected'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectionBloc, connection_state.ConnectionState>(
      builder: (context, state) {
        final status = state.status;
        final device = state.device;

        Widget statusWidget;

        if (status == connection_state.ConnectionStatus.connected && device != null) {
          statusWidget = _buildConnectedStatus(context, device);
        } else if (status == connection_state.ConnectionStatus.connecting) {
          statusWidget = _buildConnectingStatus();
        } else if (status == connection_state.ConnectionStatus.disconnecting) {
          statusWidget = _buildDisconnectingStatus();
        } else if (status == connection_state.ConnectionStatus.error) {
          statusWidget = _buildErrorStatus(context, state.errorMessage);
        } else {
          statusWidget = _buildDisconnectedStatus();
        }

        return InkWell(
          onTap: () => _showConnectionMenu(context, state),
          borderRadius: BorderRadius.circular(8),
          child: statusWidget,
        );
      },
    );
  }
}