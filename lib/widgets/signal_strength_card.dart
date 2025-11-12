import 'package:flutter/material.dart';
import '../models/wifi_signal_data.dart';
import '../utils/rssi_mapper.dart';

/// Reusable widget to display WiFi signal strength card
class SignalStrengthCard extends StatelessWidget {
  final WiFiSignalData signalData;
  final VoidCallback onRefresh;

  const SignalStrengthCard({
    super.key,
    required this.signalData,
    required this.onRefresh,
  });

  Color _getQualityColor(SignalQuality quality) {
    final colorHex = RssiMapper.getColorForQuality(quality);
    return Color(int.parse('FF$colorHex', radix: 16));
  }

  IconData _getSignalIcon(SignalQuality quality) {
    switch (quality) {
      case SignalQuality.excellent:
        return Icons.wifi;
      case SignalQuality.good:
        return Icons.wifi_2_bar;
      case SignalQuality.fair:
        return Icons.wifi_1_bar;
      case SignalQuality.poor:
      case SignalQuality.bad:
        return Icons.wifi_off;
      case SignalQuality.unknown:
        return Icons.signal_wifi_off;
    }
  }

  @override
  Widget build(BuildContext context) {
    final quality = signalData.quality;
    final color = _getQualityColor(quality);
    final percentage = signalData.signalPercentage;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Signal Icon
            Icon(
              _getSignalIcon(quality),
              size: 80,
              color: color,
            ),
            const SizedBox(height: 16),
            
            // Signal Quality Label
            Text(
              quality.displayName.toUpperCase(),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            // Quality Description
            Text(
              quality.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: Colors.grey[200],
                color: color,
                minHeight: 12,
              ),
            ),
            const SizedBox(height: 8),
            
            Text(
              '$percentage%',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            
            // RSSI Details
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Signal Strength:',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        '${signalData.rssi} dBm',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (signalData.ssid != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Network:',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Flexible(
                          child: Text(
                            signalData.ssid!,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
