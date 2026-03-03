import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:kepleomax/core/di/dependencies.dart';
import 'package:kepleomax/core/models/call_model.dart';
import 'package:kepleomax/core/models/message.dart';
import 'package:kepleomax/core/models/user.dart';
import 'package:kepleomax/core/navigation/app_navigator.dart';
import 'package:kepleomax/core/navigation/pages.dart';
import 'package:kepleomax/core/presentation/colors.dart';
import 'package:kepleomax/core/presentation/context_wrapper.dart';
import 'package:kepleomax/core/presentation/parse_time.dart';
import 'package:kepleomax/core/presentation/user_image.dart';
import 'package:kepleomax/core/scopes/auth_scope.dart';
import 'package:kepleomax/features/chat/widgets/message_menu.dart';
import 'package:url_launcher/url_launcher.dart';

part 'call_widget.dart';

part 'date_widget.dart';

part 'unread_messages_widget.dart';

part 'general_message_widget.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    required this.message,
    required this.user,
    required this.onDelete,
    super.key,
  });

  final Message message;
  final User user;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final bool highlightCacheMessages = Dependencies.of(
      context,
    ).appSettings.highlightCacheMessages;

    if (message.type == MessageType.unreadMessages) {
      return const _UnreadMessagesWidget();
    }

    if (message.type == MessageType.date) {
      return _ChatDateWidget(date: message.createdAt);
    }

    final messageContainerGlobalKey = GlobalKey();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (message.isCurrentUser)
            const Spacer(key: Key('current_user_spacer'))
          else ...[
            SizedBox(
              height: 35,
              width: 35,
              child: InkWell(
                onTap: () {
                  context.findAncestorStateOfType<AppNavigatorState>();

                  AppNavigator.withKeyOf(
                    context,
                    mainNavigatorKey,
                  )!.push(UserPage(userId: user.id));
                },
                child: UserImage(size: 35, user: user),
              ),
            ),
            const SizedBox(width: 10),
          ],
          if (message.type == MessageType.call)
            _CallWidget(
              key: Key('call_message_widget_${message.id}'),
              message: message,
              messageContainerGlobalKey: messageContainerGlobalKey,
              onDelete: onDelete,
              highlightCacheMessages: highlightCacheMessages,
            )
          else
            _GeneralMessageWidget(
              key: Key('general_message_widget_${message.id}'),
              message: message,
              messageContainerGlobalKey: messageContainerGlobalKey,
              onDelete: onDelete,
              highlightCacheMessages: highlightCacheMessages,
            ),
          if (!message.isCurrentUser) const Spacer(),
        ],
      ),
    );
  }
}
