# News Blog App - Clean Architecture with MVVM + BLoC + Cubit

A production-ready Flutter news/blog application built using Clean Architecture principles with MVVM pattern, BLoC/Cubit state management, and Repository pattern.

## 🏗️ Architecture Overview

This project follows **Clean Architecture** principles with clear separation of concerns across multiple layers:

### 📁 Project Structure

```
lib/
├── core/                           # Core functionality
│   ├── constants/                   # App constants
│   ├── errors/                      # Error handling
│   ├── network/                     # Network configuration
│   ├── theme/                       # App theming
│   ├── usecase.dart                 # Base use case classes
│   └── di/                          # Dependency injection
├── features/                        # Feature modules
│   ├── auth/                        # Authentication feature
│   │   ├── data/                    # Data layer
│   │   │   ├── datasources/         # Data sources (API, Local)
│   │   │   ├── models/              # Data models
│   │   │   └── repositories/        # Repository implementations
│   │   ├── domain/                  # Domain layer
│   │   │   ├── entities/             # Business entities
│   │   │   ├── repositories/         # Repository interfaces
│   │   │   └── usecases/             # Business logic use cases
│   │   └── presentation/            # Presentation layer
│   │       ├── bloc/                # State management
│   │       ├── pages/                # UI screens
│   │       └── widgets/              # Feature-specific widgets
│   └── news/                        # News feature
│       └── [same structure as auth]
└── shared/                          # Shared components
    ├── widgets/                      # Reusable widgets
    └── utils/                        # Utility functions
```

## 🎯 Architecture Layers

### 1. **Domain Layer** (Business Logic)
- **Entities**: Core business objects
- **Repositories**: Abstract interfaces for data access
- **Use Cases**: Business logic implementation

### 2. **Data Layer** (Data Management)
- **Data Sources**: Remote (API) and Local (Cache) data sources
- **Models**: Data transfer objects with serialization
- **Repository Implementations**: Concrete implementations of domain repositories

### 3. **Presentation Layer** (UI)
- **BLoC/Cubit**: State management
- **Pages**: UI screens
- **Widgets**: Reusable UI components

## 🔧 Key Technologies & Patterns

### State Management
- **BLoC Pattern**: For complex state management
- **Cubit**: For simpler state management
- **flutter_bloc**: BLoC implementation

### Architecture Patterns
- **MVVM**: Model-View-ViewModel pattern
- **Repository Pattern**: Data access abstraction
- **Dependency Injection**: Using GetIt and Injectable
- **Clean Architecture**: Separation of concerns

### Data Management
- **Dio**: HTTP client for API calls
- **Retrofit**: Type-safe REST client
- **Hive**: Local database for caching
- **SharedPreferences**: Simple key-value storage

### Code Generation
- **json_annotation**: JSON serialization
- **freezed**: Immutable data classes
- **injectable**: Dependency injection
- **build_runner**: Code generation

## 🚀 Features

### Authentication
- Email/Password authentication
- Google Sign-In integration
- Apple Sign-In integration
- Password reset functionality
- User profile management

### News Management
- Top headlines
- Category-based news filtering
- Search functionality
- Article bookmarking
- Offline caching
- Infinite scroll pagination

### UI/UX
- Material Design 3
- Dark/Light theme support
- Responsive design
- Loading states
- Error handling
- Empty states

## 📦 Dependencies

### Core Dependencies
```yaml
dependencies:
  flutter_bloc: ^8.1.6          # State management
  get_it: ^7.7.0                 # Dependency injection
  injectable: ^2.4.2             # DI code generation
  dio: ^5.4.3+1                  # HTTP client
  retrofit: ^4.1.0              # REST client
  hive_flutter: ^1.1.0          # Local database
  shared_preferences: ^2.2.2     # Key-value storage
  cached_network_image: ^3.3.1   # Image caching
  equatable: ^2.0.5              # Value equality
  dartz: ^0.10.1                # Functional programming
```

### Development Dependencies
```yaml
dev_dependencies:
  build_runner: ^2.4.9           # Code generation
  injectable_generator: ^2.6.2   # DI generation
  retrofit_generator: ^8.1.0     # REST generation
  json_serializable: ^6.8.0      # JSON generation
  freezed: ^2.5.2                # Data class generation
  hive_generator: ^2.0.1         # Hive generation
```

## 🛠️ Setup & Installation

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Generate Code
```bash
flutter packages pub run build_runner build
```

### 3. Run the App
```bash
flutter run
```

## 🔄 Data Flow

### 1. **User Action** → **Cubit/BLoC**
- User interacts with UI
- Cubit receives the action

### 2. **Cubit/BLoC** → **Use Case**
- Cubit calls appropriate use case
- Use case contains business logic

### 3. **Use Case** → **Repository**
- Use case calls repository interface
- Repository abstracts data source

### 4. **Repository** → **Data Source**
- Repository implementation calls data source
- Can be remote (API) or local (cache)

### 5. **Data Source** → **Repository** → **Use Case** → **Cubit** → **UI**
- Data flows back through the layers
- UI updates based on new state

## 🧪 Testing Strategy

### Unit Tests
- Use cases testing
- Repository testing
- Cubit/BLoC testing

### Widget Tests
- UI component testing
- Integration testing

### Integration Tests
- End-to-end testing
- API integration testing

## 📱 Production Considerations

### Performance
- Image caching with `cached_network_image`
- Local data caching with Hive
- Efficient state management with BLoC
- Lazy loading and pagination

### Error Handling
- Comprehensive error types
- User-friendly error messages
- Offline support with cached data
- Network error handling

### Scalability
- Modular feature structure
- Dependency injection for testability
- Clean separation of concerns
- Easy to add new features

### Security
- Secure API key management
- Input validation
- Secure local storage
- Authentication token management

## 🔧 Configuration

### API Configuration
Update `lib/core/constants/app_constants.dart`:
```dart
static const String baseUrl = 'https://your-api.com';
static const String apiKey = 'YOUR_API_KEY';
```

### Theme Customization
Modify `lib/core/theme/app_theme.dart` for custom themes.

## 📈 Future Enhancements

- [ ] Push notifications
- [ ] Offline reading mode
- [ ] Social sharing
- [ ] User preferences
- [ ] Analytics integration
- [ ] Performance monitoring
- [ ] Automated testing
- [ ] CI/CD pipeline

## 🤝 Contributing

1. Follow Clean Architecture principles
2. Write comprehensive tests
3. Use proper error handling
4. Follow Flutter/Dart conventions
5. Document your code

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Built with ❤️ using Flutter and Clean Architecture principles**
