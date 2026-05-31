// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_editor_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChannelEditorStateBase {

 ChannelEditorData get data;
/// Create a copy of ChannelEditorStateBase
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChannelEditorStateBaseCopyWith<ChannelEditorStateBase> get copyWith => _$ChannelEditorStateBaseCopyWithImpl<ChannelEditorStateBase>(this as ChannelEditorStateBase, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChannelEditorStateBase&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'ChannelEditorStateBase(data: $data)';
}


}

/// @nodoc
abstract mixin class $ChannelEditorStateBaseCopyWith<$Res>  {
  factory $ChannelEditorStateBaseCopyWith(ChannelEditorStateBase value, $Res Function(ChannelEditorStateBase) _then) = _$ChannelEditorStateBaseCopyWithImpl;
@useResult
$Res call({
 ChannelEditorData data
});


$ChannelEditorDataCopyWith<$Res> get data;

}
/// @nodoc
class _$ChannelEditorStateBaseCopyWithImpl<$Res>
    implements $ChannelEditorStateBaseCopyWith<$Res> {
  _$ChannelEditorStateBaseCopyWithImpl(this._self, this._then);

  final ChannelEditorStateBase _self;
  final $Res Function(ChannelEditorStateBase) _then;

/// Create a copy of ChannelEditorStateBase
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ChannelEditorData,
  ));
}
/// Create a copy of ChannelEditorStateBase
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChannelEditorDataCopyWith<$Res> get data {
  
  return $ChannelEditorDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChannelEditorStateBase].
extension ChannelEditorStateBasePatterns on ChannelEditorStateBase {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChannelEditorStateBase value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChannelEditorStateBase() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChannelEditorStateBase value)  $default,){
final _that = this;
switch (_that) {
case _ChannelEditorStateBase():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChannelEditorStateBase value)?  $default,){
final _that = this;
switch (_that) {
case _ChannelEditorStateBase() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ChannelEditorData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChannelEditorStateBase() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ChannelEditorData data)  $default,) {final _that = this;
switch (_that) {
case _ChannelEditorStateBase():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ChannelEditorData data)?  $default,) {final _that = this;
switch (_that) {
case _ChannelEditorStateBase() when $default != null:
return $default(_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _ChannelEditorStateBase implements ChannelEditorStateBase {
  const _ChannelEditorStateBase(this.data);
  

@override final  ChannelEditorData data;

/// Create a copy of ChannelEditorStateBase
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChannelEditorStateBaseCopyWith<_ChannelEditorStateBase> get copyWith => __$ChannelEditorStateBaseCopyWithImpl<_ChannelEditorStateBase>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChannelEditorStateBase&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'ChannelEditorStateBase(data: $data)';
}


}

/// @nodoc
abstract mixin class _$ChannelEditorStateBaseCopyWith<$Res> implements $ChannelEditorStateBaseCopyWith<$Res> {
  factory _$ChannelEditorStateBaseCopyWith(_ChannelEditorStateBase value, $Res Function(_ChannelEditorStateBase) _then) = __$ChannelEditorStateBaseCopyWithImpl;
@override @useResult
$Res call({
 ChannelEditorData data
});


@override $ChannelEditorDataCopyWith<$Res> get data;

}
/// @nodoc
class __$ChannelEditorStateBaseCopyWithImpl<$Res>
    implements _$ChannelEditorStateBaseCopyWith<$Res> {
  __$ChannelEditorStateBaseCopyWithImpl(this._self, this._then);

  final _ChannelEditorStateBase _self;
  final $Res Function(_ChannelEditorStateBase) _then;

/// Create a copy of ChannelEditorStateBase
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_ChannelEditorStateBase(
null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ChannelEditorData,
  ));
}

/// Create a copy of ChannelEditorStateBase
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChannelEditorDataCopyWith<$Res> get data {
  
  return $ChannelEditorDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

/// @nodoc
mixin _$ChannelEditorStateMessage {

 String get message; bool get isError;
/// Create a copy of ChannelEditorStateMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChannelEditorStateMessageCopyWith<ChannelEditorStateMessage> get copyWith => _$ChannelEditorStateMessageCopyWithImpl<ChannelEditorStateMessage>(this as ChannelEditorStateMessage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChannelEditorStateMessage&&(identical(other.message, message) || other.message == message)&&(identical(other.isError, isError) || other.isError == isError));
}


@override
int get hashCode => Object.hash(runtimeType,message,isError);

@override
String toString() {
  return 'ChannelEditorStateMessage(message: $message, isError: $isError)';
}


}

/// @nodoc
abstract mixin class $ChannelEditorStateMessageCopyWith<$Res>  {
  factory $ChannelEditorStateMessageCopyWith(ChannelEditorStateMessage value, $Res Function(ChannelEditorStateMessage) _then) = _$ChannelEditorStateMessageCopyWithImpl;
@useResult
$Res call({
 String message, bool isError
});




}
/// @nodoc
class _$ChannelEditorStateMessageCopyWithImpl<$Res>
    implements $ChannelEditorStateMessageCopyWith<$Res> {
  _$ChannelEditorStateMessageCopyWithImpl(this._self, this._then);

  final ChannelEditorStateMessage _self;
  final $Res Function(ChannelEditorStateMessage) _then;

/// Create a copy of ChannelEditorStateMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? isError = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,isError: null == isError ? _self.isError : isError // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChannelEditorStateMessage].
extension ChannelEditorStateMessagePatterns on ChannelEditorStateMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChannelEditorStateMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChannelEditorStateMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChannelEditorStateMessage value)  $default,){
final _that = this;
switch (_that) {
case _ChannelEditorStateMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChannelEditorStateMessage value)?  $default,){
final _that = this;
switch (_that) {
case _ChannelEditorStateMessage() when $default != null:
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
case _ChannelEditorStateMessage() when $default != null:
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
case _ChannelEditorStateMessage():
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
case _ChannelEditorStateMessage() when $default != null:
return $default(_that.message,_that.isError);case _:
  return null;

}
}

}

