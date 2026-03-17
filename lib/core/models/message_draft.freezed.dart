// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MessageDraft {

 String get message; int get chatId; int get createdAt;
/// Create a copy of MessageDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageDraftCopyWith<MessageDraft> get copyWith => _$MessageDraftCopyWithImpl<MessageDraft>(this as MessageDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageDraft&&(identical(other.message, message) || other.message == message)&&(identical(other.chatId, chatId) || other.chatId == chatId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,message,chatId,createdAt);

@override
String toString() {
  return 'MessageDraft(message: $message, chatId: $chatId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $MessageDraftCopyWith<$Res>  {
  factory $MessageDraftCopyWith(MessageDraft value, $Res Function(MessageDraft) _then) = _$MessageDraftCopyWithImpl;
@useResult
$Res call({
 String message, int chatId, int createdAt
});




}
/// @nodoc
class _$MessageDraftCopyWithImpl<$Res>
    implements $MessageDraftCopyWith<$Res> {
  _$MessageDraftCopyWithImpl(this._self, this._then);

  final MessageDraft _self;
  final $Res Function(MessageDraft) _then;

/// Create a copy of MessageDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? chatId = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MessageDraft].
extension MessageDraftPatterns on MessageDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessageDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessageDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessageDraft value)  $default,){
final _that = this;
switch (_that) {
case _MessageDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessageDraft value)?  $default,){
final _that = this;
switch (_that) {
case _MessageDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String message,  int chatId,  int createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageDraft() when $default != null:
return $default(_that.message,_that.chatId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String message,  int chatId,  int createdAt)  $default,) {final _that = this;
switch (_that) {
case _MessageDraft():
return $default(_that.message,_that.chatId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String message,  int chatId,  int createdAt)?  $default,) {final _that = this;
switch (_that) {
case _MessageDraft() when $default != null:
return $default(_that.message,_that.chatId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _MessageDraft implements MessageDraft {
  const _MessageDraft({required this.message, required this.chatId, required this.createdAt});
  

@override final  String message;
@override final  int chatId;
@override final  int createdAt;

/// Create a copy of MessageDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageDraftCopyWith<_MessageDraft> get copyWith => __$MessageDraftCopyWithImpl<_MessageDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageDraft&&(identical(other.message, message) || other.message == message)&&(identical(other.chatId, chatId) || other.chatId == chatId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,message,chatId,createdAt);

@override
String toString() {
  return 'MessageDraft(message: $message, chatId: $chatId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$MessageDraftCopyWith<$Res> implements $MessageDraftCopyWith<$Res> {
  factory _$MessageDraftCopyWith(_MessageDraft value, $Res Function(_MessageDraft) _then) = __$MessageDraftCopyWithImpl;
@override @useResult
$Res call({
 String message, int chatId, int createdAt
});




}
/// @nodoc
class __$MessageDraftCopyWithImpl<$Res>
    implements _$MessageDraftCopyWith<$Res> {
  __$MessageDraftCopyWithImpl(this._self, this._then);

  final _MessageDraft _self;
  final $Res Function(_MessageDraft) _then;

/// Create a copy of MessageDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? chatId = null,Object? createdAt = null,}) {
  return _then(_MessageDraft(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
