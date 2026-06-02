part of '../post_widget.dart';

class _PhotoWidget extends StatelessWidget {
  const _PhotoWidget({
    required this.width,
    this.height,
    required this.index,
    required this.imagesToOpen,
  });

  final double width;
  final double? height;
  final int index;
  final List<String> imagesToOpen;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AppNavigator.showGeneralDialog(
          context,
          (_) => PhotosPreviewScreen(urls: imagesToOpen, initialIndex: index),
        );
      },
      child: SizedBox(
        width: width,
        height: height,
        child: KlmCachedImage(
          imageUrl: flavor.imageUrl + imagesToOpen[index],
          width: context.imageMaxWidth,
          showProgress: true,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
