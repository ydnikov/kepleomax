// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Message {

 int get id; int get chatId; int get senderId; MessageUserType get userType; String get rawMessage; MessageType get type; bool get fromCache; bool get isReadByCurrentUser; DateTime get createdAt; DateTime? get editedAt; CallModel? get callData; int get viewsCount;
/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageCopyWith<Message> get copyWith => _$MessageCopyWithImpl<Message>(this as Message, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Message&&(identical(other.id, id) || other.id == id)&&(identical(other.chatId, chatId) || other.chatId == chatId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.userType, userType) || other.userType == userType)&&(identical(other.rawMessage, rawMessage) || other.rawMessage == rawMessage)&&(identical(other.type, type) || other.type == type)&&(identical(other.fromCache, fromCache) || other.fromCache == fromCache)&&(identical(other.isReadByCurrentUser, isReadByCurrentUser) || other.isReadByCurrentUser == isReadByCurrentUser)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.editedAt, editedAt) || other.editedAt == editedAt)&&(identical(other.callData, callData) || other.callData == callData)&&(identical(other.viewsCount, viewsCount) || other.viewsCount == viewsCount));
}


@override
int get hashCode => Object.hash(runtimeType,id,chatId,senderId,userType,rawMessage,type,fromCache,isReadByCurrentUser,createdAt,editedAt,callData,viewsCount);

@override
String toString() {
  return 'Message(id: $id, chatId: $chatId, senderId: $senderId, userType: $userType, rawMessage: $rawMessage, type: $type, fromCache: $fromCache, isRead: $isReadByCurrentUser, createdAt: $createdAt, editedAt: $editedAt, callData: $callData, viewsCount: $viewsCount)';
}


}

/// @nodoc
abstract mixin class $MessageCopyWith<$Res>  {
  factory $MessageCopyWith(Message value, $Res Function(Message) _then) = _$MessageCopyWithImpl;
@useResult
$Res call({
 int id, int chatId, int senderId, MessageUserType userType, String rawMessage, MessageType type, bool fromCache, bool isRead, DateTime createdAt, DateTime? editedAt, CallModel? callData, int viewsCount
});


$CallModelCopyWith<$Res>? get callData;

}
/// @nodoc
class _$MessageCopyWithImpl<$Res>
    implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._self, this._then);

  final Message _self;
  final $Res Function(Message) _then;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? chatId = null,Object? senderId = null,Object? userType = null,Object? rawMessage = null,Object? type = null,Object? fromCache = null,Object? isRead = null,Object? createdAt = null,Object? editedAt = freezed,Object? callData = freezed,Object? viewsCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as int,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as int,userType: null == userType ? _self.userType : userType // ignore: cast_nullable_to_non_nullable
as MessageUserType,rawMessage: null == rawMessage ? _self.rawMessage : rawMessage // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MessageType,fromCache: null == fromCache ? _self.fromCache : fromCache // ignore: cast_nullable_to_non_nullable
as bool,isRead: null == isRead ? _self.isReadByCurrentUser : isRead // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,editedAt: freezed == editedAt ? _self.editedAt : editedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,callData: freezed == callData ? _self.callData : callData // ignore: cast_nullable_to_non_nullable
as CallModel?,viewsCount: null == viewsCount ? _self.viewsCount : viewsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CallModelCopyWith<$Res>? get callData {
    if (_self.callData == null) {
    return null;
  }

  return $CallModelCopyWith<$Res>(_self.callData!, (value) {
    return _then(_self.copyWith(callData: value));
  });
}
}


