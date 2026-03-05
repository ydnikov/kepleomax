// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CallStateBase {

 CallData get data;
/// Create a copy of CallStateBase
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallStateBaseCopyWith<CallStateBase> get copyWith => _$CallStateBaseCopyWithImpl<CallStateBase>(this as CallStateBase, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallStateBase&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'CallStateBase(data: $data)';
}


}

/// @nodoc
abstract mixin class $CallStateBaseCopyWith<$Res>  {
  factory $CallStateBaseCopyWith(CallStateBase value, $Res Function(CallStateBase) _then) = _$CallStateBaseCopyWithImpl;
@useResult
$Res call({
 CallData data
});


$CallDataCopyWith<$Res> get data;

}
/// @nodoc
class _$CallStateBaseCopyWithImpl<$Res>
    implements $CallStateBaseCopyWith<$Res> {
  _$CallStateBaseCopyWithImpl(this._self, this._then);

  final CallStateBase _self;
  final $Res Function(CallStateBase) _then;

/// Create a copy of CallStateBase
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as CallData,
  ));
}
/// Create a copy of CallStateBase
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CallDataCopyWith<$Res> get data {
  
  return $CallDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [CallStateBase].
extension CallStateBasePatterns on CallStateBase {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CallStateBase value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CallStateBase() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CallStateBase value)  $default,){
final _that = this;
switch (_that) {
case _CallStateBase():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CallStateBase value)?  $default,){
final _that = this;
switch (_that) {
case _CallStateBase() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CallData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CallStateBase() when $default != null:
return $default(_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CallData data)  $default,) {final _that = this;
switch (_that) {
case _CallStateBase():
return $default(_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CallData data)?  $default,) {final _that = this;
switch (_that) {
case _CallStateBase() when $default != null:
return $default(_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _CallStateBase implements CallStateBase {
  const _CallStateBase({required this.data});
  

@override final  CallData data;

/// Create a copy of CallStateBase
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallStateBaseCopyWith<_CallStateBase> get copyWith => __$CallStateBaseCopyWithImpl<_CallStateBase>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallStateBase&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'CallStateBase(data: $data)';
}


}

/// @nodoc
abstract mixin class _$CallStateBaseCopyWith<$Res> implements $CallStateBaseCopyWith<$Res> {
  factory _$CallStateBaseCopyWith(_CallStateBase value, $Res Function(_CallStateBase) _then) = __$CallStateBaseCopyWithImpl;
@override @useResult
$Res call({
 CallData data
});


@override $CallDataCopyWith<$Res> get data;

}
/// @nodoc
class __$CallStateBaseCopyWithImpl<$Res>
    implements _$CallStateBaseCopyWith<$Res> {
  __$CallStateBaseCopyWithImpl(this._self, this._then);

  final _CallStateBase _self;
  final $Res Function(_CallStateBase) _then;

/// Create a copy of CallStateBase
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_CallStateBase(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as CallData,
  ));
}

/// Create a copy of CallStateBase
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CallDataCopyWith<$Res> get data {
  
  return $CallDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

/// @nodoc
mixin _$CallStateExit {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallStateExit);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CallStateExit()';
}


}

/// @nodoc
class $CallStateExitCopyWith<$Res>  {
$CallStateExitCopyWith(CallStateExit _, $Res Function(CallStateExit) __);
}


/// Adds pattern-matching-related methods to [CallStateExit].
extension CallStateExitPatterns on CallStateExit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CallStateExit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CallStateExit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CallStateExit value)  $default,){
final _that = this;
switch (_that) {
case _CallStateExit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CallStateExit value)?  $default,){
final _that = this;
switch (_that) {
case _CallStateExit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function()?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CallStateExit() when $default != null:
return $default();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function()  $default,) {final _that = this;
switch (_that) {
case _CallStateExit():
return $default();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function()?  $default,) {final _that = this;
switch (_that) {
case _CallStateExit() when $default != null:
return $default();case _:
  return null;

}
}

}

/// @nodoc


class _CallStateExit implements CallStateExit {
  const _CallStateExit();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallStateExit);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CallStateExit()';
}


}




