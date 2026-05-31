import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:kepleomax/core/app.dart';
import 'package:kepleomax/core/flavor.dart';
import 'package:kepleomax/core/logger.dart';
import 'package:kepleomax/core/presentation/user_error_message.dart';
import 'package:kepleomax/features/chats/chats_screen_navigator.dart';
import 'package:kepleomax/features/chats/data/chats_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class KlmUrlLauncher {
  KlmUrlLauncher({required ChatsRepository chatsRepository})
    : _chatsRepository = chatsRepository;

  final ChatsRepository _chatsRepository;

  Future<void> launchKlmUrl(Uri uri) async {
    try {
      if (uri.origin == flavor.baseUrl) {
        final path = uri.pathSegments.first;
        if (path.startsWith('@')) {
          /// user
        } else {
          /// channel/chat
          final chat = await _chatsRepository.getChatWithId(path);
          if (chat == null) {
            unawaited(Fluttertoast.showToast(msg: 'Chat not found'));
            return;
          }

          mainNavigatorGlobalKey.currentState!.push(
            ChatPage(chat: chat, otherUser: chat.otherUser),
          );
        }
      } else {
        await launchUrl(uri);
      }
    } catch (e, st) {
      logger.e(e, stackTrace: st);
      unawaited(Fluttertoast.showToast(msg: e.userErrorMessage));
    }
  }
}
