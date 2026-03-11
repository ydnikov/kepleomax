import 'package:flutter/material.dart';
import 'package:kepleomax/core/navigation/app_navigator.dart';
import 'package:kepleomax/core/navigation/pages.dart';
import 'package:kepleomax/core/extensions/build_context_extensions.dart';
import 'package:kepleomax/core/presentation/ellipsis_text_widget.dart';
import 'package:kepleomax/core/presentation/user_image.dart';
import 'package:kepleomax/core/scopes/auth_scope.dart';

class KlmAppBar extends AppBar {
  KlmAppBar(
    BuildContext context,
    String? title, {
    Widget? leading,
    bool ellipsisText = false,
    bool showLoading = false,
    super.actions,
    super.key,
  }) : super(
         leading: InkWell(
           onTap: () {
             AppNavigator.of(
               context,
             )?.push(UserPage(userId: AuthScope.userOf(context).id));
           },
           child:
               leading ??
               Container(
                 margin: const EdgeInsets.all(12),
                 child: UserImage(user: AuthScope.userOf(context)),
               ),
         ),
         titleSpacing: 5,
         backgroundColor: Colors.white,
         surfaceTintColor: Colors.white,
         title: Row(
           children: [
             if (ellipsisText)
               EllipsisTextWidget(
                 title ?? '',
                 textKey: const Key('app_bar_status_text'),
                 style: context.textTheme.labelLarge?.copyWith(fontSize: 24),
               )
             else
               Text(
                 title ?? '',
                 key: const Key('app_bar_status_text'),
                 style: context.textTheme.labelLarge?.copyWith(fontSize: 24),
               ),
             if (showLoading) ...[
               const Spacer(),
               const SizedBox(
                 height: 20,
                 width: 20,
                 child: CircularProgressIndicator(strokeWidth: 3),
               ),
               const SizedBox(width: 12),
             ],
           ],
         ),
       );
}

class KlmSliverAppBar extends SliverAppBar {
  KlmSliverAppBar(
    BuildContext context,
    String title, {
    Widget? leading,
    super.systemOverlayStyle,
    super.key,
  }) : super(
         leading: InkWell(
           onTap: () {
             AppNavigator.of(
               context,
             )?.push(UserPage(userId: AuthScope.userOf(context).id));
           },
           child:
               leading ??
               Container(
                 margin: const EdgeInsets.all(12),
                 child: UserImage(user: AuthScope.userOf(context)),
               ),
         ),
         titleSpacing: 5,
         backgroundColor: Colors.white,
         title: Text(
           title,
           style: context.textTheme.labelLarge?.copyWith(fontSize: 24),
         ),
       );
}

class KlmBackButton extends StatelessWidget {
  const KlmBackButton({this.onPressed, this.icon, super.key});

  final VoidCallback? onPressed;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const Key('back_button'),
      onPressed:
          onPressed ??
          () {
            AppNavigator.pop(context);
          },
      icon: icon ?? const Icon(Icons.arrow_back_ios_new),
    );
  }
}
