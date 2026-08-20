# groupproject_group5

# Build Your City: Screen Time Tracker with Gamification

**Build Your City** is a cross-platform Flutter application designed to tackle smartphone addiction and enhance digital wellbeing. It motivates users to stay offline, engage in physical activities and develop healthier digital habits by combining a screen-blocking timer with a virtual city-building game.
**Mood Visualisation Module** powered by real-time data streams and interactive charting.

## Key Features
* **Mood Visualisation Module (Featured)**: Real-time tracking and graphical representation of user moods and focus trends. Powered by `fl_chart` and Cloud Firestore streams to map emotional progress dynamically over daily, weekly, and monthly periods.
* **Virtual City Building**: Earn XP through focus sessions to unlock and construct virtual buildings. Watch your city thrive as your screen time decreases.
* **Anti-Cheat Focus Timer**: A resilient countdown timer featuring an anti-cheat mechanism that penalises users for exiting the app during active focus sessions.
* **Activity & Multimedia Logging**: Log off-screen activities (e.g., jogging, reading) and upload photo evidence to Firebase Storage to earn bonus rewards.
* **Comprehensive Statistics Dashboard**: Detailed bar and line graphs analyzing user focus habits and digital wellbeing metrics.
* **Multi-Role Ecosystem**: Supports standard users, family leaderboards, and a dedicated **Counselor Dashboard** for monitoring student/user progress.
* **Data Portability**: Securely export personal activity and session data in tab-separated values (TSV) format.


### Tech Stack

* **Framework**: Flutter (Cross-platform support for iOS, Android, and Desktop)
* **Backend**: [Firebase](https://google.com)
    * **Authentication**: Secure Email/Password & Role-based access.
    * **Cloud Firestore**: Real-time NoSQL database for city layouts and session logs.
    * **Cloud Storage**: Hosting for activity evidence (photos/videos).
* **Data Visualization**: `fl_chart` for rendering dynamic line and bar charts in the Mood Visualisation & Statistics modules.
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
    │   └── mood_logging_page.dart         # Emoji selection & Diary entry & Mood logging & real-time trend mapping
    │
    ├── 📂 dashboard/                     # 4. Statistics Module
    │   ├── statistics_screen.dart        # Main charts & history list & FL Chart integration for usage & mood visualization
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
