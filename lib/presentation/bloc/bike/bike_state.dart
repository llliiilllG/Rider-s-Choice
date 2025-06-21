import 'package:equatable/equatable.dart';
import '../../../domain/entities/bike.dart';

abstract class BikeState extends Equatable {
  const BikeState();

  @override
  List<Object> get props => [];
}

class BikeInitial extends BikeState {}

class BikeLoading extends BikeState {}

class BikeLoaded extends BikeState {
  final List<Bike> bikes;

  const BikeLoaded(this.bikes);

  @override
  List<Object> get props => [bikes];
}

class SingleBikeLoaded extends BikeState {
  final Bike bike;

  const SingleBikeLoaded(this.bike);

  @override
  List<Object> get props => [bike];
}

class BikeError extends BikeState {
  final String message;

  const BikeError(this.message);

  @override
  List<Object> get props => [message];
} 