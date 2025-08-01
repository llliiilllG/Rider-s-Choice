import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../storage/local_storage.dart';
import '../storage/local_storage_impl.dart';
import '../network/api_client.dart';
import '../services/bike_api_service.dart';
import '../services/accessory_api_service.dart';
import '../services/auth_api_service.dart';
import '../services/order_api_service.dart';
import '../services/sensor_service.dart';
import '../services/websocket_service.dart';
import '../services/payment_service.dart';
import '../services/connectivity_service.dart';
import '../../presentation/bloc/bike/bike_bloc.dart';
import '../../features/bikes/presentation/viewmodels/bikes_viewmodel.dart';
import '../../features/bikes/domain/usecases/get_bikes_usecase.dart';
import '../../features/bikes/domain/usecases/get_featured_bikes_usecase.dart';
import '../../features/bikes/domain/repositories/bike_repository.dart';
import '../../features/bikes/data/repositories/bike_repository_impl.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register core services
  getIt.registerSingleton<Dio>(Dio());
  getIt.registerSingleton<LocalStorage>(LocalStorageImpl());
  
  // Initialize Hive storage
  final localStorage = getIt<LocalStorage>() as LocalStorageImpl;
  await localStorage.init();
  
  // Register ApiClient
  getIt.registerLazySingleton<ApiClient>(() => ApiClient(getIt<LocalStorage>()));
  
  // Register API services
  getIt.registerLazySingleton<BikeApiService>(() => BikeApiService());
  getIt.registerLazySingleton<AccessoryApiService>(() => AccessoryApiService());
  getIt.registerLazySingleton<AuthApiService>(() => AuthApiService());
  getIt.registerLazySingleton<OrderApiService>(() => OrderApiService());
  
  // Register other services
  getIt.registerLazySingleton<SensorService>(() => SensorService());
  getIt.registerLazySingleton<WebSocketService>(() => WebSocketService(getIt<LocalStorage>()));
  getIt.registerLazySingleton<PaymentService>(() => PaymentService());
  getIt.registerLazySingleton<ConnectivityService>(() => ConnectivityService());

  // Register use cases
  getIt.registerLazySingleton<GetBikesUseCase>(() => GetBikesUseCase(getIt<BikeRepository>()));
  getIt.registerLazySingleton<GetFeaturedBikesUseCase>(() => GetFeaturedBikesUseCase(getIt<BikeRepository>()));

  // Register BikesViewModel
  getIt.registerFactory<BikesViewModel>(() => BikesViewModel(getIt<GetBikesUseCase>(), getIt<GetFeaturedBikesUseCase>()));

  // Register BikeBloc
  getIt.registerFactory<BikeBloc>(() => BikeBloc(apiService: getIt<BikeApiService>()));

  // Register BikeRepository
  getIt.registerLazySingleton<BikeRepository>(() => BikeRepositoryImpl(getIt<BikeApiService>()));
}

// Service locator pattern for easy access
class ServiceLocator {
  static T get<T extends Object>() => getIt<T>();
  
  static Future<T> getAsync<T extends Object>() => getIt.getAsync<T>();
  
  static bool isRegistered<T extends Object>() => getIt.isRegistered<T>();
} 