# groupproject_group5

# Build Your City: Screen Time Tracker with Gamification

**Build Your City** is a cross-platform Flutter application designed to tackle smartphone addiction and enhance digital wellbeing. It motivates users to stay offline, engage in physical activities and develop healthier digital habits by combining a screen-blocking timer with a virtual city-building game.

## Key Features

* **Virtual City Building**: Earn XP through focus sessions to unlock and build visual structures. Watch your city grow while reducing your screen time.
* **Focus Timer**: A robust countdown timer with an 'anti-cheat' system that penalises users for exiting the app during a session.
* **Activity & Multimedia Logging**: Log off-screen activities (e.g. jogging or painting) and upload photo evidence to earn bonus rewards.
* **Mood & Reflection**: Track your emotional state after focus sessions to see how digital use affects your mental well-being.
* **Statistics dashboard**: Detailed bar and line graphs showing usage trends over daily, weekly and monthly periods.
* **Family and counsellor roles**: Supports multiple profiles, family leaderboards for competition and a counsellor dashboard for monitoring students.
* **Data portability**: All personal data can be securely exported in tab-separated values (TSV) format for backup or migration.

### Tech Stack

* **Framework**: Flutter (Cross-platform support for iOS, Android, and Desktop)
* **Backend**: [Firebase](https://google.com)
    * **Authentication**: Secure Email/Password & Role-based access.
    * **Cloud Firestore**: Real-time NoSQL database for city layouts and session logs.
    * **Cloud Storage**: Hosting for activity evidence (photos/videos).
* **State Management**: Provider & ProxyProvider for reactive UI updates.
* **Local Storage**: SharedPreferences for offline-first settings.
* **Notifications**: Flutter Local Notifications for break reminders and daily nudges.

## 📂 Project Structure

```text
lib/
├── main.dart                               # App Entry: Firebase & Provider Setup
├── firebase_options.dart                   # Firebase configuration
├── navigation_hub.dart                     # Global BottomNavigationBar Controller
│
├── 📂 core/                                # 【Core Layer】
│   ├── constants/
│   │   ├── app_colors.dart                 # primaryGreen (0xFF46AA57), accent, etc.
│   │   ├── app_styles.dart                 # Shared TextStyles, BorderRadii, Margins
│   └── theme/
│       └── app_theme.dart                  # ThemeData for Light/Dark modes
│
├── 📂 models/                              # 【Data Model Layer】
│   ├── item_info.dart                      # Building & Map Position objects
│   ├── session_record.dart                 # Mood, Reflection & Timer duration
│   └── user_profile.dart                   # User roles (Student/Counselor), XP, Level
│
├── 📂 services/                            # 【Service Layer】
│   ├── auth_service.dart                   # Login, Sign Up, Password Reset logic
│   ├── firestore_service.dart              # Database CRUD & TSV Export logic
│   ├── storage_service.dart                # File/Image upload to Firebase Storage
│   └── notification_service.dart           # Local & Push notification setup
│
├── 📂 providers/                           # 【State Management Layer】
│   ├── user_provider.dart                  # Current User state & Role switching
│   ├── gamification_provider.dart          # City placement, XP calculation
│   └── focus_session_provider.dart         # Timer logic & Anti-cheat monitoring
│
└── 📂 screens/                             # 【UI Layer】
    ├── 📂 auth/                            # 1. Identity Module
    │   ├── home_screen.dart                # Landing / Welcome view
    │   ├── login_screen.dart               # Email/Password login
    │   └── signup_screen.dart              # User registration
    │
    ├── 📂 gamification/                    # 2. Game Module
    │   ├── focus_city_page.dart            # The City Map view
    │   └── 📂 widgets/
    │       ├── city_inventory.dart         # Bottom sheet for buildings
    │       └── timer_display.dart          # Circular/Digital timer overlay
    │
    ├── 📂 activity/                       # 3. Reflection Module
    │   ├── session_complete_screen.dart   # Evidence upload UI
    │   └── mood_logging_page.dart         # Emoji selection & Diary entry
    │
    ├── 📂 dashboard/                     # 4. Statistics Module
    │   ├── statistics_screen.dart        # Main charts & history list
    │   └── 📂 widgets/
    │       └── stat_widgets.dart         # Bar charts / Line graphs
    │
    ├── 📂 settings/                     # 5. Management Module
    │   ├── settings_page.dart           # System toggles
    │   ├── user_profile_screen.dart     # Profile editing & Badge display
    │   └── family_leaderboard.dart      # Rankings list
    │
    └── 📂 counselor/                    # 6. Admin Module
        └── counselor_dashboard.dart     # Student monitoring list
```
