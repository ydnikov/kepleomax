import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_draft.freezed.dart';

@freezed
abstract class MessageDraft with _$MessageDraft {
  const factory MessageDraft({
    required String message,
    required int chatId,
    required int createdAt,
  }) = _MessageDraft;
}
