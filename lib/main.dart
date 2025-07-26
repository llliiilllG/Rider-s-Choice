import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'core/di/injection.dart';
import 'core/theme/modern_app_theme.dart';
import 'features/bikes/presentation/pages/splash_screen.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/signup_page.dart';
import 'features/bikes/presentation/pages/home_page.dart';
import 'features/cart/presentation/pages/cart_page.dart';
import 'features/orders/presentation/pages/orders_page.dart';
import 'presentation/bloc/bike/bike_bloc.dart';
import 'core/services/bike_api_service.dart';
import 'core/services/accessory_api_service.dart';
import 'core/services/auth_api_service.dart';
import 'core/services/order_api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure dependencies
  await configureDependencies();
  
  // Register additional services that might not be in injection.dart
  if (!GetIt.instance.isRegistered<BikeApiService>()) {
    GetIt.instance.registerLazySingleton(() => BikeApiService());
  }
  if (!GetIt.instance.isRegistered<AccessoryApiService>()) {
    GetIt.instance.registerLazySingleton(() => AccessoryApiService());
  }
  if (!GetIt.instance.isRegistered<AuthApiService>()) {
    GetIt.instance.registerLazySingleton(() => AuthApiService());
  }
  if (!GetIt.instance.isRegistered<OrderApiService>()) {
    GetIt.instance.registerLazySingleton(() => OrderApiService());
  }

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BikeBloc>(
          create: (context) => GetIt.instance<BikeBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Rider\'s Choice',
        debugShowCheckedModeBanner: false,
        theme: ModernAppTheme.lightTheme,
        darkTheme: ModernAppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
        routes: {
          '/login': (context) => LoginPage(),
          '/signup': (context) => SignupPage(),
          '/home': (context) => HomePage(),
          '/cart': (context) => CartPage(),
          '/orders': (context) => OrdersPage(),
        },
      ),
    );
  }
}