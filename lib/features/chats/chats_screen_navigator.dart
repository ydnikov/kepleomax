import 'package:flutter/material.dart';
import 'package:kepleomax/core/models/chat.dart';
import 'package:kepleomax/core/models/user.dart';
import 'package:kepleomax/core/navigation/app_navigator.dart';
import 'package:kepleomax/core/navigation/pages.dart';
import 'package:kepleomax/features/call/call_screen.dart';
import 'package:kepleomax/features/channel/channel_screen.dart';
import 'package:kepleomax/features/channel_editor/channel_editor_screen.dart';
import 'package:kepleomax/features/chat/chat_screen.dart';
import 'package:kepleomax/features/chats/chats_screen.dart';

const chatsNavigatorKey = 'ChatsNavigator';
final chatsNavigatorGlobalKey = GlobalKey();

class ChatsNavigator extends StatefulWidget {
  const ChatsNavigator({super.key});

  @override
  State<ChatsNavigator> createState() => _ChatsNavigatorState();
}

class _ChatsNavigatorState extends State<ChatsNavigator>
    with AutomaticKeepAliveClientMixin<ChatsNavigator> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AppNavigator(
      initialState: [const ChatsPage()],
      navigatorKey: chatsNavigatorKey,
      key: chatsNavigatorGlobalKey,
    );
  }
}

/// pages
final class ChatsPage extends AppPage {
  const ChatsPage()
    : super(
        name: 'chats_screen',
        child: const ChatsScreen(),
        key: const ValueKey('chats_screen'),
      );
}

/// pass chatId and otherUser = null, or chatId = -1 and otherUser, or both
/// can't pass chatId = -1 and otherUser = null
final class ChatPage extends AppPage {
  ChatPage({required Chat? chat, required User otherUser})
    : super(
        name: 'chat_screen',
        child: ChatScreen(chat: chat, otherUser: otherUser),
        key: ValueKey('chat_screen_${chat?.id}_${otherUser.id}'),
      );
}

final class ChannelEditorPage extends AppPage {
  const ChannelEditorPage()
      : super(
    name: 'channel_editor_screen',
    child: const ChannelEditorScreen(),
    key: const ValueKey('channel_editor_screen'),
  );
}

final class ChannelPage extends AppPage {
  ChannelPage({required ChannelData channelData})
      : super(
    name: 'channel_page',
    child: ChannelScreen(channelData: channelData),
    key: const ValueKey('channel_page'),
  );
}

final class CallPage extends AppPage {
  CallPage({required User otherUser, bool doCall = false})
    : super(
        name: 'call_page',
        child: CallScreen(otherUser: otherUser, doCall: doCall),
        key: ValueKey('call_screen_${otherUser.id}'),
      );
}
