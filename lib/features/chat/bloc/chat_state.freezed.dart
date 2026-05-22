// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatStateBase {

 ChatData get data;
/// Create a copy of ChatStateBase
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatStateBaseCopyWith<ChatStateBase> get copyWith => _$ChatStateBaseCopyWithImpl<ChatStateBase>(this as ChatStateBase, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatStateBase&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'ChatStateBase(data: $data)';
}


}

/// @nodoc
abstract mixin class $ChatStateBaseCopyWith<$Res>  {
  factory $ChatStateBaseCopyWith(ChatStateBase value, $Res Function(ChatStateBase) _then) = _$ChatStateBaseCopyWithImpl;
@useResult
$Res call({
 ChatData data
});


$ChatDataCopyWith<$Res> get data;

}
/// @nodoc
class _$ChatStateBaseCopyWithImpl<$Res>
    implements $ChatStateBaseCopyWith<$Res> {
  _$ChatStateBaseCopyWithImpl(this._self, this._then);

  final ChatStateBase _self;
  final $Res Function(ChatStateBase) _then;

/// Create a copy of ChatStateBase
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ChatData,
  ));
}
/// Create a copy of ChatStateBase
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatDataCopyWith<$Res> get data {
  
  return $ChatDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChatStateBase].
extension ChatStateBasePatterns on ChatStateBase {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatStateBase value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatStateBase() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatStateBase value)  $default,){
final _that = this;
switch (_that) {
case _ChatStateBase():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatStateBase value)?  $default,){
final _that = this;
switch (_that) {
case _ChatStateBase() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ChatData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatStateBase() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ChatData data)  $default,) {final _that = this;
switch (_that) {
case _ChatStateBase():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ChatData data)?  $default,) {final _that = this;
switch (_that) {
case _ChatStateBase() when $default != null:
return $default(_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _ChatStateBase implements ChatStateBase {
  const _ChatStateBase({required this.data});
  

@override final  ChatData data;

/// Create a copy of ChatStateBase
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatStateBaseCopyWith<_ChatStateBase> get copyWith => __$ChatStateBaseCopyWithImpl<_ChatStateBase>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatStateBase&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'ChatStateBase(data: $data)';
}


}

/// @nodoc
abstract mixin class _$ChatStateBaseCopyWith<$Res> implements $ChatStateBaseCopyWith<$Res> {
  factory _$ChatStateBaseCopyWith(_ChatStateBase value, $Res Function(_ChatStateBase) _then) = __$ChatStateBaseCopyWithImpl;
@override @useResult
$Res call({
 ChatData data
});


@override $ChatDataCopyWith<$Res> get data;

}
/// @nodoc
class __$ChatStateBaseCopyWithImpl<$Res>
    implements _$ChatStateBaseCopyWith<$Res> {
  __$ChatStateBaseCopyWithImpl(this._self, this._then);

  final _ChatStateBase _self;
  final $Res Function(_ChatStateBase) _then;

/// Create a copy of ChatStateBase
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_ChatStateBase(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ChatData,
  ));
}

/// Create a copy of ChatStateBase
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatDataCopyWith<$Res> get data {
  
  return $ChatDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

/// @nodoc
mixin _$ChatStateError {

 String get message;
/// Create a copy of ChatStateError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatStateErrorCopyWith<ChatStateError> get copyWith => _$ChatStateErrorCopyWithImpl<ChatStateError>(this as ChatStateError, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatStateError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ChatStateError(message: $message)';
}


}

/// @nodoc
abstract mixin class $ChatStateErrorCopyWith<$Res>  {
  factory $ChatStateErrorCopyWith(ChatStateError value, $Res Function(ChatStateError) _then) = _$ChatStateErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ChatStateErrorCopyWithImpl<$Res>
    implements $ChatStateErrorCopyWith<$Res> {
  _$ChatStateErrorCopyWithImpl(this._self, this._then);

  final ChatStateError _self;
  final $Res Function(ChatStateError) _then;

/// Create a copy of ChatStateError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatStateError].
extension ChatStateErrorPatterns on ChatStateError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatStateError value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatStateError() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatStateError value)  $default,){
final _that = this;
switch (_that) {
case _ChatStateError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatStateError value)?  $default,){
final _that = this;
switch (_that) {
case _ChatStateError() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatStateError() when $default != null:
return $default(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String message)  $default,) {final _that = this;
switch (_that) {
case _ChatStateError():
return $default(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String message)?  $default,) {final _that = this;
switch (_that) {
case _ChatStateError() when $default != null:
return $default(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _ChatStateError implements ChatStateError {
  const _ChatStateError({required this.message});
  

@override final  String message;

/// Create a copy of ChatStateError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatStateErrorCopyWith<_ChatStateError> get copyWith => __$ChatStateErrorCopyWithImpl<_ChatStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatStateError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ChatStateError(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ChatStateErrorCopyWith<$Res> implements $ChatStateErrorCopyWith<$Res> {
  factory _$ChatStateErrorCopyWith(_ChatStateError value, $Res Function(_ChatStateError) _then) = __$ChatStateErrorCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ChatStateErrorCopyWithImpl<$Res>
    implements _$ChatStateErrorCopyWith<$Res> {
  __$ChatStateErrorCopyWithImpl(this._self, this._then);

  final _ChatStateError _self;
  final $Res Function(_ChatStateError) _then;

/// Create a copy of ChatStateError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_ChatStateError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ChatStateMessage {

 String get message; bool get isError;
/// Create a copy of ChatStateMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatStateMessageCopyWith<ChatStateMessage> get copyWith => _$ChatStateMessageCopyWithImpl<ChatStateMessage>(this as ChatStateMessage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatStateMessage&&(identical(other.message, message) || other.message == message)&&(identical(other.isError, isError) || other.isError == isError));
}


@override
int get hashCode => Object.hash(runtimeType,message,isError);

@override
String toString() {
  return 'ChatStateMessage(message: $message, isError: $isError)';
}


}

/// @nodoc
abstract mixin class $ChatStateMessageCopyWith<$Res>  {
  factory $ChatStateMessageCopyWith(ChatStateMessage value, $Res Function(ChatStateMessage) _then) = _$ChatStateMessageCopyWithImpl;
@useResult
$Res call({
 String message, bool isError
});




}
/// @nodoc
class _$ChatStateMessageCopyWithImpl<$Res>
    implements $ChatStateMessageCopyWith<$Res> {
  _$ChatStateMessageCopyWithImpl(this._self, this._then);

  final ChatStateMessage _self;
  final $Res Function(ChatStateMessage) _then;

/// Create a copy of ChatStateMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? isError = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,isError: null == isError ? _self.isError : isError // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatStateMessage].
extension ChatStateMessagePatterns on ChatStateMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatStateMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatStateMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatStateMessage value)  $default,){
final _that = this;
switch (_that) {
case _ChatStateMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatStateMessage value)?  $default,){
final _that = this;
switch (_that) {
case _ChatStateMessage() when $default != null:
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
case _ChatStateMessage() when $default != null:
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
case _ChatStateMessage():
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
case _ChatStateMessage() when $default != null:
return $default(_that.message,_that.isError);case _:
  return null;

}
}

}

/// @nodoc


class _ChatStateMessage implements ChatStateMessage {
  const _ChatStateMessage({required this.message, required this.isError});
  

@override final  String message;
@override final  bool isError;

/// Create a copy of ChatStateMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatStateMessageCopyWith<_ChatStateMessage> get copyWith => __$ChatStateMessageCopyWithImpl<_ChatStateMessage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatStateMessage&&(identical(other.message, message) || other.message == message)&&(identical(other.isError, isError) || other.isError == isError));
}


@override
int get hashCode => Object.hash(runtimeType,message,isError);

@override
String toString() {
  return 'ChatStateMessage(message: $message, isError: $isError)';
}


}

/// @nodoc
abstract mixin class _$ChatStateMessageCopyWith<$Res> implements $ChatStateMessageCopyWith<$Res> {
  factory _$ChatStateMessageCopyWith(_ChatStateMessage value, $Res Function(_ChatStateMessage) _then) = __$ChatStateMessageCopyWithImpl;
@override @useResult
$Res call({
 String message, bool isError
});




}
/// @nodoc
class __$ChatStateMessageCopyWithImpl<$Res>
    implements _$ChatStateMessageCopyWith<$Res> {
  __$ChatStateMessageCopyWithImpl(this._self, this._then);

  final _ChatStateMessage _self;
  final $Res Function(_ChatStateMessage) _then;

/// Create a copy of ChatStateMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? isError = null,}) {
  return _then(_ChatStateMessage(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,isError: null == isError ? _self.isError : isError // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$ChatStateUpdateTextField {

 String get message;
/// Create a copy of ChatStateUpdateTextField
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatStateUpdateTextFieldCopyWith<ChatStateUpdateTextField> get copyWith => _$ChatStateUpdateTextFieldCopyWithImpl<ChatStateUpdateTextField>(this as ChatStateUpdateTextField, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatStateUpdateTextField&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ChatStateUpdateTextField(message: $message)';
}


}

/// @nodoc
abstract mixin class $ChatStateUpdateTextFieldCopyWith<$Res>  {
  factory $ChatStateUpdateTextFieldCopyWith(ChatStateUpdateTextField value, $Res Function(ChatStateUpdateTextField) _then) = _$ChatStateUpdateTextFieldCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ChatStateUpdateTextFieldCopyWithImpl<$Res>
    implements $ChatStateUpdateTextFieldCopyWith<$Res> {
  _$ChatStateUpdateTextFieldCopyWithImpl(this._self, this._then);

  final ChatStateUpdateTextField _self;
  final $Res Function(ChatStateUpdateTextField) _then;

/// Create a copy of ChatStateUpdateTextField
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatStateUpdateTextField].
extension ChatStateUpdateTextFieldPatterns on ChatStateUpdateTextField {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatStateUpdateTextField value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatStateUpdateTextField() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatStateUpdateTextField value)  $default,){
final _that = this;
switch (_that) {
case _ChatStateUpdateTextField():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatStateUpdateTextField value)?  $default,){
final _that = this;
switch (_that) {
case _ChatStateUpdateTextField() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatStateUpdateTextField() when $default != null:
return $default(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String message)  $default,) {final _that = this;
switch (_that) {
case _ChatStateUpdateTextField():
return $default(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String message)?  $default,) {final _that = this;
switch (_that) {
case _ChatStateUpdateTextField() when $default != null:
return $default(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _ChatStateUpdateTextField implements ChatStateUpdateTextField {
  const _ChatStateUpdateTextField(this.message);
  

@override final  String message;

/// Create a copy of ChatStateUpdateTextField
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatStateUpdateTextFieldCopyWith<_ChatStateUpdateTextField> get copyWith => __$ChatStateUpdateTextFieldCopyWithImpl<_ChatStateUpdateTextField>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatStateUpdateTextField&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ChatStateUpdateTextField(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ChatStateUpdateTextFieldCopyWith<$Res> implements $ChatStateUpdateTextFieldCopyWith<$Res> {
  factory _$ChatStateUpdateTextFieldCopyWith(_ChatStateUpdateTextField value, $Res Function(_ChatStateUpdateTextField) _then) = __$ChatStateUpdateTextFieldCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ChatStateUpdateTextFieldCopyWithImpl<$Res>
    implements _$ChatStateUpdateTextFieldCopyWith<$Res> {
  __$ChatStateUpdateTextFieldCopyWithImpl(this._self, this._then);

  final _ChatStateUpdateTextField _self;
  final $Res Function(_ChatStateUpdateTextField) _then;

/// Create a copy of ChatStateUpdateTextField
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_ChatStateUpdateTextField(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ChatData {

 Chat get chat; User get otherUser;// if user in chat was null, this user will be used
 List<Message> get messages; int get unreadCount; bool get isAllMessagesLoaded; UnreadMessagesValue get unreadMessagesValue; bool get isTyping; bool get isLoading; bool get isConnected;
/// Create a copy of ChatData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatDataCopyWith<ChatData> get copyWith => _$ChatDataCopyWithImpl<ChatData>(this as ChatData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatData&&(identical(other.chat, chat) || other.chat == chat)&&(identical(other.otherUser, otherUser) || other.otherUser == otherUser)&&const DeepCollectionEquality().equals(other.messages, messages)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.isAllMessagesLoaded, isAllMessagesLoaded) || other.isAllMessagesLoaded == isAllMessagesLoaded)&&(identical(other.unreadMessagesValue, unreadMessagesValue) || other.unreadMessagesValue == unreadMessagesValue)&&(identical(other.isTyping, isTyping) || other.isTyping == isTyping)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected));
}


@override
int get hashCode => Object.hash(runtimeType,chat,otherUser,const DeepCollectionEquality().hash(messages),unreadCount,isAllMessagesLoaded,unreadMessagesValue,isTyping,isLoading,isConnected);

@override
String toString() {
  return 'ChatData(chat: $chat, otherUser: $otherUser, messages: $messages, unreadCount: $unreadCount, isAllMessagesLoaded: $isAllMessagesLoaded, unreadMessagesValue: $unreadMessagesValue, isTyping: $isTyping, isLoading: $isLoading, isConnected: $isConnected)';
}


}

/// @nodoc
abstract mixin class $ChatDataCopyWith<$Res>  {
  factory $ChatDataCopyWith(ChatData value, $Res Function(ChatData) _then) = _$ChatDataCopyWithImpl;
@useResult
$Res call({
 Chat chat, User otherUser, List<Message> messages, int unreadCount, bool isAllMessagesLoaded, UnreadMessagesValue unreadMessagesValue, bool isTyping, bool isLoading, bool isConnected
});


$ChatCopyWith<$Res> get chat;$UserCopyWith<$Res> get otherUser;$UnreadMessagesValueCopyWith<$Res> get unreadMessagesValue;

}
/// @nodoc
class _$ChatDataCopyWithImpl<$Res>
    implements $ChatDataCopyWith<$Res> {
  _$ChatDataCopyWithImpl(this._self, this._then);

  final ChatData _self;
  final $Res Function(ChatData) _then;

/// Create a copy of ChatData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chat = null,Object? otherUser = null,Object? messages = null,Object? unreadCount = null,Object? isAllMessagesLoaded = null,Object? unreadMessagesValue = null,Object? isTyping = null,Object? isLoading = null,Object? isConnected = null,}) {
  return _then(_self.copyWith(
chat: null == chat ? _self.chat : chat // ignore: cast_nullable_to_non_nullable
as Chat,otherUser: null == otherUser ? _self.otherUser : otherUser // ignore: cast_nullable_to_non_nullable
as User,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<Message>,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,isAllMessagesLoaded: null == isAllMessagesLoaded ? _self.isAllMessagesLoaded : isAllMessagesLoaded // ignore: cast_nullable_to_non_nullable
as bool,unreadMessagesValue: null == unreadMessagesValue ? _self.unreadMessagesValue : unreadMessagesValue // ignore: cast_nullable_to_non_nullable
as UnreadMessagesValue,isTyping: null == isTyping ? _self.isTyping : isTyping // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isConnected: null == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of ChatData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatCopyWith<$Res> get chat {
  
  return $ChatCopyWith<$Res>(_self.chat, (value) {
    return _then(_self.copyWith(chat: value));
  });
}/// Create a copy of ChatData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get otherUser {
  
  return $UserCopyWith<$Res>(_self.otherUser, (value) {
    return _then(_self.copyWith(otherUser: value));
  });
}/// Create a copy of ChatData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UnreadMessagesValueCopyWith<$Res> get unreadMessagesValue {
  
  return $UnreadMessagesValueCopyWith<$Res>(_self.unreadMessagesValue, (value) {
    return _then(_self.copyWith(unreadMessagesValue: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChatData].
extension ChatDataPatterns on ChatData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatData value)  $default,){
final _that = this;
switch (_that) {
case _ChatData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatData value)?  $default,){
final _that = this;
switch (_that) {
case _ChatData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Chat chat,  User otherUser,  List<Message> messages,  int unreadCount,  bool isAllMessagesLoaded,  UnreadMessagesValue unreadMessagesValue,  bool isTyping,  bool isLoading,  bool isConnected)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatData() when $default != null:
return $default(_that.chat,_that.otherUser,_that.messages,_that.unreadCount,_that.isAllMessagesLoaded,_that.unreadMessagesValue,_that.isTyping,_that.isLoading,_that.isConnected);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Chat chat,  User otherUser,  List<Message> messages,  int unreadCount,  bool isAllMessagesLoaded,  UnreadMessagesValue unreadMessagesValue,  bool isTyping,  bool isLoading,  bool isConnected)  $default,) {final _that = this;
switch (_that) {
case _ChatData():
return $default(_that.chat,_that.otherUser,_that.messages,_that.unreadCount,_that.isAllMessagesLoaded,_that.unreadMessagesValue,_that.isTyping,_that.isLoading,_that.isConnected);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Chat chat,  User otherUser,  List<Message> messages,  int unreadCount,  bool isAllMessagesLoaded,  UnreadMessagesValue unreadMessagesValue,  bool isTyping,  bool isLoading,  bool isConnected)?  $default,) {final _that = this;
switch (_that) {
case _ChatData() when $default != null:
return $default(_that.chat,_that.otherUser,_that.messages,_that.unreadCount,_that.isAllMessagesLoaded,_that.unreadMessagesValue,_that.isTyping,_that.isLoading,_that.isConnected);case _:
  return null;

}
}

}

/// @nodoc


class _ChatData implements ChatData {
  const _ChatData({required this.chat, required this.otherUser, required final  List<Message> messages, required this.unreadCount, required this.isAllMessagesLoaded, required this.unreadMessagesValue, this.isTyping = false, this.isLoading = true, this.isConnected = false}): _messages = messages;
  

@override final  Chat chat;
@override final  User otherUser;
// if user in chat was null, this user will be used
 final  List<Message> _messages;
// if user in chat was null, this user will be used
@override List<Message> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

@override final  int unreadCount;
@override final  bool isAllMessagesLoaded;
@override final  UnreadMessagesValue unreadMessagesValue;
@override@JsonKey() final  bool isTyping;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isConnected;

/// Create a copy of ChatData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatDataCopyWith<_ChatData> get copyWith => __$ChatDataCopyWithImpl<_ChatData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatData&&(identical(other.chat, chat) || other.chat == chat)&&(identical(other.otherUser, otherUser) || other.otherUser == otherUser)&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.isAllMessagesLoaded, isAllMessagesLoaded) || other.isAllMessagesLoaded == isAllMessagesLoaded)&&(identical(other.unreadMessagesValue, unreadMessagesValue) || other.unreadMessagesValue == unreadMessagesValue)&&(identical(other.isTyping, isTyping) || other.isTyping == isTyping)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected));
}


@override
int get hashCode => Object.hash(runtimeType,chat,otherUser,const DeepCollectionEquality().hash(_messages),unreadCount,isAllMessagesLoaded,unreadMessagesValue,isTyping,isLoading,isConnected);

@override
String toString() {
  return 'ChatData(chat: $chat, otherUser: $otherUser, messages: $messages, unreadCount: $unreadCount, isAllMessagesLoaded: $isAllMessagesLoaded, unreadMessagesValue: $unreadMessagesValue, isTyping: $isTyping, isLoading: $isLoading, isConnected: $isConnected)';
}


}

/// @nodoc
abstract mixin class _$ChatDataCopyWith<$Res> implements $ChatDataCopyWith<$Res> {
  factory _$ChatDataCopyWith(_ChatData value, $Res Function(_ChatData) _then) = __$ChatDataCopyWithImpl;
@override @useResult
$Res call({
 Chat chat, User otherUser, List<Message> messages, int unreadCount, bool isAllMessagesLoaded, UnreadMessagesValue unreadMessagesValue, bool isTyping, bool isLoading, bool isConnected
});


@override $ChatCopyWith<$Res> get chat;@override $UserCopyWith<$Res> get otherUser;@override $UnreadMessagesValueCopyWith<$Res> get unreadMessagesValue;

}
/// @nodoc
class __$ChatDataCopyWithImpl<$Res>
    implements _$ChatDataCopyWith<$Res> {
  __$ChatDataCopyWithImpl(this._self, this._then);

  final _ChatData _self;
  final $Res Function(_ChatData) _then;

/// Create a copy of ChatData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chat = null,Object? otherUser = null,Object? messages = null,Object? unreadCount = null,Object? isAllMessagesLoaded = null,Object? unreadMessagesValue = null,Object? isTyping = null,Object? isLoading = null,Object? isConnected = null,}) {
  return _then(_ChatData(
chat: null == chat ? _self.chat : chat // ignore: cast_nullable_to_non_nullable
as Chat,otherUser: null == otherUser ? _self.otherUser : otherUser // ignore: cast_nullable_to_non_nullable
as User,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<Message>,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,isAllMessagesLoaded: null == isAllMessagesLoaded ? _self.isAllMessagesLoaded : isAllMessagesLoaded // ignore: cast_nullable_to_non_nullable
as bool,unreadMessagesValue: null == unreadMessagesValue ? _self.unreadMessagesValue : unreadMessagesValue // ignore: cast_nullable_to_non_nullable
as UnreadMessagesValue,isTyping: null == isTyping ? _self.isTyping : isTyping // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isConnected: null == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of ChatData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatCopyWith<$Res> get chat {
  
  return $ChatCopyWith<$Res>(_self.chat, (value) {
    return _then(_self.copyWith(chat: value));
  });
}/// Create a copy of ChatData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get otherUser {
  
  return $UserCopyWith<$Res>(_self.otherUser, (value) {
    return _then(_self.copyWith(otherUser: value));
  });
}/// Create a copy of ChatData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UnreadMessagesValueCopyWith<$Res> get unreadMessagesValue {
  
  return $UnreadMessagesValueCopyWith<$Res>(_self.unreadMessagesValue, (value) {
    return _then(_self.copyWith(unreadMessagesValue: value));
  });
}
}

/// @nodoc
mixin _$UnreadMessagesValue {

/// if data from cache - set isLocked to false
/// if data from api - set isLocked to true, in that firstReadMessageCreatedAt
/// won't change for that ChatState (is handled by chat_bloc)
 bool get isLocked; DateTime? get firstReadMessageCreatedAt;
/// Create a copy of UnreadMessagesValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnreadMessagesValueCopyWith<UnreadMessagesValue> get copyWith => _$UnreadMessagesValueCopyWithImpl<UnreadMessagesValue>(this as UnreadMessagesValue, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnreadMessagesValue&&(identical(other.isLocked, isLocked) || other.isLocked == isLocked)&&(identical(other.firstReadMessageCreatedAt, firstReadMessageCreatedAt) || other.firstReadMessageCreatedAt == firstReadMessageCreatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,isLocked,firstReadMessageCreatedAt);

@override
String toString() {
  return 'UnreadMessagesValue(isLocked: $isLocked, firstReadMessageCreatedAt: $firstReadMessageCreatedAt)';
}


}

/// @nodoc
abstract mixin class $UnreadMessagesValueCopyWith<$Res>  {
  factory $UnreadMessagesValueCopyWith(UnreadMessagesValue value, $Res Function(UnreadMessagesValue) _then) = _$UnreadMessagesValueCopyWithImpl;
@useResult
$Res call({
 bool isLocked, DateTime? firstReadMessageCreatedAt
});




}
/// @nodoc
class _$UnreadMessagesValueCopyWithImpl<$Res>
    implements $UnreadMessagesValueCopyWith<$Res> {
  _$UnreadMessagesValueCopyWithImpl(this._self, this._then);

  final UnreadMessagesValue _self;
  final $Res Function(UnreadMessagesValue) _then;

/// Create a copy of UnreadMessagesValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLocked = null,Object? firstReadMessageCreatedAt = freezed,}) {
  return _then(_self.copyWith(
isLocked: null == isLocked ? _self.isLocked : isLocked // ignore: cast_nullable_to_non_nullable
as bool,firstReadMessageCreatedAt: freezed == firstReadMessageCreatedAt ? _self.firstReadMessageCreatedAt : firstReadMessageCreatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [UnreadMessagesValue].
extension UnreadMessagesValuePatterns on UnreadMessagesValue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UnreadMessagesValue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UnreadMessagesValue() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UnreadMessagesValue value)  $default,){
final _that = this;
switch (_that) {
case _UnreadMessagesValue():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UnreadMessagesValue value)?  $default,){
final _that = this;
switch (_that) {
case _UnreadMessagesValue() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLocked,  DateTime? firstReadMessageCreatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UnreadMessagesValue() when $default != null:
return $default(_that.isLocked,_that.firstReadMessageCreatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLocked,  DateTime? firstReadMessageCreatedAt)  $default,) {final _that = this;
switch (_that) {
case _UnreadMessagesValue():
return $default(_that.isLocked,_that.firstReadMessageCreatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLocked,  DateTime? firstReadMessageCreatedAt)?  $default,) {final _that = this;
switch (_that) {
case _UnreadMessagesValue() when $default != null:
return $default(_that.isLocked,_that.firstReadMessageCreatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _UnreadMessagesValue implements UnreadMessagesValue {
  const _UnreadMessagesValue({required this.isLocked, required this.firstReadMessageCreatedAt});
  

/// if data from cache - set isLocked to false
/// if data from api - set isLocked to true, in that firstReadMessageCreatedAt
/// won't change for that ChatState (is handled by chat_bloc)
@override final  bool isLocked;
@override final  DateTime? firstReadMessageCreatedAt;

/// Create a copy of UnreadMessagesValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnreadMessagesValueCopyWith<_UnreadMessagesValue> get copyWith => __$UnreadMessagesValueCopyWithImpl<_UnreadMessagesValue>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnreadMessagesValue&&(identical(other.isLocked, isLocked) || other.isLocked == isLocked)&&(identical(other.firstReadMessageCreatedAt, firstReadMessageCreatedAt) || other.firstReadMessageCreatedAt == firstReadMessageCreatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,isLocked,firstReadMessageCreatedAt);

@override
String toString() {
  return 'UnreadMessagesValue(isLocked: $isLocked, firstReadMessageCreatedAt: $firstReadMessageCreatedAt)';
}


}

/// @nodoc
abstract mixin class _$UnreadMessagesValueCopyWith<$Res> implements $UnreadMessagesValueCopyWith<$Res> {
  factory _$UnreadMessagesValueCopyWith(_UnreadMessagesValue value, $Res Function(_UnreadMessagesValue) _then) = __$UnreadMessagesValueCopyWithImpl;
@override @useResult
$Res call({
 bool isLocked, DateTime? firstReadMessageCreatedAt
});




}
/// @nodoc
class __$UnreadMessagesValueCopyWithImpl<$Res>
    implements _$UnreadMessagesValueCopyWith<$Res> {
  __$UnreadMessagesValueCopyWithImpl(this._self, this._then);

  final _UnreadMessagesValue _self;
  final $Res Function(_UnreadMessagesValue) _then;

/// Create a copy of UnreadMessagesValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLocked = null,Object? firstReadMessageCreatedAt = freezed,}) {
  return _then(_UnreadMessagesValue(
isLocked: null == isLocked ? _self.isLocked : isLocked // ignore: cast_nullable_to_non_nullable
as bool,firstReadMessageCreatedAt: freezed == firstReadMessageCreatedAt ? _self.firstReadMessageCreatedAt : firstReadMessageCreatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
