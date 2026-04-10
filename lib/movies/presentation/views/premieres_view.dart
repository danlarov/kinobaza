import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinobaza/core/domain/entities/media.dart';
import 'package:kinobaza/core/presentation/components/custom_app_bar.dart';
import 'package:kinobaza/core/presentation/components/error_screen.dart';
import 'package:kinobaza/core/presentation/components/loading_indicator.dart';
import 'package:kinobaza/core/presentation/components/vertical_listview.dart';
import 'package:kinobaza/core/presentation/components/vertical_listview_card.dart';
import 'package:kinobaza/movies/presentation/controllers/movies_bloc/movies_bloc.dart';
import 'package:kinobaza/movies/presentation/controllers/movies_bloc/movies_event.dart';
import 'package:kinobaza/movies/presentation/controllers/movies_bloc/movies_state.dart';
import 'package:kinobaza/core/utils/enums.dart';

class PremieresView extends StatelessWidget {
  const PremieresView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Скоро в кино'),
      body: BlocBuilder<MoviesBloc, MoviesState>(
        builder: (context, state) {
          switch (state.status) {
            case RequestStatus.loading:
              return const LoadingIndicator();
            case RequestStatus.loaded:
              final movies = state.movies.length > 3 ? state.movies[3] : <Media>[];
              if (movies.isEmpty) return const LoadingIndicator();
              return VerticalListView(
                itemCount: movies.length,
                itemBuilder: (context, index) =>
                    VerticalListViewCard(media: movies[index]),
                addEvent: () {},
              );
            case RequestStatus.error:
              return ErrorScreen(onTryAgainPressed: () {
                context.read<MoviesBloc>().add(GetMoviesEvent());
              });
          }
        },
      ),
    );
  }
}