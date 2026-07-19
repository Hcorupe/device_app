import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/ble_bloc.dart';
import '../widgets/device_tile.dart';

class DeviceListScreen extends StatelessWidget {
  const DeviceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLE Devices'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload',
            onPressed: () => context.read<BleBloc>().add(const LoadDevices()),
          ),
        ],
      ),
      body: BlocBuilder<BleBloc, BleState>(
        builder: (context, state) {
          switch (state.status) {
            case BleStatus.initial:
            case BleStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case BleStatus.error:
              return Center(
                child: Text('Error: ${state.errorMessage ?? 'unknown'}'),
              );
            case BleStatus.loaded:
              if (state.devices.isEmpty) {
                return const Center(child: Text('No devices found.'));
              }
              return ListView.separated(
                itemCount: state.devices.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) =>
                    DeviceTile(device: state.devices[index]),
              );
          }
        },
      ),
    );
  }
}
