import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kepleomax/core/models/chat.dart';
import 'package:kepleomax/core/navigation/app_navigator.dart';
import 'package:kepleomax/core/navigation/pages.dart';
import 'package:kepleomax/features/chat/widgets/message_widget.dart';
import 'package:kepleomax/features/chats/chats_screen.dart';

part 'checkers.dart';

enum ChatsAppBarStatus { connecting, updating, chats }

enum ChatAppBarStatus { connecting, updating, none }

extension TesterExtension on WidgetTester {
  String? textByKey(Key key) => widget<Text>(find.byKey(key)).data;

  Iterable<T> childrenOfListByKey<T extends Widget>(
    Key listKey,
    Type childrenType,
  ) => widgetList<T>(
    find.descendant(of: find.byKey(listKey), matching: find.byType(childrenType)),
  ).toList();

  Iterable<Key?> keysOfListByKey(Key listKey, Type childrenType) =>
      childrenOfListByKey(
        listKey,
        childrenType,
      ).map((widget) => widget.key).toList();

  Future<void> sendResponse(Completer<void> completer, {bool settle = true}) async {
    completer.complete();
    if (settle) {
      await pumpAndSettle();
    } else {
      await pump(const Duration(milliseconds: 50));
    }
  }

  Future<void> scrollMessagesTo(int messageId) async {
    await dragUntilVisible(
      find.byKey(Key('message_$messageId')),
      find.byKey(const Key('messages_list_view')),
      const Offset(0, 200),
    );
  }

  Future<void> flingMessages({bool toTheTop = true}) async {
    await fling(
      find.byKey(const Key('messages_list_view')),
      Offset(0, 1000 * (toTheTop ? 1 : -1)),
      5000,
    );
    await pumpAndSettle();
  }

  Future<void> reopenChat({int chatId = 0, bool settle = true}) async {
    await tap(find.byKey(const Key('back_button')));
    await pumpAndSettle();
    await openChat(chatId, settle: settle);
  }

  Future<void> openChat(int chatId, {bool settle = true}) async {
    await tap(find.byKey(Key('chat_$chatId')));
    if (settle) {
      await pumpAndSettle();
    } else {
      await pump(const Duration(milliseconds: 50));
    }
  }

  ChatChecker getChat(int id) => ChatChecker(find.byKey(Key('chat_$id')));

  MessageChecker getMessage(int id) =>
      MessageChecker(find.byKey(Key('message_$id')));

  void checkChatsAppBarStatus(ChatsAppBarStatus expected) {
    String text;
    switch (expected) {
      case ChatsAppBarStatus.connecting:
        text = 'Connecting';
      case ChatsAppBarStatus.updating:
        text = 'Updating';
      case ChatsAppBarStatus.chats:
        text = 'Chats';
    }
    expect(textByKey(const Key('app_bar_status_text')), contains(text));
  }

  void checkChatAppBarStatus(ChatAppBarStatus expected) {
    if (expected == ChatAppBarStatus.none) {
      expect(find.byKey(const Key('chat_app_bar_status_text')), findsNothing);
      return;
    }

    String text;
    switch (expected) {
      case ChatAppBarStatus.connecting:
        text = 'Connecting';
      case ChatAppBarStatus.updating:
        text = 'Updating';
      case ChatAppBarStatus.none:
        return;
    }
    expect(textByKey(const Key('chat_app_bar_status_text')), contains(text));
  }

  void checkChatName(String expected) {
    expect(textByKey(const Key('chat_username')), equals(expected));
  }

  void checkChatOtherUserStatus(String expected) {
    expect(textByKey(const Key('user_status_text')), contains(expected));
  }

  void checkFindPeopleButton({required bool isShown}) {
    expect(
      find.byKey(const Key('find_people_button')),
      isShown ? findsOneWidget : findsNothing,
    );
  }

  void checkTotalUnreadCount(int expected) {
    if (expected == 0) {
      expect(find.byKey(const Key('chats_unread_text')), findsNothing);
    } else {
      expect(textByKey(const Key('chats_unread_text')), equals(expected.toString()));
    }
  }

  void checkChatsCount(int expected) {
    expect(
      keysOfListByKey(const Key('chats_list_view'), ChatWidget).length,
      equals(expected),
    );
  }

  void checkChatsOrder(List<int> ids) {
    expect(
      keysOfListByKey(const Key('chats_list_view'), ChatWidget),
      equals(ids.map((id) => Key('chat_$id'))),
    );
  }

  void checkMessagesCount(int expected) {
    expect(visibleMessagesCount, equals(expected));
  }

  int get visibleMessagesCount => childrenOfListByKey<MessageWidget>(
    const Key('messages_list_view'),
    MessageWidget,
  ).where((w) => !w.message.isSystem).length;

  void checkMessagesOrder(List<int> ids, {bool countSystem = false}) {
    expect(
      childrenOfListByKey<MessageWidget>(
        const Key('messages_list_view'),
        MessageWidget,
      ).where((w) => !w.message.isSystem || countSystem).map((w) => w.key),
      equals(ids.map((id) => Key('message_$id'))),
    );
  }

  Future<void> pushPage(AppPage page, {bool settle = true}) async {
    AppNavigator.of(firstElement(find.byType(Text)))!.push(page);
    if (settle) {
      await pumpAndSettle();
    } else {
      await pump(const Duration(milliseconds: 50));
    }
  }

  Future<void> goBack() async {
    await tap(find.byKey(const Key('back_button')));
    await pumpAndSettle();
  }

  /// channel
  void checkChannelBottom(UserChannelRole expected) {
    if (expected.isNone || expected.isSubscriber) {
      expect(
        find.childrenWithText(
          const Key('chat_channel_bottom_button'),
          expected.isNone ? 'Subscribe' : 'Go to Channel',
        ),
        findsOneWidget,
      );
    } else {
      // TODO
    }
  }

  void checkSubsCountOnChatScreen(String expected) {
    expect(textByKey(const Key('subscribers_count_text')), expected);
  }
}

extension CommonFindersExtension on CommonFinders {
  Finder childrenWithText(Key parentKey, String text) =>
      find.descendant(of: find.byKey(parentKey), matching: find.text(text));

  Finder childrenWithKey(Key parentKey, Key key) =>
      find.descendant(of: find.byKey(parentKey), matching: find.byKey(key));

  Finder childrenWithIcon(Key parentKey, IconData icon) =>
      find.descendant(of: find.byKey(parentKey), matching: find.byIcon(icon));
}
