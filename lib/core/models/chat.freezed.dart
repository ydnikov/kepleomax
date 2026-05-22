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

 int get id; User get otherUser; ChannelData? get channelData; Message? get lastMessage; bool get fromCache; int get unreadCount; MessageDraft? get draft; DateTime? get lastTypingActivityTime;
/// Create a copy of Chat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatCopyWith<Chat> get copyWith => _$ChatCopyWithImpl<Chat>(this as Chat, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Chat&&(identical(other.id, id) || other.id == id)&&(identical(other.otherUser, otherUser) || other.otherUser == otherUser)&&(identical(other.channelData, channelData) || other.channelData == channelData)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&(identical(other.fromCache, fromCache) || other.fromCache == fromCache)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.lastTypingActivityTime, lastTypingActivityTime) || other.lastTypingActivityTime == lastTypingActivityTime));
}


@override
int get hashCode => Object.hash(runtimeType,id,otherUser,channelData,lastMessage,fromCache,unreadCount,draft,lastTypingActivityTime);

@override
String toString() {
  return 'Chat(id: $id, otherUser: $otherUser, channelData: $channelData, lastMessage: $lastMessage, fromCache: $fromCache, unreadCount: $unreadCount, draft: $draft, lastTypingActivityTime: $lastTypingActivityTime)';
}


}

/// @nodoc
abstract mixin class $ChatCopyWith<$Res>  {
  factory $ChatCopyWith(Chat value, $Res Function(Chat) _then) = _$ChatCopyWithImpl;
@useResult
$Res call({
 int id, User otherUser, ChannelData? channelData, Message? lastMessage, bool fromCache, int unreadCount, MessageDraft? draft, DateTime? lastTypingActivityTime
});


$UserCopyWith<$Res> get otherUser;$ChannelDataCopyWith<$Res>? get channelData;$MessageCopyWith<$Res>? get lastMessage;$MessageDraftCopyWith<$Res>? get draft;

}
/// @nodoc
class _$ChatCopyWithImpl<$Res>
    implements $ChatCopyWith<$Res> {
  _$ChatCopyWithImpl(this._self, this._then);

  final Chat _self;
  final $Res Function(Chat) _then;

/// Create a copy of Chat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? otherUser = null,Object? channelData = freezed,Object? lastMessage = freezed,Object? fromCache = null,Object? unreadCount = null,Object? draft = freezed,Object? lastTypingActivityTime = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,otherUser: null == otherUser ? _self.otherUser : otherUser // ignore: cast_nullable_to_non_nullable
as User,channelData: freezed == channelData ? _self.channelData : channelData // ignore: cast_nullable_to_non_nullable
as ChannelData?,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
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
$ChannelDataCopyWith<$Res>? get channelData {
    if (_self.channelData == null) {
    return null;
  }

  return $ChannelDataCopyWith<$Res>(_self.channelData!, (value) {
    return _then(_self.copyWith(channelData: value));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  User otherUser,  ChannelData? channelData,  Message? lastMessage,  bool fromCache,  int unreadCount,  MessageDraft? draft,  DateTime? lastTypingActivityTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Chat() when $default != null:
return $default(_that.id,_that.otherUser,_that.channelData,_that.lastMessage,_that.fromCache,_that.unreadCount,_that.draft,_that.lastTypingActivityTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  User otherUser,  ChannelData? channelData,  Message? lastMessage,  bool fromCache,  int unreadCount,  MessageDraft? draft,  DateTime? lastTypingActivityTime)  $default,) {final _that = this;
switch (_that) {
case _Chat():
return $default(_that.id,_that.otherUser,_that.channelData,_that.lastMessage,_that.fromCache,_that.unreadCount,_that.draft,_that.lastTypingActivityTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  User otherUser,  ChannelData? channelData,  Message? lastMessage,  bool fromCache,  int unreadCount,  MessageDraft? draft,  DateTime? lastTypingActivityTime)?  $default,) {final _that = this;
switch (_that) {
case _Chat() when $default != null:
return $default(_that.id,_that.otherUser,_that.channelData,_that.lastMessage,_that.fromCache,_that.unreadCount,_that.draft,_that.lastTypingActivityTime);case _:
  return null;

}
}

}

/// @nodoc


class _Chat extends Chat {
  const _Chat({required this.id, required this.otherUser, required this.channelData, required this.lastMessage, required this.fromCache, required this.unreadCount, this.draft, this.lastTypingActivityTime}): super._();
  

@override final  int id;
@override final  User otherUser;
@override final  ChannelData? channelData;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Chat&&(identical(other.id, id) || other.id == id)&&(identical(other.otherUser, otherUser) || other.otherUser == otherUser)&&(identical(other.channelData, channelData) || other.channelData == channelData)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&(identical(other.fromCache, fromCache) || other.fromCache == fromCache)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.lastTypingActivityTime, lastTypingActivityTime) || other.lastTypingActivityTime == lastTypingActivityTime));
}


