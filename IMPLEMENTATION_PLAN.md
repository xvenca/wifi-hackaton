# Implementation Plan and Specification for WiFi Proximity Detector App

## 1. Project Overview

### 1.1 Description
The **WiFi Proximity Detector** is a mobile application designed to help users assess the proximity and signal quality of their WiFi connection to the router in real-time. By analyzing the WiFi signal strength (RSSI - Received Signal Strength Indicator), the app categorizes the connection into qualitative levels: **Excellent**, **Good**, **Fair**, **Poor**, or **Bad**. This provides users with an intuitive way to troubleshoot connectivity issues, optimize device placement, or understand network performance without technical jargon.

- **Core Functionality**: Continuously monitor WiFi signal strength and display proximity-based feedback.
- **Target Audience**: Home users, office workers, gamers, or anyone experiencing WiFi issues.
- **Platform**: Cross-platform mobile app (iOS and Android) to ensure "write once, run everywhere" efficiency.
- **Design System**: Material Design 3 (MD3) for a modern, consistent, and accessible UI.
- **Monetization/Extensibility**: Free app with optional premium features (e.g., signal history logging, router mapping) in future iterations.

### 1.2 Key Goals
- **User-Centric**: Simple, non-intrusive interface with real-time updates.
- **Performance**: Low battery impact; efficient background scanning.
- **Cross-Platform**: Single codebase for iOS and Android.
- **Accessibility**: Support for dark/light themes, screen readers, and large text.

### 1.3 Assumptions and Constraints
- App requires location permissions (for WiFi scanning on modern OS).
- Signal strength is an approximation; actual proximity can vary due to walls, interference, etc. (App will include a disclaimer).
- No backend required for MVP; all processing is on-device.
- Development timeline: 4-6 weeks for MVP (1 developer using GitHub Copilot for code acceleration).

## 2. Features Specification

### 2.1 MVP Features
| Feature | Description | Priority |
|---------|-------------|----------|
| **Real-Time Signal Monitoring** | Scan WiFi signal strength every 5 seconds; display RSSI (dBm) and qualitative label (e.g., "Excellent: -30 dBm"). | High |
| **Proximity Categories** | Map RSSI to labels:<br>- Excellent: > -50 dBm<br>- Good: -50 to -60 dBm<br>- Fair: -60 to -70 dBm<br>- Poor: -70 to -80 dBm<br>- Bad: < -80 dBm | High |
| **Visual Indicators** | Color-coded progress bar (green for Excellent, red for Bad) and icons (e.g., signal bars). | High |
| **Permission Handling** | Graceful prompts for WiFi/location permissions; fallback to manual input if denied. | High |
| **Settings Screen** | Toggle auto-scan, theme selection, scan interval (5s/10s/30s). | Medium |
| **About/Disclaimer** | Explain limitations (e.g., "Signal strength is approximate"). | Low |

### 2.2 Future Enhancements (Post-MVP)
- Historical signal logging (charts via local storage).
- Router-specific scanning (if SSID provided).
- Notifications for signal drops.
- Integration with smart home APIs (e.g., Google Home).

## 3. Technical Specification

### 3.1 Tech Stack
To achieve "write once, run everywhere," we'll use **Flutter** (Dart-based framework) for its native performance, hot reload, and excellent Material Design support.

| Component | Technology | Rationale |
|-----------|------------|-----------|
| **Framework** | Flutter 3.16+ | Cross-platform (iOS/Android), single codebase, built-in Material widgets. |
| **UI/Design** | Material Design 3 (via flutter/material) | Native Android look; adaptable for iOS via Cupertino hybrids if needed. |
| **WiFi Scanning** | `wifi_info_flutter` or `network_info_plus` plugin | Cross-platform access to RSSI and SSID; handles permissions. |
| **State Management** | Provider or Riverpod | Lightweight for real-time updates without overkill (e.g., no Bloc for MVP). |
| **Storage** | Hive or SharedPreferences | Local prefs for settings; no cloud needed. |
| **Testing** | Flutter's unit/integration tests + Golden tests for UI | Ensure cross-device consistency. |
| **Build/Deployment** | Flutter CLI + Codemagic/Fastlane | CI/CD for app stores. |
| **Code Assistance** | GitHub Copilot | Accelerate boilerplate (e.g., widget generation, API wrappers). |
| **Version Control** | Git/GitHub | Branches: `main`, `dev`, `feature/*`. |

### 3.2 Architecture
- **Pattern**: MVVM (Model-View-ViewModel) for separation of concerns.
  - **Model**: WiFi data (RSSI, SSID, timestamp).
  - **View**: Material widgets (Scaffold, AppBar, Cards).
  - **ViewModel**: Handles scanning logic, state updates.
- **Data Flow**:
  1. App launch → Request permissions.
  2. Timer-based scan → Fetch RSSI → Map to category → Update UI.
  3. User interactions → Settings persistence.
