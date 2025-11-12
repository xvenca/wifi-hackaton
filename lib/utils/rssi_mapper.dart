import '../models/wifi_signal_data.dart';

/// Utility class for mapping RSSI values to signal quality categories
class RssiMapper {
  /// Map RSSI value (in dBm) to SignalQuality enum
  /// 
  /// Thresholds:
  /// - Excellent: > -50 dBm
  /// - Good: -50 to -60 dBm
  /// - Fair: -60 to -70 dBm
  /// - Poor: -70 to -80 dBm
  /// - Bad: < -80 dBm
  static SignalQuality mapRssiToQuality(int rssi) {
    if (rssi > -50) {
      return SignalQuality.excellent;
    } else if (rssi >= -60) {
      return SignalQuality.good;
    } else if (rssi >= -70) {
      return SignalQuality.fair;
    } else if (rssi >= -80) {
      return SignalQuality.poor;
    } else {
      return SignalQuality.bad;
    }
  }

  /// Get color representation for signal quality (for Material Design)
  /// Returns color value as hex string
  static String getColorForQuality(SignalQuality quality) {
    switch (quality) {
      case SignalQuality.excellent:
      case SignalQuality.good:
        return '4CAF50'; // Green
      case SignalQuality.fair:
        return 'FFC107'; // Amber
      case SignalQuality.poor:
        return 'FF9800'; // Orange
      case SignalQuality.bad:
        return 'F44336'; // Red
      case SignalQuality.unknown:
        return '9E9E9E'; // Grey
    }
  }

  /// Get icon name for signal quality (Material Icons)
  static String getIconForQuality(SignalQuality quality) {
    switch (quality) {
      case SignalQuality.excellent:
        return 'wifi';
      case SignalQuality.good:
        return 'wifi_2_bar';
      case SignalQuality.fair:
        return 'wifi_1_bar';
      case SignalQuality.poor:
      case SignalQuality.bad:
        return 'wifi_off';
      case SignalQuality.unknown:
        return 'signal_wifi_off';
    }
  }

  /// Validate if RSSI value is within reasonable range
  static bool isValidRssi(int rssi) {
    // Typical WiFi RSSI range is -100 dBm to 0 dBm
    return rssi >= -100 && rssi <= 0;
  }
}
