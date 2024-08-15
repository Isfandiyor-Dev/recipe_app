import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/blocs/user_bloc/user_bloc.dart';
import 'package:recipe_app/blocs/user_bloc/user_event.dart';
import 'package:recipe_app/data/models/recipe_model.dart';

class LikeWidgetForReels extends StatefulWidget {
  final List likedRecipes;
  final RecipeModel recipe;
  final String userId;
  const LikeWidgetForReels(
      {super.key,
      required this.recipe,
      required this.likedRecipes,
      required this.userId});

  @override
  State<LikeWidgetForReels> createState() => _LikeWidgetState();
}

class _LikeWidgetState extends State<LikeWidgetForReels> {
  late bool isliked;

  @override
  void initState() {
    super.initState();
    if (widget.likedRecipes.contains(widget.recipe.id)) {
      isliked = true;
    } else {
      isliked = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isliked) {
          widget.likedRecipes.removeWhere(
            (element) => element == widget.recipe.id,
          );
          context.read<UserBloc>().add(AddLikedRecipe(
                recipeId: widget.recipe.id,
                likeCheck: false,
                userId: widget.userId,
                savedRecipe: widget.likedRecipes,
              ));
          isliked = false;
          setState(() {});
        } else {
          widget.likedRecipes.add(widget.recipe.id);
          context.read<UserBloc>().add(AddLikedRecipe(
                recipeId: widget.recipe.id,
                likeCheck: true,
                userId: widget.userId,
                savedRecipe: widget.likedRecipes,
              ));
          isliked = true;
          setState(() {});
        }
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.deepPurple),
        padding: const EdgeInsets.all(10),
        child: Icon(
          CupertinoIcons.heart_fill,
          color: isliked ? Colors.red : Colors.white,
          size: 30.0,
        ),
      ),
    );
  }
}
