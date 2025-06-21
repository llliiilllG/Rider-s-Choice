# Rider's Choice - Motorcycle Marketplace

A Flutter-based motorcycle marketplace application with a modern UI and offline functionality.

## Features

### 🏍️ **Motorcycles**
- Browse featured motorcycles
- View detailed specifications
- Product details with reviews
- Category-based filtering

### 🛡️ **Accessories**
- Motorcycle accessories (helmets, gloves, jackets, boots)
- Product details and pricing
- Stock availability
- Add to cart functionality

### 🎨 **UI/UX**
- Modern Material Design 3
- Responsive design for mobile and web
- Smooth navigation between pages
- Beautiful product cards and details

## Project Structure

```
Rider-s-Choice/
├── lib/
│   ├── data/
│   │   ├── bike_data.dart          # Hardcoded bike and accessory data
│   │   └── models/
│   │       └── bike_model.dart     # Bike model class
│   ├── domain/
│   │   └── entities/
│   │       └── bike.dart           # Bike entity definitions
│   ├── presentation/
│   │   ├── bloc/
│   │   │   └── bike/
│   │   │       ├── bike_bloc.dart  # State management
│   │   │       ├── bike_event.dart # Events
│   │   │       └── bike_state.dart # States
│   │   ├── pages/
│   │   │   ├── dashboard_page.dart # Main dashboard
│   │   │   ├── home_page.dart      # Motorcycle listing
│   │   │   ├── accessories_page.dart # Accessories listing
│   │   │   └── product_details_page.dart # Product details
│   │   └── widgets/
│   │       └── bike_card.dart      # Bike card widget
│   └── main.dart                   # App entry point
├── assets/
│   ├── motorcycles/                # Motorcycle images
│   ├── accessories/                # Accessory images
│   └── logo/                       # App logos
└── README.md
```

## Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK
- Android Studio / VS Code

## Installation & Setup

### 1. Clone the Repository
```bash
git clone <repository-url>
cd Rider-s-Choice
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Run the Application
```bash
flutter run
```

## Available Motorcycles

The app includes the following motorcycles with detailed specifications:

- **Ducati Panigale V4** - $24,999
- **BMW S1000RR** - $18,995
- **Yamaha YZF-R1** - $17,999
- **Kawasaki Ninja H2** - $29,999

## Available Accessories

- **AGV Pista GP RR Helmet** - $899
- **Alpinestars GP Pro Gloves** - $299
- **Dainese Super Speed Jacket** - $1,299
- **Sidi Mag-1 Racing Boots** - $499

## App Navigation

1. **Dashboard** - Main menu with quick actions
2. **Browse Motorcycles** - View all available motorcycles
3. **Accessories** - Browse motorcycle accessories
4. **Product Details** - Detailed view with specifications and reviews

## Technologies Used

### Frontend
- **Flutter 3.x** - Cross-platform framework
- **Dart** - Programming language
- **flutter_bloc** - State management
- **google_fonts** - Typography
- **equatable** - Value equality

## Development

### Running the App
```bash
flutter run              # Run on connected device/emulator
flutter run -d chrome    # Run on web
```

### Building for Production
```bash
flutter build web        # Web build
flutter build apk        # Android APK
flutter build ios        # iOS build
```

## Features Implemented

### ✅ **Completed**
- Dashboard with navigation
- Motorcycle browsing and details
- Accessories browsing and details
- Product specifications
- Reviews and ratings
- Stock management
- Add to cart functionality
- Responsive design
- Material Design 3 theming

### 🚧 **Planned Features**
- User authentication
- Shopping cart persistence
- Wishlist functionality
- Order management
- Payment integration
- User profiles
- Search and filtering

## Screenshots

The app includes:
- **Dashboard** - Main menu with action cards
- **Motorcycle List** - Grid/list view of motorcycles
- **Product Details** - Detailed specifications and reviews
- **Accessories** - Accessory products with details
- **Responsive Design** - Works on mobile and web

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

For support and questions, please open an issue on GitHub or contact the development team.
