// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostStateImpl _$$PostStateImplFromJson(Map<String, dynamic> json) =>
    _$PostStateImpl(
      title: json['title'] as String?,
      description: json['description'] as String?,
      image: (json['image'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$$PostStateImplToJson(_$PostStateImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'image': instance.image,
    };
