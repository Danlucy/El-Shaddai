// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostState _$PostStateFromJson(Map<String, dynamic> json) => _PostState(
  title: json['title'] as String?,
  description: json['description'] as String?,
  image: (json['image'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$PostStateToJson(_PostState instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'image': instance.image,
    };
