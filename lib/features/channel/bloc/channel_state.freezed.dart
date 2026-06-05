// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChannelStateBase {

 ChannelScreenData get data;
/// Create a copy of ChannelStateBase
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChannelStateBaseCopyWith<ChannelStateBase> get copyWith => _$ChannelStateBaseCopyWithImpl<ChannelStateBase>(this as ChannelStateBase, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChannelStateBase&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'ChannelStateBase(data: $data)';
}


}

/// @nodoc
abstract mixin class $ChannelStateBaseCopyWith<$Res>  {
  factory $ChannelStateBaseCopyWith(ChannelStateBase value, $Res Function(ChannelStateBase) _then) = _$ChannelStateBaseCopyWithImpl;
@useResult
$Res call({
 ChannelScreenData data
});


$ChannelScreenDataCopyWith<$Res> get data;

}
/// @nodoc
class _$ChannelStateBaseCopyWithImpl<$Res>
    implements $ChannelStateBaseCopyWith<$Res> {
  _$ChannelStateBaseCopyWithImpl(this._self, this._then);

  final ChannelStateBase _self;
  final $Res Function(ChannelStateBase) _then;

/// Create a copy of ChannelStateBase
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ChannelScreenData,
  ));
}
/// Create a copy of ChannelStateBase
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChannelScreenDataCopyWith<$Res> get data {
  
  return $ChannelScreenDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChannelStateBase].
extension ChannelStateBasePatterns on ChannelStateBase {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChannelStateBase value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChannelStateBase() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChannelStateBase value)  $default,){
final _that = this;
switch (_that) {
case _ChannelStateBase():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChannelStateBase value)?  $default,){
final _that = this;
switch (_that) {
case _ChannelStateBase() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ChannelScreenData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChannelStateBase() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ChannelScreenData data)  $default,) {final _that = this;
switch (_that) {
case _ChannelStateBase():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ChannelScreenData data)?  $default,) {final _that = this;
switch (_that) {
case _ChannelStateBase() when $default != null:
return $default(_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _ChannelStateBase implements ChannelStateBase {
  const _ChannelStateBase(this.data);
  

@override final  ChannelScreenData data;

/// Create a copy of ChannelStateBase
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChannelStateBaseCopyWith<_ChannelStateBase> get copyWith => __$ChannelStateBaseCopyWithImpl<_ChannelStateBase>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChannelStateBase&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'ChannelStateBase(data: $data)';
}


}

/// @nodoc
abstract mixin class _$ChannelStateBaseCopyWith<$Res> implements $ChannelStateBaseCopyWith<$Res> {
  factory _$ChannelStateBaseCopyWith(_ChannelStateBase value, $Res Function(_ChannelStateBase) _then) = __$ChannelStateBaseCopyWithImpl;
@override @useResult
$Res call({
 ChannelScreenData data
});


@override $ChannelScreenDataCopyWith<$Res> get data;

}
/// @nodoc
class __$ChannelStateBaseCopyWithImpl<$Res>
    implements _$ChannelStateBaseCopyWith<$Res> {
  __$ChannelStateBaseCopyWithImpl(this._self, this._then);

  final _ChannelStateBase _self;
  final $Res Function(_ChannelStateBase) _then;

/// Create a copy of ChannelStateBase
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_ChannelStateBase(
null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ChannelScreenData,
  ));
}

/// Create a copy of ChannelStateBase
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChannelScreenDataCopyWith<$Res> get data {
  
  return $ChannelScreenDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

/// @nodoc
mixin _$ChannelStateMessage {

 String get message; bool get isError;
/// Create a copy of ChannelStateMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChannelStateMessageCopyWith<ChannelStateMessage> get copyWith => _$ChannelStateMessageCopyWithImpl<ChannelStateMessage>(this as ChannelStateMessage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChannelStateMessage&&(identical(other.message, message) || other.message == message)&&(identical(other.isError, isError) || other.isError == isError));
}


@override
int get hashCode => Object.hash(runtimeType,message,isError);

@override
String toString() {
  return 'ChannelStateMessage(message: $message, isError: $isError)';
}


}

/// @nodoc
abstract mixin class $ChannelStateMessageCopyWith<$Res>  {
  factory $ChannelStateMessageCopyWith(ChannelStateMessage value, $Res Function(ChannelStateMessage) _then) = _$ChannelStateMessageCopyWithImpl;
@useResult
$Res call({
 String message, bool isError
});




}
/// @nodoc
class _$ChannelStateMessageCopyWithImpl<$Res>
    implements $ChannelStateMessageCopyWith<$Res> {
  _$ChannelStateMessageCopyWithImpl(this._self, this._then);

  final ChannelStateMessage _self;
  final $Res Function(ChannelStateMessage) _then;

/// Create a copy of ChannelStateMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? isError = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,isError: null == isError ? _self.isError : isError // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChannelStateMessage].
extension ChannelStateMessagePatterns on ChannelStateMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChannelStateMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChannelStateMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChannelStateMessage value)  $default,){
final _that = this;
switch (_that) {
case _ChannelStateMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChannelStateMessage value)?  $default,){
final _that = this;
switch (_that) {
case _ChannelStateMessage() when $default != null:
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
case _ChannelStateMessage() when $default != null:
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
case _ChannelStateMessage():
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
case _ChannelStateMessage() when $default != null:
return $default(_that.message,_that.isError);case _:
  return null;

}
}

}

