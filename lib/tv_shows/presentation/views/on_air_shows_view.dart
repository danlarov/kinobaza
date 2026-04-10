import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinobaza/core/presentation/components/custom_app_bar.dart';
import 'package:kinobaza/core/presentation/components/error_screen.dart';
import 'package:kinobaza/core/presentation/components/loading_indicator.dart';
import 'package:kinobaza/core/presentation/components/vertical_listview.dart';
import 'package:kinobaza/core/presentation/components/vertical_listview_card.dart';
import 'package:kinobaza/core/utils/enums.dart';
import 'package:kinobaza/tv_shows/presentation/controllers/tv_shows_bloc/tv_shows_bloc.dart';

class OnAirShowsView extends StatelessWidget {
  const OnAirShowsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Сейчас в эфире'),
      body: BlocBuilder<TVShowsBloc, TVShowsState>(
        builder: (context, state) {
          switch (state.status) {
            case RequestStatus.loading:
              return const LoadingIndicator();
            case RequestStatus.loaded:
              final shows = state.tvShows[0];
              if (shows.isEmpty) return const LoadingIndicator();
              return VerticalListView(
                itemCount: shows.length,
                itemBuilder: (context, index) =>
                    VerticalListViewCard(media: shows[index]),
                addEvent: () {},
              );
            case RequestStatus.error:
              return ErrorScreen(onTryAgainPressed: () {
                context.read<TVShowsBloc>().add(GetTVShowsEvent());
              });
          }
        },
      ),
    );
  }
}