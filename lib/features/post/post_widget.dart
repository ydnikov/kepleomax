import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kepleomax/core/flavor.dart';
import 'package:kepleomax/core/models/post.dart';
import 'package:kepleomax/core/navigation/app_navigator.dart';
import 'package:kepleomax/core/extensions/build_context_extensions.dart';
import 'package:kepleomax/core/presentation/klm_cached_image.dart';
import 'package:kepleomax/core/presentation/parse_time.dart';
import 'package:kepleomax/core/presentation/photos_preview/photos_preview_screen.dart';
import 'package:kepleomax/core/presentation/user_image_widget.dart';
import 'package:kepleomax/generated/images_keys.images_keys.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

part 'widgets/photo_row.dart';
part 'widgets/photo_widget.dart';
part 'widgets/post_images_widget.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({
    required this.post,
    this.onDelete,
    this.onEdit,
    this.onUserTap,
    super.key,
  });

  final Post post;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onUserTap;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: post.isMockLoadingPost,
      effect: const SoldColorEffect(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: onUserTap,
                    child: Row(
                      children: [
                        UserImageWidget(
                          user: post.user,
                          size: 34,
                          isLoading: post.isMockLoadingPost,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            post.user.username,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 19,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (post.user.isCurrent && (onEdit != null || onDelete != null))
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit?.call();
                      } else if (value == 'delete') {
                        onDelete?.call();
                      }
                    },
                    itemBuilder: (context) => [
                      if (onEdit != null)
                        const PopupMenuItem(value: 'edit', child: Text('Edit post')),
                      if (onDelete != null)
                        PopupMenuItem(
                          value: 'delete',
                          child: Text(
                            'Delete post',
                            style: context.textTheme.bodyLarge?.copyWith(
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  )
                else
                  const SizedBox(height: 42),
              ],
            ),
          ),
          const SizedBox(height: 4),
          if (post.images.isNotEmpty) _PostImagesWidget(images: post.images),
          if (post.content.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Linkify(
                onOpen: (link) async {
                  await launchUrl(Uri.parse(link.url));
                },
                text: post.content,
                style: context.textTheme.bodyLarge?.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                options: const LinkifyOptions(removeWww: true),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                TextButton(
                  onPressed: () {
                    Fluttertoast.showToast(msg: 'Not working now');
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                  ),
                  child: Row(
                    children: [
                      if (!post.isMockLoadingPost) ...[
                        SvgPicture.asset(ImagesKeys.favorite_icon_svg, height: 24),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        post.likesCount.toString(),
                        style: context.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Tooltip(
                  message:
                      '${ParseTime.toPreciseDate(post.createdAt)}${post.updatedAt == null ? '' : '\nedited: ${ParseTime.toPreciseDate(post.updatedAt!)}'}',
                  triggerMode: TooltipTriggerMode.tap,
                  preferBelow: false,
                  showDuration: const Duration(seconds: 5),
                  child: Text(
                    ParseTime.toPassTime(post.createdAt),
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
