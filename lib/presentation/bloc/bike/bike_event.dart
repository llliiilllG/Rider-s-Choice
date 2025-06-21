abstract class BikeEvent {}

class GetFeaturedBikesEvent extends BikeEvent {}

class GetBikeByIdEvent extends BikeEvent {
  final String id;
  GetBikeByIdEvent(this.id);
}

class GetBikesByCategoryEvent extends BikeEvent {
  final String category;
  GetBikesByCategoryEvent(this.category);
} 