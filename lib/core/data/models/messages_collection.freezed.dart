// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'messages_collection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MessagesCollection {

 int get chatId; Iterable<Message> get messages;/// if get messages from cache, loading still have to be visible
 bool get fromCache; bool? get allMessagesLoaded;
/// Create a copy of MessagesCollection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessagesCollectionCopyWith<MessagesCollection> get copyWith => _$MessagesCollectionCopyWithImpl<MessagesCollection>(this as MessagesCollection, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessagesCollection&&(identical(other.chatId, chatId) || other.chatId == chatId)&&const DeepCollectionEquality().equals(other.messages, messages)&&(identical(other.fromCache, fromCache) || other.fromCache == fromCache)&&(identical(other.allMessagesLoaded, allMessagesLoaded) || other.allMessagesLoaded == allMessagesLoaded));
}


@override
int get hashCode => Object.hash(runtimeType,chatId,const DeepCollectionEquality().hash(messages),fromCache,allMessagesLoaded);

@override
String toString() {
  return 'MessagesCollection(chatId: $chatId, messages: $messages, fromCache: $fromCache, allMessagesLoaded: $allMessagesLoaded)';
}


}

/// @nodoc
abstract mixin class $MessagesCollectionCopyWith<$Res>  {
  factory $MessagesCollectionCopyWith(MessagesCollection value, $Res Function(MessagesCollection) _then) = _$MessagesCollectionCopyWithImpl;
@useResult
$Res call({
 int chatId, Iterable<Message> messages, bool fromCache, bool? allMessagesLoaded
});




}
/// @nodoc
class _$MessagesCollectionCopyWithImpl<$Res>
    implements $MessagesCollectionCopyWith<$Res> {
  _$MessagesCollectionCopyWithImpl(this._self, this._then);

  final MessagesCollection _self;
  final $Res Function(MessagesCollection) _then;

/// Create a copy of MessagesCollection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chatId = null,Object? messages = null,Object? fromCache = null,Object? allMessagesLoaded = freezed,}) {
  return _then(_self.copyWith(
chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as int,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as Iterable<Message>,fromCache: null == fromCache ? _self.fromCache : fromCache // ignore: cast_nullable_to_non_nullable
as bool,allMessagesLoaded: freezed == allMessagesLoaded ? _self.allMessagesLoaded : allMessagesLoaded // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [MessagesCollection].
extension MessagesCollectionPatterns on MessagesCollection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessagesCollection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessagesCollection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessagesCollection value)  $default,){
final _that = this;
switch (_that) {
case _MessagesCollection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessagesCollection value)?  $default,){
final _that = this;
switch (_that) {
case _MessagesCollection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int chatId,  Iterable<Message> messages,  bool fromCache,  bool? allMessagesLoaded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessagesCollection() when $default != null:
return $default(_that.chatId,_that.messages,_that.fromCache,_that.allMessagesLoaded);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int chatId,  Iterable<Message> messages,  bool fromCache,  bool? allMessagesLoaded)  $default,) {final _that = this;
switch (_that) {
case _MessagesCollection():
return $default(_that.chatId,_that.messages,_that.fromCache,_that.allMessagesLoaded);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int chatId,  Iterable<Message> messages,  bool fromCache,  bool? allMessagesLoaded)?  $default,) {final _that = this;
switch (_that) {
case _MessagesCollection() when $default != null:
return $default(_that.chatId,_that.messages,_that.fromCache,_that.allMessagesLoaded);case _:
  return null;

}
}

}

/// @nodoc


class _MessagesCollection implements MessagesCollection {
  const _MessagesCollection({required this.chatId, required this.messages, this.fromCache = false, this.allMessagesLoaded});
  

@override final  int chatId;
@override final  Iterable<Message> messages;
/// if get messages from cache, loading still have to be visible
@override@JsonKey() final  bool fromCache;
@override final  bool? allMessagesLoaded;

/// Create a copy of MessagesCollection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessagesCollectionCopyWith<_MessagesCollection> get copyWith => __$MessagesCollectionCopyWithImpl<_MessagesCollection>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessagesCollection&&(identical(other.chatId, chatId) || other.chatId == chatId)&&const DeepCollectionEquality().equals(other.messages, messages)&&(identical(other.fromCache, fromCache) || other.fromCache == fromCache)&&(identical(other.allMessagesLoaded, allMessagesLoaded) || other.allMessagesLoaded == allMessagesLoaded));
}


@override
int get hashCode => Object.hash(runtimeType,chatId,const DeepCollectionEquality().hash(messages),fromCache,allMessagesLoaded);

@override
String toString() {
  return 'MessagesCollection(chatId: $chatId, messages: $messages, fromCache: $fromCache, allMessagesLoaded: $allMessagesLoaded)';
}


}

/// @nodoc
abstract mixin class _$MessagesCollectionCopyWith<$Res> implements $MessagesCollectionCopyWith<$Res> {
  factory _$MessagesCollectionCopyWith(_MessagesCollection value, $Res Function(_MessagesCollection) _then) = __$MessagesCollectionCopyWithImpl;
@override @useResult
$Res call({
 int chatId, Iterable<Message> messages, bool fromCache, bool? allMessagesLoaded
});




}
/// @nodoc
class __$MessagesCollectionCopyWithImpl<$Res>
    implements _$MessagesCollectionCopyWith<$Res> {
  __$MessagesCollectionCopyWithImpl(this._self, this._then);

  final _MessagesCollection _self;
  final $Res Function(_MessagesCollection) _then;

/// Create a copy of MessagesCollection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chatId = null,Object? messages = null,Object? fromCache = null,Object? allMessagesLoaded = freezed,}) {
  return _then(_MessagesCollection(
chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as int,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as Iterable<Message>,fromCache: null == fromCache ? _self.fromCache : fromCache // ignore: cast_nullable_to_non_nullable
as bool,allMessagesLoaded: freezed == allMessagesLoaded ? _self.allMessagesLoaded : allMessagesLoaded // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
