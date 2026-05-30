// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_on_chat_screen_update.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChannelOnChatScreenUpdate {

 int get channelId; ChannelData? get newChannelData; UserChannelRole? get newUserRole; int? get newSubsCount;
/// Create a copy of ChannelOnChatScreenUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChannelOnChatScreenUpdateCopyWith<ChannelOnChatScreenUpdate> get copyWith => _$ChannelOnChatScreenUpdateCopyWithImpl<ChannelOnChatScreenUpdate>(this as ChannelOnChatScreenUpdate, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChannelOnChatScreenUpdate&&(identical(other.channelId, channelId) || other.channelId == channelId)&&(identical(other.newChannelData, newChannelData) || other.newChannelData == newChannelData)&&(identical(other.newUserRole, newUserRole) || other.newUserRole == newUserRole)&&(identical(other.newSubsCount, newSubsCount) || other.newSubsCount == newSubsCount));
}


@override
int get hashCode => Object.hash(runtimeType,channelId,newChannelData,newUserRole,newSubsCount);

@override
String toString() {
  return 'ChannelOnChatScreenUpdate(channelId: $channelId, newChannelData: $newChannelData, newUserRole: $newUserRole, newSubsCount: $newSubsCount)';
}


}

/// @nodoc
abstract mixin class $ChannelOnChatScreenUpdateCopyWith<$Res>  {
  factory $ChannelOnChatScreenUpdateCopyWith(ChannelOnChatScreenUpdate value, $Res Function(ChannelOnChatScreenUpdate) _then) = _$ChannelOnChatScreenUpdateCopyWithImpl;
@useResult
$Res call({
 int channelId, ChannelData? newChannelData, UserChannelRole? newUserRole, int? newSubsCount
});


$ChannelDataCopyWith<$Res>? get newChannelData;

}
/// @nodoc
class _$ChannelOnChatScreenUpdateCopyWithImpl<$Res>
    implements $ChannelOnChatScreenUpdateCopyWith<$Res> {
  _$ChannelOnChatScreenUpdateCopyWithImpl(this._self, this._then);

  final ChannelOnChatScreenUpdate _self;
  final $Res Function(ChannelOnChatScreenUpdate) _then;

/// Create a copy of ChannelOnChatScreenUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? channelId = null,Object? newChannelData = freezed,Object? newUserRole = freezed,Object? newSubsCount = freezed,}) {
  return _then(_self.copyWith(
channelId: null == channelId ? _self.channelId : channelId // ignore: cast_nullable_to_non_nullable
as int,newChannelData: freezed == newChannelData ? _self.newChannelData : newChannelData // ignore: cast_nullable_to_non_nullable
as ChannelData?,newUserRole: freezed == newUserRole ? _self.newUserRole : newUserRole // ignore: cast_nullable_to_non_nullable
as UserChannelRole?,newSubsCount: freezed == newSubsCount ? _self.newSubsCount : newSubsCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of ChannelOnChatScreenUpdate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChannelDataCopyWith<$Res>? get newChannelData {
    if (_self.newChannelData == null) {
    return null;
  }

  return $ChannelDataCopyWith<$Res>(_self.newChannelData!, (value) {
    return _then(_self.copyWith(newChannelData: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChannelOnChatScreenUpdate].
extension ChannelOnChatScreenUpdatePatterns on ChannelOnChatScreenUpdate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChannelOnChatScreenUpdate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChannelOnChatScreenUpdate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChannelOnChatScreenUpdate value)  $default,){
final _that = this;
switch (_that) {
case _ChannelOnChatScreenUpdate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChannelOnChatScreenUpdate value)?  $default,){
final _that = this;
switch (_that) {
case _ChannelOnChatScreenUpdate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int channelId,  ChannelData? newChannelData,  UserChannelRole? newUserRole,  int? newSubsCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChannelOnChatScreenUpdate() when $default != null:
return $default(_that.channelId,_that.newChannelData,_that.newUserRole,_that.newSubsCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int channelId,  ChannelData? newChannelData,  UserChannelRole? newUserRole,  int? newSubsCount)  $default,) {final _that = this;
switch (_that) {
case _ChannelOnChatScreenUpdate():
return $default(_that.channelId,_that.newChannelData,_that.newUserRole,_that.newSubsCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int channelId,  ChannelData? newChannelData,  UserChannelRole? newUserRole,  int? newSubsCount)?  $default,) {final _that = this;
switch (_that) {
case _ChannelOnChatScreenUpdate() when $default != null:
return $default(_that.channelId,_that.newChannelData,_that.newUserRole,_that.newSubsCount);case _:
  return null;

}
}

}

/// @nodoc


class _ChannelOnChatScreenUpdate implements ChannelOnChatScreenUpdate {
  const _ChannelOnChatScreenUpdate({required this.channelId, this.newChannelData, this.newUserRole, this.newSubsCount}): assert(newChannelData == null || (newUserRole == null && newSubsCount == null), 'If there is newChannelData, other fields must be null');
  

@override final  int channelId;
@override final  ChannelData? newChannelData;
@override final  UserChannelRole? newUserRole;
@override final  int? newSubsCount;

/// Create a copy of ChannelOnChatScreenUpdate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChannelOnChatScreenUpdateCopyWith<_ChannelOnChatScreenUpdate> get copyWith => __$ChannelOnChatScreenUpdateCopyWithImpl<_ChannelOnChatScreenUpdate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChannelOnChatScreenUpdate&&(identical(other.channelId, channelId) || other.channelId == channelId)&&(identical(other.newChannelData, newChannelData) || other.newChannelData == newChannelData)&&(identical(other.newUserRole, newUserRole) || other.newUserRole == newUserRole)&&(identical(other.newSubsCount, newSubsCount) || other.newSubsCount == newSubsCount));
}


@override
int get hashCode => Object.hash(runtimeType,channelId,newChannelData,newUserRole,newSubsCount);

@override
String toString() {
  return 'ChannelOnChatScreenUpdate(channelId: $channelId, newChannelData: $newChannelData, newUserRole: $newUserRole, newSubsCount: $newSubsCount)';
}


}

/// @nodoc
abstract mixin class _$ChannelOnChatScreenUpdateCopyWith<$Res> implements $ChannelOnChatScreenUpdateCopyWith<$Res> {
  factory _$ChannelOnChatScreenUpdateCopyWith(_ChannelOnChatScreenUpdate value, $Res Function(_ChannelOnChatScreenUpdate) _then) = __$ChannelOnChatScreenUpdateCopyWithImpl;
@override @useResult
$Res call({
 int channelId, ChannelData? newChannelData, UserChannelRole? newUserRole, int? newSubsCount
});


@override $ChannelDataCopyWith<$Res>? get newChannelData;

}
/// @nodoc
class __$ChannelOnChatScreenUpdateCopyWithImpl<$Res>
    implements _$ChannelOnChatScreenUpdateCopyWith<$Res> {
  __$ChannelOnChatScreenUpdateCopyWithImpl(this._self, this._then);

  final _ChannelOnChatScreenUpdate _self;
  final $Res Function(_ChannelOnChatScreenUpdate) _then;

/// Create a copy of ChannelOnChatScreenUpdate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? channelId = null,Object? newChannelData = freezed,Object? newUserRole = freezed,Object? newSubsCount = freezed,}) {
  return _then(_ChannelOnChatScreenUpdate(
channelId: null == channelId ? _self.channelId : channelId // ignore: cast_nullable_to_non_nullable
as int,newChannelData: freezed == newChannelData ? _self.newChannelData : newChannelData // ignore: cast_nullable_to_non_nullable
as ChannelData?,newUserRole: freezed == newUserRole ? _self.newUserRole : newUserRole // ignore: cast_nullable_to_non_nullable
as UserChannelRole?,newSubsCount: freezed == newSubsCount ? _self.newSubsCount : newSubsCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of ChannelOnChatScreenUpdate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChannelDataCopyWith<$Res>? get newChannelData {
    if (_self.newChannelData == null) {
    return null;
  }

  return $ChannelDataCopyWith<$Res>(_self.newChannelData!, (value) {
    return _then(_self.copyWith(newChannelData: value));
  });
}
}

// dart format on
