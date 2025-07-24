import 'package:flutter_test/flutter_test.dart';

// Import all test files
import 'unit/bike_entity_test.dart' as bike_entity_test;
import 'unit/bike_data_test.dart' as bike_data_test;
import 'bloc/bike_bloc_test.dart' as bike_bloc_test;
import 'widget/bike_card_test.dart' as bike_card_test;
import 'integration/app_flow_test.dart' as app_flow_test;

void main() {
  group('Rider\'s Choice App Tests', () {
    group('Unit Tests', () {
      bike_entity_test.main();
      bike_data_test.main();
    });

    group('Bloc Tests', () {
      bike_bloc_test.main();
    });

    group('Widget Tests', () {
      bike_card_test.main();
    });

    group('Integration Tests', () {
      app_flow_test.main();
    });
  });
} 