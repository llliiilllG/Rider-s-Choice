# 🏍️ Rider's Choice - Professional E-commerce Bike Showroom

A cutting-edge Flutter application with advanced features, clean architecture, and professional UI design for motorcycle enthusiasts.

## 🚀 Features

### 🏗️ **Architecture & Design**
- **Clean Architecture** with clear separation of concerns
- **MVVM Pattern** with reactive state management
- **Dependency Injection** using GetIt and Injectable
- **Repository Pattern** for data access abstraction
- **Use Case Pattern** for business logic encapsulation

### 📱 **Advanced Features**
- **Sensor Integration**: Accelerometer, gyroscope, and GPS tracking
- **Real-time Communication**: WebSocket support for live updates
- **Payment Processing**: Stripe integration for secure transactions
- **Connectivity Monitoring**: Network status and quality detection
- **Offline Support**: Local data persistence with Hive
- **Multi-platform**: iOS, Android, and macOS support

### 🎨 **UI/UX Excellence**
- **Material 3 Design** with custom green theme
- **Smooth Animations** and micro-interactions
- **Responsive Layout** for all screen sizes
- **Professional Components** with consistent styling
- **Dark/Light Theme** support

### 🔧 **Technical Stack**

#### Frontend (Flutter)
- **State Management**: Provider + ChangeNotifier
- **Network**: Dio with interceptors
- **Storage**: Hive for local persistence
- **Dependency Injection**: GetIt + Injectable
- **Testing**: Unit, widget, and integration tests
- **Code Generation**: Build Runner for DI and JSON serialization

#### Backend (Node.js/Express)
- **Architecture**: Clean Architecture with services and repositories
- **Database**: MongoDB with Mongoose ODM
- **Authentication**: JWT with middleware
- **Real-time**: WebSocket with Socket.io
- **Payments**: Stripe integration
- **Testing**: Jest for unit and integration tests

## 📁 Project Structure

```
Rider-s-Choice/
├── lib/
│   ├── core/                    # Core functionality
│   │   ├── di/                 # Dependency injection
│   │   ├── network/            # API client and interceptors
│   │   ├── storage/            # Local storage implementations
│   │   ├── services/           # Core services (sensors, WebSocket, etc.)
│   │   ├── theme/              # App theme and styling
│   │   └── utils/              # Utility functions
│   ├── features/               # Feature-based modules
│   │   ├── auth/               # Authentication feature
│   │   │   ├── data/           # Data layer
│   │   │   ├── domain/         # Domain layer
│   │   │   └── presentation/   # Presentation layer
│   │   └── bikes/              # Bikes feature
│   │       ├── data/           # Data layer
│   │       ├── domain/         # Domain layer
│   │       └── presentation/   # Presentation layer
│   └── main.dart               # App entry point
├── backend/                    # Node.js backend
│   ├── src/
│   │   ├── controllers/        # HTTP controllers
│   │   ├── services/           # Business logic services
│   │   ├── repositories/       # Data access repositories
│   │   ├── models/             # Database models
│   │   ├── routes/             # API routes
│   │   └── middleware/         # Custom middleware
│   └── server.js               # Server entry point
└── test/                       # Comprehensive test suite
```

## 🛠️ Setup Instructions

### Prerequisites
- Flutter SDK (3.0+)
- Node.js (16+)
- MongoDB
- Stripe account (for payments)

### Frontend Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd Rider-s-Choice
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   # For macOS
   flutter run -d macos
   
   # For iOS
   flutter run -d ios
   
   # For Android
   flutter run -d android
   ```

### Backend Setup

1. **Navigate to backend directory**
   ```bash
   cd backend
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Environment configuration**
   ```bash
   cp env.example .env
   # Edit .env with your configuration
   ```

4. **Start the server**
   ```bash
   npm start
   ```

## 🔧 Advanced Features Implementation

### Sensor Integration
The app integrates device sensors for enhanced user experience:

```dart
// Sensor service usage
final sensorService = getIt<SensorService>();
await sensorService.startMonitoring();

// Listen to sensor data
sensorService.sensorDataStream.listen((data) {
  // Handle sensor updates
});
```

### Real-time Communication
WebSocket integration for live updates:

```dart
// WebSocket service usage
final webSocketService = getIt<WebSocketService>();
await webSocketService.connect();

// Send real-time events
webSocketService.sendBikeView(bikeId);
webSocketService.sendAddToCart(bikeId, quantity);
```

### Payment Processing
Secure payment handling with Stripe:

```dart
// Payment service usage
final paymentService = getIt<PaymentService>();

// Create payment intent
final intent = await paymentService.createPaymentIntent(
  amount: 24999.0,
  currency: 'usd',
  bikeId: bikeId,
  quantity: 1,
);
```

### Connectivity Monitoring
Network status and quality detection:

```dart
// Connectivity service usage
final connectivityService = getIt<ConnectivityService>();

// Check connection status
if (connectivityService.isConnected) {
  // Perform online operations
}

// Monitor connection quality
connectivityService.connectionQuality; // excellent, good, fair, poor
```

## 🧪 Testing

### Frontend Tests
```bash
# Unit tests
flutter test test/unit/

# Widget tests
flutter test test/widget/

# Integration tests
flutter test test/integration/
```

### Backend Tests
```bash
cd backend
npm test
```

## 📱 Screenshots

### Home Page
- Featured bikes carousel
- Category grid
- Professional green theme
- Smooth animations

### Bike Details
- Comprehensive specifications
- Real-time sensor data
- Connectivity status
- Payment integration
- Reviews and ratings

### Advanced Features
- Sensor integration display
- WebSocket real-time updates
- Payment processing
- Network monitoring

## 🚀 Deployment

### Frontend Deployment
```bash
# Build for production
flutter build macos --release
flutter build ios --release
flutter build apk --release
```

### Backend Deployment
```bash
# Production build
npm run build
npm start
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation

## 🔮 Future Enhancements

- **AR/VR Integration**: Virtual bike showroom
- **AI Recommendations**: Smart bike suggestions
- **Social Features**: User reviews and ratings
- **Advanced Analytics**: User behavior tracking
- **Multi-language Support**: Internationalization
- **Push Notifications**: Real-time alerts
- **Advanced Search**: Filter and search capabilities

---

**Built with ❤️ using Flutter and Node.js**