/// @nodoc


class _ChannelEditorStateMessage implements ChannelEditorStateMessage {
  const _ChannelEditorStateMessage({required this.message, this.isError = false});
  

@override final  String message;
@override@JsonKey() final  bool isError;

/// Create a copy of ChannelEditorStateMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChannelEditorStateMessageCopyWith<_ChannelEditorStateMessage> get copyWith => __$ChannelEditorStateMessageCopyWithImpl<_ChannelEditorStateMessage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChannelEditorStateMessage&&(identical(other.message, message) || other.message == message)&&(identical(other.isError, isError) || other.isError == isError));
}


@override
int get hashCode => Object.hash(runtimeType,message,isError);

@override
String toString() {
  return 'ChannelEditorStateMessage(message: $message, isError: $isError)';
}


}

/// @nodoc
abstract mixin class _$ChannelEditorStateMessageCopyWith<$Res> implements $ChannelEditorStateMessageCopyWith<$Res> {
  factory _$ChannelEditorStateMessageCopyWith(_ChannelEditorStateMessage value, $Res Function(_ChannelEditorStateMessage) _then) = __$ChannelEditorStateMessageCopyWithImpl;
@override @useResult
$Res call({
 String message, bool isError
});




}
/// @nodoc
class __$ChannelEditorStateMessageCopyWithImpl<$Res>
    implements _$ChannelEditorStateMessageCopyWith<$Res> {
  __$ChannelEditorStateMessageCopyWithImpl(this._self, this._then);

  final _ChannelEditorStateMessage _self;
  final $Res Function(_ChannelEditorStateMessage) _then;

/// Create a copy of ChannelEditorStateMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? isError = null,}) {
  return _then(_ChannelEditorStateMessage(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,isError: null == isError ? _self.isError : isError // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$ChannelEditorStateExit {

 String? get message;
/// Create a copy of ChannelEditorStateExit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChannelEditorStateExitCopyWith<ChannelEditorStateExit> get copyWith => _$ChannelEditorStateExitCopyWithImpl<ChannelEditorStateExit>(this as ChannelEditorStateExit, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChannelEditorStateExit&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ChannelEditorStateExit(message: $message)';
}


}

/// @nodoc
abstract mixin class $ChannelEditorStateExitCopyWith<$Res>  {
  factory $ChannelEditorStateExitCopyWith(ChannelEditorStateExit value, $Res Function(ChannelEditorStateExit) _then) = _$ChannelEditorStateExitCopyWithImpl;
@useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$ChannelEditorStateExitCopyWithImpl<$Res>
    implements $ChannelEditorStateExitCopyWith<$Res> {
  _$ChannelEditorStateExitCopyWithImpl(this._self, this._then);

  final ChannelEditorStateExit _self;
  final $Res Function(ChannelEditorStateExit) _then;

/// Create a copy of ChannelEditorStateExit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = freezed,}) {
  return _then(_self.copyWith(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChannelEditorStateExit].
extension ChannelEditorStateExitPatterns on ChannelEditorStateExit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChannelEditorStateExit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChannelEditorStateExit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChannelEditorStateExit value)  $default,){
final _that = this;
switch (_that) {
case _ChannelEditorStateExit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChannelEditorStateExit value)?  $default,){
final _that = this;
switch (_that) {
case _ChannelEditorStateExit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChannelEditorStateExit() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? message)  $default,) {final _that = this;
switch (_that) {
case _ChannelEditorStateExit():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? message)?  $default,) {final _that = this;
switch (_that) {
case _ChannelEditorStateExit() when $default != null:
return $default(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _ChannelEditorStateExit implements ChannelEditorStateExit {
  const _ChannelEditorStateExit({this.message});
  

@override final  String? message;

/// Create a copy of ChannelEditorStateExit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChannelEditorStateExitCopyWith<_ChannelEditorStateExit> get copyWith => __$ChannelEditorStateExitCopyWithImpl<_ChannelEditorStateExit>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChannelEditorStateExit&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ChannelEditorStateExit(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ChannelEditorStateExitCopyWith<$Res> implements $ChannelEditorStateExitCopyWith<$Res> {
  factory _$ChannelEditorStateExitCopyWith(_ChannelEditorStateExit value, $Res Function(_ChannelEditorStateExit) _then) = __$ChannelEditorStateExitCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$ChannelEditorStateExitCopyWithImpl<$Res>
    implements _$ChannelEditorStateExitCopyWith<$Res> {
  __$ChannelEditorStateExitCopyWithImpl(this._self, this._then);

  final _ChannelEditorStateExit _self;
  final $Res Function(_ChannelEditorStateExit) _then;

/// Create a copy of ChannelEditorStateExit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_ChannelEditorStateExit(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$ChannelEditorData {

 bool get isLoading;
/// Create a copy of ChannelEditorData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChannelEditorDataCopyWith<ChannelEditorData> get copyWith => _$ChannelEditorDataCopyWithImpl<ChannelEditorData>(this as ChannelEditorData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChannelEditorData&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'ChannelEditorData(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $ChannelEditorDataCopyWith<$Res>  {
  factory $ChannelEditorDataCopyWith(ChannelEditorData value, $Res Function(ChannelEditorData) _then) = _$ChannelEditorDataCopyWithImpl;
@useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class _$ChannelEditorDataCopyWithImpl<$Res>
    implements $ChannelEditorDataCopyWith<$Res> {
  _$ChannelEditorDataCopyWithImpl(this._self, this._then);

  final ChannelEditorData _self;
  final $Res Function(ChannelEditorData) _then;

/// Create a copy of ChannelEditorData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChannelEditorData].
extension ChannelEditorDataPatterns on ChannelEditorData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChannelEditorData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChannelEditorData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChannelEditorData value)  $default,){
final _that = this;
switch (_that) {
case _ChannelEditorData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChannelEditorData value)?  $default,){
final _that = this;
switch (_that) {
case _ChannelEditorData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChannelEditorData() when $default != null:
return $default(_that.isLoading);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading)  $default,) {final _that = this;
switch (_that) {
case _ChannelEditorData():
return $default(_that.isLoading);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading)?  $default,) {final _that = this;
switch (_that) {
case _ChannelEditorData() when $default != null:
return $default(_that.isLoading);case _:
  return null;

}
}

}

/// @nodoc


class _ChannelEditorData implements ChannelEditorData {
  const _ChannelEditorData({this.isLoading = false});
  

@override@JsonKey() final  bool isLoading;

/// Create a copy of ChannelEditorData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChannelEditorDataCopyWith<_ChannelEditorData> get copyWith => __$ChannelEditorDataCopyWithImpl<_ChannelEditorData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChannelEditorData&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading);

@override
String toString() {
  return 'ChannelEditorData(isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$ChannelEditorDataCopyWith<$Res> implements $ChannelEditorDataCopyWith<$Res> {
  factory _$ChannelEditorDataCopyWith(_ChannelEditorData value, $Res Function(_ChannelEditorData) _then) = __$ChannelEditorDataCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading
});




}
/// @nodoc
class __$ChannelEditorDataCopyWithImpl<$Res>
    implements _$ChannelEditorDataCopyWith<$Res> {
  __$ChannelEditorDataCopyWithImpl(this._self, this._then);

  final _ChannelEditorData _self;
  final $Res Function(_ChannelEditorData) _then;

/// Create a copy of ChannelEditorData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,}) {
  return _then(_ChannelEditorData(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$ChannelEditingUiData {

 String get name; String get description; String get tag; String? get imagePath;
/// Create a copy of ChannelEditingUiData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChannelEditingUiDataCopyWith<ChannelEditingUiData> get copyWith => _$ChannelEditingUiDataCopyWithImpl<ChannelEditingUiData>(this as ChannelEditingUiData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChannelEditingUiData&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath));
}


@override
int get hashCode => Object.hash(runtimeType,name,description,tag,imagePath);

@override
String toString() {
  return 'ChannelEditingUiData(name: $name, description: $description, tag: $tag, imagePath: $imagePath)';
}


}

/// @nodoc
abstract mixin class $ChannelEditingUiDataCopyWith<$Res>  {
  factory $ChannelEditingUiDataCopyWith(ChannelEditingUiData value, $Res Function(ChannelEditingUiData) _then) = _$ChannelEditingUiDataCopyWithImpl;
@useResult
$Res call({
 String name, String description, String tag, String? imagePath
});




}
/// @nodoc
class _$ChannelEditingUiDataCopyWithImpl<$Res>
    implements $ChannelEditingUiDataCopyWith<$Res> {
  _$ChannelEditingUiDataCopyWithImpl(this._self, this._then);

  final ChannelEditingUiData _self;
  final $Res Function(ChannelEditingUiData) _then;

/// Create a copy of ChannelEditingUiData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = null,Object? tag = null,Object? imagePath = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChannelEditingUiData].
extension ChannelEditingUiDataPatterns on ChannelEditingUiData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChannelEditingUiData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChannelEditingUiData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChannelEditingUiData value)  $default,){
final _that = this;
switch (_that) {
case _ChannelEditingUiData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChannelEditingUiData value)?  $default,){
final _that = this;
switch (_that) {
case _ChannelEditingUiData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String description,  String tag,  String? imagePath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChannelEditingUiData() when $default != null:
return $default(_that.name,_that.description,_that.tag,_that.imagePath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String description,  String tag,  String? imagePath)  $default,) {final _that = this;
switch (_that) {
case _ChannelEditingUiData():
return $default(_that.name,_that.description,_that.tag,_that.imagePath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String description,  String tag,  String? imagePath)?  $default,) {final _that = this;
switch (_that) {
case _ChannelEditingUiData() when $default != null:
return $default(_that.name,_that.description,_that.tag,_that.imagePath);case _:
  return null;

}
}

}

/// @nodoc


class _ChannelEditingUiData implements ChannelEditingUiData {
  const _ChannelEditingUiData({required this.name, required this.description, required this.tag, required this.imagePath});
  

@override final  String name;
@override final  String description;
@override final  String tag;
@override final  String? imagePath;

/// Create a copy of ChannelEditingUiData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChannelEditingUiDataCopyWith<_ChannelEditingUiData> get copyWith => __$ChannelEditingUiDataCopyWithImpl<_ChannelEditingUiData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChannelEditingUiData&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath));
}


@override
int get hashCode => Object.hash(runtimeType,name,description,tag,imagePath);

@override
String toString() {
  return 'ChannelEditingUiData(name: $name, description: $description, tag: $tag, imagePath: $imagePath)';
}


}

/// @nodoc
abstract mixin class _$ChannelEditingUiDataCopyWith<$Res> implements $ChannelEditingUiDataCopyWith<$Res> {
  factory _$ChannelEditingUiDataCopyWith(_ChannelEditingUiData value, $Res Function(_ChannelEditingUiData) _then) = __$ChannelEditingUiDataCopyWithImpl;
@override @useResult
$Res call({
 String name, String description, String tag, String? imagePath
});




}
/// @nodoc
class __$ChannelEditingUiDataCopyWithImpl<$Res>
    implements _$ChannelEditingUiDataCopyWith<$Res> {
  __$ChannelEditingUiDataCopyWithImpl(this._self, this._then);

  final _ChannelEditingUiData _self;
  final $Res Function(_ChannelEditingUiData) _then;

/// Create a copy of ChannelEditingUiData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = null,Object? tag = null,Object? imagePath = freezed,}) {
  return _then(_ChannelEditingUiData(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
