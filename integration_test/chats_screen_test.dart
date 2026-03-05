// dart format width=200

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kepleomax/core/app.dart';
import 'package:kepleomax/core/app_constants.dart';
import 'package:kepleomax/core/data/local_data_sources/local_database_manager.dart';
import 'package:kepleomax/core/di/dependencies.dart';
import 'package:kepleomax/core/flavor.dart';
import 'package:kepleomax/core/models/call_model.dart';
import 'package:kepleomax/core/models/user.dart';
import 'package:kepleomax/core/network/apis/chats/chats_dtos.dart';
import 'package:kepleomax/core/network/apis/messages/message_dtos.dart';
import 'package:kepleomax/core/network/websockets/models/deleted_message_update.dart';
import 'package:kepleomax/core/network/websockets/models/online_status_update.dart';
import 'package:kepleomax/core/network/websockets/models/read_messages_update.dart';
import 'package:kepleomax/core/network/websockets/models/typing_activity_update.dart';
import 'package:mockito/mockito.dart';
import 'package:retrofit/dio.dart';

import 'initialize_tests_dependencies.dart';
import 'mocks/mock_klm_web_socket.dart';
import 'mocks/mock_messages_web_socket.dart';
import 'mocks/mockito_mocks.mocks.dart';
import 'utils/mock_objects.dart';
import 'utils/utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized().framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  group('chats_screen_tests', () {
    late Dependencies dp;
    late MockMessengerWebSocket ws;
    late MockKlmWebSocket baseWs;
    late Completer<void> _getChatsCompleter;

    setUpAll(() {
      Flavor.setFlavor(Flavor.testing());
    });

    setUp(() async {
      dp = await initializeTestsDependencies();
      ws = dp.messengerWebSocket as MockMessengerWebSocket;
      baseWs = dp.klmWebSocket as MockKlmWebSocket;
      await dp.authController.setUser(User.testing());
    });

    tearDown(() async {
      await LocalDatabaseManager.reset();
    });

    Future<void> setupAppWithChats(WidgetTester tester, List<ChatDto> chats, {bool getChatsAsyncControl = false, bool connect = true}) async {
      when(dp.chatsApi.getChats()).thenAnswer((_) async {
        if (getChatsAsyncControl) {
          _getChatsCompleter = Completer();
          await _getChatsCompleter.future;
        }
        return HttpResponse(ChatsResponse(data: chats, message: null), Response(requestOptions: RequestOptions(), statusCode: 200));
      });
      when((dp.chatsApi as MockChatsApi).getChatWithId(chatId: anyNamed('chatId'))).thenAnswer((inv) async {
        return HttpResponse(
          ChatResponse(data: [chatDto0, chatDto1, chatDto2, chatDto3, chatDto4].firstWhere((chat) => chat.id == inv.namedArguments[#chatId]), message: null),
          Response(requestOptions: RequestOptions(), statusCode: 200),
        );
      });
      await tester.pumpWidget(dp.inject(child: const App()));
      if (!connect) {
        return;
      }
      baseWs.setIsConnected(true);
      if (getChatsAsyncControl) {
        await tester.pump();
      } else {
        await tester.pumpAndSettle();
      }
    }

    Future<void> sendGetChatsResponse(WidgetTester tester) async {
      _getChatsCompleter.complete();
      await tester.pumpAndSettle();
    }

    void getChatsMustReturn(List<ChatDto> chats, {bool asyncControl = false}) {
      when(dp.chatsApi.getChats()).thenAnswer((_) async {
        if (asyncControl) {
          _getChatsCompleter = Completer();
          await _getChatsCompleter.future;
        }
        return HttpResponse(ChatsResponse(data: chats, message: null), Response(requestOptions: RequestOptions(), statusCode: 200));
      });
    }

    Future<void> restartApp(WidgetTester tester) async {
      baseWs.setIsConnected(false);
      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(dp.inject(child: const App()));
      baseWs.setIsConnected(true);
      await tester.pumpAndSettle();
    }

    testWidgets('connection_test', (tester) async {
      await setupAppWithChats(tester, [], getChatsAsyncControl: true, connect: false);
      tester
        ..checkChatsAppBarStatus(ChatsAppBarStatus.connecting)
        ..checkFindPeopleButton(isShown: false);

      /// connect, check
      baseWs.setIsConnected(true);
      await tester.pump();
      tester
        ..checkChatsAppBarStatus(ChatsAppBarStatus.updating)
        ..checkFindPeopleButton(isShown: false);

      /// wait for the getChats response, check
      await sendGetChatsResponse(tester);
      tester
        ..checkChatsAppBarStatus(ChatsAppBarStatus.chats)
        ..checkFindPeopleButton(isShown: true);

      /// disconnect, check
      baseWs.setIsConnected(false);
      await tester.pump();
      tester
        ..checkChatsAppBarStatus(ChatsAppBarStatus.connecting)
        ..checkFindPeopleButton(isShown: true);

      /// connect, check
      baseWs.setIsConnected(true);
      await tester.pump();
      tester
        ..checkChatsAppBarStatus(ChatsAppBarStatus.updating)
        ..checkFindPeopleButton(isShown: false);

      /// wait for the getChats response, check
      await sendGetChatsResponse(tester);
      tester
        ..checkChatsAppBarStatus(ChatsAppBarStatus.chats)
        ..checkFindPeopleButton(isShown: true);
    });

    testWidgets('chats_statuses_test', (tester) async {
      await setupAppWithChats(tester, [chatDto0, chatDto1, chatDto2, chatDto3, chatDto4]);

      /// check
      tester.checkChatsOrder([0, 1, 2, 3, 4]);
      tester.getChat(0).check(unreadCount: 2, unreadIcon: false, readIcon: false, message: 'MSG_0', msgFromCurrentUser: false, otherUserName: 'OTHER_USERNAME_1', isOnline: true);
      tester.getChat(1).check(unreadCount: 4, unreadIcon: false, readIcon: false, message: 'MSG_1', msgFromCurrentUser: false, otherUserName: 'OTHER_USERNAME_2', isOnline: false);
      tester.getChat(2).check(unreadCount: 0, unreadIcon: true, readIcon: false, message: 'MSG_2', msgFromCurrentUser: true, otherUserName: 'OTHER_USERNAME_3', isOnline: false);
      tester.getChat(3).check(unreadCount: 0, unreadIcon: false, readIcon: true, message: 'MSG_3', msgFromCurrentUser: true, otherUserName: 'OTHER_USERNAME_4', isOnline: false);
      tester.getChat(4).check(unreadCount: 0, unreadIcon: false, readIcon: false, message: 'MSG_4', msgFromCurrentUser: false, otherUserName: 'OTHER_USERNAME_5', isOnline: false);
    });

    testWidgets('unread_count_test', (tester) async {
      await setupAppWithChats(tester, [chatDto0, chatDto1, chatDto2, chatDto3, chatDto4]);
      tester.checkTotalUnreadCount(6);
    });

    testWidgets('new_message_test', (tester) async {
      await setupAppWithChats(tester, [chatDto0, chatDto1, chatDto2, chatDto3, chatDto4]);

      /// check chat
      tester.checkChatsOrder([0, 1, 2, 3, 4]);
      tester.getChat(4).check(unreadCount: 0, unreadIcon: false, readIcon: false, message: 'MSG_4', msgFromCurrentUser: false);

      /// add message
      ws.addMessage(MessageDto(id: 5, chatId: chatDto4.id, senderId: chatDto4.otherUser.id, isCurrentUser: false, message: 'MSG_5', isRead: false, createdAt: 1100, editedAt: null, fromCache: false));
      await tester.pumpAndSettle();

      /// check chat again
      tester.checkChatsOrder([4, 0, 1, 2, 3]);
      tester.getChat(4).check(unreadCount: 1, unreadIcon: false, readIcon: false, message: 'MSG_5', msgFromCurrentUser: false);
      tester.checkTotalUnreadCount(7);
    });

    testWidgets('read_message_test', (tester) async {
      await setupAppWithChats(tester, [chatDto0]);

      /// check chat
      tester.getChat(0).check(unreadCount: 2);
      tester.checkTotalUnreadCount(2);

      /// add readMessages, check chat
      ws.addReadMessagesUpdate(ReadMessagesUpdate(chatId: chatDto0.id, senderId: chatDto0.otherUser.id, isCurrentUser: false, messagesIds: [999]));
      await tester.pumpAndSettle();
      tester.getChat(0).check(unreadCount: 1);
      tester.checkTotalUnreadCount(1);

      /// add readMessages, check chat again
      ws.addReadMessagesUpdate(ReadMessagesUpdate(chatId: chatDto0.id, senderId: chatDto0.otherUser.id, isCurrentUser: false, messagesIds: [chatDto0.lastMessage!.id]));
      await tester.pumpAndSettle();
      tester.getChat(0).check(unreadCount: 0, unreadIcon: false, readIcon: false); // both was false and now still are false
      tester.checkTotalUnreadCount(0);
    });

    testWidgets('read_current_user_messages_test', (tester) async {
      await setupAppWithChats(tester, [chatDto0, chatDto2]);

      /// check chat
      tester.getChat(0).check(unreadCount: 2);
      tester.checkTotalUnreadCount(2);

      /// add readMessages, check chat
      ws.addReadMessagesUpdate(ReadMessagesUpdate(chatId: chatDto0.id, senderId: 0, isCurrentUser: true, messagesIds: [999]));
      await tester.pumpAndSettle();
      tester.getChat(0).check(unreadCount: 2);
      tester.checkTotalUnreadCount(2);

      /// check chat2, add readMessages, check chat2
      tester.getChat(2).check(unreadIcon: true, readIcon: false);
      ws.addReadMessagesUpdate(ReadMessagesUpdate(chatId: chatDto2.id, senderId: 0, isCurrentUser: true, messagesIds: [999]));
      await tester.pumpAndSettle();
      tester.getChat(2).check(unreadIcon: true, readIcon: false);
      tester.checkTotalUnreadCount(2);

      /// add readMessages, check chat2
      ws.addReadMessagesUpdate(ReadMessagesUpdate(chatId: chatDto2.id, senderId: 0, isCurrentUser: true, messagesIds: [chatDto2.lastMessage!.id]));
      await tester.pumpAndSettle();
      tester.getChat(2).check(unreadIcon: false, readIcon: true);
      tester.checkTotalUnreadCount(2);
    });

    testWidgets('10000_unread_messages_test', (tester) async {
      await setupAppWithChats(tester, [ChatDto(id: chatDto0.id, otherUser: chatDto0.otherUser, lastMessage: chatDto0.lastMessage, unreadCount: 10000)]);

      /// check
      tester.getChat(0).check(unreadCount: 999);
      tester.checkTotalUnreadCount(99);
    });

    /**
     * if deletedMessage from otherUser && unread -> should decrease unreadCount
     * if newLastMessage != null -> new lastMessage of chat should be set to that
     */
    testWidgets('delete_messages_test', (tester) async {
      await setupAppWithChats(tester, [chatDto0]);

      /// check, delete currentUser message, check
      tester.getChat(0).check(unreadCount: 2);
      ws.addDeletedMessagesUpdate(
        const DeletedMessageUpdate(
          chatId: 0,
          deletedMessage: MessageDto(id: 999, chatId: 0, senderId: 0, isCurrentUser: true, message: '', isRead: true, createdAt: 999, editedAt: null, fromCache: false),
          newLastMessage: null,
        ),
      );
      await tester.pumpAndSettle();
      tester.getChat(0).check(unreadCount: 2);

      /// delete otherUser unread message, check
      ws.addDeletedMessagesUpdate(
        const DeletedMessageUpdate(
          chatId: 0,
          deletedMessage: MessageDto(id: 999, chatId: 0, senderId: 0, isCurrentUser: false, message: '', isRead: false, createdAt: 999, editedAt: null, fromCache: false),
          newLastMessage: null,
        ),
      );
      await tester.pumpAndSettle();
      tester.getChat(0).check(unreadCount: 1);

      /// delete otherUser read message, check
      ws.addDeletedMessagesUpdate(
        const DeletedMessageUpdate(
          chatId: 0,
          deletedMessage: MessageDto(id: 999, chatId: 0, senderId: 0, isCurrentUser: false, message: '', isRead: true, createdAt: 999, editedAt: null, fromCache: false),
          newLastMessage: null,
        ),
      );
      await tester.pumpAndSettle();
      tester.getChat(0).check(unreadCount: 1);

      /// check, delete currentUser message with newLastMessage from otherUser, check
      tester.getChat(0).check(message: chatDto0.lastMessage!.message);
      ws.addDeletedMessagesUpdate(
        const DeletedMessageUpdate(
          chatId: 0,
          deletedMessage: MessageDto(id: 999, chatId: 0, senderId: 0, isCurrentUser: false, message: '', isRead: true, createdAt: 999, editedAt: null, fromCache: false),
          newLastMessage: MessageDto(id: 998, chatId: 0, senderId: 0, isCurrentUser: false, message: 'NEW_MSG', isRead: false, createdAt: 999, editedAt: null, fromCache: false),
        ),
      );
      await tester.pumpAndSettle();
      tester.getChat(0).check(message: 'NEW_MSG', msgFromCurrentUser: false);
      tester.getChat(0).check(unreadCount: 1);

      /// delete otherUser unread message with newLastMessage from currentUser, check
      ws.addDeletedMessagesUpdate(
        const DeletedMessageUpdate(
          chatId: 0,
          deletedMessage: MessageDto(id: 999, chatId: 0, senderId: 0, isCurrentUser: false, message: '', isRead: false, createdAt: 999, editedAt: null, fromCache: false),
          newLastMessage: MessageDto(id: 998, chatId: 0, senderId: 0, isCurrentUser: true, message: 'NEW_MSG_2', isRead: true, createdAt: 999, editedAt: null, fromCache: false),
        ),
      );
      await tester.pumpAndSettle();
      tester.getChat(0).check(message: 'NEW_MSG_2', msgFromCurrentUser: true);
      tester.getChat(0).check(unreadCount: 0);
    });

    testWidgets('delete_messages_chats_order_test', (tester) async {
      await setupAppWithChats(tester, [chatDto0, chatDto1, chatDto2, chatDto3, chatDto4]);

      /// current createdAts: [1090, 1080, 1070, 1060, 1050]
      /// check order, add newLastMessage to chat 0 with createdAt 1000, check order
      tester.checkChatsOrder([0, 1, 2, 3, 4]);
      ws.addDeletedMessagesUpdate(
        const DeletedMessageUpdate(
          chatId: 0,
          deletedMessage: MessageDto(id: 999, chatId: 0, senderId: 0, isCurrentUser: false, message: '', isRead: false, createdAt: 999, editedAt: null, fromCache: false),
          newLastMessage: MessageDto(id: 999, chatId: 0, senderId: 0, isCurrentUser: false, message: '', isRead: false, createdAt: 1000, editedAt: null, fromCache: false),
        ),
      );
      await tester.pumpAndSettle();
      tester.checkChatsOrder([1, 2, 3, 4, 0]);

      /// current createdAts: [1080, 1070, 1060, 1050, 1000]
      /// check order, add newLastMessage to chat 2 with createdAt 1055, check order
      ws.addDeletedMessagesUpdate(
        const DeletedMessageUpdate(
          chatId: 2,
          deletedMessage: MessageDto(id: 999, chatId: 2, senderId: 0, isCurrentUser: false, message: '', isRead: false, createdAt: 999, editedAt: null, fromCache: false),
          newLastMessage: MessageDto(id: 999, chatId: 2, senderId: 0, isCurrentUser: false, message: '', isRead: false, createdAt: 1055, editedAt: null, fromCache: false),
        ),
      );
      await tester.pumpAndSettle();
      tester.checkChatsOrder([1, 3, 2, 4, 0]);

      /// current createdAts: [1080, 1060, 1055, 1050, 1000]
      /// check order, add newLastMessage to chat 4 with createdAt 1052, check order
      ws.addDeletedMessagesUpdate(
        const DeletedMessageUpdate(
          chatId: 4,
          deletedMessage: MessageDto(id: 999, chatId: 4, senderId: 0, isCurrentUser: false, message: '', isRead: false, createdAt: 999, editedAt: null, fromCache: false),
          newLastMessage: MessageDto(id: 999, chatId: 4, senderId: 0, isCurrentUser: false, message: '', isRead: false, createdAt: 1052, editedAt: null, fromCache: false),
        ),
      );
      await tester.pumpAndSettle();
      tester.checkChatsOrder([1, 3, 2, 4, 0]);
    });

    testWidgets('cache_test', (tester) async {
      await setupAppWithChats(tester, [chatDto0, chatDto1, chatDto2, chatDto3, chatDto4], getChatsAsyncControl: true);

      /// check no chats on first start
      expect(find.byKey(const Key('chats_loading')), findsOneWidget);
      await sendGetChatsResponse(tester);
      expect(find.byKey(const Key('chats_loading')), findsNothing);
      tester
        ..checkChatsAppBarStatus(ChatsAppBarStatus.chats)
        ..checkChatsOrder([0, 1, 2, 3, 4]);

      /// check cachedChats, then new chats from api
      getChatsMustReturn([chatDto4, chatDto3, chatDto2, chatDto1], asyncControl: true);
      await restartApp(tester);
      tester
        ..checkChatsAppBarStatus(ChatsAppBarStatus.updating)
        ..checkChatsOrder([0, 1, 2, 3, 4]);
      await sendGetChatsResponse(tester);
      tester
        ..checkChatsAppBarStatus(ChatsAppBarStatus.chats)
        ..checkChatsOrder([4, 3, 2, 1]);
    });

    testWidgets('cache_new_message_test', (tester) async {
      await setupAppWithChats(tester, [chatDto0, chatDto1, chatDto2, chatDto3, chatDto4], getChatsAsyncControl: true);
      await sendGetChatsResponse(tester);

      /// check current chats
      tester
        ..checkChatsOrder([0, 1, 2, 3, 4])
        ..checkChatsAppBarStatus(ChatsAppBarStatus.chats);

      /// add new message, check chats
      const newMessage = MessageDto(id: 999, chatId: 2, senderId: 0, isCurrentUser: true, message: 'MSG_999', isRead: false, createdAt: 1100, editedAt: null, fromCache: false);
      ws.addMessage(newMessage);
      await tester.pumpAndSettle();
      tester.checkChatsOrder([2, 0, 1, 3, 4]);
      tester.getChat(2).check(message: 'MSG_999', msgFromCurrentUser: true);

      /// restart app, check cachedChats
      await restartApp(tester);
      tester
        ..checkChatsAppBarStatus(ChatsAppBarStatus.updating)
        ..checkChatsOrder([2, 0, 1, 3, 4]);
      tester.getChat(2).check(message: 'MSG_999', msgFromCurrentUser: true);

      /// send response, check new chats from api
      await sendGetChatsResponse(tester);
      tester
        ..checkChatsAppBarStatus(ChatsAppBarStatus.chats)
        ..checkChatsOrder([0, 1, 2, 3, 4]);
      tester.getChat(2).check(message: chatDto2.lastMessage!.message, msgFromCurrentUser: chatDto2.lastMessage!.isCurrentUser);

      /// restart app, check cachedChats
      await restartApp(tester);
      tester
        ..checkChatsAppBarStatus(ChatsAppBarStatus.updating)
        ..checkChatsOrder([0, 1, 2, 3, 4]);
      tester.getChat(2).check(message: chatDto2.lastMessage!.message, msgFromCurrentUser: chatDto2.lastMessage!.isCurrentUser);
    });

    testWidgets('new_message_from_new_chat_test', (tester) async {
      await setupAppWithChats(tester, [chatDto0, chatDto1]);

      /// wait for chats to load, check, add message, check
      await tester.pumpAndSettle(const Duration(milliseconds: 10));
      tester.checkChatsOrder([0, 1]);
      ws.addMessage(chatDto3.lastMessage!);
      await tester.pumpAndSettle();
      tester.checkChatsOrder([3, 0, 1]);
      tester.getChat(3).check(message: chatDto3.lastMessage!.message, msgFromCurrentUser: chatDto3.lastMessage!.isCurrentUser, otherUserName: chatDto3.otherUser.username);
    });

    testWidgets('online_status_test', (tester) async {
      await setupAppWithChats(tester, [chatDto1]);

      /// update online status to another user, check
      tester.getChat(1).check(isOnline: false);
      ws.addOnlineUpdate(OnlineStatusUpdate(userId: 1, isOnline: true, lastActivityTime: DateTime.now().millisecondsSinceEpoch));
      await tester.pumpAndSettle();
      tester.getChat(1).check(isOnline: false);

      /// update online to first chat user, check
      ws.addOnlineUpdate(OnlineStatusUpdate(userId: 2, isOnline: true, lastActivityTime: DateTime.now().millisecondsSinceEpoch));
      await tester.pumpAndSettle();
      tester.getChat(1).check(isOnline: true);

      /// update online to first chat user, check
      ws.addOnlineUpdate(OnlineStatusUpdate(userId: 2, isOnline: false, lastActivityTime: DateTime.now().millisecondsSinceEpoch));
      await tester.pumpAndSettle();
      tester.getChat(1).check(isOnline: false);
    });

    testWidgets('online_status_long_test', (tester) async {
      await setupAppWithChats(tester, [chatDto1]);

      /// update online, check, wait, check
      tester.getChat(1).check(isOnline: false);
      ws.addOnlineUpdate(
        OnlineStatusUpdate(
          userId: 2,
          isOnline: true,
          lastActivityTime: DateTime.now().millisecondsSinceEpoch - (AppConstants.markAsOfflineAfterInactivity - const Duration(seconds: 1)).inMilliseconds,
        ),
      );
      await tester.pumpAndSettle();
      tester.getChat(1).check(isOnline: true);
      await tester.pumpAndSettle(const Duration(milliseconds: 1500));
      tester.getChat(1).check(isOnline: false);

      /// again
      ws.addOnlineUpdate(
        OnlineStatusUpdate(
          userId: 2,
          isOnline: true,
          lastActivityTime: DateTime.now().millisecondsSinceEpoch - (AppConstants.markAsOfflineAfterInactivity - const Duration(seconds: 1)).inMilliseconds,
        ),
      );
      await tester.pumpAndSettle();
      tester.getChat(1).check(isOnline: true);
      await tester.pumpAndSettle(const Duration(milliseconds: 1500));
      tester.getChat(1).check(isOnline: false);
    });

    testWidgets('typing_and_new_message_test', (tester) async {
      await setupAppWithChats(tester, [chatDto0]);

      /// add typingUpdate to another chat, check
      tester.getChat(0).check(isTyping: false);
      ws.addTypingUpdate(const TypingActivityUpdate(chatId: 1, isTyping: true));
      await tester.pumpAndSettle();
      tester.getChat(0).check(isTyping: false);

      /// add typingUpdate to the first chat, check
      ws.addTypingUpdate(const TypingActivityUpdate(chatId: 0, isTyping: true));
      await tester.pumpAndSettle();
      tester.getChat(0).check(isTyping: true);

      /// add newMessage, check
      ws.addMessage(messageDto0);
      await tester.pumpAndSettle();
      tester.getChat(0).check(isTyping: false);
    });

    testWidgets('typing_long_test', (tester) async {
      await setupAppWithChats(tester, [chatDto0]);

      /// add typingUpdate, check
      tester.getChat(0).check(isTyping: false);
      ws.addTypingUpdate(const TypingActivityUpdate(chatId: 0, isTyping: true));
      await tester.pumpAndSettle();
      tester.getChat(0).check(isTyping: true);

      /// wait, check, wait, check
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      tester.getChat(0).check(isTyping: true);
      await tester.pumpAndSettle(const Duration(milliseconds: 1000));
      tester.getChat(0).check(isTyping: false);
    });

    testWidgets('all_messages_deleted_test', (tester) async {
      await setupAppWithChats(tester, [chatDto0]);

      tester.checkChatsOrder([0]);
      ws.addDeletedMessagesUpdate(const DeletedMessageUpdate(chatId: 0, deletedMessage: messageDto0, newLastMessage: null, deleteChat: true));
      await tester.pumpAndSettle();
      tester.checkChatsOrder([]);
    });

    testWidgets('delete_message_behind_app_cache_test', (tester) async {
      await setupAppWithChats(tester, [chatDto0]);

      /// lastMessage will be earlier that the current one, cause the current one is deleted
      getChatsMustReturn([ChatDto(id: chatDto0.id, otherUser: chatDto0.otherUser, lastMessage: messageDto1, unreadCount: chatDto0.unreadCount)], asyncControl: true);
      await restartApp(tester);
      tester.getChat(0).check(message: messageDto0.message);
      await sendGetChatsResponse(tester);
      tester.getChat(0).check(message: messageDto1.message);

      await restartApp(tester);
      tester.getChat(0).check(message: messageDto1.message);
      await sendGetChatsResponse(tester);
      tester.getChat(0).check(message: messageDto1.message);
    });

    testWidgets('incoming_call_test', (tester) async {
      await setupAppWithChats(tester, [chatDto2], getChatsAsyncControl: true);
      await sendGetChatsResponse(tester);

      /// send call message, check
      ws.addMessage(createCallMessage(callerId: 3, answererId: 0, callType: CallType.incoming, isRead: true));
      await tester.pumpAndSettle();
      tester.getChat(2).check(unreadCount: 0, message: 'Incoming Call', msgFromCurrentUser: false);

      /// check cache
      await restartApp(tester);
      tester.getChat(2).check(unreadCount: 0, message: 'Incoming Call');
    });

    testWidgets('outgoing_call_test', (tester) async {
      await setupAppWithChats(tester, [chatDto2], getChatsAsyncControl: true);
      await sendGetChatsResponse(tester);

      /// send call message, check
      ws.addMessage(createCallMessage(callerId: 0, answererId: 3, callType: CallType.outgoing, isRead: true));
      await tester.pumpAndSettle();
      tester.getChat(2).check(unreadCount: 0, message: 'Outgoing Call', msgFromCurrentUser: true);

      /// check cache
      await restartApp(tester);
      tester.getChat(2).check(unreadCount: 0, message: 'Outgoing Call', msgFromCurrentUser: true);
    });

    testWidgets('missed_call_test', (tester) async {
      await setupAppWithChats(tester, [chatDto2], getChatsAsyncControl: true);
      await sendGetChatsResponse(tester);

      /// check chat, send call message, check
      tester.getChat(2).check(unreadCount: 0);
      ws.addMessage(createCallMessage(callerId: 3, answererId: 0, callType: CallType.missed, isRead: false));
      await tester.pumpAndSettle();
      tester.getChat(2).check(unreadCount: 1, message: 'Missed Call', msgFromCurrentUser: false);

      /// check cache
      await restartApp(tester);
      tester.getChat(2).check(unreadCount: 1, message: 'Missed Call', msgFromCurrentUser: false);
    });

    testWidgets('canceled_call_test', (tester) async {
      await setupAppWithChats(tester, [chatDto2], getChatsAsyncControl: true);
      await sendGetChatsResponse(tester);

      /// send call message, check
      ws.addMessage(createCallMessage(callerId: 0, answererId: 3, callType: CallType.canceled, isRead: false));
      await tester.pumpAndSettle();
      tester.getChat(2).check(unreadCount: 0, message: 'Canceled Call', msgFromCurrentUser: true);

      /// check cache
      await restartApp(tester);
      tester.getChat(2).check(unreadCount: 0, message: 'Canceled Call', msgFromCurrentUser: true);
    });

    testWidgets('missed_and_incoming_call_test', (tester) async {
      await setupAppWithChats(tester, [chatDto2], getChatsAsyncControl: true);
      await sendGetChatsResponse(tester);

      /// check chat, send call message, check
      tester.getChat(2).check(unreadCount: 0);
      ws.addMessage(createCallMessage(callerId: 3, answererId: 0, callType: CallType.missed, isRead: false));
      await tester.pumpAndSettle();
      tester.getChat(2).check(unreadCount: 1, message: 'Missed Call', msgFromCurrentUser: false);

      /// send call message, check
      ws.addMessage(createCallMessage(callerId: 3, answererId: 0, callType: CallType.incoming, isRead: true, createdAt: 1210));
      await tester.pumpAndSettle();
      tester.getChat(2).check(unreadCount: 1, message: 'Incoming Call', msgFromCurrentUser: false);

      /// check cache
      await restartApp(tester);
      tester.getChat(2).check(unreadCount: 1, message: 'Incoming Call', msgFromCurrentUser: false);
    });

    /// TODO error cases test ?
    /// TODO find people navigation test ?
  });
}
