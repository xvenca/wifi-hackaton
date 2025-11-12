import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/wifi_viewmodel.dart';
import '../widgets/signal_strength_card.dart';
import 'settings_screen.dart';

/// Home screen displaying WiFi signal strength
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Request permissions on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<WiFiViewModel>();
      if (!viewModel.hasPermissions) {
        _showPermissionDialog();
      }
    });
  }

  Future<void> _showPermissionDialog() async {
    final viewModel = context.read<WiFiViewModel>();
    
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'This app needs location permission to scan WiFi networks. '
          'This is required by Android 10+ to access WiFi information.\n\n'
          'Your location data is not collected or stored.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Deny'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Grant Access'),
          ),
        ],
      ),
    );

    if (result == true) {
      final granted = await viewModel.requestPermissions();
      if (granted && mounted) {
        viewModel.scanWiFi();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WiFi Proximity Detector'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<WiFiViewModel>(
        builder: (context, viewModel, child) {
          if (!viewModel.hasPermissions) {
            return _buildPermissionRequired(viewModel);
          }

          if (viewModel.errorMessage != null) {
            return _buildError(viewModel);
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                
                SignalStrengthCard(
                  signalData: viewModel.currentSignal,
                  onRefresh: () => viewModel.scanWiFi(),
                ),
                
                const SizedBox(height: 16),
                
                // Status indicators
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (viewModel.isScanning)
                        const Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      Text(
                        viewModel.isScanning
                            ? 'Scanning...'
                            : viewModel.autoScanEnabled
                                ? 'Auto-scan: Every ${viewModel.scanInterval}s'
                                : 'Auto-scan disabled',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Disclaimer
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'ℹ️ Signal strength is approximate due to environmental factors',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Consumer<WiFiViewModel>(
        builder: (context, viewModel, child) {
          if (!viewModel.hasPermissions) return const SizedBox.shrink();
          
          return FloatingActionButton(
            onPressed: viewModel.isScanning ? null : () => viewModel.scanWiFi(),
            tooltip: 'Refresh scan',
            child: const Icon(Icons.refresh),
          );
        },
      ),
    );
  }

  Widget _buildPermissionRequired(WiFiViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'Permission Required',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Location permission is needed to scan WiFi networks.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _showPermissionDialog,
              icon: const Icon(Icons.lock_open),
              label: const Text('Grant Permission'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(WiFiViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red[400],
            ),
            const SizedBox(height: 24),
            Text(
              'Error',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              viewModel.errorMessage ?? 'Unknown error occurred',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => viewModel.scanWiFi(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
