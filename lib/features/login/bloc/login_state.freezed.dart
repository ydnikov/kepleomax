// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoginStateBase {

 LoginData get data; bool get updateControllers;
/// Create a copy of LoginStateBase
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginStateBaseCopyWith<LoginStateBase> get copyWith => _$LoginStateBaseCopyWithImpl<LoginStateBase>(this as LoginStateBase, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginStateBase&&(identical(other.data, data) || other.data == data)&&(identical(other.updateControllers, updateControllers) || other.updateControllers == updateControllers));
}


@override
int get hashCode => Object.hash(runtimeType,data,updateControllers);

@override
String toString() {
  return 'LoginStateBase(data: $data, updateControllers: $updateControllers)';
}


}

/// @nodoc
abstract mixin class $LoginStateBaseCopyWith<$Res>  {
  factory $LoginStateBaseCopyWith(LoginStateBase value, $Res Function(LoginStateBase) _then) = _$LoginStateBaseCopyWithImpl;
@useResult
$Res call({
 LoginData data, bool updateControllers
});


$LoginDataCopyWith<$Res> get data;

}
/// @nodoc
class _$LoginStateBaseCopyWithImpl<$Res>
    implements $LoginStateBaseCopyWith<$Res> {
  _$LoginStateBaseCopyWithImpl(this._self, this._then);

  final LoginStateBase _self;
  final $Res Function(LoginStateBase) _then;

/// Create a copy of LoginStateBase
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,Object? updateControllers = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as LoginData,updateControllers: null == updateControllers ? _self.updateControllers : updateControllers // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of LoginStateBase
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LoginDataCopyWith<$Res> get data {
  
  return $LoginDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [LoginStateBase].
extension LoginStateBasePatterns on LoginStateBase {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginStateBase value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginStateBase() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginStateBase value)  $default,){
final _that = this;
switch (_that) {
case _LoginStateBase():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginStateBase value)?  $default,){
final _that = this;
switch (_that) {
case _LoginStateBase() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoginData data,  bool updateControllers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginStateBase() when $default != null:
return $default(_that.data,_that.updateControllers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoginData data,  bool updateControllers)  $default,) {final _that = this;
switch (_that) {
case _LoginStateBase():
return $default(_that.data,_that.updateControllers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoginData data,  bool updateControllers)?  $default,) {final _that = this;
switch (_that) {
case _LoginStateBase() when $default != null:
return $default(_that.data,_that.updateControllers);case _:
  return null;

}
}

}

/// @nodoc


class _LoginStateBase implements LoginStateBase {
  const _LoginStateBase({required this.data, this.updateControllers = false});
  

@override final  LoginData data;
@override@JsonKey() final  bool updateControllers;

/// Create a copy of LoginStateBase
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginStateBaseCopyWith<_LoginStateBase> get copyWith => __$LoginStateBaseCopyWithImpl<_LoginStateBase>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginStateBase&&(identical(other.data, data) || other.data == data)&&(identical(other.updateControllers, updateControllers) || other.updateControllers == updateControllers));
}


@override
int get hashCode => Object.hash(runtimeType,data,updateControllers);

@override
String toString() {
  return 'LoginStateBase(data: $data, updateControllers: $updateControllers)';
}


}

