# WiFi Proximity Detector - AI Agent Instructions

## Project Overview
Cross-platform mobile app (Flutter) that monitors WiFi signal strength (RSSI) and displays proximity-based feedback using Material Design 3. Target: Simple, user-friendly WiFi troubleshooting tool for non-technical users.

## Architecture & Tech Stack
- **Framework**: Flutter 3.16+ (Dart)
- **Pattern**: MVVM (Model-View-ViewModel)
  - Model: WiFi data (RSSI, SSID, timestamp)
  - View: Material Design 3 widgets
  - ViewModel: Scanning logic + state management
- **State Management**: Provider or Riverpod (lightweight, avoid Bloc for MVP)
- **Key Plugins**:
  - `wifi_info_flutter` or `network_info_plus`: WiFi scanning, RSSI access
  - `permission_handler`: Location/WiFi permissions
  - `material_design_icons_flutter`: Icons
- **Storage**: Hive or SharedPreferences for local settings (no backend)

## Critical Conventions

### RSSI Mapping (Core Business Logic)
Always use these exact thresholds when working with signal strength:
```dart
// Excellent: > -50 dBm
// Good: -50 to -60 dBm
// Fair: -60 to -70 dBm
// Poor: -70 to -80 dBm
// Bad: < -80 dBm
```

### Scan Behavior
- Default scan interval: **5 seconds** (configurable: 5s/10s/30s in settings)
- Use timer-based scanning to minimize battery drain
- Implement throttling to prevent excessive background activity

### Permission Strategy
- Android 10+: Requires **both** WiFi state AND location permissions for scanning
- Graceful degradation: If permissions denied, show fallback UI with manual input option
- Always include user-friendly permission explanation before requesting

## Development Workflow

### Project Setup
```bash
# Initialize Flutter project (when creating codebase)
flutter create wifi_proximity_detector
cd wifi_proximity_detector

# Install dependencies from IMPLEMENTATION_PLAN.md spec:
# Add to pubspec.yaml: wifi_info_flutter, provider, permission_handler, material_design_icons_flutter
flutter pub get

# Verify setup
flutter doctor
```

### Branching Strategy
- `main`: Production-ready code
- `dev`: Integration branch
- `feature/*`: Individual features (e.g., `feature/wifi-scanner`, `feature/settings-ui`)
- Use squash merges for PRs

### Testing Requirements
- Unit tests: RSSI mapper, permission handlers
- Integration tests: Full scan flow (permissions → scan → UI update)
- Golden tests: UI screenshots for visual regression
- Target: **80% code coverage**

## UI/UX Guidelines

### Material Design 3 Principles
- Dynamic color theming (system-following)
- Support both light/dark modes
- Use elevation for depth, rounded corners for cards
- Color-coded signal indicators:
  - Green: Excellent/Good
  - Yellow/Amber: Fair
  - Orange: Poor
  - Red: Bad

### Key Screens Structure
1. **Home Screen**: AppBar with title + settings icon, large signal card with icon/label/progress bar/RSSI details, FAB for manual refresh
2. **Settings Screen**: ListView with auto-scan toggle, theme selector, scan interval slider, reset permissions button
3. **Permission Modal**: Explanation text + grant access CTA

### Accessibility Requirements
- Semantic labels for screen readers
- High contrast mode support
- Scalable text (respect system font size)
- Color-blind friendly (don't rely solely on color)

## Code Generation Patterns

### When adding WiFi scanning logic:
- Use async/await with streams for real-time updates
- Handle permission states explicitly (denied, granted, permanentlyDenied)
- Include error boundaries for platform-specific failures
- Log RSSI values for debugging but sanitize before production

### When creating widgets:
- Prefer stateless widgets where possible
- Extract reusable components (e.g., SignalStrengthCard, PermissionDialog)
- Use const constructors for performance
- Follow Flutter naming conventions: `UpperCamelCase` for classes, `lowerCamelCase` for methods

### When managing state:
- Keep ViewModels separate from UI files
- Use ChangeNotifier with Provider for reactive updates
- Avoid direct access to platform APIs from widgets (use ViewModel layer)

## Performance Considerations
- App size target: < 20MB
- UI refresh rate: 60 FPS minimum
- Battery impact: Monitor with Flutter DevTools profiler
- Avoid blocking UI thread during scans (use isolates if needed)

## Security & Privacy
- **No data collection**: All processing is on-device
- No analytics in MVP (Firebase optional for post-launch)
- Include privacy disclaimer in About screen: "Signal strength is approximate due to environmental factors"
- Comply with App Store privacy nutrition labels

## Known Constraints
- RSSI accuracy varies by device manufacturer
- Physical obstructions (walls, interference) affect readings beyond app control
- iOS restrictions may limit background scanning frequency
- Location permission required on Android 10+ for WiFi scanning (OS limitation, not app choice)

## File Organization (When Created)
```
lib/
├── main.dart                    # Entry point
├── models/                      # WiFi data models
├── viewmodels/                  # Business logic, scan service
├── views/                       # Screens (home, settings)
├── widgets/                     # Reusable components
└── utils/                       # RSSI mapper, constants
test/                            # Unit/integration tests
```

## References
- Full specifications: `IMPLEMENTATION_PLAN.md`
- Timeline: 4-6 week MVP with phases defined in section 5.1
- Target audience: Non-technical home users, not network admins