- **Dependencies** (pubspec.yaml snippet):
  ```yaml
  dependencies:
    flutter:
      sdk: flutter
    material_design_icons_flutter: ^7.0.7296
    wifi_info_flutter: ^2.0.2
    provider: ^6.1.2
    permission_handler: ^11.3.1
  ```

### 3.3 Security and Privacy
- No data collection; all on-device.
- Permissions: WiFi state (always), Location (for scanning on Android 10+).
- Comply with App Store guidelines (e.g., privacy nutrition labels).

### 3.4 Performance Metrics
- Scan interval: Configurable, default 5s (throttle to avoid battery drain).
- UI Refresh: 60 FPS for smooth animations.
- App Size: Target < 20MB.

## 4. UI/UX Design Specification

### 4.1 Design Principles
- **Material Design 3**: Use dynamic color theming, rounded corners, elevation for depth.
- **Themes**: Light/Dark mode (system-following).
- **Accessibility**: Semantic labels, high contrast, scalable text.
- **Localization**: English only for MVP; prepare for i18n.

### 4.2 Key Screens
1. **Home Screen**:
   - AppBar: Title "WiFi Proximity Detector", settings icon.
   - Body: Large card with:
     - Icon: WiFi signal (animated based on strength).
     - Text: "Excellent Signal" (bold, color-coded).
     - Progress Bar: LinearProgressIndicator (0-100% mapped from RSSI).
     - Subtext: "RSSI: -45 dBm | SSID: HomeWiFi".
   - FAB: Refresh scan.

2. **Settings Screen**:
   - ListView with Switches: Auto-scan, Dark Mode.
   - Slider: Scan interval.
   - Button: Reset Permissions.

3. **Permission Screen** (Modal):
   - Explanation text + "Grant Access" button.

### 4.3 Wireframe Sketch (Text-Based)
```
[Home Screen]
----------------------------------------
| WiFi Proximity Detector     [⚙️]    |
----------------------------------------
|                                     |
|         📶 (Icon)                   |
|                                     |
|      EXCELLENT SIGNAL               |
|                                     |
|      [██████████████████] 100%      |
|      RSSI: -45 dBm                  |
|      Connected to: HomeWiFi         |
|                                     |
|                 [🔄 Refresh]        |
----------------------------------------
```

## 5. Implementation Plan

### 5.1 Phases and Timeline (Total: 4-6 Weeks)
Using GitHub Copilot to generate ~70% of boilerplate code (e.g., widgets, API calls).

| Phase | Tasks | Duration | Milestones | Tools/Notes |
|-------|-------|----------|------------|-------------|
| **1: Setup & Planning** | - Init Flutter project.<br>- Setup GitHub repo.<br>- Install plugins.<br>- Design wireframes in Figma. | Week 1 (Days 1-3) | Repo live; basic scaffold runs on emulator. | Flutter Doctor; Copilot for pubspec setup. |
| **2: Core Functionality** | - Implement permission handler.<br>- WiFi scanning service (timer + RSSI mapping).<br>- State management for real-time updates. | Week 1-2 (Days 4-10) | App scans and logs RSSI in console. | Copilot for async streams; test on physical devices. |
| **3: UI Development** | - Build Home/Settings screens with Material widgets.<br>- Add themes, animations (e.g., signal pulse).<br>- Accessibility audits. | Week 2-3 (Days 11-17) | UI prototype; dark mode toggle works. | Copilot for widget trees; Golden tests. |
| **4: Testing & Polish** | - Unit tests for RSSI mapper.<br>- Integration tests for scan flow.<br>- Bug fixes, performance tuning. | Week 3-4 (Days 18-24) | 80% test coverage; beta build. | Flutter Test; emulators for iOS/Android. |
| **5: Deployment** | - Build APK/IPA.<br>- Submit to Play Store/App Store.<br>- Analytics setup (Firebase optional). | Week 4-5 (Days 25-28) | Live on stores. | Fastlane for automation. |
| **6: Post-Launch** | - Monitor crashes (via Play Console).<br>- Iterate on feedback. | Ongoing | v1.1 with enhancements. | - |

### 5.2 Development Workflow
- **Daily Routine**: Code with Copilot (e.g., prompt: "Generate a Flutter widget for signal progress bar").
- **Code Review**: Self-review + PRs for features.
- **Branching**: Feature branches merged via squash.
- **Risks & Mitigations**:
  - Permission denials: User-friendly fallbacks.
  - Cross-platform bugs: Test on iOS Simulator + Android Emulator.
  - Copilot Hallucinations: Manual verification of generated code.

### 5.3 Resources
- **Team**: 1 Full-Stack Developer (Flutter expertise).
- **Budget**: $0 (open-source tools); optional $100 for app icons.
- **Success Metrics**: 1K downloads in Month 1; 4+ star rating.

This plan provides a comprehensive blueprint. If you'd like to dive into code snippets, adjust features, or generate prototypes, let me know!