// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_update.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChannelUpdate {

 int get channelId; ChannelData get newChannelData;
/// Create a copy of ChannelUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChannelUpdateCopyWith<ChannelUpdate> get copyWith => _$ChannelUpdateCopyWithImpl<ChannelUpdate>(this as ChannelUpdate, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChannelUpdate&&(identical(other.channelId, channelId) || other.channelId == channelId)&&(identical(other.newChannelData, newChannelData) || other.newChannelData == newChannelData));
}


@override
int get hashCode => Object.hash(runtimeType,channelId,newChannelData);

@override
String toString() {
  return 'ChannelUpdate(channelId: $channelId, newChannelData: $newChannelData)';
}


}

/// @nodoc
abstract mixin class $ChannelUpdateCopyWith<$Res>  {
  factory $ChannelUpdateCopyWith(ChannelUpdate value, $Res Function(ChannelUpdate) _then) = _$ChannelUpdateCopyWithImpl;
@useResult
$Res call({
 int channelId, ChannelData newChannelData
});


$ChannelDataCopyWith<$Res> get newChannelData;

}
/// @nodoc
class _$ChannelUpdateCopyWithImpl<$Res>
    implements $ChannelUpdateCopyWith<$Res> {
  _$ChannelUpdateCopyWithImpl(this._self, this._then);

  final ChannelUpdate _self;
  final $Res Function(ChannelUpdate) _then;

/// Create a copy of ChannelUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? channelId = null,Object? newChannelData = null,}) {
  return _then(_self.copyWith(
channelId: null == channelId ? _self.channelId : channelId // ignore: cast_nullable_to_non_nullable
as int,newChannelData: null == newChannelData ? _self.newChannelData : newChannelData // ignore: cast_nullable_to_non_nullable
as ChannelData,
  ));
}
/// Create a copy of ChannelUpdate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChannelDataCopyWith<$Res> get newChannelData {
  
  return $ChannelDataCopyWith<$Res>(_self.newChannelData, (value) {
    return _then(_self.copyWith(newChannelData: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChannelUpdate].
extension ChannelUpdatePatterns on ChannelUpdate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChannelUpdate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChannelUpdate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChannelUpdate value)  $default,){
final _that = this;
switch (_that) {
case _ChannelUpdate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChannelUpdate value)?  $default,){
final _that = this;
switch (_that) {
case _ChannelUpdate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int channelId,  ChannelData newChannelData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChannelUpdate() when $default != null:
return $default(_that.channelId,_that.newChannelData);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int channelId,  ChannelData newChannelData)  $default,) {final _that = this;
switch (_that) {
case _ChannelUpdate():
return $default(_that.channelId,_that.newChannelData);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int channelId,  ChannelData newChannelData)?  $default,) {final _that = this;
switch (_that) {
case _ChannelUpdate() when $default != null:
return $default(_that.channelId,_that.newChannelData);case _:
  return null;

}
}

}

/// @nodoc


class _ChannelUpdate implements ChannelUpdate {
  const _ChannelUpdate({required this.channelId, required this.newChannelData});
  

@override final  int channelId;
@override final  ChannelData newChannelData;

/// Create a copy of ChannelUpdate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChannelUpdateCopyWith<_ChannelUpdate> get copyWith => __$ChannelUpdateCopyWithImpl<_ChannelUpdate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChannelUpdate&&(identical(other.channelId, channelId) || other.channelId == channelId)&&(identical(other.newChannelData, newChannelData) || other.newChannelData == newChannelData));
}


@override
int get hashCode => Object.hash(runtimeType,channelId,newChannelData);

@override
String toString() {
  return 'ChannelUpdate(channelId: $channelId, newChannelData: $newChannelData)';
}


}

/// @nodoc
abstract mixin class _$ChannelUpdateCopyWith<$Res> implements $ChannelUpdateCopyWith<$Res> {
  factory _$ChannelUpdateCopyWith(_ChannelUpdate value, $Res Function(_ChannelUpdate) _then) = __$ChannelUpdateCopyWithImpl;
@override @useResult
$Res call({
 int channelId, ChannelData newChannelData
});


@override $ChannelDataCopyWith<$Res> get newChannelData;

}
/// @nodoc
class __$ChannelUpdateCopyWithImpl<$Res>
    implements _$ChannelUpdateCopyWith<$Res> {
  __$ChannelUpdateCopyWithImpl(this._self, this._then);

  final _ChannelUpdate _self;
  final $Res Function(_ChannelUpdate) _then;

/// Create a copy of ChannelUpdate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? channelId = null,Object? newChannelData = null,}) {
  return _then(_ChannelUpdate(
channelId: null == channelId ? _self.channelId : channelId // ignore: cast_nullable_to_non_nullable
as int,newChannelData: null == newChannelData ? _self.newChannelData : newChannelData // ignore: cast_nullable_to_non_nullable
as ChannelData,
  ));
}

/// Create a copy of ChannelUpdate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChannelDataCopyWith<$Res> get newChannelData {
  
  return $ChannelDataCopyWith<$Res>(_self.newChannelData, (value) {
    return _then(_self.copyWith(newChannelData: value));
  });
}
}

// dart format on
