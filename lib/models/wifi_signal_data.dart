/// Enum representing WiFi signal quality levels
enum SignalQuality {
  excellent,
  good,
  fair,
  poor,
  bad,
  unknown
}

/// Extension to provide display properties for SignalQuality
extension SignalQualityExtension on SignalQuality {
  String get displayName {
    switch (this) {
      case SignalQuality.excellent:
        return 'Excellent';
      case SignalQuality.good:
        return 'Good';
      case SignalQuality.fair:
        return 'Fair';
      case SignalQuality.poor:
        return 'Poor';
      case SignalQuality.bad:
        return 'Bad';
      case SignalQuality.unknown:
        return 'Unknown';
    }
  }

  String get description {
    switch (this) {
      case SignalQuality.excellent:
        return 'Very close to router';
      case SignalQuality.good:
        return 'Close to router';
      case SignalQuality.fair:
        return 'Moderate distance';
      case SignalQuality.poor:
        return 'Far from router';
      case SignalQuality.bad:
        return 'Very far from router';
      case SignalQuality.unknown:
        return 'No signal detected';
    }
  }
}

/// Model representing WiFi signal data
class WiFiSignalData {
  final int rssi;
  final String? ssid;
  final DateTime timestamp;
  final SignalQuality quality;

  WiFiSignalData({
    required this.rssi,
    this.ssid,
    required this.timestamp,
    required this.quality,
  });

  /// Create a WiFiSignalData instance with unknown/default values
  factory WiFiSignalData.unknown() {
    return WiFiSignalData(
      rssi: -100,
      ssid: null,
      timestamp: DateTime.now(),
      quality: SignalQuality.unknown,
    );
  }

  /// Calculate signal strength percentage (0-100)
  /// Maps RSSI range (-100 to -30) to percentage
  int get signalPercentage {
    if (rssi >= -30) return 100;
    if (rssi <= -100) return 0;
    
    // Map -100 to -30 dBm to 0-100%
    return ((rssi + 100) * 100 ~/ 70).clamp(0, 100);
  }

  @override
  String toString() {
    return 'WiFiSignalData(rssi: $rssi dBm, ssid: $ssid, quality: ${quality.displayName})';
  }
}
