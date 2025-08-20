// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostModel _$PostModelFromJson(Map<String, dynamic> json) => _PostModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      image: (json['image'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PostModelToJson(_PostModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'image': instance.image,
      'userId': instance.userId,
      'createdAt': instance.createdAt.toIso8601String(),
    };
