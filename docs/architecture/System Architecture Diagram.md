Flutter App (Cross-platform: Android / iOS / Web)

  ├─ 1) UI Layer (Screens / Widgets)
  │    ├─ Welcome / Sign In / Sign Up
  │    └─ MainShell (Bottom Navigation)
  │         ├─ Tab 1: Build City (Focus + Gamification)
  │         ├─ Tab 2: Mood Log
  │         ├─ Tab 3: Dashboard
  │         └─ Tab 4: Settings (Account / Notifications / Export)

  ├─ 2) State Layer (Provider)
  │    ├─ AuthProvider  (login state / user session)
  │    ├─ DataProvider  (sessions / moods / activities / sync state)
  │    └─ GameProvider  (timer / XP / level / city state)

  ├─ 3) Repository Layer (Data Access)
  │    ├─ AuthRepository
  │    ├─ SessionRepository
  │    ├─ MoodRepository
  │    ├─ ActivityRepository
  │    └─ SyncService (offline-first push/pull)

  ├─ 4) Local Storage Layer
  │    ├─ SharedPreferences (token / settings)
  │    └─ Hive Local DB
  │         ├─ sessions_box
  │         ├─ moods_box
  │         ├─ activities_box
  │         └─ pending_sync_box

  └─ 5) Communication Layer
       └─ HTTPS via Supabase SDK (JWT secured)
                ↓

Supabase Backend Platform

  ├─ Authentication (Email/Password + JWT session)
  ├─ PostgreSQL Database (Persistent Storage)
  │    ├─ profiles
  │    ├─ focus_sessions
  │    ├─ mood_entries
  │    ├─ activity_entries
  │    └─ gamification_state (optional)
  │
  ├─ Row Level Security (RLS)
  │    └─ Policy: user_id = auth.uid()
  │
  └─ Storage (Media Evidence)
       └─ activity_media bucket (images/videos)