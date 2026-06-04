// dart format width=200

import 'package:kepleomax/core/models/call_model.dart';
import 'package:kepleomax/core/network/apis/chats/chats_dtos.dart';
import 'package:kepleomax/core/network/apis/messages/message_dtos.dart';
import 'package:kepleomax/core/network/common/user_dto.dart';

final chatDto0 = ChatDto(
  id: 0,
  otherUser: UserDto(id: 1, username: 'OTHER_USERNAME_1', profileImage: null, isCurrent: false, isOnline: true, lastActivityTime: DateTime.now().millisecondsSinceEpoch),
  lastMessage: messageDto0,
  unreadCount: 2,
  channelData: null,
  createdAt: 0,
);

const chatDto1 = ChatDto(
  id: 1,
  otherUser: UserDto(id: 2, username: 'OTHER_USERNAME_2', profileImage: null, isCurrent: false, isOnline: true, lastActivityTime: 0),
  lastMessage: MessageDto(id: 1, chatId: 1, senderId: 2, isCurrentUser: false, message: 'MSG_1', type: 'message', isRead: false, createdAt: 1080, editedAt: null, fromCache: false),
  unreadCount: 4,
  channelData: null,
  createdAt: 0,
);

const chatDto2 = ChatDto(
  id: 2,
  otherUser: UserDto(id: 3, username: 'OTHER_USERNAME_3', profileImage: null, isCurrent: false, isOnline: false, lastActivityTime: 0),
  lastMessage: MessageDto(id: 2, chatId: 2, senderId: 0, isCurrentUser: true, message: 'MSG_2', type: 'message', isRead: false, createdAt: 1070, editedAt: null, fromCache: false),
  unreadCount: 0,
  channelData: null,
  createdAt: 0,
);

const chatDto3 = ChatDto(
  id: 3,
  otherUser: UserDto(id: 4, username: 'OTHER_USERNAME_4', profileImage: null, isCurrent: false, isOnline: false, lastActivityTime: 0),
  lastMessage: MessageDto(id: 3, chatId: 3, senderId: 0, isCurrentUser: true, message: 'MSG_3', type: 'message', isRead: true, createdAt: 1060, editedAt: null, fromCache: false),
  unreadCount: 0,
  channelData: null,
  createdAt: 0,
);

const chatDto4 = ChatDto(
  id: 4,
  otherUser: UserDto(id: 5, username: 'OTHER_USERNAME_5', profileImage: null, isCurrent: false, isOnline: false, lastActivityTime: 0),
  lastMessage: MessageDto(id: 4, chatId: 4, senderId: 5, isCurrentUser: false, message: 'MSG_4', type: 'message', isRead: true, createdAt: 1050, editedAt: null, fromCache: false),
  unreadCount: 0,
  channelData: null,
  createdAt: 0,
);

final chatChannelDto0 = ChatDto(
  id: 0,
  otherUser: UserDto.empty(),
  lastMessage: null,
  unreadCount: 0,
  createdAt: 1000,
  channelData: const ChannelDataDto(
    id: 0,
    channelName: 'CHANNEL_NAME_0',
    description: 'CHANNEL_0_DESCRIPTION',
    image: null,
    isOfficial: false,
    userChannelRole: UserChannelRoleDto.subscriber,
    tag: 'CHANNEL_0',
  ),
);

final chatChannelDto1 = ChatDto(
  id: 1,
  otherUser: UserDto.empty(),
  lastMessage: null,
  unreadCount: 0,
  createdAt: 2000,
  channelData: const ChannelDataDto(
    id: 1,
    channelName: 'CHANNEL_NAME_1',
    description: 'CHANNEL_1_DESCRIPTION',
    image: null,
    isOfficial: false,
    userChannelRole: UserChannelRoleDto.subscriber,
    tag: 'CHANNEL_1',
  ),
);

const messageDto0 = MessageDto(id: 0, chatId: 0, senderId: 1, isCurrentUser: false, message: 'MSG_0', type: 'message', isRead: false, createdAt: 1090, editedAt: null, fromCache: false);
const messageDto1 = MessageDto(id: 1, chatId: 0, senderId: 1, isCurrentUser: false, message: 'MSG_1', type: 'message', isRead: false, createdAt: 1080, editedAt: null, fromCache: false);
const messageDto2 = MessageDto(id: 2, chatId: 0, senderId: 1, isCurrentUser: false, message: 'MSG_2', type: 'message', isRead: true, createdAt: 1070, editedAt: null, fromCache: false);
const messageDto3 = MessageDto(id: 3, chatId: 0, senderId: 0, isCurrentUser: true, message: 'MSG_3', type: 'message', isRead: false, createdAt: 1060, editedAt: null, fromCache: false);
const messageDto4 = MessageDto(id: 4, chatId: 0, senderId: 0, isCurrentUser: true, message: 'MSG_4', type: 'message', isRead: true, createdAt: 1050, editedAt: null, fromCache: false);

List<MessageDto> generateMessages(int from, int count, {int chatId = 0}) => List.generate(
  count,
  (i) => MessageDto(id: i + from, chatId: chatId, senderId: 1, isCurrentUser: false, message: 'MSG_${i + from}', type: 'message', isRead: true, createdAt: 800, editedAt: null, fromCache: false),
);

MessageDto createCallMessage({required int callerId, required int answererId, required CallType callType, required bool isRead, int createdAt = 1200}) {
  final bool hasStartTime = callType == CallType.active || callType == CallType.outgoing || callType == CallType.incoming;
  final bool hasEndTime = callType == CallType.missed || callType == CallType.canceled || callType == CallType.outgoing || callType == CallType.incoming;
  return MessageDto(
    id: 11,
    chatId: 2,
    senderId: callerId,
    isCurrentUser: callerId == 0,
    message: '{"id": 0, "caller_id": $callerId, "answerer_id": $answererId, ${hasStartTime ? '"start_time": 950, ' : ''}${hasEndTime ? '"end_time": 990, ' : ''}"created_at": $createdAt}',
    type: 'call',
    isRead: isRead,
    createdAt: createdAt,
    editedAt: null,
    fromCache: false,
  );
}
