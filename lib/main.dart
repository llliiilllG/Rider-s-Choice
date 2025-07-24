import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'view/splash_screen.dart';
import 'view/login_page.dart';
import 'view/signup_page.dart';
import 'presentation/pages/dashboard_page.dart';
import 'presentation/bloc/bike/bike_bloc.dart';
import 'presentation/pages/cart_provider.dart';
import 'core/services/bike_api_service.dart';
import 'core/services/accessory_api_service.dart';
import 'core/services/auth_api_service.dart';
import 'core/services/order_api_service.dart';
import 'presentation/pages/cart_page.dart';

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
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: const MyApp(),
    ),
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
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
        routes: {
          '/login': (context) => LoginPage(),
          '/signup': (context) => SignupPage(),
          '/home': (context) => DashboardPage(),
          '/cart': (context) => CartPage(),
        },
      ),
    );
  }
}