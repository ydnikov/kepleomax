import 'dart:math';

import 'package:kepleomax/core/models/chat.dart';

/// in case of channels, createdAt - time at which user was subscribed
/// in case of chats, it's impossible to createdAt be greater than lastMessage.createdAt
int Function(Chat, Chat)? get chatsSort => (a, b) {
  final bValue = _maxBNullable(
    b.createdAt.millisecondsSinceEpoch,
    b.lastMessage?.createdAt.millisecondsSinceEpoch,
  );
  final aValue = _maxBNullable(
    a.createdAt.millisecondsSinceEpoch,
    a.lastMessage?.createdAt.millisecondsSinceEpoch,
  );

  return bValue - aValue;

  // return (b.lastMessage?.createdAt.millisecondsSinceEpoch ?? b.createdAt) -
  //     (a.lastMessage?.createdAt.millisecondsSinceEpoch ?? a.createdAt);
};

int _maxBNullable(int a, int? b) {
  if (b == null) {
    return a;
  } else {
    return max(a, b);
  }
}
