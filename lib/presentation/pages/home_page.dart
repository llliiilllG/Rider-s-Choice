import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bike/bike_bloc.dart';
import '../bloc/bike/bike_state.dart';
import '../widgets/bike_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rider\'s Choice'),
        centerTitle: true,
      ),
      body: BlocBuilder<BikeBloc, BikeState>(
        builder: (context, state) {
          if (state is BikeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BikeLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.bikes.length,
              itemBuilder: (context, index) {
                final bike = state.bikes[index];
                return BikeCard(bike: bike);
              },
            );
          } else if (state is BikeError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
} 