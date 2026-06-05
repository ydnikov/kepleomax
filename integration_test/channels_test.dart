// dart format width=250

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kepleomax/core/app.dart';
import 'package:kepleomax/core/data/local_data_sources/local_database_manager.dart';
import 'package:kepleomax/core/data/models/channel_update.dart';
import 'package:kepleomax/core/di/dependencies.dart';
import 'package:kepleomax/core/flavor.dart';
import 'package:kepleomax/core/models/chat.dart';
import 'package:kepleomax/core/models/user.dart';
import 'package:kepleomax/core/network/apis/chats/chats_dtos.dart';
import 'package:kepleomax/core/network/websockets/klm_web_socket.dart';
import 'package:kepleomax/core/network/websockets/messenger_web_socket.dart';
import 'package:kepleomax/core/network/websockets/models/channel_subscription_update.dart';
import 'package:kepleomax/core/network/websockets/models/channel_unsubscription_update.dart';

import 'di/initialize_tests_dependencies.dart';
import 'mocks/mock_klm_web_socket.dart';
import 'mocks/mock_messages_web_socket.dart';
import 'utils/mock_objects.dart';
import 'utils/mock_utils.dart';
import 'utils/utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized().framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  group('channels_tests', () {
    late Dependencies dp;
    late MockMessengerWebSocket ws;
    late MockKlmWebSocket baseWs;

    /// test lifecycle
    setUpAll(() {
      Flavor.setFlavor(Flavor.testing());
    });

    setUp(() async {
      dp = await initializeTestsDependencies();
      await dp.authController.setUser(User.testing());
    });

    tearDown(() async {
      await LocalDatabaseManager.reset();
    });

    /// setup methods
    Future<void> pumpAppWidgetAndSetupDi(WidgetTester tester) async {
      await tester.pumpWidget(dp.inject(child: const App()));
      ws = dp.read<MessengerWebSocket>() as MockMessengerWebSocket;
      baseWs = dp.read<KlmWebSocket>() as MockKlmWebSocket;
    }

    Future<void> setupApp(WidgetTester tester, {required List<ChatDto> initialChats, bool openFirstChat = false}) async {
      getChatsMustReturn(dp, initialChats);

      await pumpAppWidgetAndSetupDi(tester);
      baseWs.setIsConnected(true);
      await tester.pumpAndSettle();

      if (openFirstChat) {
        getMessagesMustReturn(dp, []);
        getSubsCountMustReturn(dp, 2);
        await tester.tap(find.byKey(Key('chat_${initialChats[0].id}')));
        await tester.pumpAndSettle();
      }
    }

    /// tests
    testWidgets('sub_unsub_on_chats_screen', (tester) async {
      await setupApp(tester, initialChats: []);

      /// check
      tester.checkChatsOrder([]);

      /// add subEvent, check
      ws.addSubChannel(ChannelSubscriptionUpdate(chat: Chat.fromDto(chatChannelDto0)));
      await tester.pumpAndSettle();
      tester.checkChatsOrder([0]);
      tester.getChat(0).check(unreadCount: 0, name: chatChannelDto0.channelData!.channelName);

      /// add unsubEvent with other chatId, check
      ws.addUnsubChannel(const ChannelUnsubscriptionUpdate(channelId: 1, subsCount: 0));
      await tester.pumpAndSettle();
      tester.checkChatsOrder([0]);

      /// add unsubEvent, check
      ws.addUnsubChannel(const ChannelUnsubscriptionUpdate(channelId: 0, subsCount: 0));
      await tester.pumpAndSettle();
      tester.checkChatsOrder([]);
    });

    testWidgets('sub_unsub_on_chat_screen', (tester) async {
      await setupApp(tester, initialChats: [chatChannelDto0], openFirstChat: true);

      /// check
      tester
        ..checkChannelBottom(UserChannelRole.subscriber)
        ..checkSubsCountOnChatScreen('2 subscribers');

      /// add unsubEvent with other chatId, check
      ws.addUnsubChannel(const ChannelUnsubscriptionUpdate(channelId: 1, subsCount: 0));
      await tester.pumpAndSettle();
      tester
        ..checkChannelBottom(UserChannelRole.subscriber)
        ..checkSubsCountOnChatScreen('2 subscribers');

      /// add unsubEvent, check
      ws.addUnsubChannel(const ChannelUnsubscriptionUpdate(channelId: 0, subsCount: 1));
      await tester.pumpAndSettle();
      tester
        ..checkChannelBottom(UserChannelRole.none)
        ..checkSubsCountOnChatScreen('1 subscriber');

      /// add subEvent, check
      final chat = Chat.fromDto(chatChannelDto0);
      final chatWithSubsCount = chat.copyWith(channelData: chat.channelData!.copyWith(subsCount: 2));
      ws.addSubChannel(ChannelSubscriptionUpdate(chat: chatWithSubsCount));
      await tester.pumpAndSettle();
      tester
        ..checkChannelBottom(UserChannelRole.subscriber)
        ..checkSubsCountOnChatScreen('2 subscribers');
      ;
    });

    testWidgets('update_on_chats_screen', (tester) async {
      await setupApp(tester, initialChats: [chatChannelDto0]);

      /// check
      tester.checkChatsOrder([0]);
      tester.getChat(0).check(name: chatChannelDto0.channelData!.channelName);

      /// add update with other channelId, check
      ws.addChannelUpdateEvent(ChannelUpdate(channelId: 1, newChannelData: ChannelData.fromDto(chatChannelDto1.channelData!)));
      await tester.pumpAndSettle();
      tester.getChat(0).check(name: chatChannelDto0.channelData!.channelName);

      /// add update, check
      ws.addChannelUpdateEvent(
        ChannelUpdate(
          channelId: 0,
          newChannelData: ChannelData.fromDto(ChannelDataDto(id: 0, channelName: chatChannelDto1.channelData!.channelName, description: '', image: null, isOfficial: false, userChannelRole: UserChannelRoleDto.subscriber, tag: 'tag', subsCount: 2)),
        ),
      );
      await tester.pumpAndSettle();
      tester.getChat(0).check(name: chatChannelDto1.channelData!.channelName);
    });

    testWidgets('update_on_chat_screen', (tester) async {
      await setupApp(tester, initialChats: [chatChannelDto0], openFirstChat: true);

      /// check
      tester.checkChatName(chatChannelDto0.channelData!.channelName);

      /// add update with other channelId, check
      ws.addChannelUpdateEvent(ChannelUpdate(channelId: 1, newChannelData: ChannelData.fromDto(chatChannelDto1.channelData!)));
      await tester.pumpAndSettle();
      tester.checkChatName(chatChannelDto0.channelData!.channelName);

      /// add update, check
      ws.addChannelUpdateEvent(
        ChannelUpdate(
          channelId: 0,
          newChannelData: ChannelData.fromDto(ChannelDataDto(id: 0, channelName: chatChannelDto1.channelData!.channelName, description: '', image: null, isOfficial: false, userChannelRole: UserChannelRoleDto.subscriber, tag: 'tag', subsCount: 88)),
        ),
      );
      await tester.pumpAndSettle();
      tester
        ..checkChatName(chatChannelDto1.channelData!.channelName)
        ..checkChannelBottom(UserChannelRole.subscriber)
        ..checkSubsCountOnChatScreen('88 subscribers');
    });
  });
}