@override
int get hashCode => Object.hash(runtimeType,id,otherUser,channelData,lastMessage,fromCache,unreadCount,draft,lastTypingActivityTime);

@override
String toString() {
  return 'Chat(id: $id, otherUser: $otherUser, channelData: $channelData, lastMessage: $lastMessage, fromCache: $fromCache, unreadCount: $unreadCount, draft: $draft, lastTypingActivityTime: $lastTypingActivityTime)';
}


}

/// @nodoc
abstract mixin class _$ChatCopyWith<$Res> implements $ChatCopyWith<$Res> {
  factory _$ChatCopyWith(_Chat value, $Res Function(_Chat) _then) = __$ChatCopyWithImpl;
@override @useResult
$Res call({
 int id, User otherUser, ChannelData? channelData, Message? lastMessage, bool fromCache, int unreadCount, MessageDraft? draft, DateTime? lastTypingActivityTime
});


@override $UserCopyWith<$Res> get otherUser;@override $ChannelDataCopyWith<$Res>? get channelData;@override $MessageCopyWith<$Res>? get lastMessage;@override $MessageDraftCopyWith<$Res>? get draft;

}
/// @nodoc
class __$ChatCopyWithImpl<$Res>
    implements _$ChatCopyWith<$Res> {
  __$ChatCopyWithImpl(this._self, this._then);

  final _Chat _self;
  final $Res Function(_Chat) _then;

/// Create a copy of Chat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? otherUser = null,Object? channelData = freezed,Object? lastMessage = freezed,Object? fromCache = null,Object? unreadCount = null,Object? draft = freezed,Object? lastTypingActivityTime = freezed,}) {
  return _then(_Chat(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,otherUser: null == otherUser ? _self.otherUser : otherUser // ignore: cast_nullable_to_non_nullable
as User,channelData: freezed == channelData ? _self.channelData : channelData // ignore: cast_nullable_to_non_nullable
as ChannelData?,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
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
$ChannelDataCopyWith<$Res>? get channelData {
    if (_self.channelData == null) {
    return null;
  }

  return $ChannelDataCopyWith<$Res>(_self.channelData!, (value) {
    return _then(_self.copyWith(channelData: value));
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

/// @nodoc
mixin _$ChannelData {

 String get name; bool get isOfficial; bool get currentUserIsOwner;
/// Create a copy of ChannelData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChannelDataCopyWith<ChannelData> get copyWith => _$ChannelDataCopyWithImpl<ChannelData>(this as ChannelData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChannelData&&(identical(other.name, name) || other.name == name)&&(identical(other.isOfficial, isOfficial) || other.isOfficial == isOfficial)&&(identical(other.currentUserIsOwner, currentUserIsOwner) || other.currentUserIsOwner == currentUserIsOwner));
}


@override
int get hashCode => Object.hash(runtimeType,name,isOfficial,currentUserIsOwner);

@override
String toString() {
  return 'ChannelData(name: $name, isOfficial: $isOfficial, currentUserIsOwner: $currentUserIsOwner)';
}


}

/// @nodoc
abstract mixin class $ChannelDataCopyWith<$Res>  {
  factory $ChannelDataCopyWith(ChannelData value, $Res Function(ChannelData) _then) = _$ChannelDataCopyWithImpl;
@useResult
$Res call({
 String name, bool isOfficial, bool currentUserIsOwner
});




}
/// @nodoc
class _$ChannelDataCopyWithImpl<$Res>
    implements $ChannelDataCopyWith<$Res> {
  _$ChannelDataCopyWithImpl(this._self, this._then);

  final ChannelData _self;
  final $Res Function(ChannelData) _then;

/// Create a copy of ChannelData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? isOfficial = null,Object? currentUserIsOwner = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isOfficial: null == isOfficial ? _self.isOfficial : isOfficial // ignore: cast_nullable_to_non_nullable
as bool,currentUserIsOwner: null == currentUserIsOwner ? _self.currentUserIsOwner : currentUserIsOwner // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChannelData].
extension ChannelDataPatterns on ChannelData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChannelData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChannelData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChannelData value)  $default,){
final _that = this;
switch (_that) {
case _ChannelData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChannelData value)?  $default,){
final _that = this;
switch (_that) {
case _ChannelData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  bool isOfficial,  bool currentUserIsOwner)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChannelData() when $default != null:
return $default(_that.name,_that.isOfficial,_that.currentUserIsOwner);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  bool isOfficial,  bool currentUserIsOwner)  $default,) {final _that = this;
switch (_that) {
case _ChannelData():
return $default(_that.name,_that.isOfficial,_that.currentUserIsOwner);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  bool isOfficial,  bool currentUserIsOwner)?  $default,) {final _that = this;
switch (_that) {
case _ChannelData() when $default != null:
return $default(_that.name,_that.isOfficial,_that.currentUserIsOwner);case _:
  return null;

}
}

}

/// @nodoc


class _ChannelData implements ChannelData {
  const _ChannelData({required this.name, required this.isOfficial, required this.currentUserIsOwner});
  

@override final  String name;
@override final  bool isOfficial;
@override final  bool currentUserIsOwner;

/// Create a copy of ChannelData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChannelDataCopyWith<_ChannelData> get copyWith => __$ChannelDataCopyWithImpl<_ChannelData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChannelData&&(identical(other.name, name) || other.name == name)&&(identical(other.isOfficial, isOfficial) || other.isOfficial == isOfficial)&&(identical(other.currentUserIsOwner, currentUserIsOwner) || other.currentUserIsOwner == currentUserIsOwner));
}


@override
int get hashCode => Object.hash(runtimeType,name,isOfficial,currentUserIsOwner);

@override
String toString() {
  return 'ChannelData(name: $name, isOfficial: $isOfficial, currentUserIsOwner: $currentUserIsOwner)';
}


}

/// @nodoc
abstract mixin class _$ChannelDataCopyWith<$Res> implements $ChannelDataCopyWith<$Res> {
  factory _$ChannelDataCopyWith(_ChannelData value, $Res Function(_ChannelData) _then) = __$ChannelDataCopyWithImpl;
@override @useResult
$Res call({
 String name, bool isOfficial, bool currentUserIsOwner
});




}
/// @nodoc
class __$ChannelDataCopyWithImpl<$Res>
    implements _$ChannelDataCopyWith<$Res> {
  __$ChannelDataCopyWithImpl(this._self, this._then);

  final _ChannelData _self;
  final $Res Function(_ChannelData) _then;

/// Create a copy of ChannelData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? isOfficial = null,Object? currentUserIsOwner = null,}) {
  return _then(_ChannelData(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isOfficial: null == isOfficial ? _self.isOfficial : isOfficial // ignore: cast_nullable_to_non_nullable
as bool,currentUserIsOwner: null == currentUserIsOwner ? _self.currentUserIsOwner : currentUserIsOwner // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
