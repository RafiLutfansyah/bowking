# Product Requirements Document (PRD): Bowking

| Attribute | Details |
| :--- | :--- |
| **Product Name** | Bowking (Service Booking & Loyalty System) |
| **Author** | Rafi Lutfansyah |
| **Status** | In Progress / Development |
| **Version** | 1.0 (MVP) |
| **Last Updated** | December 23, 2025 |

---

# 1. One Pager

## 1.1 Overview
Bowking is a modular mobile application developed using Flutter. It is designed to streamline the on-premise experience for visitors by integrating service bookings (e.g., Valet, Car Wash), a digital payment wallet, and a loyalty reward system. The app aims to remove friction from daily errands while incentivizing user retention through a dual-currency wallet system (Fiat & Loyalty Tokens).

## 1.2 Problem Statement
* **Friction in Service Access:** Customers currently face long queues or uncertainty when trying to access amenities like valet parking or car washes, with no visibility on real-time availability.
* **Disconnected Loyalty Experience:** Physical loyalty cards or separate voucher systems are inconvenient, often leading to low redemption rates and poor customer engagement.
* **Payment Inefficiency:** Relying solely on cash or card terminals at service points slows down operations and lacks integration with digital rewards.

## 1.3 Objectives
1.  **Unified Convenience:** Provide a single, intuitive interface for users to browse service availability, book slots, and pay instantly.
2.  **Increase Customer Retention:** Drive repeat usage through a "Gamified" wallet system where bookings earn loyalty tokens (GP Coins) redeemable for retail offers.

## 1.4 Constraints
1.  **Technical Stack:** Must be built using **Flutter** with a focus on Clean Architecture and modularity.
2.  **Data Simulation:** As a standalone client-side demo, backend services (booking status, transactions, inventory) will be simulated/mocked locally.
3.  **Scope (MVP):** Limited to three core modules: Service Booking, Dual-Wallet System, and Retail Campaign Center. No real payment gateway integration.

## 1.5 Persona
**Key Persona: Alex, the Busy Professional**
* **Profile:** 32 years old, tech-savvy, visits the commercial center 3x a week.
* **Pain Point:** Hates waiting in line for the car wash and often forgets to bring physical loyalty vouchers.
* **Goal:** Wants to book a car wash while in a meeting and pay using accumulated points to save money.

## 1.6 User Scenarios
* **Scenario 1 (Booking):** Alex checks "Premium Valet" availability, selects a time slot, and receives an instant confirmation simulation.
* **Scenario 2 (Payment):** Alex pays for a service using a split payment method: 50% Credit Balance (MYR) and 50% Loyalty Tokens (GP Coins).
* **Scenario 3 (Rewards):** Alex browses the "Retail Offers Center," finds a limited-time voucher with a countdown timer, and claims it to his digital wallet.

---

# 2. Functional Requirements (Features In)

These are the prioritized features for the MVP release.

## 2.1 Feature Set 1: Service Booking Interface
**Goal:** Allow users to view and reserve on-premise services.
* **Service List:** Display available services (Valet, Car Wash, Bay Reservation) with pricing and status.
* **Booking Flow:** User selects a service -> Selects Date/Time -> Confirms Booking.
* **Live Status Simulation:** visual indicators for booking status (e.g., "Pending" -> "Confirmed" via polling logic simulation).

## 2.2 Feature Set 2: Dual-Currency Wallet System
**Goal:** Manage user funds and loyalty rewards seamlessly.
* **Dual Balances:** UI must display two distinct balances: `Wallet (MYR)` and `Tokens (GP Coins)`.
* **Transaction History:** List view showing history with Date, Transaction Type (Debit/Credit), and Amount.
* **Payment Logic:** When booking, the system must support logic to deduct from either RM or Tokens (or simulate a split payment logic).

## 2.3 Feature Set 3: Retail Offers Center (Campaigns)
**Goal:** Drive engagement through gamified rewards.
* **Offers Listing:** Display mock campaigns, events, and loyalty exclusives.
* **Claim Mechanism:** "Claim" button that moves an offer from the global list to the user's "My Vouchers" inventory.
* **Countdown Timer:** Visual urgency indicator on specific claimed offers (e.g., "Expires in 24h").

## 2.4 Feature Set 4: UX & Navigation
**Goal:** Ensure a smooth, native-feeling user experience.
* **Navigation:** Persistent Bottom Navigation Bar (Home, Wallet, Services, Rewards).
* **Feedback Loops:** Use of Shimmer loading effects during data fetching and Toast/Snackbars for success/error messages.
* **Transitions:** Smooth page transitions between lists and details.

---

# 3. Features Out (Out of Scope)

The following features are explicitly excluded from this MVP to ensure focus on architectural quality and core logic:
* **Real Backend Integration:** No API connection to a live server; all data is mocked.
* **Real Payment Gateway:** No integration with Stripe, Xendit, or Banks. Payment is instant and simulated.
* **Push Notifications:** No Firebase Cloud Messaging (FCM). Alerts will be local only.
* **User Authentication:** Login/Signup is bypassed or hardcoded for the demo user ("Alex").
* **Admin Dashboard:** No interface for managing services or offers.

---

# 4. Technical Considerations

## 4.1 Architecture
* **Pattern:** Clean Architecture (Separation of concerns).
    * **Presentation Layer:** Widgets, State Management (Bloc/Riverpod/Provider).
    * **Domain Layer:** Entities, Usecases, Repository Interfaces (Pure Dart).
    * **Data Layer:** DTOs, Repository Implementations, Local Data Sources (Mock Services).
* **Modularity:** Features should be decoupled (e.g., `features/booking`, `features/wallet`).

## 4.2 State Management & Data
* **State Management:** Robust handling of UI states (Loading, Loaded, Error, Empty).
* **Mocking:** Use of a dedicated `MockService` class to simulate network delays (`Future.delayed`) and random failures for error handling testing.

## 4.3 Quality Assurance
* **Unit Testing:** Focus on testing the Logic/BLoC and Repository layers.
* **Linting:** Strict adherence to Flutter lints for code consistency.

---

# 5. Success Metrics

| Metric | Target | Description |
| :--- | :--- | :--- |
| **Code Quality** | Pass | Zero linter errors and adherence to Clean Architecture folder structure. |
| **UX Responsiveness** | < 200ms | Interaction delay (tap to feedback) should be minimal. |
| **Booking Success Rate** | 100% | In the simulation, valid bookings must always deduct the correct wallet balance. |

---

# 6. Timeline & Phasing

| Phase | Duration | Focus Area |
| :--- | :--- | :--- |
| **Phase 1: Foundation** | Week 1 (Days 1-3) | Project setup, folder structure, base widgets, and Navigation bar. |
| **Phase 2: Core Logic** | Week 1 (Days 4-7) | Implementing Mock Services, Wallet Logic, and Booking State Management. |
| **Phase 3: UI & Polish** | Week 2 (Days 1-4) | Building screens, Shimmer effects, transitions, and Retail Center UI. |
| **Phase 4: Refactor** | Week 2 (Days 5-7) | Unit testing, bug fixing, edge case handling, and README documentation. |

---

# 7. Open Issues / Q&A

| ID | Question | Answer |
| :--- | :--- | :--- |
| Q1 | How do we handle "Insuficient Funds"? | The app should show a Snackbar error and block the "Confirm Booking" action. |
| Q2 | Should the countdown timer persist if the app is closed? | For this MVP, resetting the timer on app restart is acceptable, but using a timestamp difference is preferred for realism. |