import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/bike_api_service.dart';
import 'bike_event.dart';
import 'bike_state.dart';

class BikeBloc extends Bloc<BikeEvent, BikeState> {
  final BikeApiService apiService;
  BikeBloc({required this.apiService}) : super(BikeInitial()) {
    on<GetFeaturedBikesEvent>((event, emit) async {
      emit(BikeLoading());
      try {
        final bikes = await apiService.getFeaturedBikes();
        emit(BikeLoaded(bikes));
      } catch (e) {
        emit(BikeError('Failed to load featured bikes'));
      }
    });

    on<GetBikeByIdEvent>((event, emit) async {
      emit(BikeLoading());
      try {
        final bike = await apiService.getBikeById(event.id);
        if (bike != null) {
          emit(SingleBikeLoaded(bike));
        } else {
          emit(BikeError('Bike not found'));
        }
      } catch (e) {
        if (e is Exception && e.toString().contains('Bike not found')) {
          emit(BikeError('Bike not found'));
        } else {
          emit(BikeError('Failed to load bike details'));
        }
      }
    });

    on<GetBikesByCategoryEvent>((event, emit) async {
      emit(BikeLoading());
      try {
        final bikes = await apiService.getBikesByCategory(event.category);
        emit(BikeLoaded(bikes));
      } catch (e) {
        emit(BikeError('Failed to load bikes by category'));
      }
    });
  }
} 