/// @nodoc
abstract mixin class _$LoginStateBaseCopyWith<$Res> implements $LoginStateBaseCopyWith<$Res> {
  factory _$LoginStateBaseCopyWith(_LoginStateBase value, $Res Function(_LoginStateBase) _then) = __$LoginStateBaseCopyWithImpl;
@override @useResult
$Res call({
 LoginData data, bool updateControllers
});


@override $LoginDataCopyWith<$Res> get data;

}
/// @nodoc
class __$LoginStateBaseCopyWithImpl<$Res>
    implements _$LoginStateBaseCopyWith<$Res> {
  __$LoginStateBaseCopyWithImpl(this._self, this._then);

  final _LoginStateBase _self;
  final $Res Function(_LoginStateBase) _then;

/// Create a copy of LoginStateBase
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,Object? updateControllers = null,}) {
  return _then(_LoginStateBase(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as LoginData,updateControllers: null == updateControllers ? _self.updateControllers : updateControllers // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of LoginStateBase
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LoginDataCopyWith<$Res> get data {
  
  return $LoginDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

/// @nodoc
mixin _$LoginStateError {

 String get message;
/// Create a copy of LoginStateError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginStateErrorCopyWith<LoginStateError> get copyWith => _$LoginStateErrorCopyWithImpl<LoginStateError>(this as LoginStateError, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginStateError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'LoginStateError(message: $message)';
}


}

/// @nodoc
abstract mixin class $LoginStateErrorCopyWith<$Res>  {
  factory $LoginStateErrorCopyWith(LoginStateError value, $Res Function(LoginStateError) _then) = _$LoginStateErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$LoginStateErrorCopyWithImpl<$Res>
    implements $LoginStateErrorCopyWith<$Res> {
  _$LoginStateErrorCopyWithImpl(this._self, this._then);

  final LoginStateError _self;
  final $Res Function(LoginStateError) _then;

/// Create a copy of LoginStateError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LoginStateError].
extension LoginStateErrorPatterns on LoginStateError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginStateError value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginStateError() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginStateError value)  $default,){
final _that = this;
switch (_that) {
case _LoginStateError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginStateError value)?  $default,){
final _that = this;
switch (_that) {
case _LoginStateError() when $default != null:
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
case _LoginStateError() when $default != null:
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
case _LoginStateError():
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
case _LoginStateError() when $default != null:
return $default(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _LoginStateError implements LoginStateError {
  const _LoginStateError({required this.message});
  

@override final  String message;

/// Create a copy of LoginStateError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginStateErrorCopyWith<_LoginStateError> get copyWith => __$LoginStateErrorCopyWithImpl<_LoginStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginStateError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'LoginStateError(message: $message)';
}


}

/// @nodoc
abstract mixin class _$LoginStateErrorCopyWith<$Res> implements $LoginStateErrorCopyWith<$Res> {
  factory _$LoginStateErrorCopyWith(_LoginStateError value, $Res Function(_LoginStateError) _then) = __$LoginStateErrorCopyWithImpl;
@override @useResult
$Res call({
 String message
});




}
/// @nodoc
class __$LoginStateErrorCopyWithImpl<$Res>
    implements _$LoginStateErrorCopyWith<$Res> {
  __$LoginStateErrorCopyWithImpl(this._self, this._then);

  final _LoginStateError _self;
  final $Res Function(_LoginStateError) _then;

/// Create a copy of LoginStateError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_LoginStateError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$LoginData {

 String get email; String get password; String get confirmPassword; bool get isLoading; LoginStage get stage;
/// Create a copy of LoginData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginDataCopyWith<LoginData> get copyWith => _$LoginDataCopyWithImpl<LoginData>(this as LoginData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginData&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.confirmPassword, confirmPassword) || other.confirmPassword == confirmPassword)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.stage, stage) || other.stage == stage));
}


@override
int get hashCode => Object.hash(runtimeType,email,password,confirmPassword,isLoading,stage);

@override
String toString() {
  return 'LoginData(email: $email, password: $password, confirmPassword: $confirmPassword, isLoading: $isLoading, stage: $stage)';
}


}

/// @nodoc
abstract mixin class $LoginDataCopyWith<$Res>  {
  factory $LoginDataCopyWith(LoginData value, $Res Function(LoginData) _then) = _$LoginDataCopyWithImpl;
@useResult
$Res call({
 String email, String password, String confirmPassword, bool isLoading, LoginStage stage
});




}
/// @nodoc
class _$LoginDataCopyWithImpl<$Res>
    implements $LoginDataCopyWith<$Res> {
  _$LoginDataCopyWithImpl(this._self, this._then);

  final LoginData _self;
  final $Res Function(LoginData) _then;

/// Create a copy of LoginData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? password = null,Object? confirmPassword = null,Object? isLoading = null,Object? stage = null,}) {
  return _then(_self.copyWith(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,confirmPassword: null == confirmPassword ? _self.confirmPassword : confirmPassword // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as LoginStage,
  ));
}

}


/// Adds pattern-matching-related methods to [LoginData].
extension LoginDataPatterns on LoginData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginData value)  $default,){
final _that = this;
switch (_that) {
case _LoginData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginData value)?  $default,){
final _that = this;
switch (_that) {
case _LoginData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String email,  String password,  String confirmPassword,  bool isLoading,  LoginStage stage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginData() when $default != null:
return $default(_that.email,_that.password,_that.confirmPassword,_that.isLoading,_that.stage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String email,  String password,  String confirmPassword,  bool isLoading,  LoginStage stage)  $default,) {final _that = this;
switch (_that) {
case _LoginData():
return $default(_that.email,_that.password,_that.confirmPassword,_that.isLoading,_that.stage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String email,  String password,  String confirmPassword,  bool isLoading,  LoginStage stage)?  $default,) {final _that = this;
switch (_that) {
case _LoginData() when $default != null:
return $default(_that.email,_that.password,_that.confirmPassword,_that.isLoading,_that.stage);case _:
  return null;

}
}

}

/// @nodoc


class _LoginData implements LoginData {
  const _LoginData({required this.email, required this.password, required this.confirmPassword, required this.isLoading, required this.stage});
  

@override final  String email;
@override final  String password;
@override final  String confirmPassword;
@override final  bool isLoading;
@override final  LoginStage stage;

/// Create a copy of LoginData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginDataCopyWith<_LoginData> get copyWith => __$LoginDataCopyWithImpl<_LoginData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginData&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.confirmPassword, confirmPassword) || other.confirmPassword == confirmPassword)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.stage, stage) || other.stage == stage));
}


@override
int get hashCode => Object.hash(runtimeType,email,password,confirmPassword,isLoading,stage);

@override
String toString() {
  return 'LoginData(email: $email, password: $password, confirmPassword: $confirmPassword, isLoading: $isLoading, stage: $stage)';
}


}

/// @nodoc
abstract mixin class _$LoginDataCopyWith<$Res> implements $LoginDataCopyWith<$Res> {
  factory _$LoginDataCopyWith(_LoginData value, $Res Function(_LoginData) _then) = __$LoginDataCopyWithImpl;
@override @useResult
$Res call({
 String email, String password, String confirmPassword, bool isLoading, LoginStage stage
});




}
/// @nodoc
class __$LoginDataCopyWithImpl<$Res>
    implements _$LoginDataCopyWith<$Res> {
  __$LoginDataCopyWithImpl(this._self, this._then);

  final _LoginData _self;
  final $Res Function(_LoginData) _then;

/// Create a copy of LoginData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,Object? confirmPassword = null,Object? isLoading = null,Object? stage = null,}) {
  return _then(_LoginData(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,confirmPassword: null == confirmPassword ? _self.confirmPassword : confirmPassword // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as LoginStage,
  ));
}


}

// dart format on
