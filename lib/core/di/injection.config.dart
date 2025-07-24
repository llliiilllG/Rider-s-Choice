// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:riders_choice/core/network/api_client.dart' as _i549;
import 'package:riders_choice/core/services/connectivity_service.dart' as _i890;
import 'package:riders_choice/core/services/payment_service.dart' as _i647;
import 'package:riders_choice/core/services/sensor_service.dart' as _i485;
import 'package:riders_choice/core/services/websocket_service.dart' as _i879;
import 'package:riders_choice/core/storage/local_storage.dart' as _i176;
import 'package:riders_choice/core/storage/local_storage_impl.dart' as _i962;
import 'package:riders_choice/features/auth/data/repositories/auth_repository_impl.dart'
    as _i503;
import 'package:riders_choice/features/auth/domain/repositories/auth_repository.dart'
    as _i695;
import 'package:riders_choice/features/auth/domain/usecases/login_usecase.dart'
    as _i771;
import 'package:riders_choice/features/auth/domain/usecases/register_usecase.dart'
    as _i872;
import 'package:riders_choice/features/bikes/data/repositories/bike_repository_impl.dart'
    as _i795;
import 'package:riders_choice/features/bikes/domain/repositories/bike_repository.dart'
    as _i818;
import 'package:riders_choice/features/bikes/domain/usecases/get_bikes_usecase.dart'
    as _i290;
import 'package:riders_choice/features/bikes/domain/usecases/get_featured_bikes_usecase.dart'
    as _i86;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i485.SensorService>(() => _i485.SensorService());
    gh.factory<_i890.ConnectivityService>(() => _i890.ConnectivityService());
    gh.factory<_i818.BikeRepository>(() => _i795.BikeRepositoryImpl());
    gh.factory<_i176.LocalStorage>(() => _i962.LocalStorageImpl());
    gh.factory<_i549.ApiClient>(
        () => _i549.ApiClient(gh<_i176.LocalStorage>()));
    gh.factory<_i879.WebSocketService>(
        () => _i879.WebSocketService(gh<_i176.LocalStorage>()));
    gh.factory<_i647.PaymentService>(() => _i647.PaymentService(
          gh<_i549.ApiClient>(),
          gh<_i176.LocalStorage>(),
        ));
    gh.factory<_i695.AuthRepository>(() => _i503.AuthRepositoryImpl(
          gh<_i549.ApiClient>(),
          gh<_i176.LocalStorage>(),
        ));
    gh.factory<_i290.GetBikesUseCase>(
        () => _i290.GetBikesUseCase(gh<_i818.BikeRepository>()));
    gh.factory<_i86.GetFeaturedBikesUseCase>(
        () => _i86.GetFeaturedBikesUseCase(gh<_i818.BikeRepository>()));
    gh.factory<_i872.RegisterUseCase>(
        () => _i872.RegisterUseCase(gh<_i695.AuthRepository>()));
    gh.factory<_i771.LoginUseCase>(
        () => _i771.LoginUseCase(gh<_i695.AuthRepository>()));
    return this;
  }
}
