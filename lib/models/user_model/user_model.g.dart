// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      name: json['name'] as String,
      uid: json['uid'] as String,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      nationality: json['nationality'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      description: json['description'] as String?,
      church: json['church'] as String?,
      address: json['address'] as String?,
      birthday: json['birthday'] == null
          ? null
          : DateTime.parse(json['birthday'] as String),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'uid': instance.uid,
      'role': _$UserRoleEnumMap[instance.role]!,
      'nationality': instance.nationality,
      'phoneNumber': instance.phoneNumber,
      'description': instance.description,
      'church': instance.church,
      'address': instance.address,
      'birthday': instance.birthday?.toIso8601String(),
    };

const _$UserRoleEnumMap = {
  UserRole.admin: 'admin',
  UserRole.watchman: 'watchman',
  UserRole.intercessor: 'intercessor',
};