/// @nodoc


class _ChannelStateMessage implements ChannelStateMessage {
  const _ChannelStateMessage({required this.message, this.isError = false});
  

@override final  String message;
@override@JsonKey() final  bool isError;

/// Create a copy of ChannelStateMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChannelStateMessageCopyWith<_ChannelStateMessage> get copyWith => __$ChannelStateMessageCopyWithImpl<_ChannelStateMessage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChannelStateMessage&&(identical(other.message, message) || other.message == message)&&(identical(other.isError, isError) || other.isError == isError));
}


@override
int get hashCode => Object.hash(runtimeType,message,isError);

@override
String toString() {
  return 'ChannelStateMessage(message: $message, isError: $isError)';
}


}

/// @nodoc
abstract mixin class _$ChannelStateMessageCopyWith<$Res> implements $ChannelStateMessageCopyWith<$Res> {
  factory _$ChannelStateMessageCopyWith(_ChannelStateMessage value, $Res Function(_ChannelStateMessage) _then) = __$ChannelStateMessageCopyWithImpl;
@override @useResult
$Res call({
 String message, bool isError
});




}
/// @nodoc
class __$ChannelStateMessageCopyWithImpl<$Res>
    implements _$ChannelStateMessageCopyWith<$Res> {
  __$ChannelStateMessageCopyWithImpl(this._self, this._then);

  final _ChannelStateMessage _self;
  final $Res Function(_ChannelStateMessage) _then;

/// Create a copy of ChannelStateMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? isError = null,}) {
  return _then(_ChannelStateMessage(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,isError: null == isError ? _self.isError : isError // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$ChannelStateDeleted {

 bool get showToast;
/// Create a copy of ChannelStateDeleted
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChannelStateDeletedCopyWith<ChannelStateDeleted> get copyWith => _$ChannelStateDeletedCopyWithImpl<ChannelStateDeleted>(this as ChannelStateDeleted, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChannelStateDeleted&&(identical(other.showToast, showToast) || other.showToast == showToast));
}


@override
int get hashCode => Object.hash(runtimeType,showToast);

@override
String toString() {
  return 'ChannelStateDeleted(showToast: $showToast)';
}


}

/// @nodoc
abstract mixin class $ChannelStateDeletedCopyWith<$Res>  {
  factory $ChannelStateDeletedCopyWith(ChannelStateDeleted value, $Res Function(ChannelStateDeleted) _then) = _$ChannelStateDeletedCopyWithImpl;
@useResult
$Res call({
 bool showToast
});




}
/// @nodoc
class _$ChannelStateDeletedCopyWithImpl<$Res>
    implements $ChannelStateDeletedCopyWith<$Res> {
  _$ChannelStateDeletedCopyWithImpl(this._self, this._then);

  final ChannelStateDeleted _self;
  final $Res Function(ChannelStateDeleted) _then;

/// Create a copy of ChannelStateDeleted
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? showToast = null,}) {
  return _then(_self.copyWith(
showToast: null == showToast ? _self.showToast : showToast // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChannelStateDeleted].
extension ChannelStateDeletedPatterns on ChannelStateDeleted {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChannelStateDeleted value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChannelStateDeleted() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChannelStateDeleted value)  $default,){
final _that = this;
switch (_that) {
case _ChannelStateDeleted():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChannelStateDeleted value)?  $default,){
final _that = this;
switch (_that) {
case _ChannelStateDeleted() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool showToast)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChannelStateDeleted() when $default != null:
return $default(_that.showToast);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool showToast)  $default,) {final _that = this;
switch (_that) {
case _ChannelStateDeleted():
return $default(_that.showToast);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool showToast)?  $default,) {final _that = this;
switch (_that) {
case _ChannelStateDeleted() when $default != null:
return $default(_that.showToast);case _:
  return null;

}
}

}

