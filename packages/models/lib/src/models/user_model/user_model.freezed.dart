// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserModel {

 String get name; String get uid; UserRole get role;@TimestampConverter() DateTime get createdAt; String? get lastName; List<int>? get image; String? get nationality; String? get phoneNumber; String? get description; String? get address; String? get birthAddress; String? get church; String? get beleifInGod; String? get prayerNetwork; String? get definitionOfGod; String? get godsCalling; String? get recommendation; String? get fcmToken;
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserModelCopyWith<UserModel> get copyWith => _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserModel&&(identical(other.name, name) || other.name == name)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.role, role) || other.role == role)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&const DeepCollectionEquality().equals(other.image, image)&&(identical(other.nationality, nationality) || other.nationality == nationality)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.description, description) || other.description == description)&&(identical(other.address, address) || other.address == address)&&(identical(other.birthAddress, birthAddress) || other.birthAddress == birthAddress)&&(identical(other.church, church) || other.church == church)&&(identical(other.beleifInGod, beleifInGod) || other.beleifInGod == beleifInGod)&&(identical(other.prayerNetwork, prayerNetwork) || other.prayerNetwork == prayerNetwork)&&(identical(other.definitionOfGod, definitionOfGod) || other.definitionOfGod == definitionOfGod)&&(identical(other.godsCalling, godsCalling) || other.godsCalling == godsCalling)&&(identical(other.recommendation, recommendation) || other.recommendation == recommendation)&&(identical(other.fcmToken, fcmToken) || other.fcmToken == fcmToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,uid,role,createdAt,lastName,const DeepCollectionEquality().hash(image),nationality,phoneNumber,description,address,birthAddress,church,beleifInGod,prayerNetwork,definitionOfGod,godsCalling,recommendation,fcmToken);

