import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kepleomax/core/app_constants.dart';
import 'package:kepleomax/core/di/dependencies.dart';
import 'package:kepleomax/core/network/apis/channels/channel_dtos.dart';
import 'package:kepleomax/core/network/apis/chats/chats_dtos.dart';
import 'package:kepleomax/core/network/apis/messages/message_dtos.dart';
import 'package:mockito/mockito.dart';
import 'package:retrofit/dio.dart';

import '../mocks/mockito_mocks.mocks.dart';
import 'utils.dart';

late Completer<void> _getChatsCompleter;

Future<void> sendGetChatsResponse(WidgetTester tester) =>
    tester.sendResponse(_getChatsCompleter);

void getChatsMustReturn(
  Dependencies dp,
  List<ChatDto> chats, {
  bool asyncControl = false,
}) {
  when(dp.chatsApi.getChats()).thenAnswer((_) async {
    if (asyncControl) {
      _getChatsCompleter = Completer();
      await _getChatsCompleter.future;
    }

    return HttpResponse(
      ChatsResponse(data: chats, message: null),
      Response(requestOptions: RequestOptions(), statusCode: 200),
    );
  });
}

late Completer<void> _getChatWithIdCompleter;

Future<void> sendGetChatWithIdResponse(WidgetTester tester) =>
    tester.sendResponse(_getChatWithIdCompleter);

void getChatWithIdMustReturn(
  Dependencies dp,
  ChatDto? Function(int) factory, {
  bool asyncControl = false,
}) {
  when(
    (dp.chatsApi as MockChatsApi).getChatWithId(chatId: anyNamed('chatId')),
  ).thenAnswer((inv) async {
    if (asyncControl) {
      _getChatWithIdCompleter = Completer();
      await _getChatWithIdCompleter.future;
    }
    final chat = factory(int.parse(inv.namedArguments[#chatId] as String));
    return HttpResponse(
      ChatResponse(data: chat, message: null),
      Response(
        requestOptions: RequestOptions(),
        statusCode: chat == null ? 404 : 200,
      ),
    );
  });
}

late Completer<void> _getMessagesCompleter;

Future<void> sendGetMessagesResponse(WidgetTester tester) =>
    tester.sendResponse(_getMessagesCompleter);

void getMessagesMustReturn(
  Dependencies dp,
  List<MessageDto> messages, {
  int chatId = 0,
  bool asyncControl = false,
}) {
  when(
    dp.messagesApi.getMessages(
      chatId: chatId,
      limit: AppConstants.msgPagingLimit,
      cursor: null,
    ),
  ).thenAnswer((_) async {
    if (asyncControl) {
      _getMessagesCompleter = Completer();
      await _getMessagesCompleter.future;
    }
    return HttpResponse(
      MessagesResponse(data: messages, message: null),
      Response(requestOptions: RequestOptions(), statusCode: 200),
    );
  });
}

void getSubsCountMustReturn(Dependencies dp, int subsCount, {int chatId = 0}) {
  when(dp.channelApi.getSubscribersCount(channelId: chatId)).thenAnswer((_) async {
    return HttpResponse(
      GetSubscribersCountResponseDto(count: subsCount, message: null),
      Response(requestOptions: RequestOptions(), statusCode: 200),
    );
  });
}

void getChatWithUserMustReturn(Dependencies dp, ChatDto? chat, {int userId = 1}) {
  when(dp.chatsApi.getChatWithUser(otherUserId: userId)).thenAnswer(
    (_) async => HttpResponse(
      ChatResponse(data: chat, message: null),
      Response(
        requestOptions: RequestOptions(),
        statusCode: chat == null ? 404 : 200,
      ),
    ),
  );
}
