import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kepleomax/core/flavor.dart';
import 'package:kepleomax/core/models/user.dart';
import 'package:kepleomax/core/extensions/build_context_extensions.dart';
import 'package:kepleomax/core/navigation/app_navigator.dart';
import 'package:kepleomax/core/presentation/klm_cached_image.dart';
import 'package:kepleomax/core/presentation/photos_preview/photos_preview_screen.dart';
import 'package:kepleomax/generated/images_keys.images_keys.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserImageWidget extends StatelessWidget {
  const UserImageWidget({
    required this.user,
    this.size,
    this.isLoading = false,
    this.openImageViewerOnTap = false,
    this.onlineIconSize = 10,
    this.onlineIconPadding = 4,
    this.showOnlineIndicator = false,
    super.key,
  });

  final User? user;
  final double? size;
  final bool isLoading;
  final bool openImageViewerOnTap;

  /// online
  final bool showOnlineIndicator;
  final double onlineIconSize;
  final double onlineIconPadding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            SizedBox(
              height: size ?? constraints.maxHeight,
              width: size ?? constraints.maxWidth,
              child: ClipOval(
                child: isLoading
                    ? const Skeletonizer(child: ColoredBox(color: Colors.grey))
                    : user?.profileImage == null || user!.profileImage!.isEmpty
                    ? const UserDefaultIconWidget()
                    : GestureDetector(
                        onTap: openImageViewerOnTap ? () {
                          AppNavigator.showGeneralDialog(
                            context,
                            PhotosPreviewScreen(
                              urls: [user!.profileImage!],
                              isOnePictureMode: true,
                            ),
                          );
                        } : null,
                        child: KlmCachedImage(
                          imageUrl: flavor.imageUrl + user!.profileImage!,
                          width: context.imageMaxWidth,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),

            /// TODO maybe use it, looks nice
            // Positioned(
            //   bottom: onlineIconPadding / 4,
            //   right: 0,
            //   child: Container(
            //     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            //     decoration: BoxDecoration(
            //       color: Colors.grey,
            //       borderRadius: BorderRadius.circular(16),
            //       border: Border.all(
            //         color: Colors.white,
            //         width: 2,
            //         strokeAlign: BorderSide.strokeAlignOutside,
            //       ),
            //     ),
            //     child: Text(
            //       '32 min',
            //       style: TextStyle(
            //         fontSize: 12,
            //         fontWeight: FontWeight.w500,
            //         color: Colors.white,
            //       ),
            //     ),
            //   ),
            // ),
            if (user != null && showOnlineIndicator)
              Positioned(
                bottom: onlineIconPadding / 4,
                right: onlineIconPadding,
                child: _OnlineIndicator(user: user!, onlineIconSize: onlineIconSize),
              ),
          ],
        );
      },
    );
  }
}

class UserDefaultIconWidget extends StatelessWidget {
  const UserDefaultIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ColoredBox(
          color: Colors.grey.shade400,
          child: Padding(
            padding: EdgeInsets.only(top: constraints.maxHeight * 0.2),
            child: SvgPicture.asset(ImagesKeys.user_default_icon_svg),
          ),
        );
      },
    );
  }
}

class _OnlineIndicator extends StatefulWidget {
  const _OnlineIndicator({required this.user, required this.onlineIconSize});

  final User user;
  final double onlineIconSize;

  @override
  State<_OnlineIndicator> createState() => _OnlineIndicatorState();
}

class _OnlineIndicatorState extends State<_OnlineIndicator> {
  late Timer _timer;
  bool _isOnline = false;

  @override
  void initState() {
    _isOnline = widget.user.showOnlineStatus;

    /// this timer is needed cause user.showOnlineStatus depends on DateTime.now()
    /// and can be changed to false at some point
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (widget.user.showOnlineStatus != _isOnline) {
        setState(() {});

        /// isOnline will be changed in build()
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _isOnline = widget.user.showOnlineStatus;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 100),
      opacity: _isOnline == true ? 1 : 0,
      child: Container(
        key: Key(_isOnline ? 'online_indicator' : 'hidden_online_indicator'),
        height: widget.onlineIconSize,
        width: widget.onlineIconSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green,
          border: Border.all(
            color: Colors.white,
            width: 2,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
      ),
    );
  }
}