/// @nodoc
mixin _$CallStateMessage {

 String get message; bool get isError;
/// Create a copy of CallStateMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallStateMessageCopyWith<CallStateMessage> get copyWith => _$CallStateMessageCopyWithImpl<CallStateMessage>(this as CallStateMessage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallStateMessage&&(identical(other.message, message) || other.message == message)&&(identical(other.isError, isError) || other.isError == isError));
}


@override
int get hashCode => Object.hash(runtimeType,message,isError);

@override
String toString() {
  return 'CallStateMessage(message: $message, isError: $isError)';
}


}

/// @nodoc
abstract mixin class $CallStateMessageCopyWith<$Res>  {
  factory $CallStateMessageCopyWith(CallStateMessage value, $Res Function(CallStateMessage) _then) = _$CallStateMessageCopyWithImpl;
@useResult
$Res call({
 String message, bool isError
});




}
/// @nodoc
class _$CallStateMessageCopyWithImpl<$Res>
    implements $CallStateMessageCopyWith<$Res> {
  _$CallStateMessageCopyWithImpl(this._self, this._then);

  final CallStateMessage _self;
  final $Res Function(CallStateMessage) _then;

/// Create a copy of CallStateMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? isError = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,isError: null == isError ? _self.isError : isError // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CallStateMessage].
extension CallStateMessagePatterns on CallStateMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CallStateMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CallStateMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CallStateMessage value)  $default,){
final _that = this;
switch (_that) {
case _CallStateMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CallStateMessage value)?  $default,){
final _that = this;
switch (_that) {
case _CallStateMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String message,  bool isError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CallStateMessage() when $default != null:
return $default(_that.message,_that.isError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String message,  bool isError)  $default,) {final _that = this;
switch (_that) {
case _CallStateMessage():
return $default(_that.message,_that.isError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String message,  bool isError)?  $default,) {final _that = this;
switch (_that) {
case _CallStateMessage() when $default != null:
return $default(_that.message,_that.isError);case _:
  return null;

}
}

}

/// @nodoc


class _CallStateMessage implements CallStateMessage {
  const _CallStateMessage({required this.message, this.isError = false});
  

@override final  String message;
@override@JsonKey() final  bool isError;

/// Create a copy of CallStateMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallStateMessageCopyWith<_CallStateMessage> get copyWith => __$CallStateMessageCopyWithImpl<_CallStateMessage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallStateMessage&&(identical(other.message, message) || other.message == message)&&(identical(other.isError, isError) || other.isError == isError));
}


@override
int get hashCode => Object.hash(runtimeType,message,isError);

@override
String toString() {
  return 'CallStateMessage(message: $message, isError: $isError)';
}


}

