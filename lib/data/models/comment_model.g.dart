// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) => CommentModel(
      commentatorImageUrl: json['commentatorImageUrl']==null?"":json['commentatorImageUrl'] as String,
      commentatorName: json['commentatorName'] as String,
      text: json['text'] as String,
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$CommentModelToJson(CommentModel instance) =>
    <String, dynamic>{
      'commentatorImageUrl': instance.commentatorImageUrl,
      'commentatorName': instance.commentatorName,
      'text': instance.text,
      'date': instance.date.toIso8601String(),
    };
