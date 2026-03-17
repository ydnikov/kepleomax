// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Chat {

 int get id; User get otherUser; Message? get lastMessage; bool get fromCache; int get unreadCount; MessageDraft? get draft; DateTime? get lastTypingActivityTime;
/// Create a copy of Chat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatCopyWith<Chat> get copyWith => _$ChatCopyWithImpl<Chat>(this as Chat, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Chat&&(identical(other.id, id) || other.id == id)&&(identical(other.otherUser, otherUser) || other.otherUser == otherUser)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&(identical(other.fromCache, fromCache) || other.fromCache == fromCache)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.lastTypingActivityTime, lastTypingActivityTime) || other.lastTypingActivityTime == lastTypingActivityTime));
}


@override
int get hashCode => Object.hash(runtimeType,id,otherUser,lastMessage,fromCache,unreadCount,draft,lastTypingActivityTime);

@override
String toString() {
  return 'Chat(id: $id, otherUser: $otherUser, lastMessage: $lastMessage, fromCache: $fromCache, unreadCount: $unreadCount, draft: $draft, lastTypingActivityTime: $lastTypingActivityTime)';
}


}

/// @nodoc
abstract mixin class $ChatCopyWith<$Res>  {
  factory $ChatCopyWith(Chat value, $Res Function(Chat) _then) = _$ChatCopyWithImpl;
@useResult
$Res call({
 int id, User otherUser, Message? lastMessage, bool fromCache, int unreadCount, MessageDraft? draft, DateTime? lastTypingActivityTime
});


$UserCopyWith<$Res> get otherUser;$MessageCopyWith<$Res>? get lastMessage;$MessageDraftCopyWith<$Res>? get draft;

}
/// @nodoc
class _$ChatCopyWithImpl<$Res>
    implements $ChatCopyWith<$Res> {
  _$ChatCopyWithImpl(this._self, this._then);

  final Chat _self;
  final $Res Function(Chat) _then;

/// Create a copy of Chat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? otherUser = null,Object? lastMessage = freezed,Object? fromCache = null,Object? unreadCount = null,Object? draft = freezed,Object? lastTypingActivityTime = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,otherUser: null == otherUser ? _self.otherUser : otherUser // ignore: cast_nullable_to_non_nullable
as User,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as Message?,fromCache: null == fromCache ? _self.fromCache : fromCache // ignore: cast_nullable_to_non_nullable
as bool,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,draft: freezed == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as MessageDraft?,lastTypingActivityTime: freezed == lastTypingActivityTime ? _self.lastTypingActivityTime : lastTypingActivityTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Chat
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get otherUser {
  
  return $UserCopyWith<$Res>(_self.otherUser, (value) {
    return _then(_self.copyWith(otherUser: value));
  });
}/// Create a copy of Chat
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessageCopyWith<$Res>? get lastMessage {
    if (_self.lastMessage == null) {
    return null;
  }

  return $MessageCopyWith<$Res>(_self.lastMessage!, (value) {
    return _then(_self.copyWith(lastMessage: value));
  });
}/// Create a copy of Chat
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessageDraftCopyWith<$Res>? get draft {
    if (_self.draft == null) {
    return null;
  }

  return $MessageDraftCopyWith<$Res>(_self.draft!, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}


/// Adds pattern-matching-related methods to [Chat].
extension ChatPatterns on Chat {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Chat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Chat() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Chat value)  $default,){
final _that = this;
switch (_that) {
case _Chat():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Chat value)?  $default,){
final _that = this;
switch (_that) {
case _Chat() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  User otherUser,  Message? lastMessage,  bool fromCache,  int unreadCount,  MessageDraft? draft,  DateTime? lastTypingActivityTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Chat() when $default != null:
return $default(_that.id,_that.otherUser,_that.lastMessage,_that.fromCache,_that.unreadCount,_that.draft,_that.lastTypingActivityTime);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  User otherUser,  Message? lastMessage,  bool fromCache,  int unreadCount,  MessageDraft? draft,  DateTime? lastTypingActivityTime)  $default,) {final _that = this;
switch (_that) {
case _Chat():
return $default(_that.id,_that.otherUser,_that.lastMessage,_that.fromCache,_that.unreadCount,_that.draft,_that.lastTypingActivityTime);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  User otherUser,  Message? lastMessage,  bool fromCache,  int unreadCount,  MessageDraft? draft,  DateTime? lastTypingActivityTime)?  $default,) {final _that = this;
switch (_that) {
case _Chat() when $default != null:
return $default(_that.id,_that.otherUser,_that.lastMessage,_that.fromCache,_that.unreadCount,_that.draft,_that.lastTypingActivityTime);case _:
  return null;

}
}

}

