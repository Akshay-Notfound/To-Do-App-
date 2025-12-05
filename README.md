# ToDo+ 📚 Smart Study Assistant

<div align="center">
  
  ![Flutter](https://img.shields.io/badge/Flutter-3.32+-02569B?logo=flutter)
  ![Dart](https://img.shields.io/badge/Dart-3.2+-0175C2?logo=dart)
  ![License](https://img.shields.io/badge/License-MIT-green)
  
  **AI-Powered Productivity App for Competitive Exam Aspirants**
  
  `JEE` • `GATE` • `UPSC` • `NEET`
  
</div>

---

## 🌟 Features

### 🧠 AI-Powered Intelligence
- **Weak Area Detection**: Automatically identifies struggling topics based on:
  - Task completion rate
  - Number of snoozes (postponements)
  - Success vs. failure ratio
- **Subject Mastery Tracking**: 
  - Confidence scoring (0-100%) for each subject
  - Real-time performance analysis
  - Visual indicators (🟢 Strong, 🟠 Medium, 🔴 Weak)
- **Smart Rescheduling**: 
  - "I'm Sick Today" button
  - Intelligently postpones non-urgent tasks
  - Preserves high-priority deadlines
- **Burnout Detector**: 
  - Monitors study hours vs. completion ratio
  - Alerts when effectiveness drops
  - Suggests breaks and task redistribution

### 📝 Smart Input Features
- **Natural Language Date Parsing**:
  ```
  "tomorrow 5pm"        → Tomorrow at 17:00
  "next Friday 10am"    → Next Friday at 10:00
  "in 3 days"           → 3 days from now
  "Saturday 2:30pm"     → This Saturday at 14:30
  ```
- **Exam Templates**: One-click task generation
  - **JEE**: Physics, Chemistry, Mathematics (15 topics)
  - **GATE CS**: Programming, Theory, Aptitude
  - **UPSC**: History, Geography, Polity, Economy
  - **NEET**: Physics, Chemistry, Biology

### ⏱️ Focus Tools
- **Pomodoro Timer**:
  - Visual circular ring progress indicator
  - Customizable durations (15/25/30/45/60 min)
  - Auto work/break cycling (25 min work, 5 min break)
  - Long break after 4 sessions (15 min)
  - Session counter
- **Focus Session Tracking**:
  - Completion rate analytics
  - Study time per subject
  - Historical session data

### 🎨 Premium UI/UX
- **Modern Typography**: 
  - Outfit (headings) - Bold, modern
  - Inter (body text) - Highly readable
  - 13 defined text styles with proper hierarchy
- **Haptic Feedback**: 
  - Medium impact on task toggle
  - Heavy impact on task deletion
  - Tactile responsiveness throughout
- **Visual Design**:
  - Priority-based left border colors (4px thick)
    - 🔴 High Priority: Red
    - 🟠 Medium Priority: Orange
    - 🟢 Low Priority: Green
  - Skeleton loaders with shimmer effect
  - True Black OLED dark mode (#121212) for battery saving

### 🤖 ML Kit Integration (Mobile)
- **Study Buddy Chat**: 
  - On-device Smart Reply suggestions
  - Conversational AI responses
  - Motivational context-aware messages
  - No internet required

---

## 🏗️ Architecture

```
Clean Architecture Pattern
├── Presentation Layer
│   ├── UI (Material 3 Design)
│   ├── Widgets (Reusable components)
│   └── Providers (Riverpod State Management)
├── Domain Layer
│   ├── Use Cases (Business logic)
│   └── Repository Interfaces
└── Data Layer
    ├── Models (Hive entities)
    ├── Repositories (Implementations)
    └── Services (AI, Notifications, Scheduling)
```

---

## 🛠️ Tech Stack

| Component | Technology | Purpose |
|-----------|-----------|---------|
| **Framework** | Flutter 3.32+ | Cross-platform UI (Android, iOS, Web) |
| **Language** | Dart 3.2+ | Type-safe, null-safe |
| **State Management** | Riverpod 2.6+ | Reactive, testable state |
| **Local Database** | Hive 1.1+ | Fast, offline-first NoSQL |
| **Cloud Backend** | Firebase | Auth, Firestore sync |
| **AI/ML** | ML Kit Smart Reply | On-device suggestions |
| **Typography** | Google Fonts | Outfit + Inter |
| **Notifications** | flutter_local_notifications | Task reminders |
| **UI Effects** | Shimmer 3.0 | Loading states |
| **Code Generation** | build_runner, Hive generator | Adapters |

---

## 🚀 Getting Started

### Prerequisites
```bash
Flutter SDK >= 3.2.0
Dart SDK >= 3.2.0
Android Studio / VS Code
```

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/Akshay-NotFound/To-Do-App-.git
cd To-Do-App-
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Generate Hive adapters**
```bash
dart run build_runner build --delete-conflicting-outputs
```

4. **Run the app**
```bash
# Mobile (Android/iOS)
flutter run

# Web (Chrome)
flutter run -d chrome
```

---

## 📱 Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| Android | ✅ Fully Supported | API 21+ |
| iOS | ✅ Fully Supported | iOS 12+ |
| Web | ✅ Supported | ML Kit disabled (mobile-only) |
| Windows | 🟡 Partial | UI works, notifications limited |
| macOS | 🟡 Partial | UI works, notifications limited |
| Linux | 🟡 Partial | UI works, notifications limited |

---

## 🎯 Key Differentiators

| Feature | Todoist | Google Tasks | Microsoft To Do | **ToDo+** |
|---------|---------|--------------|----------------|-----------|
| Weak Area Detection | ❌ | ❌ | ❌ | ✅ AI-powered |
| Smart Rescheduling | ❌ | ❌ | ❌ | ✅ One-click |
| Exam Templates | ❌ | ❌ | ❌ | ✅ 4 exams pre-loaded |
| NLP Date Input | ✅ Basic | ❌ | ❌ | ✅ Enhanced |
| Subject Mastery Tracking | ❌ | ❌ | ❌ | ✅ Confidence scoring |
| Pomodoro Timer | ❌ | ❌ | ❌ | ✅ Ring progress |
| Study Buddy AI | ❌ | ❌ | ❌ | ✅ ML Kit (mobile) |
| Offline-First | ✅ | ✅ | ✅ | ✅ Hive |
| Haptic Feedback | ❌ | ❌ | ❌ | ✅ Throughout |

---

## 📊 Project Stats

- **Lines of Code**: ~3,500+
- **Features Implemented**: 30+
- **Files Created**: 25+
- **Sprints Completed**: 6/6 (100%)
- **Development Time**: 10 weeks (roadmap)

---

## 🗂️ Project Structure

```
lib/
├── core/
│   ├── models/
│   │   └── chat_message.dart          # Platform-agnostic chat model
│   ├── services/
│   │   ├── notification_service.dart   # Local notifications
│   │   ├── smart_reply_service.dart    # Conditional imports (mobile/web)
│   │   └── smart_scheduling_service.dart # AI-powered rescheduling
│   ├── theme/
│   │   └── app_theme.dart              # Outfit + Inter typography
│   └── utils/
│       └── date_parser.dart            # Natural language date parsing
├── data/
│   ├── models/
│   │   ├── task_model.dart             # Extended with AI fields
│   │   ├── subject_mastery.dart        # Confidence tracking model
│   │   └── focus_session.dart          # Pomodoro session data
│   ├── repositories/
│   │   └── task_repository_impl.dart   # Hive implementation
│   └── templates/
│       └── exam_templates.dart         # Pre-built exam syllabi
├── domain/
│   └── repositories/
│       └── task_repository.dart        # Repository interface
└── presentation/
    ├── providers/
    │   ├── task_provider.dart          # Task state management
    │   └── subject_mastery_provider.dart # AI analytics
    ├── home/
    │   └── home_screen.dart            # Dashboard with weak areas
    ├── tasks/
    │   └── add_task_screen.dart        # Task creation with NLP
    ├── focus/
    │   └── pomodoro_timer_screen.dart  # Timer with ring UI
    ├── chat/
    │   └── study_buddy_screen.dart     # ML-powered chat
    ├── onboarding/
    │   └── onboarding_screen.dart      # 3-screen onboarding
    └── widgets/
        ├── ai_widgets.dart             # Weak areas card, reschedule sheet
        └── skeleton_loaders.dart       # Shimmer loading states
```

---

## 🔮 Future Enhancements

- [ ] **OCR Syllabus Scanner**: Photo textbook index → Auto-generate tasks
- [ ] **Voice Input**: "Add physics quiz tomorrow at 10 AM"
- [ ] **Collaborative Study Groups**: Share tasks and compete with peers
- [ ] **Home Screen Widgets**: Android/iOS widget support
- [ ] **Advanced Analytics**: 
  - Study heatmap (GitHub-style)
  - Subject-wise time distribution
  - Weekly/monthly reports
- [ ] **Spaced Repetition**: Automatic revision reminders
- [ ] **Cloud Sync**: Real-time multi-device synchronization
- [ ] **Export Capabilities**: PDF reports, CSV exports

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. **Fork** the repository
2. Create a **feature branch** (`git checkout -b feature/AmazingFeature`)
3. **Commit** your changes (`git commit -m 'Add some AmazingFeature'`)
4. **Push** to the branch (`git push origin feature/AmazingFeature`)
5. Open a **Pull Request**

### Coding Standards
- Follow [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable/function names
- Add comments for complex logic
- Run `flutter analyze` before committing

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Akshay Rathod**

- 📧 Email: [rathod4520@gmail.com](mailto:rathod4520@gmail.com)
- 💬 WhatsApp: [Message on WhatsApp](https://wa.me/message/GSUE3AWAGR4AD1)
- 🐙 GitHub: [@Akshay-NotFound](https://github.com/Akshay-NotFound)
- 🔗 Repository: [To-Do-App-](https://github.com/Akshay-NotFound/To-Do-App-)

---

## 🙏 Acknowledgments

- **Flutter Team** for the amazing cross-platform framework
- **Material Design** for the beautiful design system
- **Google ML Kit** for on-device AI capabilities
- **Riverpod** for elegant state management
- **Hive** for blazing-fast local storage
- Open-source community for inspiration and libraries

---

## 💡 Use Cases

### For Students
- ✅ JEE/NEET aspirants managing 15+ subjects
- ✅ GATE candidates with 3-month crash course
- ✅ UPSC hopefuls with 2-year preparation cycles
- ✅ Any competitive exam with extensive syllabus

### For Developers
- ✅ Learn Clean Architecture in Flutter
- ✅ Understand Riverpod state management
- ✅ Implement ML Kit Smart Reply
- ✅ Build offline-first apps with Hive
- ✅ Create custom UI components (ring progress, shimmer loaders)

---

<div align="center">
  
  ### Made with ❤️ for Competitive Exam Aspirants
  
  ⭐ **Star this repo if you find it helpful!**
  
  🐛 **Found a bug?** [Open an issue](https://github.com/Akshay-NotFound/To-Do-App-/issues)
  
  💡 **Have an idea?** [Start a discussion](https://github.com/Akshay-NotFound/To-Do-App-/discussions)
  
</div>
