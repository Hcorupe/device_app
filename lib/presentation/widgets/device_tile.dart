import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/ble_device.dart';
import '../bloc/ble_bloc.dart';

/// A single row showing a BLE device with a connect/disconnect action.
class DeviceTile extends StatelessWidget {
  const DeviceTile({super.key, required this.device});

  final BleDevice device;

  @override
  Widget build(BuildContext context) {
    final connected = device.isConnected;
    return ListTile(
      leading: Icon(
        Icons.bluetooth,
        color: connected ? Colors.blue : Colors.grey,
      ),
      title: Text(device.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text('${device.id}   •   ${device.rssi} dBm'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StatusChip(connected: connected),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {
              final bloc = context.read<BleBloc>();
              if (connected) {
                bloc.add(DisconnectDevice(device.id));
              } else {
                bloc.add(ConnectDevice(device.id));
              }
            },
            child: Text(connected ? 'Disconnect' : 'Connect'),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.connected});

  final bool connected;

  @override
  Widget build(BuildContext context) {
    final color = connected ? Colors.green : Colors.grey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        connected ? 'Connected' : 'Disconnected',
        style: TextStyle(color: color, fontSize: 12),
      ),
    );
  }
}