/// @nodoc


class _Chat extends Chat {
  const _Chat({required this.id, required this.otherUser, required this.lastMessage, required this.fromCache, required this.unreadCount, this.draft, this.lastTypingActivityTime}): super._();
  

@override final  int id;
@override final  User otherUser;
@override final  Message? lastMessage;
@override final  bool fromCache;
@override final  int unreadCount;
@override final  MessageDraft? draft;
@override final  DateTime? lastTypingActivityTime;

/// Create a copy of Chat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatCopyWith<_Chat> get copyWith => __$ChatCopyWithImpl<_Chat>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Chat&&(identical(other.id, id) || other.id == id)&&(identical(other.otherUser, otherUser) || other.otherUser == otherUser)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&(identical(other.fromCache, fromCache) || other.fromCache == fromCache)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.lastTypingActivityTime, lastTypingActivityTime) || other.lastTypingActivityTime == lastTypingActivityTime));
}


@override
int get hashCode => Object.hash(runtimeType,id,otherUser,lastMessage,fromCache,unreadCount,draft,lastTypingActivityTime);

@override
String toString() {
  return 'Chat(id: $id, otherUser: $otherUser, lastMessage: $lastMessage, fromCache: $fromCache, unreadCount: $unreadCount, draft: $draft, lastTypingActivityTime: $lastTypingActivityTime)';
}


}

/// @nodoc
abstract mixin class _$ChatCopyWith<$Res> implements $ChatCopyWith<$Res> {
  factory _$ChatCopyWith(_Chat value, $Res Function(_Chat) _then) = __$ChatCopyWithImpl;
@override @useResult
$Res call({
 int id, User otherUser, Message? lastMessage, bool fromCache, int unreadCount, MessageDraft? draft, DateTime? lastTypingActivityTime
});


@override $UserCopyWith<$Res> get otherUser;@override $MessageCopyWith<$Res>? get lastMessage;@override $MessageDraftCopyWith<$Res>? get draft;

}
/// @nodoc
class __$ChatCopyWithImpl<$Res>
    implements _$ChatCopyWith<$Res> {
  __$ChatCopyWithImpl(this._self, this._then);

  final _Chat _self;
  final $Res Function(_Chat) _then;

/// Create a copy of Chat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? otherUser = null,Object? lastMessage = freezed,Object? fromCache = null,Object? unreadCount = null,Object? draft = freezed,Object? lastTypingActivityTime = freezed,}) {
  return _then(_Chat(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,otherUser: null == otherUser ? _self.otherUser : otherUser // ignore: cast_nullable_to_non_nullable
as User,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as Message?,fromCache: null == fromCache ? _self.fromCache : fromCache // ignore: cast_nullable_to_non_nullable
as bool,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,draft: freezed == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as MessageDraft?,lastTypingActivityTime: freezed == lastTypingActivityTime ? _self.lastTypingActivityTime : lastTypingActivityTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Chat
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get otherUser {
  
  return $UserCopyWith<$Res>(_self.otherUser, (value) {
    return _then(_self.copyWith(otherUser: value));
  });
}/// Create a copy of Chat
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessageCopyWith<$Res>? get lastMessage {
    if (_self.lastMessage == null) {
    return null;
  }

  return $MessageCopyWith<$Res>(_self.lastMessage!, (value) {
    return _then(_self.copyWith(lastMessage: value));
  });
}/// Create a copy of Chat
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessageDraftCopyWith<$Res>? get draft {
    if (_self.draft == null) {
    return null;
  }

  return $MessageDraftCopyWith<$Res>(_self.draft!, (value) {
    return _then(_self.copyWith(draft: value));
  });
}
}

// dart format on
