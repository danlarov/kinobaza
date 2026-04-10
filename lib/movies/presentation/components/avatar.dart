import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kinobaza/core/resources/app_colors.dart';
import 'package:kinobaza/core/resources/app_values.dart';
import 'package:shimmer/shimmer.dart';

class Avatar extends StatelessWidget {
  const Avatar({super.key, required this.avatarUrl, this.name = ''});

  final String avatarUrl;
  final String name;

  @override
  Widget build(BuildContext context) {
    if (avatarUrl.isEmpty) {
      return CircleAvatar(
        radius: AppSize.s20,
        backgroundColor: Colors.grey[800],
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: avatarUrl,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: AppSize.s20,
        backgroundColor: AppColors.transparent,
        backgroundImage: imageProvider,
      ),
      placeholder: (context, _) => Shimmer.fromColors(
        baseColor: Colors.grey[850]!,
        highlightColor: Colors.grey[800]!,
        child: const CircleAvatar(radius: AppSize.s20),
      ),
      errorWidget: (_, _, _) => CircleAvatar(
        radius: AppSize.s20,
        backgroundColor: Colors.grey[800],
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}