/// Adds pattern-matching-related methods to [Message].
extension MessagePatterns on Message {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Message value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Message() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Message value)  $default,){
final _that = this;
switch (_that) {
case _Message():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Message value)?  $default,){
final _that = this;
switch (_that) {
case _Message() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int chatId,  int senderId,  MessageUserType userType,  String rawMessage,  MessageType type,  bool fromCache,  bool isRead,  DateTime createdAt,  DateTime? editedAt,  CallModel? callData,  int viewsCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Message() when $default != null:
return $default(_that.id,_that.chatId,_that.senderId,_that.userType,_that.rawMessage,_that.type,_that.fromCache,_that.isReadByCurrentUser,_that.createdAt,_that.editedAt,_that.callData,_that.viewsCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int chatId,  int senderId,  MessageUserType userType,  String rawMessage,  MessageType type,  bool fromCache,  bool isRead,  DateTime createdAt,  DateTime? editedAt,  CallModel? callData,  int viewsCount)  $default,) {final _that = this;
switch (_that) {
case _Message():
return $default(_that.id,_that.chatId,_that.senderId,_that.userType,_that.rawMessage,_that.type,_that.fromCache,_that.isReadByCurrentUser,_that.createdAt,_that.editedAt,_that.callData,_that.viewsCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int chatId,  int senderId,  MessageUserType userType,  String rawMessage,  MessageType type,  bool fromCache,  bool isRead,  DateTime createdAt,  DateTime? editedAt,  CallModel? callData,  int viewsCount)?  $default,) {final _that = this;
switch (_that) {
case _Message() when $default != null:
return $default(_that.id,_that.chatId,_that.senderId,_that.userType,_that.rawMessage,_that.type,_that.fromCache,_that.isReadByCurrentUser,_that.createdAt,_that.editedAt,_that.callData,_that.viewsCount);case _:
  return null;

}
}

}

/// @nodoc


class _Message extends Message {
  const _Message({required this.id, required this.chatId, required this.senderId, required this.userType, required this.rawMessage, required this.type, required this.fromCache, required this.isReadByCurrentUser, required this.createdAt, this.editedAt, this.callData, this.viewsCount = 0}): super._();
  

@override final  int id;
@override final  int chatId;
@override final  int senderId;
@override final  MessageUserType userType;
@override final  String rawMessage;
@override final  MessageType type;
@override final  bool fromCache;
@override final  bool isReadByCurrentUser;
@override final  DateTime createdAt;
@override final  DateTime? editedAt;
@override final  CallModel? callData;
@override@JsonKey() final  int viewsCount;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageCopyWith<_Message> get copyWith => __$MessageCopyWithImpl<_Message>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Message&&(identical(other.id, id) || other.id == id)&&(identical(other.chatId, chatId) || other.chatId == chatId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.userType, userType) || other.userType == userType)&&(identical(other.rawMessage, rawMessage) || other.rawMessage == rawMessage)&&(identical(other.type, type) || other.type == type)&&(identical(other.fromCache, fromCache) || other.fromCache == fromCache)&&(identical(other.isReadByCurrentUser, isReadByCurrentUser) || other.isReadByCurrentUser == isReadByCurrentUser)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.editedAt, editedAt) || other.editedAt == editedAt)&&(identical(other.callData, callData) || other.callData == callData)&&(identical(other.viewsCount, viewsCount) || other.viewsCount == viewsCount));
}


@override
int get hashCode => Object.hash(runtimeType,id,chatId,senderId,userType,rawMessage,type,fromCache,isReadByCurrentUser,createdAt,editedAt,callData,viewsCount);

@override
String toString() {
  return 'Message(id: $id, chatId: $chatId, senderId: $senderId, userType: $userType, rawMessage: $rawMessage, type: $type, fromCache: $fromCache, isRead: $isReadByCurrentUser, createdAt: $createdAt, editedAt: $editedAt, callData: $callData, viewsCount: $viewsCount)';
}


}

/// @nodoc
abstract mixin class _$MessageCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$MessageCopyWith(_Message value, $Res Function(_Message) _then) = __$MessageCopyWithImpl;
@override @useResult
$Res call({
 int id, int chatId, int senderId, MessageUserType userType, String rawMessage, MessageType type, bool fromCache, bool isRead, DateTime createdAt, DateTime? editedAt, CallModel? callData, int viewsCount
});


@override $CallModelCopyWith<$Res>? get callData;

}
/// @nodoc
class __$MessageCopyWithImpl<$Res>
    implements _$MessageCopyWith<$Res> {
  __$MessageCopyWithImpl(this._self, this._then);

  final _Message _self;
  final $Res Function(_Message) _then;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? chatId = null,Object? senderId = null,Object? userType = null,Object? rawMessage = null,Object? type = null,Object? fromCache = null,Object? isRead = null,Object? createdAt = null,Object? editedAt = freezed,Object? callData = freezed,Object? viewsCount = null,}) {
  return _then(_Message(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as int,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as int,userType: null == userType ? _self.userType : userType // ignore: cast_nullable_to_non_nullable
as MessageUserType,rawMessage: null == rawMessage ? _self.rawMessage : rawMessage // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MessageType,fromCache: null == fromCache ? _self.fromCache : fromCache // ignore: cast_nullable_to_non_nullable
as bool,isReadByCurrentUser: null == isRead ? _self.isReadByCurrentUser : isRead // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,editedAt: freezed == editedAt ? _self.editedAt : editedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,callData: freezed == callData ? _self.callData : callData // ignore: cast_nullable_to_non_nullable
as CallModel?,viewsCount: null == viewsCount ? _self.viewsCount : viewsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CallModelCopyWith<$Res>? get callData {
    if (_self.callData == null) {
    return null;
  }

  return $CallModelCopyWith<$Res>(_self.callData!, (value) {
    return _then(_self.copyWith(callData: value));
  });
}
}

// dart format on
