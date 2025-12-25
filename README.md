# Bowking - Service Booking & Loyalty System

A Flutter MVP application for streamlined on-premise service bookings with integrated dual-currency wallet and loyalty rewards system.

## Features

### 🎯 Core Features (MVP)

1. **Service Booking Interface**
   - View available services (Valet, Car Wash, Bay Reservation)
   - Real-time service status indicators
   - Date/Time slot selection
   - Instant booking confirmation

2. **Dual-Currency Wallet System**
   - Manage MYR (Fiat) balance
   - Manage GP Coins (Loyalty Tokens)
   - Transaction history tracking
   - Split payment support

3. **Retail Offers Center**
   - Browse available campaigns and offers
   - Claim rewards with loyalty tokens
   - Countdown timers for limited offers
   - My Vouchers inventory

4. **Navigation & UX**
   - Bottom navigation bar (Home, Services, Wallet, Rewards)
   - Shimmer loading effects
   - Toast notifications for user feedback
   - Smooth page transitions

## Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/
│   ├── constants/      # App-wide constants
│   ├── theme/          # App theming
│   └── utils/          # Utility functions
├── features/
│   ├── booking/
│   │   ├── data/
│   │   │   ├── datasources/    # Mock data sources
│   │   │   ├── models/         # Data models
│   │   │   └── repositories/   # Repository implementations
│   │   ├── domain/
│   │   │   ├── entities/       # Business entities
│   │   │   ├── repositories/   # Repository interfaces
│   │   │   └── usecases/       # Business logic
│   │   └── presentation/
│   │       ├── bloc/           # State management
│   │       ├── pages/          # Screen widgets
│   │       └── widgets/        # Reusable widgets
│   ├── wallet/
│   └── rewards/
└── main.dart
```

### Layers

1. **Domain Layer** (Pure Dart)
   - Entities: Business models
   - Repositories: Interfaces
   - Use Cases: Business logic

2. **Data Layer**
   - Models: Data transfer objects
   - Data Sources: Mock services with simulated delays
   - Repository Implementations

3. **Presentation Layer**
   - BLoC: State management using flutter_bloc
   - Pages: Full-screen widgets
   - Widgets: Reusable UI components

## Tech Stack

- **Framework**: Flutter 3.10+
- **State Management**: BLoC (flutter_bloc)
- **Data Modeling**: Equatable
- **UI Enhancements**: Shimmer, Material Design 3
- **Date Formatting**: intl

## Getting Started

### Prerequisites

- Flutter SDK 3.10.4 or higher
- Dart 3.0 or higher

### Installation

1. Clone the repository
```bash
git clone <repository-url>
cd bowking
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

## Project Structure Details

### State Management

Using BLoC pattern for predictable state management:
- **Events**: User actions (e.g., LoadServices, CreateBooking)
- **States**: UI states (Loading, Loaded, Error)
- **BLoC**: Business logic processor

### Mock Data

All data is simulated locally with:
- Realistic network delays (`Future.delayed`)
- Mock services for bookings, wallet, and rewards
- Persistent state during app session

### Key Components

- **BookingBloc**: Manages service listing and booking creation
- **WalletBloc**: Handles balance management and transactions
- **RewardsBloc**: Controls offer browsing and claiming
- **Mock Data Sources**: Simulate backend responses

## Features Implementation

### Service Booking
- Display services with pricing in both MYR and GP Coins
- Check user balance before booking
- Automatic balance deduction
- Status updates (Pending → Confirmed)

### Wallet Management
- Display dual balances prominently
- Transaction history with type indicators
- Real-time balance updates after bookings

### Rewards System
- Grid/List view of available offers
- Category badges
- Expiry countdown timers
- One-tap claim functionality

## Testing

Run static analysis:
```bash
flutter analyze
```

Run tests:
```bash
flutter test
```

## Future Enhancements (Out of MVP Scope)

- Real backend API integration
- Payment gateway integration
- Push notifications (FCM)
- User authentication
- Admin dashboard
- Booking history with filters
- Advanced payment splitting logic

## Design Decisions

1. **Clean Architecture**: Ensures maintainability and testability
2. **BLoC Pattern**: Separates business logic from UI
3. **Mock Services**: Enables rapid prototyping without backend
4. **Material Design 3**: Modern, consistent UI/UX

## Contributing

This is an MVP project. For production use, consider:
- Adding comprehensive unit tests
- Implementing integration tests
- Adding error boundary handling
- Implementing proper logging
- Adding analytics

## License

MIT License - See LICENSE file for details

## Contact

For questions or feedback, please refer to the Product Requirements Document (PRD) in `/docs/PRD.md`.
