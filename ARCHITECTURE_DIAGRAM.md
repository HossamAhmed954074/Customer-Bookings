# 📊 Home Screen Architecture Diagram

## Component Hierarchy

```
HomeScreen (StatefulWidget)
│
├─── SafeArea
│    └─── BlocConsumer<HomeCubit, HomeState>
│         └─── Column
│              │
│              ├─── Header
│              │    ├── Time Display (Icon + Text)
│              │    └── Calendar Button
│              │
│              ├─── Google Maps Section (250px)
│              │    ├── GoogleMap Widget
│              │    ├── Markers (Set<Marker>)
│              │    └── Loading Overlay
│              │
│              ├─── Category Filters (60px)
│              │    ├── ListView.builder (Horizontal)
│              │    │    └── CategoryFilterChip × 5
│              │    │         ├── All
│              │    │         ├── Yoga
│              │    │         ├── Pilates
│              │    │         ├── HIIT
│              │    │         └── Dance
│              │    └── FilterButton
│              │
│              └─── Sessions List (Expanded)
│                   └── ListView.builder (Vertical)
│                        └── SessionCard × N
│                             ├── Background Image
│                             ├── Gradient Overlay
│                             ├── Session Info
│                             │    ├── Name
│                             │    ├── Instructor
│                             │    ├── Time (Icon + Text)
│                             │    ├── Date (Icon + Text)
│                             │    └── Availability Badge
│                             └── GestureDetector (onTap)
```

## Data Flow

```
┌──────────────────────────────────────────────────────────────────┐
│                          USER INTERACTION                         │
└──────────────────────────────────────────────────────────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────┐
│                         PRESENTATION LAYER                        │
│                                                                   │
│  HomeScreen (UI) ──► HomeCubit (State Management)                │
│       │                    │                                      │
│       │                    ├─ loadSessions()                      │
│       │                    ├─ selectCategory()                    │
│       │                    └─ refreshSessions()                   │
│       │                                                           │
│       └─ Widgets:                                                 │
│          ├─ CategoryFilterChip                                    │
│          ├─ SessionCard                                           │
│          └─ FilterButton                                          │
└──────────────────────────────────────────────────────────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────┐
│                          DOMAIN LAYER                             │
│                     (Business Logic)                              │
│                                                                   │
│  GetSessionsUseCase ──► SessionRepository (Interface)            │
│       │                       │                                   │
│       │                       ├─ getSessions()                    │
│       │                       └─ getSessionDetail()               │
│       │                                                           │
│       └─ Entity: Session                                          │
│            ├─ id, businessId                                      │
│            ├─ name, instructor                                    │
│            ├─ date, time                                          │
│            ├─ capacity, booked                                    │
│            └─ latitude, longitude                                 │
└──────────────────────────────────────────────────────────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────┐
│                           DATA LAYER                              │
│                                                                   │
│  SessionRepositoryImpl ──► SessionRemoteDataSource               │
│       │                            │                              │
│       │                            ├─ getSessions()               │
│       │                            └─ getSessionDetail()          │
│       │                                                           │
│       └─ Model: SessionModel                                      │
│            ├─ fromJson()                                          │
│            ├─ toJson()                                            │
│            └─ toEntity()                                          │
└──────────────────────────────────────────────────────────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────┐
│                          API CONSUMER                             │
│                                                                   │
│  DioConsumer ──► HTTP Request                                    │
│       │                                                           │
│       └─ GET /api/v1/sessions                                     │
│            ├─ Query: businessId                                   │
│            ├─ Query: dateFrom                                     │
│            └─ Query: dateTo                                       │
└──────────────────────────────────────────────────────────────────┘
                                 │
                                 ▼
┌──────────────────────────────────────────────────────────────────┐
│                       BACKEND API SERVER                          │
│                                                                   │
│  https://booking-classes-api.onrender.com/api/v1                 │
└──────────────────────────────────────────────────────────────────┘
```

## State Management Flow

