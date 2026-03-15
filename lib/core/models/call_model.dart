import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kepleomax/core/scopes/auth_scope.dart';

part 'call_model.freezed.dart';

@Freezed(fromJson: false, toJson: false)
abstract class CallModel with _$CallModel {
  const factory CallModel({
    required int id,
    required int callerId,
    required int answererId,
    required DateTime? startTime,
    required DateTime? endTime,
    required DateTime createdAt,
  }) = _CallModel;

  factory CallModel.fromJson(Map<String, dynamic> json) => CallModel(
    id: json['id'] as int,
    callerId: json['caller_id'] as int,
    answererId: json['answerer_id'] as int,
    startTime: json['start_time'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(json['start_time'] as int),
    endTime: json['end_time'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(json['end_time'] as int),
    createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at'] as int),
  );

  const CallModel._();

  CallType getCallType() {
    final userId = AuthScope.userOf(authScopeGlobalKey.currentContext!).id;

    if (startTime != null && endTime != null) {
      if (callerId == userId) {
        return CallType.outgoing;
      } else {
        return CallType.incoming;
      }
    } else if (startTime == null && endTime != null) {
      if (callerId == userId) {
        return CallType.canceled;
      } else {
        return CallType.missed;
      }
    } else if (startTime != null && endTime == null) {
      return CallType.active;
    } else {
      /// (startTime == null && endTime == null)
      return CallType.pending;
    }
  }
}

enum CallType {
  outgoing('Outgoing Call'),
  incoming('Incoming Call'),
  canceled('Canceled Call'),
  missed('Missed Call'),
  active('Active Call'),
  pending('Pending Call');

  const CallType(this.userString);

  final String userString;

  IconData get arrowIcon {
    switch (this) {
      case CallType.outgoing:
      case CallType.incoming:
      case CallType.canceled:
        return Icons.call_made;
      case CallType.missed:
        return Icons.call_received;
      case CallType.active:
      case CallType.pending:
        return Icons.call;
    }
  }

  Color get arrowColor {
    switch (this) {
      case CallType.outgoing:
      case CallType.incoming:
        return Colors.green;
      case CallType.missed:
      case CallType.canceled:
        return Colors.red;
      case CallType.active:
      case CallType.pending:
        return Colors.black;
    }
  }
}
