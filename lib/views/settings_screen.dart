import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/wifi_viewmodel.dart';

/// Settings screen for app configuration
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<WiFiViewModel>(
        builder: (context, viewModel, child) {
          return ListView(
            children: [
              const SizedBox(height: 8),
              
              // Auto-scan toggle
              SwitchListTile(
                title: const Text('Auto-scan'),
                subtitle: const Text('Automatically scan WiFi signal at intervals'),
                value: viewModel.autoScanEnabled,
                onChanged: (value) => viewModel.toggleAutoScan(value),
                secondary: const Icon(Icons.refresh),
              ),
              
              const Divider(),
              
              // Scan interval slider
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Scan Interval',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '${viewModel.scanInterval} seconds',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Slider(
                      value: viewModel.scanInterval.toDouble(),
                      min: 5,
                      max: 30,
                      divisions: 5,
                      label: '${viewModel.scanInterval}s',
                      onChanged: viewModel.autoScanEnabled
                          ? (value) => viewModel.updateScanInterval(value.toInt())
                          : null,
                    ),
                    Text(
                      'How often to scan WiFi signal (5-30 seconds)',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              const Divider(),
              
              // Theme section header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Appearance',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              
              // Theme mode tiles
              RadioListTile<ThemeMode>(
                title: const Text('Light Theme'),
                value: ThemeMode.light,
                groupValue: ThemeMode.system,
                onChanged: (value) {
                  // TODO: Implement theme switching with provider
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Theme switching coming soon!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                secondary: const Icon(Icons.light_mode),
              ),
              
              RadioListTile<ThemeMode>(
                title: const Text('Dark Theme'),
                value: ThemeMode.dark,
                groupValue: ThemeMode.system,
                onChanged: (value) {
                  // TODO: Implement theme switching with provider
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Theme switching coming soon!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                secondary: const Icon(Icons.dark_mode),
              ),
              
              RadioListTile<ThemeMode>(
                title: const Text('System Default'),
                value: ThemeMode.system,
                groupValue: ThemeMode.system,
                onChanged: (value) {},
                secondary: const Icon(Icons.brightness_auto),
              ),
              
              const Divider(),
              
              // About section
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'About',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About WiFi Proximity Detector'),
                onTap: () => _showAboutDialog(context),
              ),
              
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text('Privacy'),
                subtitle: const Text('All processing is done on-device'),
              ),
              
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'WiFi Proximity Detector',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.wifi, size: 48),
      children: [
        const Text(
          'A simple tool to monitor WiFi signal strength and help you find the optimal location for your device.',
        ),
        const SizedBox(height: 16),
        const Text(
          'Signal strength is approximate due to environmental factors such as walls, interference, and device hardware.',
        ),
        const SizedBox(height: 16),
        const Text(
          '© 2025 WiFi Proximity Detector\nAll rights reserved.',
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