/// @nodoc


class _ChannelStateDeleted implements ChannelStateDeleted {
  const _ChannelStateDeleted({this.showToast = true});
  

@override@JsonKey() final  bool showToast;

/// Create a copy of ChannelStateDeleted
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChannelStateDeletedCopyWith<_ChannelStateDeleted> get copyWith => __$ChannelStateDeletedCopyWithImpl<_ChannelStateDeleted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChannelStateDeleted&&(identical(other.showToast, showToast) || other.showToast == showToast));
}


@override
int get hashCode => Object.hash(runtimeType,showToast);

@override
String toString() {
  return 'ChannelStateDeleted(showToast: $showToast)';
}


}

/// @nodoc
abstract mixin class _$ChannelStateDeletedCopyWith<$Res> implements $ChannelStateDeletedCopyWith<$Res> {
  factory _$ChannelStateDeletedCopyWith(_ChannelStateDeleted value, $Res Function(_ChannelStateDeleted) _then) = __$ChannelStateDeletedCopyWithImpl;
@override @useResult
$Res call({
 bool showToast
});




}
/// @nodoc
class __$ChannelStateDeletedCopyWithImpl<$Res>
    implements _$ChannelStateDeletedCopyWith<$Res> {
  __$ChannelStateDeletedCopyWithImpl(this._self, this._then);

  final _ChannelStateDeleted _self;
  final $Res Function(_ChannelStateDeleted) _then;

/// Create a copy of ChannelStateDeleted
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? showToast = null,}) {
  return _then(_ChannelStateDeleted(
showToast: null == showToast ? _self.showToast : showToast // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$ChannelScreenData {

 ChannelData get channelData; List<User> get subs; bool get isLoading; bool get isConnected;
/// Create a copy of ChannelScreenData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChannelScreenDataCopyWith<ChannelScreenData> get copyWith => _$ChannelScreenDataCopyWithImpl<ChannelScreenData>(this as ChannelScreenData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChannelScreenData&&(identical(other.channelData, channelData) || other.channelData == channelData)&&const DeepCollectionEquality().equals(other.subs, subs)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected));
}


@override
int get hashCode => Object.hash(runtimeType,channelData,const DeepCollectionEquality().hash(subs),isLoading,isConnected);

@override
String toString() {
  return 'ChannelScreenData(channelData: $channelData, subs: $subs, isLoading: $isLoading, isConnected: $isConnected)';
}


}

/// @nodoc
abstract mixin class $ChannelScreenDataCopyWith<$Res>  {
  factory $ChannelScreenDataCopyWith(ChannelScreenData value, $Res Function(ChannelScreenData) _then) = _$ChannelScreenDataCopyWithImpl;
@useResult
$Res call({
 ChannelData channelData, List<User> subs, bool isLoading, bool isConnected
});


$ChannelDataCopyWith<$Res> get channelData;

}
/// @nodoc
class _$ChannelScreenDataCopyWithImpl<$Res>
    implements $ChannelScreenDataCopyWith<$Res> {
  _$ChannelScreenDataCopyWithImpl(this._self, this._then);

  final ChannelScreenData _self;
  final $Res Function(ChannelScreenData) _then;

/// Create a copy of ChannelScreenData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? channelData = null,Object? subs = null,Object? isLoading = null,Object? isConnected = null,}) {
  return _then(_self.copyWith(
channelData: null == channelData ? _self.channelData : channelData // ignore: cast_nullable_to_non_nullable
as ChannelData,subs: null == subs ? _self.subs : subs // ignore: cast_nullable_to_non_nullable
as List<User>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isConnected: null == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of ChannelScreenData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChannelDataCopyWith<$Res> get channelData {
  
  return $ChannelDataCopyWith<$Res>(_self.channelData, (value) {
    return _then(_self.copyWith(channelData: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChannelScreenData].
extension ChannelScreenDataPatterns on ChannelScreenData {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ChannelData channelData,  List<User> subs,  bool isLoading,  bool isConnected)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChannelData() when $default != null:
return $default(_that.channelData,_that.subs,_that.isLoading,_that.isConnected);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ChannelData channelData,  List<User> subs,  bool isLoading,  bool isConnected)  $default,) {final _that = this;
switch (_that) {
case _ChannelData():
return $default(_that.channelData,_that.subs,_that.isLoading,_that.isConnected);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ChannelData channelData,  List<User> subs,  bool isLoading,  bool isConnected)?  $default,) {final _that = this;
switch (_that) {
case _ChannelData() when $default != null:
return $default(_that.channelData,_that.subs,_that.isLoading,_that.isConnected);case _:
  return null;

}
}

}

/// @nodoc


class _ChannelData implements ChannelScreenData {
  const _ChannelData({required this.channelData, required final  List<User> subs, this.isLoading = true, this.isConnected = false}): _subs = subs;
  

@override final  ChannelData channelData;
 final  List<User> _subs;
@override List<User> get subs {
  if (_subs is EqualUnmodifiableListView) return _subs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subs);
}

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isConnected;

/// Create a copy of ChannelScreenData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChannelDataCopyWith<_ChannelData> get copyWith => __$ChannelDataCopyWithImpl<_ChannelData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChannelData&&(identical(other.channelData, channelData) || other.channelData == channelData)&&const DeepCollectionEquality().equals(other._subs, _subs)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected));
}


@override
int get hashCode => Object.hash(runtimeType,channelData,const DeepCollectionEquality().hash(_subs),isLoading,isConnected);

@override
String toString() {
  return 'ChannelScreenData(channelData: $channelData, subs: $subs, isLoading: $isLoading, isConnected: $isConnected)';
}


}

/// @nodoc
abstract mixin class _$ChannelDataCopyWith<$Res> implements $ChannelScreenDataCopyWith<$Res> {
  factory _$ChannelDataCopyWith(_ChannelData value, $Res Function(_ChannelData) _then) = __$ChannelDataCopyWithImpl;
@override @useResult
$Res call({
 ChannelData channelData, List<User> subs, bool isLoading, bool isConnected
});


@override $ChannelDataCopyWith<$Res> get channelData;

}
/// @nodoc
class __$ChannelDataCopyWithImpl<$Res>
    implements _$ChannelDataCopyWith<$Res> {
  __$ChannelDataCopyWithImpl(this._self, this._then);

  final _ChannelData _self;
  final $Res Function(_ChannelData) _then;

/// Create a copy of ChannelScreenData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? channelData = null,Object? subs = null,Object? isLoading = null,Object? isConnected = null,}) {
  return _then(_ChannelData(
channelData: null == channelData ? _self.channelData : channelData // ignore: cast_nullable_to_non_nullable
as ChannelData,subs: null == subs ? _self._subs : subs // ignore: cast_nullable_to_non_nullable
as List<User>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isConnected: null == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of ChannelScreenData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChannelDataCopyWith<$Res> get channelData {
  
  return $ChannelDataCopyWith<$Res>(_self.channelData, (value) {
    return _then(_self.copyWith(channelData: value));
  });
}
}

// dart format on