/// @nodoc
abstract mixin class _$CallStateMessageCopyWith<$Res> implements $CallStateMessageCopyWith<$Res> {
  factory _$CallStateMessageCopyWith(_CallStateMessage value, $Res Function(_CallStateMessage) _then) = __$CallStateMessageCopyWithImpl;
@override @useResult
$Res call({
 String message, bool isError
});




}
/// @nodoc
class __$CallStateMessageCopyWithImpl<$Res>
    implements _$CallStateMessageCopyWith<$Res> {
  __$CallStateMessageCopyWithImpl(this._self, this._then);

  final _CallStateMessage _self;
  final $Res Function(_CallStateMessage) _then;

/// Create a copy of CallStateMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? isError = null,}) {
  return _then(_CallStateMessage(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,isError: null == isError ? _self.isError : isError // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$CallData {

 User get otherUser; RTCPeerConnectionState get connectionStatus; RTCVideoRenderer? get localRenderer; RTCVideoRenderer? get remoteRenderer; DateTime? get callStartedTime; bool get isLocalCameraOn; bool get isRemoteCameraOn; bool get isLocalMicrophoneOn; bool get isCallAccepted;
/// Create a copy of CallData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallDataCopyWith<CallData> get copyWith => _$CallDataCopyWithImpl<CallData>(this as CallData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallData&&(identical(other.otherUser, otherUser) || other.otherUser == otherUser)&&(identical(other.connectionStatus, connectionStatus) || other.connectionStatus == connectionStatus)&&(identical(other.localRenderer, localRenderer) || other.localRenderer == localRenderer)&&(identical(other.remoteRenderer, remoteRenderer) || other.remoteRenderer == remoteRenderer)&&(identical(other.callStartedTime, callStartedTime) || other.callStartedTime == callStartedTime)&&(identical(other.isLocalCameraOn, isLocalCameraOn) || other.isLocalCameraOn == isLocalCameraOn)&&(identical(other.isRemoteCameraOn, isRemoteCameraOn) || other.isRemoteCameraOn == isRemoteCameraOn)&&(identical(other.isLocalMicrophoneOn, isLocalMicrophoneOn) || other.isLocalMicrophoneOn == isLocalMicrophoneOn)&&(identical(other.isCallAccepted, isCallAccepted) || other.isCallAccepted == isCallAccepted));
}


@override
int get hashCode => Object.hash(runtimeType,otherUser,connectionStatus,localRenderer,remoteRenderer,callStartedTime,isLocalCameraOn,isRemoteCameraOn,isLocalMicrophoneOn,isCallAccepted);

@override
String toString() {
  return 'CallData(otherUser: $otherUser, connectionStatus: $connectionStatus, localRenderer: $localRenderer, remoteRenderer: $remoteRenderer, callStartedTime: $callStartedTime, isLocalCameraOn: $isLocalCameraOn, isRemoteCameraOn: $isRemoteCameraOn, isLocalMicrophoneOn: $isLocalMicrophoneOn, isCallAccepted: $isCallAccepted)';
}


}

/// @nodoc
abstract mixin class $CallDataCopyWith<$Res>  {
  factory $CallDataCopyWith(CallData value, $Res Function(CallData) _then) = _$CallDataCopyWithImpl;
@useResult
$Res call({
 User otherUser, RTCPeerConnectionState connectionStatus, RTCVideoRenderer? localRenderer, RTCVideoRenderer? remoteRenderer, DateTime? callStartedTime, bool isLocalCameraOn, bool isRemoteCameraOn, bool isLocalMicrophoneOn, bool isCallAccepted
});


$UserCopyWith<$Res> get otherUser;

}
/// @nodoc
class _$CallDataCopyWithImpl<$Res>
    implements $CallDataCopyWith<$Res> {
  _$CallDataCopyWithImpl(this._self, this._then);

  final CallData _self;
  final $Res Function(CallData) _then;

/// Create a copy of CallData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? otherUser = null,Object? connectionStatus = null,Object? localRenderer = freezed,Object? remoteRenderer = freezed,Object? callStartedTime = freezed,Object? isLocalCameraOn = null,Object? isRemoteCameraOn = null,Object? isLocalMicrophoneOn = null,Object? isCallAccepted = null,}) {
  return _then(_self.copyWith(
otherUser: null == otherUser ? _self.otherUser : otherUser // ignore: cast_nullable_to_non_nullable
as User,connectionStatus: null == connectionStatus ? _self.connectionStatus : connectionStatus // ignore: cast_nullable_to_non_nullable
as RTCPeerConnectionState,localRenderer: freezed == localRenderer ? _self.localRenderer : localRenderer // ignore: cast_nullable_to_non_nullable
as RTCVideoRenderer?,remoteRenderer: freezed == remoteRenderer ? _self.remoteRenderer : remoteRenderer // ignore: cast_nullable_to_non_nullable
as RTCVideoRenderer?,callStartedTime: freezed == callStartedTime ? _self.callStartedTime : callStartedTime // ignore: cast_nullable_to_non_nullable
as DateTime?,isLocalCameraOn: null == isLocalCameraOn ? _self.isLocalCameraOn : isLocalCameraOn // ignore: cast_nullable_to_non_nullable
as bool,isRemoteCameraOn: null == isRemoteCameraOn ? _self.isRemoteCameraOn : isRemoteCameraOn // ignore: cast_nullable_to_non_nullable
as bool,isLocalMicrophoneOn: null == isLocalMicrophoneOn ? _self.isLocalMicrophoneOn : isLocalMicrophoneOn // ignore: cast_nullable_to_non_nullable
as bool,isCallAccepted: null == isCallAccepted ? _self.isCallAccepted : isCallAccepted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of CallData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get otherUser {
  
  return $UserCopyWith<$Res>(_self.otherUser, (value) {
    return _then(_self.copyWith(otherUser: value));
  });
}
}


/// Adds pattern-matching-related methods to [CallData].
extension CallDataPatterns on CallData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CallData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CallData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CallData value)  $default,){
final _that = this;
switch (_that) {
case _CallData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CallData value)?  $default,){
final _that = this;
switch (_that) {
case _CallData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( User otherUser,  RTCPeerConnectionState connectionStatus,  RTCVideoRenderer? localRenderer,  RTCVideoRenderer? remoteRenderer,  DateTime? callStartedTime,  bool isLocalCameraOn,  bool isRemoteCameraOn,  bool isLocalMicrophoneOn,  bool isCallAccepted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CallData() when $default != null:
return $default(_that.otherUser,_that.connectionStatus,_that.localRenderer,_that.remoteRenderer,_that.callStartedTime,_that.isLocalCameraOn,_that.isRemoteCameraOn,_that.isLocalMicrophoneOn,_that.isCallAccepted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( User otherUser,  RTCPeerConnectionState connectionStatus,  RTCVideoRenderer? localRenderer,  RTCVideoRenderer? remoteRenderer,  DateTime? callStartedTime,  bool isLocalCameraOn,  bool isRemoteCameraOn,  bool isLocalMicrophoneOn,  bool isCallAccepted)  $default,) {final _that = this;
switch (_that) {
case _CallData():
return $default(_that.otherUser,_that.connectionStatus,_that.localRenderer,_that.remoteRenderer,_that.callStartedTime,_that.isLocalCameraOn,_that.isRemoteCameraOn,_that.isLocalMicrophoneOn,_that.isCallAccepted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( User otherUser,  RTCPeerConnectionState connectionStatus,  RTCVideoRenderer? localRenderer,  RTCVideoRenderer? remoteRenderer,  DateTime? callStartedTime,  bool isLocalCameraOn,  bool isRemoteCameraOn,  bool isLocalMicrophoneOn,  bool isCallAccepted)?  $default,) {final _that = this;
switch (_that) {
case _CallData() when $default != null:
return $default(_that.otherUser,_that.connectionStatus,_that.localRenderer,_that.remoteRenderer,_that.callStartedTime,_that.isLocalCameraOn,_that.isRemoteCameraOn,_that.isLocalMicrophoneOn,_that.isCallAccepted);case _:
  return null;

}
}

}

/// @nodoc


class _CallData implements CallData {
  const _CallData({required this.otherUser, this.connectionStatus = RTCPeerConnectionState.RTCPeerConnectionStateDisconnected, this.localRenderer, this.remoteRenderer, this.callStartedTime, this.isLocalCameraOn = true, this.isRemoteCameraOn = true, this.isLocalMicrophoneOn = true, this.isCallAccepted = false});
  

@override final  User otherUser;
@override@JsonKey() final  RTCPeerConnectionState connectionStatus;
@override final  RTCVideoRenderer? localRenderer;
@override final  RTCVideoRenderer? remoteRenderer;
@override final  DateTime? callStartedTime;
@override@JsonKey() final  bool isLocalCameraOn;
@override@JsonKey() final  bool isRemoteCameraOn;
@override@JsonKey() final  bool isLocalMicrophoneOn;
@override@JsonKey() final  bool isCallAccepted;

/// Create a copy of CallData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallDataCopyWith<_CallData> get copyWith => __$CallDataCopyWithImpl<_CallData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallData&&(identical(other.otherUser, otherUser) || other.otherUser == otherUser)&&(identical(other.connectionStatus, connectionStatus) || other.connectionStatus == connectionStatus)&&(identical(other.localRenderer, localRenderer) || other.localRenderer == localRenderer)&&(identical(other.remoteRenderer, remoteRenderer) || other.remoteRenderer == remoteRenderer)&&(identical(other.callStartedTime, callStartedTime) || other.callStartedTime == callStartedTime)&&(identical(other.isLocalCameraOn, isLocalCameraOn) || other.isLocalCameraOn == isLocalCameraOn)&&(identical(other.isRemoteCameraOn, isRemoteCameraOn) || other.isRemoteCameraOn == isRemoteCameraOn)&&(identical(other.isLocalMicrophoneOn, isLocalMicrophoneOn) || other.isLocalMicrophoneOn == isLocalMicrophoneOn)&&(identical(other.isCallAccepted, isCallAccepted) || other.isCallAccepted == isCallAccepted));
}


@override
int get hashCode => Object.hash(runtimeType,otherUser,connectionStatus,localRenderer,remoteRenderer,callStartedTime,isLocalCameraOn,isRemoteCameraOn,isLocalMicrophoneOn,isCallAccepted);

@override
String toString() {
  return 'CallData(otherUser: $otherUser, connectionStatus: $connectionStatus, localRenderer: $localRenderer, remoteRenderer: $remoteRenderer, callStartedTime: $callStartedTime, isLocalCameraOn: $isLocalCameraOn, isRemoteCameraOn: $isRemoteCameraOn, isLocalMicrophoneOn: $isLocalMicrophoneOn, isCallAccepted: $isCallAccepted)';
}


}

/// @nodoc
abstract mixin class _$CallDataCopyWith<$Res> implements $CallDataCopyWith<$Res> {
  factory _$CallDataCopyWith(_CallData value, $Res Function(_CallData) _then) = __$CallDataCopyWithImpl;
@override @useResult
$Res call({
 User otherUser, RTCPeerConnectionState connectionStatus, RTCVideoRenderer? localRenderer, RTCVideoRenderer? remoteRenderer, DateTime? callStartedTime, bool isLocalCameraOn, bool isRemoteCameraOn, bool isLocalMicrophoneOn, bool isCallAccepted
});


@override $UserCopyWith<$Res> get otherUser;

}
/// @nodoc
class __$CallDataCopyWithImpl<$Res>
    implements _$CallDataCopyWith<$Res> {
  __$CallDataCopyWithImpl(this._self, this._then);

  final _CallData _self;
  final $Res Function(_CallData) _then;

/// Create a copy of CallData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? otherUser = null,Object? connectionStatus = null,Object? localRenderer = freezed,Object? remoteRenderer = freezed,Object? callStartedTime = freezed,Object? isLocalCameraOn = null,Object? isRemoteCameraOn = null,Object? isLocalMicrophoneOn = null,Object? isCallAccepted = null,}) {
  return _then(_CallData(
otherUser: null == otherUser ? _self.otherUser : otherUser // ignore: cast_nullable_to_non_nullable
as User,connectionStatus: null == connectionStatus ? _self.connectionStatus : connectionStatus // ignore: cast_nullable_to_non_nullable
as RTCPeerConnectionState,localRenderer: freezed == localRenderer ? _self.localRenderer : localRenderer // ignore: cast_nullable_to_non_nullable
as RTCVideoRenderer?,remoteRenderer: freezed == remoteRenderer ? _self.remoteRenderer : remoteRenderer // ignore: cast_nullable_to_non_nullable
as RTCVideoRenderer?,callStartedTime: freezed == callStartedTime ? _self.callStartedTime : callStartedTime // ignore: cast_nullable_to_non_nullable
as DateTime?,isLocalCameraOn: null == isLocalCameraOn ? _self.isLocalCameraOn : isLocalCameraOn // ignore: cast_nullable_to_non_nullable
as bool,isRemoteCameraOn: null == isRemoteCameraOn ? _self.isRemoteCameraOn : isRemoteCameraOn // ignore: cast_nullable_to_non_nullable
as bool,isLocalMicrophoneOn: null == isLocalMicrophoneOn ? _self.isLocalMicrophoneOn : isLocalMicrophoneOn // ignore: cast_nullable_to_non_nullable
as bool,isCallAccepted: null == isCallAccepted ? _self.isCallAccepted : isCallAccepted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of CallData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get otherUser {
  
  return $UserCopyWith<$Res>(_self.otherUser, (value) {
    return _then(_self.copyWith(otherUser: value));
  });
}
}

// dart format on
