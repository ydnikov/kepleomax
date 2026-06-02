import 'package:flutter/material.dart';
import 'package:kepleomax/core/extensions/build_context_extensions.dart';
import 'package:kepleomax/core/flavor.dart';
import 'package:kepleomax/core/navigation/app_navigator.dart';
import 'package:kepleomax/core/presentation/klm_cached_image.dart';
import 'package:kepleomax/core/presentation/photos_preview/photos_preview_screen.dart';

class ChannelImageWidget extends StatelessWidget {
  const ChannelImageWidget({
    required this.image,
    this.size,
    this.openImageViewerOnTap = false,
    super.key,
  });

  final String? image;
  final double? size;
  final bool openImageViewerOnTap;

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return ChannelDefaultIconWidget(size: size);
    }

    return GestureDetector(
      onTap: openImageViewerOnTap
          ? () {
              AppNavigator.showGeneralDialog(
                context,
                (_) => PhotosPreviewScreen(urls: [image!], isOnePictureMode: true),
              );
            }
          : null,
      child: ClipOval(
        child: SizedBox(
          height: size,
          width: size,
          child: KlmCachedImage(
            imageUrl: flavor.imageUrl + image!,
            width: context.imageMaxWidth,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class ChannelDefaultIconWidget extends StatelessWidget {
  const ChannelDefaultIconWidget({this.size, super.key});

  final double? size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        color: Colors.grey.shade400,
        height: size,
        width: size,
        child: FittedBox(
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Icon(Icons.ac_unit, size: size),
          ),
        ),
      ),
    );
  }
}
