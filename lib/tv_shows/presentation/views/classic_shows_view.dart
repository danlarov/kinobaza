import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinobaza/core/domain/entities/media.dart';
import 'package:kinobaza/core/presentation/components/custom_app_bar.dart';
import 'package:kinobaza/core/presentation/components/error_screen.dart';
import 'package:kinobaza/core/presentation/components/loading_indicator.dart';
import 'package:kinobaza/core/presentation/components/vertical_listview.dart';
import 'package:kinobaza/core/presentation/components/vertical_listview_card.dart';
import 'package:kinobaza/core/utils/enums.dart';
import 'package:kinobaza/tv_shows/presentation/controllers/tv_shows_bloc/tv_shows_bloc.dart';

class ClassicShowsView extends StatelessWidget {
  const ClassicShowsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Классика сериалов'),
      body: BlocBuilder<TVShowsBloc, TVShowsState>(
        builder: (context, state) {
          switch (state.status) {
            case RequestStatus.loading:
              return const LoadingIndicator();
            case RequestStatus.loaded:
              final classics = state.tvShows[2].where((m) {
                final year = int.tryParse(m.releaseDate) ?? 9999;
                return year < 2015;
              }).toList();
              if (classics.isEmpty) return const Center(
                child: Text('Нет данных', style: TextStyle(color: Colors.white)),
              );
              return VerticalListView(
                itemCount: classics.length,
                itemBuilder: (context, index) =>
                    VerticalListViewCard(media: classics[index]),
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