@override
String toString() {
  return 'UserModel(name: $name, uid: $uid, role: $role, createdAt: $createdAt, lastName: $lastName, image: $image, nationality: $nationality, phoneNumber: $phoneNumber, description: $description, address: $address, birthAddress: $birthAddress, church: $church, beleifInGod: $beleifInGod, prayerNetwork: $prayerNetwork, definitionOfGod: $definitionOfGod, godsCalling: $godsCalling, recommendation: $recommendation, fcmToken: $fcmToken)';
}


}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res>  {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) = _$UserModelCopyWithImpl;
@useResult
$Res call({
 String name, String uid, UserRole role,@TimestampConverter() DateTime createdAt, String? lastName, List<int>? image, String? nationality, String? phoneNumber, String? description, String? address, String? birthAddress, String? church, String? beleifInGod, String? prayerNetwork, String? definitionOfGod, String? godsCalling, String? recommendation, String? fcmToken
});




}
/// @nodoc
class _$UserModelCopyWithImpl<$Res>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._self, this._then);

  final UserModel _self;
  final $Res Function(UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? uid = null,Object? role = null,Object? createdAt = null,Object? lastName = freezed,Object? image = freezed,Object? nationality = freezed,Object? phoneNumber = freezed,Object? description = freezed,Object? address = freezed,Object? birthAddress = freezed,Object? church = freezed,Object? beleifInGod = freezed,Object? prayerNetwork = freezed,Object? definitionOfGod = freezed,Object? godsCalling = freezed,Object? recommendation = freezed,Object? fcmToken = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as List<int>?,nationality: freezed == nationality ? _self.nationality : nationality // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,birthAddress: freezed == birthAddress ? _self.birthAddress : birthAddress // ignore: cast_nullable_to_non_nullable
as String?,church: freezed == church ? _self.church : church // ignore: cast_nullable_to_non_nullable
as String?,beleifInGod: freezed == beleifInGod ? _self.beleifInGod : beleifInGod // ignore: cast_nullable_to_non_nullable
as String?,prayerNetwork: freezed == prayerNetwork ? _self.prayerNetwork : prayerNetwork // ignore: cast_nullable_to_non_nullable
as String?,definitionOfGod: freezed == definitionOfGod ? _self.definitionOfGod : definitionOfGod // ignore: cast_nullable_to_non_nullable
as String?,godsCalling: freezed == godsCalling ? _self.godsCalling : godsCalling // ignore: cast_nullable_to_non_nullable
as String?,recommendation: freezed == recommendation ? _self.recommendation : recommendation // ignore: cast_nullable_to_non_nullable
as String?,fcmToken: freezed == fcmToken ? _self.fcmToken : fcmToken // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserModel].
extension UserModelPatterns on UserModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserModel value)  $default,){
final _that = this;
switch (_that) {
case _UserModel():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String uid,  UserRole role, @TimestampConverter()  DateTime createdAt,  String? lastName,  List<int>? image,  String? nationality,  String? phoneNumber,  String? description,  String? address,  String? birthAddress,  String? church,  String? beleifInGod,  String? prayerNetwork,  String? definitionOfGod,  String? godsCalling,  String? recommendation,  String? fcmToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.name,_that.uid,_that.role,_that.createdAt,_that.lastName,_that.image,_that.nationality,_that.phoneNumber,_that.description,_that.address,_that.birthAddress,_that.church,_that.beleifInGod,_that.prayerNetwork,_that.definitionOfGod,_that.godsCalling,_that.recommendation,_that.fcmToken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String uid,  UserRole role, @TimestampConverter()  DateTime createdAt,  String? lastName,  List<int>? image,  String? nationality,  String? phoneNumber,  String? description,  String? address,  String? birthAddress,  String? church,  String? beleifInGod,  String? prayerNetwork,  String? definitionOfGod,  String? godsCalling,  String? recommendation,  String? fcmToken)  $default,) {final _that = this;
switch (_that) {
case _UserModel():
return $default(_that.name,_that.uid,_that.role,_that.createdAt,_that.lastName,_that.image,_that.nationality,_that.phoneNumber,_that.description,_that.address,_that.birthAddress,_that.church,_that.beleifInGod,_that.prayerNetwork,_that.definitionOfGod,_that.godsCalling,_that.recommendation,_that.fcmToken);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String uid,  UserRole role, @TimestampConverter()  DateTime createdAt,  String? lastName,  List<int>? image,  String? nationality,  String? phoneNumber,  String? description,  String? address,  String? birthAddress,  String? church,  String? beleifInGod,  String? prayerNetwork,  String? definitionOfGod,  String? godsCalling,  String? recommendation,  String? fcmToken)?  $default,) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.name,_that.uid,_that.role,_that.createdAt,_that.lastName,_that.image,_that.nationality,_that.phoneNumber,_that.description,_that.address,_that.birthAddress,_that.church,_that.beleifInGod,_that.prayerNetwork,_that.definitionOfGod,_that.godsCalling,_that.recommendation,_that.fcmToken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserModel implements UserModel {
  const _UserModel({required this.name, required this.uid, required this.role, @TimestampConverter() required this.createdAt, this.lastName, final  List<int>? image, this.nationality, this.phoneNumber, this.description, this.address, this.birthAddress, this.church, this.beleifInGod, this.prayerNetwork, this.definitionOfGod, this.godsCalling, this.recommendation, this.fcmToken}): _image = image;
  factory _UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

@override final  String name;
@override final  String uid;
@override final  UserRole role;
@override@TimestampConverter() final  DateTime createdAt;
@override final  String? lastName;
 final  List<int>? _image;
@override List<int>? get image {
  final value = _image;
  if (value == null) return null;
  if (_image is EqualUnmodifiableListView) return _image;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? nationality;
@override final  String? phoneNumber;
@override final  String? description;
@override final  String? address;
@override final  String? birthAddress;
@override final  String? church;
@override final  String? beleifInGod;
@override final  String? prayerNetwork;
@override final  String? definitionOfGod;
@override final  String? godsCalling;
@override final  String? recommendation;
@override final  String? fcmToken;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserModelCopyWith<_UserModel> get copyWith => __$UserModelCopyWithImpl<_UserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserModel&&(identical(other.name, name) || other.name == name)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.role, role) || other.role == role)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&const DeepCollectionEquality().equals(other._image, _image)&&(identical(other.nationality, nationality) || other.nationality == nationality)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.description, description) || other.description == description)&&(identical(other.address, address) || other.address == address)&&(identical(other.birthAddress, birthAddress) || other.birthAddress == birthAddress)&&(identical(other.church, church) || other.church == church)&&(identical(other.beleifInGod, beleifInGod) || other.beleifInGod == beleifInGod)&&(identical(other.prayerNetwork, prayerNetwork) || other.prayerNetwork == prayerNetwork)&&(identical(other.definitionOfGod, definitionOfGod) || other.definitionOfGod == definitionOfGod)&&(identical(other.godsCalling, godsCalling) || other.godsCalling == godsCalling)&&(identical(other.recommendation, recommendation) || other.recommendation == recommendation)&&(identical(other.fcmToken, fcmToken) || other.fcmToken == fcmToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,uid,role,createdAt,lastName,const DeepCollectionEquality().hash(_image),nationality,phoneNumber,description,address,birthAddress,church,beleifInGod,prayerNetwork,definitionOfGod,godsCalling,recommendation,fcmToken);