```
┌─────────────┐
│   Initial   │ ──► Screen loads
└─────────────┘
       │
       ▼
┌─────────────┐
│   Loading   │ ──► Fetching from API (shows spinner)
└─────────────┘
       │
       ├──► Success ──┐
       │              │
       └──► Error ────┤
                      ▼
              ┌───────────────┐
              │ Update State  │
              └───────────────┘
                      │
                      ▼
              ┌───────────────┐
              │   UI Reacts   │ ──► Display sessions or error
              └───────────────┘
```

## State Properties

```dart
HomeState {
  status: HomeStatus           // initial, loading, success, error
  sessions: List<Session>      // All sessions from API
  filteredSessions: []         // Filtered by category
  selectedCategory: String?    // Current filter
  errorMessage: String?        // Error text
  selectedDateFrom: DateTime?  // Filter date range
  selectedDateTo: DateTime?    // Filter date range
}
```

## Dependency Injection

```
HomeInjection.init()
     │
     ├─► DioConsumer (API Client)
     │      │
     │      └─► Dio instance
     │
     ├─► SessionRemoteDataSource
     │      │
     │      └─► Uses: DioConsumer
     │
     ├─► SessionRepositoryImpl
     │      │
     │      └─► Uses: SessionRemoteDataSource
     │
     └─► GetSessionsUseCase
            │
            └─► Uses: SessionRepository

HomeInjection.getHomeCubit()
     │
     └─► HomeCubit
            │
            └─► Uses: GetSessionsUseCase
```

## File Dependencies Map

```
home_screen.dart
  ├── Imports: home_cubit.dart
  ├── Imports: home_state.dart
  ├── Imports: session.dart (entity)
  ├── Imports: category_filter_chip.dart
  ├── Imports: session_card.dart
  └── Imports: filter_button.dart

home_cubit.dart
  ├── Imports: home_state.dart
  ├── Imports: session.dart (entity)
  └── Imports: get_sessions_usecase.dart

get_sessions_usecase.dart
  ├── Imports: session.dart (entity)
  └── Imports: session_repository.dart

session_repository_impl.dart
  ├── Imports: session_repository.dart
  ├── Imports: session.dart (entity)
  └── Imports: session_remote_data_source.dart

session_remote_data_source.dart
  ├── Imports: session_model.dart
  ├── Imports: api_consumer.dart
  └── Imports: end_points.dart

session_model.dart
  └── Imports: session.dart (entity)
```

## Widget Tree (Simplified)

```
MaterialApp
 └─ GoRouter
     └─ BlocProvider<HomeCubit>
         └─ HomeScreen
             └─ Scaffold
                 └─ SafeArea
                     └─ BlocConsumer
                         └─ Column
                             ├─ Header (Time + Calendar)
                             ├─ GoogleMap Container
                             ├─ Category Filters Row
                             └─ Sessions ListView
                                 └─ SessionCard (×N)
```

## API Request/Response Flow

```
User scrolls ──► HomeCubit.loadSessions()
                      │
                      ▼
              GetSessionsUseCase.call()
                      │
                      ▼
              SessionRepository.getSessions()
                      │
                      ▼
              SessionRepositoryImpl.getSessions()
                      │
                      ▼
              SessionRemoteDataSource.getSessions()
                      │
                      ▼
              DioConsumer.get()
                      │
                      ▼
              HTTP GET /api/v1/sessions?dateFrom=...&dateTo=...
                      │
                      ▼
              API Response (JSON)
                      │
                      ▼
              SessionModel.fromJson() × N
                      │
                      ▼
              List<SessionModel>.toEntity()
                      │
                      ▼
              Either<String, List<Session>>
                      │
                      ▼
              HomeCubit updates state
                      │
                      ▼
              UI rebuilds with sessions
```

## Key Design Patterns Used

1. **Clean Architecture** - Separation of concerns
2. **Repository Pattern** - Abstract data access
3. **Use Case Pattern** - Single responsibility
4. **BLoC Pattern** - State management
5. **Dependency Injection** - Loose coupling
6. **Factory Pattern** - Object creation (fromJson)
7. **Builder Pattern** - UI construction (ListView.builder)

---

This diagram shows the complete architecture and data flow of the Home Screen implementation.
