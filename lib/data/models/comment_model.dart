import 'package:json_annotation/json_annotation.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class CommentModel {
  String commentatorImageUrl;
  String commentatorName;
  String text;
  DateTime date;

  CommentModel({required this.commentatorImageUrl,required this.commentatorName, required this.text,required this.date});

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return _$CommentModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CommentModelToJson(this);
  }
}
