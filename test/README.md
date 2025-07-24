# Rider's Choice App Tests

This directory contains comprehensive tests for the Rider's Choice motorcycle marketplace app.

## Test Structure

```
test/
├── unit/                    # Unit tests for domain entities and data layer
│   ├── bike_entity_test.dart
│   └── bike_data_test.dart
├── bloc/                    # Bloc tests for state management
│   └── bike_bloc_test.dart
├── widget/                  # Widget tests for UI components
│   └── bike_card_test.dart
├── integration/             # Integration tests for app flow
│   └── app_flow_test.dart
├── helpers/                 # Test helper utilities
│   └── test_helpers.dart
├── test_config.dart         # Test configuration
├── run_tests.dart          # Test runner script
└── README.md               # This file
```

## Test Categories

### 1. Unit Tests (`test/unit/`)
- **Purpose**: Test individual functions, classes, and methods in isolation
- **Coverage**: Domain entities, data models, utility functions
- **Examples**: 
  - Bike entity creation and equality
  - BikeData static methods
  - Review entity validation

### 2. Bloc Tests (`test/bloc/`)
- **Purpose**: Test state management and business logic
- **Coverage**: Bloc events, states, and state transitions
- **Examples**:
  - BikeBloc state changes
  - Event handling
  - Error state management

### 3. Widget Tests (`test/widget/`)
- **Purpose**: Test UI components and user interactions
- **Coverage**: Widget rendering, user interactions, navigation
- **Examples**:
  - BikeCard widget display
  - Button interactions
  - Text rendering

### 4. Integration Tests (`test/integration/`)
- **Purpose**: Test complete app flows and user journeys
- **Coverage**: End-to-end scenarios, app navigation, data flow
- **Examples**:
  - App startup flow
  - Bloc integration with UI
  - Navigation between screens

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test Categories
```bash
# Unit tests only
flutter test test/unit/

# Bloc tests only
flutter test test/bloc/

# Widget tests only
flutter test test/widget/

# Integration tests only
flutter test test/integration/
```

### Run Individual Test Files
```bash
flutter test test/unit/bike_entity_test.dart
flutter test test/bloc/bike_bloc_test.dart
flutter test test/widget/bike_card_test.dart
```

### Run Tests with Coverage
```bash
flutter test --coverage
```

### Run Tests with Verbose Output
```bash
flutter test --verbose
```

## Test Dependencies

The following dependencies are required for testing:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: ^9.1.5
  mockito: ^5.4.4
  build_runner: ^2.4.8
```

## Test Helpers

The `test/helpers/test_helpers.dart` file provides common utilities:

- `TestHelpers.createTestBike()` - Create test bike instances
- `TestHelpers.createTestBikes()` - Create multiple test bikes
- `TestHelpers.createTestReview()` - Create test review instances
- `TestHelpers.createTestApp()` - Create test app wrapper
- `TestHelpers.pumpWidgetWithDelay()` - Pump widget with delay
- `TestHelpers.tapAndWait()` - Tap and wait for animations
- `TestHelpers.expectTextPresent()` - Check if text is present

## Writing New Tests

### Unit Test Example
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:riders_choice/domain/entities/bike.dart';

void main() {
  group('Bike Entity', () {
    test('should create bike with all properties', () {
      final bike = Bike(/* properties */);
      expect(bike.name, 'Test Bike');
    });
  });
}
```

### Bloc Test Example
```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:riders_choice/presentation/bloc/bike/bike_bloc.dart';

void main() {
  blocTest<BikeBloc, BikeState>(
    'emits [BikeLoading, BikeLoaded] when GetFeaturedBikesEvent is added',
    build: () => BikeBloc(),
    act: (bloc) => bloc.add(GetFeaturedBikesEvent()),
    expect: () => [isA<BikeLoading>(), isA<BikeLoaded>()],
  );
}
```

### Widget Test Example
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:riders_choice/presentation/widgets/bike_card.dart';

void main() {
  testWidgets('should display bike information', (WidgetTester tester) async {
    await tester.pumpWidget(BikeCard(bike: testBike));
    expect(find.text('Bike Name'), findsOneWidget);
  });
}
```

## Best Practices

1. **Test Naming**: Use descriptive test names that explain the expected behavior
2. **Test Organization**: Group related tests using `group()`
3. **Test Isolation**: Each test should be independent and not rely on other tests
4. **Mocking**: Use mocks for external dependencies
5. **Coverage**: Aim for high test coverage, especially for critical business logic
6. **Performance**: Keep tests fast and efficient
7. **Maintenance**: Update tests when code changes

## Continuous Integration

Tests are automatically run in CI/CD pipelines to ensure code quality and prevent regressions.

## Troubleshooting

### Common Issues

1. **Test fails with "No such file or directory"**
   - Ensure all assets referenced in tests exist
   - Check file paths are correct

2. **Bloc tests fail with state timing issues**
   - Use `await tester.pump()` to wait for state changes
   - Add appropriate delays for async operations

3. **Widget tests fail with navigation**
   - Mock navigation or use `NavigatorObserver` for testing
   - Use `tester.pumpAndSettle()` for navigation animations

4. **Tests timeout**
   - Increase timeout duration for complex operations
   - Use `TestConfig.defaultTimeout` for consistent timeouts

For more information, see the [Flutter Testing Documentation](https://docs.flutter.dev/testing). 