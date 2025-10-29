# News Blog App Architecture Diagram

## Clean Architecture Layers

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐          │
│  │   Pages     │  │   Widgets   │  │ BLoC/Cubit  │          │
│  │             │  │             │  │             │          │
│  │ • Login     │  │ • Cards     │  │ • AuthCubit │          │
│  │ • News      │  │ • Lists     │  │ • NewsCubit │          │
│  │ • Profile   │  │ • Buttons   │  │             │          │
│  └─────────────┘  └─────────────┘  └─────────────┘          │
└─────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                      DOMAIN LAYER                            │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐          │
│  │  Entities   │  │ Repositories │  │  Use Cases  │          │
│  │             │  │             │  │             │          │
│  │ • User      │  │ • AuthRepo  │  │ • SignIn    │          │
│  │ • News      │  │ • NewsRepo  │  │ • GetNews   │          │
│  │ • Category  │  │             │  │ • Bookmark  │          │
│  └─────────────┘  └─────────────┘  └─────────────┘          │
└─────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                       DATA LAYER                             │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐          │
│  │    Models   │  │ Data Sources │  │Repositories │          │
│  │             │  │             │  │             │          │
│  │ • UserModel │  │ • Remote     │  │ • AuthRepo  │          │
│  │ • NewsModel │  │ • Local      │  │ • NewsRepo  │          │
│  │             │  │ • Cache      │  │             │          │
│  └─────────────┘  └─────────────┘  └─────────────┘          │
└─────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                    EXTERNAL LAYER                            │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐          │
│  │     API     │  │   Storage   │  │   Network   │          │
│  │             │  │             │  │             │          │
│  │ • News API  │  │ • Hive      │  │ • Dio       │          │
│  │ • Auth API  │  │ • SharedPref│  │ • Retrofit  │          │
│  │             │  │             │  │             │          │
│  └─────────────┘  └─────────────┘  └─────────────┘          │
└─────────────────────────────────────────────────────────────┘
```

## Data Flow

```
User Action → Cubit → Use Case → Repository → Data Source
     ↑                                              │
     └────────── UI Update ← State ←───────────────┘
```

## Feature Structure

```
features/
├── auth/
│   ├── data/
│   │   ├── datasources/
│   │   │   ├── auth_remote_data_source.dart
│   │   │   └── auth_local_data_source.dart
│   │   ├── models/
│   │   │   └── user_model.dart
│   │   └── repositories/
│   │       └── auth_repository_impl.dart
│   ├── domain/
│   │   ├── entities/
│   │   │   └── user.dart
│   │   ├── repositories/
│   │   │   └── auth_repository.dart
│   │   └── usecases/
│   │       └── sign_in_with_email_and_password.dart
│   └── presentation/
│       ├── bloc/
│       │   └── auth_cubit.dart
│       ├── pages/
│       │   └── login_screen.dart
│       └── widgets/
│           └── auth_widgets.dart
└── news/
    └── [same structure as auth]
```

## Dependency Injection Flow

```
main.dart
    │
    ▼
configureDependencies()
    │
    ├── Data Sources
    ├── Repositories
    ├── Use Cases
    └── BLoC/Cubit
```

## State Management Flow

```
UI Widget
    │
    ▼
Cubit/BLoC
    │
    ├── Loading State
    ├── Success State
    └── Error State
    │
    ▼
UI Update
```

## Error Handling Flow

```
Exception
    │
    ▼
Failure (Domain)
    │
    ▼
Error State (Presentation)
    │
    ▼
Error Widget (UI)
```
