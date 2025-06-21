import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/bike_data.dart';
import 'bike_event.dart';
import 'bike_state.dart';

class BikeBloc extends Bloc<BikeEvent, BikeState> {
  BikeBloc() : super(BikeInitial()) {
    on<GetFeaturedBikesEvent>((event, emit) async {
      emit(BikeLoading());
      try {
        final bikes = BikeData.getFeaturedBikes();
        emit(BikeLoaded(bikes));
      } catch (e) {
        emit(BikeError('Failed to load featured bikes'));
      }
    });

    on<GetBikeByIdEvent>((event, emit) async {
      emit(BikeLoading());
      try {
        final bike = BikeData.getBikeById(event.id);
        if (bike != null) {
          emit(SingleBikeLoaded(bike));
        } else {
          emit(BikeError('Bike not found'));
        }
      } catch (e) {
        emit(BikeError('Failed to load bike details'));
      }
    });

    on<GetBikesByCategoryEvent>((event, emit) async {
      emit(BikeLoading());
      try {
        final bikes = BikeData.getBikesByCategory(event.category);
        emit(BikeLoaded(bikes));
      } catch (e) {
        emit(BikeError('Failed to load bikes by category'));
      }
    });
  }
} 