@override
String toString() {
  return 'UserModel(name: $name, uid: $uid, role: $role, createdAt: $createdAt, lastName: $lastName, image: $image, nationality: $nationality, phoneNumber: $phoneNumber, description: $description, address: $address, birthAddress: $birthAddress, church: $church, beleifInGod: $beleifInGod, prayerNetwork: $prayerNetwork, definitionOfGod: $definitionOfGod, godsCalling: $godsCalling, recommendation: $recommendation, fcmToken: $fcmToken)';
}


}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(_UserModel value, $Res Function(_UserModel) _then) = __$UserModelCopyWithImpl;
@override @useResult
$Res call({
 String name, String uid, UserRole role,@TimestampConverter() DateTime createdAt, String? lastName, List<int>? image, String? nationality, String? phoneNumber, String? description, String? address, String? birthAddress, String? church, String? beleifInGod, String? prayerNetwork, String? definitionOfGod, String? godsCalling, String? recommendation, String? fcmToken
});




}
/// @nodoc
class __$UserModelCopyWithImpl<$Res>
    implements _$UserModelCopyWith<$Res> {
  __$UserModelCopyWithImpl(this._self, this._then);

  final _UserModel _self;
  final $Res Function(_UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? uid = null,Object? role = null,Object? createdAt = null,Object? lastName = freezed,Object? image = freezed,Object? nationality = freezed,Object? phoneNumber = freezed,Object? description = freezed,Object? address = freezed,Object? birthAddress = freezed,Object? church = freezed,Object? beleifInGod = freezed,Object? prayerNetwork = freezed,Object? definitionOfGod = freezed,Object? godsCalling = freezed,Object? recommendation = freezed,Object? fcmToken = freezed,}) {
  return _then(_UserModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self._image : image // ignore: cast_nullable_to_non_nullable
as List<int>?,nationality: freezed == nationality ? _self.nationality : nationality // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,birthAddress: freezed == birthAddress ? _self.birthAddress : birthAddress // ignore: cast_nullable_to_non_nullable
as String?,church: freezed == church ? _self.church : church // ignore: cast_nullable_to_non_nullable
as String?,beleifInGod: freezed == beleifInGod ? _self.beleifInGod : beleifInGod // ignore: cast_nullable_to_non_nullable
as String?,prayerNetwork: freezed == prayerNetwork ? _self.prayerNetwork : prayerNetwork // ignore: cast_nullable_to_non_nullable
as String?,definitionOfGod: freezed == definitionOfGod ? _self.definitionOfGod : definitionOfGod // ignore: cast_nullable_to_non_nullable
as String?,godsCalling: freezed == godsCalling ? _self.godsCalling : godsCalling // ignore: cast_nullable_to_non_nullable
as String?,recommendation: freezed == recommendation ? _self.recommendation : recommendation // ignore: cast_nullable_to_non_nullable
as String?,fcmToken: freezed == fcmToken ? _self.fcmToken : fcmToken // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
