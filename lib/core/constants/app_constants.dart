class AppConstants {
  // API Configuration
  static const String baseUrl = 'http://localhost:5000/api';
  static const String wsUrl = 'ws://localhost:5000';
  
  // API Endpoints
  static const String authEndpoint = '/auth';
  static const String bikesEndpoint = '/bikes';
  static const String ordersEndpoint = '/orders';
  static const String usersEndpoint = '/users';
  static const String sensorsEndpoint = '/sensors';
  static const String paymentsEndpoint = '/payments';
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'app_theme';
  static const String languageKey = 'app_language';
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);
  
  // Sensor Configuration
  static const int sensorUpdateInterval = 100; // milliseconds
  static const double locationAccuracy = 10.0; // meters
  
  // Pagination
  static const int defaultPageSize = 10;
  static const int maxPageSize = 50;
  
  // Cache Configuration
  static const Duration cacheDuration = Duration(hours: 1);
  static const int maxCacheSize = 100;
  
  // Error Messages
  static const String networkError = 'Network connection error';
  static const String serverError = 'Server error occurred';
  static const String unknownError = 'An unknown error occurred';
  static const String invalidCredentials = 'Invalid email or password';
  static const String emailAlreadyExists = 'Email already exists';
  
  // Success Messages
  static const String loginSuccess = 'Login successful';
  static const String registrationSuccess = 'Registration successful';
  static const String orderPlacedSuccess = 'Order placed successfully';
  static const String profileUpdatedSuccess = 'Profile updated successfully';
  
  // Validation Messages
  static const String emailRequired = 'Email is required';
  static const String passwordRequired = 'Password is required';
  static const String nameRequired = 'Name is required';
  static const String invalidEmail = 'Please enter a valid email';
  static const String passwordTooShort = 'Password must be at least 6 characters';
  
  // Bike Categories
  static const List<String> bikeCategories = [
    'Sport',
    'Cruiser',
    'Adventure',
    'Naked',
    'Touring'
  ];
  
  // Order Status
  static const List<String> orderStatuses = [
    'pending',
    'processing',
    'shipped',
    'delivered',
    'cancelled'
  ];
  
  // Payment Methods
  static const List<String> paymentMethods = [
    'credit_card',
    'debit_card',
    'paypal'
  ];
} 