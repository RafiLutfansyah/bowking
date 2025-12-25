# Bowking Features Documentation

## Implemented Features

### 1. Countdown Timer for Claimed Offers

**Location:** Rewards Page > My Vouchers Tab

**Description:** Real-time countdown timer that updates every second, showing time remaining before offer expires.

**Color Coding:**
- Green: > 24 hours remaining
- Orange: 1-24 hours remaining
- Red: < 1 hour remaining
- Grey: Expired

**Implementation:** `lib/features/rewards/presentation/widgets/countdown_timer.dart`

**Key Features:**
- Updates every 1 second using Timer.periodic
- Proper timer disposal to prevent memory leaks
- Optimized setState to avoid unnecessary rebuilds
- Formats duration as "Xd Xh Xm" or "Xh Xm Xs" based on remaining time

---

### 2. My Vouchers Tab

**Location:** Rewards Page > My Vouchers Tab

**Description:** Displays all offers claimed by the user with countdown timers.

**Features:**
- Tab switching between "Available" and "My Vouchers"
- Real-time countdown for each voucher
- Empty state when no vouchers claimed
- Integrates CountdownTimer widget for each claimed offer

**Implementation:** `lib/features/rewards/presentation/pages/rewards_page.dart`

**Data Flow:**
- User opens Rewards page → load both available & claimed offers
- User claims offer → refresh both tabs
- Claimed offers auto-filter expired ones (backend handles this)
- Timer countdown active only in "My Vouchers" tab

---

### 3. Transaction History

**Location:** Wallet Page > Transactions Tab

**Description:** Complete history of all wallet transactions (debits and credits).

**Features:**
- Tab switching between "Balance" and "Transactions"
- Shows date, description, and amount for each transaction
- Color coding: Red for debits, Green for credits
- Displays both RM and Token amounts
- Sorted by date (newest first)

**Implementation:** `lib/features/wallet/presentation/pages/wallet_page.dart`

**Transaction Item Display:**
- Icon: Debit (↓ red) or Credit (↑ green)
- Description: "Booking: Premium Valet" or "Top-up" or "Claimed offer: X"
- Amount: Display RM and Tokens (if > 0)
- Date: Format "Dec 26, 2025 - 14:30"

---

### 4. Date/Time Picker for Booking

**Location:** Services Page > Booking Dialog

**Description:** Allows users to select custom date and time for service bookings.

**Features:**
- Date picker for selecting booking date
- Time picker for selecting booking time
- Validation: only future dates/times allowed
- Default: 2 hours from current time
- Display format: "Dec 26, 2025 at 16:30"

**Implementation:** `lib/features/booking/presentation/pages/services_page.dart`

**User Flow:**
1. User taps service → dialog appears with default date/time
2. User taps "Change Date/Time" button
3. Date picker appears → user selects date
4. Time picker appears → user selects time
5. Dialog updates with selected date/time
6. User taps "Confirm" → booking created with selected date/time

---

### 5. Live Status Polling

**Location:** Backend (Booking Status Updates)

**Description:** Automatic status progression for bookings using polling mechanism.

**Status Flow:**
- Pending (0-5 seconds)
- Confirmed (5-15 seconds)
- Completed (15+ seconds)

**Implementation:** `lib/features/booking/presentation/bloc/booking_bloc.dart`

**Polling Mechanism:**
- Starts automatically after booking creation
- Polls every 5 seconds
- Simulates status progression based on elapsed time
- Stops polling when status reaches "completed"
- Proper timer cleanup on bloc disposal

---

## Architecture

All features follow **Clean Architecture** principles:

### Layers:
- **Presentation Layer:** UI widgets, Bloc state management
- **Domain Layer:** Entities, Usecases, Repository interfaces
- **Data Layer:** Models, Repository implementations, DataSources

### State Management:
- Uses **flutter_bloc** for state management
- Proper event/state separation
- Error handling with Either pattern (Dartz)

---

## Testing

### Run All Tests:
```bash
flutter test
```

### Run Specific Feature Tests:
```bash
flutter test test/features/rewards/
flutter test test/features/wallet/
flutter test test/features/booking/
```

### Run Linter:
```bash
flutter analyze
```

---

## Development Notes

- All features follow existing Clean Architecture patterns
- Bloc pattern used consistently across all features
- Repository pattern for data access
- Proper error handling and state management
- Memory-safe implementations with proper resource cleanup
