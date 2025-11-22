# Regina Bus Tracker 🚌

A Flutter mobile application that provides real-time bus tracking for Regina Transit system. Users can view all active buses on a map, select a specific bus to track, and receive notifications about the nearest bus stops.

## Features

- 🗺️ **Real-time Bus Map**: View all active Regina Transit buses on an interactive map
- 📍 **Bus Tracking**: Select and track specific buses with live location updates
- 🔔 **Smart Notifications**: Get notified with the nearest bus stop name every 5-10 seconds
- 📱 **Background Tracking**: Continue tracking buses even when the app is in background
- 🎯 **Distance Calculation**: Automatic calculation of nearest bus stops using coordinate distance
- 💾 **Data Caching**: Offline support with cached bus stop data

## Development Setup

### Prerequisites
- Flutter SDK (^3.5.3)
- Dart SDK
- Android Studio or VS Code
- iOS Simulator (for iOS development)
- Android Emulator or physical device

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd bus_tracker
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Create configuration files:
   ```bash
   # Create API configuration (see lib/config/api_config.dart.example)
   cp lib/config/api_config.dart.example lib/config/api_config.dart
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## API Integration

This app integrates with Regina Transit Live API to fetch real-time bus location data. The API provides:
- Current bus positions
- Route information
- Bus stop locations
- Real-time updates

## Architecture

The app follows a clean architecture pattern with clear separation of concerns:

- **Presentation Layer**: UI components and state management
- **Domain Layer**: Business logic and use cases
- **Data Layer**: API services and data repositories

## Key Dependencies

- `flutter_map` - Interactive map widget
- `geolocator` - Location services
- `flutter_local_notifications` - Local notifications
- `http` - HTTP client for API calls
- `provider` or `riverpod` - State management
- `shared_preferences` - Local data storage
- `workmanager` - Background task management

## Development Roadmap

- [x] Project setup and structure
- [ ] Regina Transit API integration
- [ ] Map implementation with bus markers
- [ ] Bus selection and tracking UI
- [ ] Background location service
- [ ] Notification system
- [ ] Distance calculation algorithm
- [ ] Bus stop data management
- [ ] Performance optimization
- [ ] Testing and deployment

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

For questions or support, please open an issue on GitHub.
