import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riders_choice/presentation/bloc/bike/bike_event.dart';
import 'presentation/bloc/bike/bike_bloc.dart';
import 'presentation/pages/dashboard_page.dart';
import 'view/splash_screen.dart';
import 'view/login_page.dart';
import 'view/signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BikeBloc()..add(GetFeaturedBikesEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'Rider\'s Choice',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6750A4),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          fontFamily: 'Poppins',
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6750A4),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          fontFamily: 'Poppins',
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => LoginPage(),
          '/signup': (context) => SignupPage(),
          '/dashboard': (context) => const DashboardPage(),
        },
      ),
    );
  }
}