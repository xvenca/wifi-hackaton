import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/wifi_signal_data.dart';
import '../utils/rssi_mapper.dart';

/// ViewModel for WiFi scanning and state management
class WiFiViewModel extends ChangeNotifier {
  final NetworkInfo _networkInfo = NetworkInfo();
  
  WiFiSignalData _currentSignal = WiFiSignalData.unknown();
  bool _isScanning = false;
  bool _autoScanEnabled = true;
  int _scanInterval = 5; // seconds
  String? _errorMessage;
  Timer? _scanTimer;
  PermissionStatus _locationPermissionStatus = PermissionStatus.denied;

  // Getters
  WiFiSignalData get currentSignal => _currentSignal;
  bool get isScanning => _isScanning;
  bool get autoScanEnabled => _autoScanEnabled;
  int get scanInterval => _scanInterval;
  String? get errorMessage => _errorMessage;
  PermissionStatus get locationPermissionStatus => _locationPermissionStatus;
  
  bool get hasPermissions => 
      _locationPermissionStatus == PermissionStatus.granted;

  WiFiViewModel() {
    _loadSettings();
    _checkPermissions();
  }

  /// Load saved settings from SharedPreferences
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _autoScanEnabled = prefs.getBool('auto_scan_enabled') ?? true;
      _scanInterval = prefs.getInt('scan_interval') ?? 5;
      notifyListeners();
      
      if (_autoScanEnabled) {
        startAutoScan();
      }
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  /// Save settings to SharedPreferences
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('auto_scan_enabled', _autoScanEnabled);
      await prefs.setInt('scan_interval', _scanInterval);
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }

  /// Check location permissions (required for WiFi scanning on Android 10+)
  Future<void> _checkPermissions() async {
    _locationPermissionStatus = await Permission.location.status;
    notifyListeners();
  }

  /// Request location permissions
  Future<bool> requestPermissions() async {
    final status = await Permission.location.request();
    _locationPermissionStatus = status;
    notifyListeners();
    return status == PermissionStatus.granted;
  }

  /// Perform a single WiFi scan
  Future<void> scanWiFi() async {
    if (_isScanning) return;

    _isScanning = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Check permissions first
      if (!hasPermissions) {
        _errorMessage = 'Location permission required for WiFi scanning';
        _currentSignal = WiFiSignalData.unknown();
        _isScanning = false;
        notifyListeners();
        return;
      }

      // Get WiFi information
      final wifiName = await _networkInfo.getWifiName();
      final wifiBSSID = await _networkInfo.getWifiBSSID();
      
      // Note: network_info_plus doesn't provide RSSI directly
      // For demo purposes, we'll simulate RSSI based on connection status
      // In production, you'd need platform-specific code or a different plugin
      
      int rssi;
      if (wifiName != null && wifiName.isNotEmpty) {
        // Simulate RSSI - in real implementation, use platform channels
        rssi = _simulateRssi();
      } else {
        rssi = -100; // No connection
      }

      final quality = RssiMapper.mapRssiToQuality(rssi);
      
      _currentSignal = WiFiSignalData(
        rssi: rssi,
        ssid: wifiName?.replaceAll('"', ''), // Remove quotes from SSID
        timestamp: DateTime.now(),
        quality: quality,
      );

      debugPrint('WiFi Scan: ${_currentSignal.toString()}');

    } catch (e) {
      _errorMessage = 'Failed to scan WiFi: ${e.toString()}';
      _currentSignal = WiFiSignalData.unknown();
      debugPrint('WiFi scan error: $e');
    } finally {
      _isScanning = false;
      notifyListeners();
    }
  }

  /// Simulate RSSI for demo purposes
  /// In production, replace with actual platform channel implementation
  int _simulateRssi() {
    // Generate random RSSI between -90 and -30 dBm for demonstration
    final random = DateTime.now().millisecondsSinceEpoch % 60;
    return -90 + random;
  }

  /// Start automatic scanning with timer
  void startAutoScan() {
    _scanTimer?.cancel();
    
    // Initial scan
    scanWiFi();
    
    // Set up periodic scanning
    _scanTimer = Timer.periodic(
      Duration(seconds: _scanInterval),
      (timer) => scanWiFi(),
    );
  }

  /// Stop automatic scanning
  void stopAutoScan() {
    _scanTimer?.cancel();
    _scanTimer = null;
  }

  /// Toggle auto-scan setting
  Future<void> toggleAutoScan(bool enabled) async {
    _autoScanEnabled = enabled;
    await _saveSettings();
    
    if (enabled) {
      startAutoScan();
    } else {
      stopAutoScan();
    }
    
    notifyListeners();
  }

  /// Update scan interval
  Future<void> updateScanInterval(int seconds) async {
    _scanInterval = seconds;
    await _saveSettings();
    
    if (_autoScanEnabled) {
      startAutoScan(); // Restart with new interval
    }
    
    notifyListeners();
  }

  @override
  void dispose() {
    _scanTimer?.cancel();
    super.dispose();
  }
}
