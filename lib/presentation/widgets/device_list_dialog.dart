import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pc_remote_control_app/business_logic/blocs/connection/connection_bloc.dart';
import 'package:pc_remote_control_app/business_logic/blocs/connection/connection_event.dart';
import 'package:pc_remote_control_app/business_logic/blocs/connection/connection_state.dart' as connection_state;
import 'package:pc_remote_control_app/data/models/device.dart';

class DeviceListDialog extends StatelessWidget {
  const DeviceListDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectionBloc, connection_state.ConnectionState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available Devices',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    style: IconButton.styleFrom(elevation: 2),
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Scan button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: state.isScanning
                    ? null
                    : () => context.read<ConnectionBloc>().add(StartScan()),
                icon: state.isScanning
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.search),
                label: Text(state.isScanning ? 'Scanning...' : 'Scan for Devices'),
              ),
              
              const SizedBox(height: 16),
              
              // Device list
              if (state.discoveredDevices.isEmpty && !state.isScanning)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text('No devices found. Tap Scan to search for devices.'),
                  ),
                )
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.discoveredDevices.length,
                    itemBuilder: (context, index) {
                      final device = state.discoveredDevices[index];
                      return DeviceListItem(
                        device: device,
                        isConnected: state.device?.id == device.id,
                        onTap: () {
                          context.read<ConnectionBloc>().add(ConnectToDevice(device));
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              
              if (state.isScanning)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text('Scanning for nearby devices...'),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class DeviceListItem extends StatelessWidget {
  final Device device;
  final bool isConnected;
  final VoidCallback onTap;

  const DeviceListItem({
    super.key,
    required this.device,
    required this.isConnected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final deviceCardDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
    return ListTile(
      title: Text(device.name),
      subtitle: Text(device.id),
      trailing: isConnected
          ? const Icon(Icons.check_circle, color: Colors.green)
          : const Icon(Icons.bluetooth),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (device.rssi != null)
            _buildSignalStrengthIcon(device.rssi!)
          else
            const Icon(Icons.device_unknown),
        ],
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: Theme.of(context).colorScheme.surface,
      onTap: onTap,
    );
  }

  Widget _buildSignalStrengthIcon(int rssi) {
    // RSSI values typically range from -100 (weak) to -40 (strong)
    IconData icon;
    if (rssi > -60) {
      icon = Icons.signal_cellular_alt; // Full signal (4 bars)
    } else if (rssi > -75) {
      icon = Icons.signal_cellular_alt_2_bar; // Good signal (3 bars)
    } else if (rssi > -90) {
      icon = Icons.signal_cellular_alt_1_bar; // Fair signal (2 bars)
    } else {
      icon = Icons.signal_cellular_0_bar; // Poor signal (1 bar)
    }
    return Icon(icon);
  }
}
