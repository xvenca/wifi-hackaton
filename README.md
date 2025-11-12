# WiFi Proximity Detector

A cross-platform mobile app built with Flutter that monitors WiFi signal strength (RSSI) and displays proximity-based feedback using Material Design 3.

## Features

- 📶 **Real-Time Signal Monitoring**: Scans WiFi signal strength every 5 seconds (configurable)
- 🎯 **Proximity Categories**: Maps RSSI to quality levels (Excellent/Good/Fair/Poor/Bad)
- 🎨 **Material Design 3**: Modern UI with color-coded signal indicators and dynamic theming
- ⚙️ **Customizable Settings**: Toggle auto-scan, adjust scan interval, theme selection
- 🔒 **Privacy-First**: All processing is on-device, no data collection
- ♿ **Accessible**: Support for screen readers, high contrast, and scalable text

## Signal Quality Thresholds

- **Excellent**: > -50 dBm (Very close to router)
- **Good**: -50 to -60 dBm (Close to router)
- **Fair**: -60 to -70 dBm (Moderate distance)
- **Poor**: -70 to -80 dBm (Far from router)
- **Bad**: < -80 dBm (Very far from router)

## Setup

### Prerequisites

- Flutter 3.0+ 
- Dart SDK 3.0+
- Android Studio / Xcode for mobile development

### Installation

1. Clone the repository:
```bash
git clone https://github.com/xvenca/wifi-hackaton.git
cd wifi-hackaton
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                    # Entry point with Provider setup
├── models/                      # WiFi data models
│   └── wifi_signal_data.dart   # Signal data model with quality enum
├── viewmodels/                  # Business logic & state management
│   └── wifi_viewmodel.dart     # WiFi scanning service
├── views/                       # Screens
│   ├── home_screen.dart        # Main signal display screen
│   └── settings_screen.dart    # App settings
├── widgets/                     # Reusable components
│   └── signal_strength_card.dart # Signal display card
└── utils/                       # Utilities
    └── rssi_mapper.dart        # RSSI to quality mapping logic
```

## Permissions

### Android
- `ACCESS_WIFI_STATE`: Read WiFi state
- `CHANGE_WIFI_STATE`: Scan WiFi networks
- `ACCESS_FINE_LOCATION`: Required for WiFi scanning on Android 10+

### iOS
- `NSLocationWhenInUseUsageDescription`: WiFi network scanning
- `NSLocalNetworkUsageDescription`: Local network access

**Note**: Location permission is required by the OS for WiFi scanning, but no location data is collected or stored by this app.

## Testing

Run unit tests:
```bash
flutter test
```

Run integration tests:
```bash
flutter test integration_test/
```

## Development

### Key Technologies
- **Framework**: Flutter 3.16+
- **State Management**: Provider
- **WiFi Scanning**: network_info_plus
- **Permissions**: permission_handler
- **Storage**: shared_preferences

### Architecture
- **Pattern**: MVVM (Model-View-ViewModel)
- **Design**: Material Design 3
- **Theme**: Light/Dark mode support

## Known Limitations

- RSSI accuracy varies by device manufacturer
- Physical obstructions (walls, interference) affect readings
- iOS may limit background scanning frequency
- Signal strength is approximate due to environmental factors

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Roadmap

- [ ] Historical signal logging with charts
- [ ] Router-specific scanning
- [ ] Notifications for signal drops
- [ ] Multi-language support
- [ ] Smart home integration

## Support

For issues or questions, please open an issue on GitHub.

---

Built with ❤️ using Flutter and GitHub Copilot
