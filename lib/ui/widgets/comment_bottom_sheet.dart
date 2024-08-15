import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_bloc.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_event.dart';
import 'package:recipe_app/data/models/comment_model.dart';
import 'package:recipe_app/data/models/recipe_model.dart';
import 'package:user_repository/user_repository.dart';

class CommentButtomSheet extends StatelessWidget {
  final UserModel userModel;
  final RecipeModel recipeModel;
  CommentButtomSheet(
      {super.key, required this.userModel, required this.recipeModel});

  final textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.55,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 6,
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: recipeModel.comments.length,
                itemBuilder: (context, index) {
                  CommentModel comment = recipeModel.comments[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: 60,
                          decoration: const BoxDecoration(shape: BoxShape.circle),
                          clipBehavior: Clip.hardEdge,
                          child: comment.commentatorImageUrl != ''
                              ? CachedNetworkImage(
                                  imageUrl: userModel.imageUrl,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                )
                              : CachedNetworkImage(
                                  imageUrl:
                                      "https://verdantfox.com/static/images/avatars_default/av_blank.png",
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                )),
                      const SizedBox(width: 12),
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.grey[500],
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5,
                              offset: Offset(0.01, 0.5),
                            ),
                          ],
                        ),
                        child: SizedBox(
                          width: 240,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comment.commentatorName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  comment.text,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    comment.date.toString().split(" ")[0],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: "Enter text",
                    suffixIcon: IconButton(
                      onPressed: () {
                        context.read<RecipesBloc>().add(AddComment(
                            recipeId: recipeModel.id,
                            commentatorImageUrl: userModel.imageUrl,
                            commentatorName: userModel.name,
                            text: textEditingController.text));
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.send_rounded),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
