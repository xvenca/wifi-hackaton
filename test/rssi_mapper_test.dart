import 'package:flutter_test/flutter_test.dart';
import 'package:wifi_proximity_detector/models/wifi_signal_data.dart';
import 'package:wifi_proximity_detector/utils/rssi_mapper.dart';

void main() {
  group('RssiMapper Tests', () {
    test('maps RSSI to Excellent quality', () {
      expect(RssiMapper.mapRssiToQuality(-40), SignalQuality.excellent);
      expect(RssiMapper.mapRssiToQuality(-30), SignalQuality.excellent);
      expect(RssiMapper.mapRssiToQuality(-49), SignalQuality.excellent);
    });

    test('maps RSSI to Good quality', () {
      expect(RssiMapper.mapRssiToQuality(-50), SignalQuality.good);
      expect(RssiMapper.mapRssiToQuality(-55), SignalQuality.good);
      expect(RssiMapper.mapRssiToQuality(-59), SignalQuality.good);
    });

    test('maps RSSI to Fair quality', () {
      expect(RssiMapper.mapRssiToQuality(-60), SignalQuality.fair);
      expect(RssiMapper.mapRssiToQuality(-65), SignalQuality.fair);
      expect(RssiMapper.mapRssiToQuality(-69), SignalQuality.fair);
    });

    test('maps RSSI to Poor quality', () {
      expect(RssiMapper.mapRssiToQuality(-70), SignalQuality.poor);
      expect(RssiMapper.mapRssiToQuality(-75), SignalQuality.poor);
      expect(RssiMapper.mapRssiToQuality(-79), SignalQuality.poor);
    });

    test('maps RSSI to Bad quality', () {
      expect(RssiMapper.mapRssiToQuality(-80), SignalQuality.bad);
      expect(RssiMapper.mapRssiToQuality(-90), SignalQuality.bad);
      expect(RssiMapper.mapRssiToQuality(-100), SignalQuality.bad);
    });

    test('validates RSSI range correctly', () {
      expect(RssiMapper.isValidRssi(-50), true);
      expect(RssiMapper.isValidRssi(0), true);
      expect(RssiMapper.isValidRssi(-100), true);
      expect(RssiMapper.isValidRssi(10), false);
      expect(RssiMapper.isValidRssi(-110), false);
    });

    test('returns correct color hex for each quality', () {
      expect(RssiMapper.getColorForQuality(SignalQuality.excellent), '4CAF50');
      expect(RssiMapper.getColorForQuality(SignalQuality.good), '4CAF50');
      expect(RssiMapper.getColorForQuality(SignalQuality.fair), 'FFC107');
      expect(RssiMapper.getColorForQuality(SignalQuality.poor), 'FF9800');
      expect(RssiMapper.getColorForQuality(SignalQuality.bad), 'F44336');
      expect(RssiMapper.getColorForQuality(SignalQuality.unknown), '9E9E9E');
    });
  });

  group('WiFiSignalData Tests', () {
    test('creates WiFiSignalData with correct properties', () {
      final data = WiFiSignalData(
        rssi: -50,
        ssid: 'TestNetwork',
        timestamp: DateTime(2025, 11, 12),
        quality: SignalQuality.good,
      );

      expect(data.rssi, -50);
      expect(data.ssid, 'TestNetwork');
      expect(data.quality, SignalQuality.good);
    });

    test('creates unknown WiFiSignalData', () {
      final data = WiFiSignalData.unknown();

      expect(data.rssi, -100);
      expect(data.ssid, null);
      expect(data.quality, SignalQuality.unknown);
    });

    test('calculates signal percentage correctly', () {
      expect(WiFiSignalData(
        rssi: -30,
        timestamp: DateTime.now(),
        quality: SignalQuality.excellent,
      ).signalPercentage, 100);

      expect(WiFiSignalData(
        rssi: -100,
        timestamp: DateTime.now(),
        quality: SignalQuality.bad,
      ).signalPercentage, 0);

      expect(WiFiSignalData(
        rssi: -65,
        timestamp: DateTime.now(),
        quality: SignalQuality.fair,
      ).signalPercentage, 50);
    });

    test('signal quality extension returns correct display names', () {
      expect(SignalQuality.excellent.displayName, 'Excellent');
      expect(SignalQuality.good.displayName, 'Good');
      expect(SignalQuality.fair.displayName, 'Fair');
      expect(SignalQuality.poor.displayName, 'Poor');
      expect(SignalQuality.bad.displayName, 'Bad');
      expect(SignalQuality.unknown.displayName, 'Unknown');
    });

    test('signal quality extension returns correct descriptions', () {
      expect(SignalQuality.excellent.description, 'Very close to router');
      expect(SignalQuality.good.description, 'Close to router');
      expect(SignalQuality.fair.description, 'Moderate distance');
      expect(SignalQuality.poor.description, 'Far from router');
      expect(SignalQuality.bad.description, 'Very far from router');
      expect(SignalQuality.unknown.description, 'No signal detected');
    });
  });
}
