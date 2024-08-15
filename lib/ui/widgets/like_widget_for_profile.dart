import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_bloc.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_event.dart';
import 'package:recipe_app/blocs/user_bloc/user_bloc.dart';
import 'package:recipe_app/blocs/user_bloc/user_event.dart';
import 'package:recipe_app/data/models/recipe_model.dart';

class LikeWidgetForProfile extends StatefulWidget {
  final List likedRecipes;
  final RecipeModel recipe;
  final String userId;
  const LikeWidgetForProfile(
      {super.key,
      required this.recipe,
      required this.likedRecipes,
      required this.userId});

  @override
  State<LikeWidgetForProfile> createState() => _LikekWidgetState();
}

class _LikekWidgetState extends State<LikeWidgetForProfile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.likedRecipes.contains(widget.recipe.id)) {
          widget.likedRecipes.removeWhere(
            (element) => element == widget.recipe.id,
          );
          context.read<UserBloc>().add(AddLikedRecipe(
                recipeId: widget.recipe.id,
                likeCheck: false,
                userId: widget.userId,
                savedRecipe: widget.likedRecipes,
              ));
          context.read<RecipesBloc>().add(GetRecipesEvent());
        } else {
          widget.likedRecipes.add(widget.recipe.id);
          context.read<UserBloc>().add(AddLikedRecipe(
                recipeId: widget.recipe.id,
                likeCheck: true,
                userId: widget.userId,
                savedRecipe: widget.likedRecipes,
              ));
          context.read<RecipesBloc>().add(GetRecipesEvent());
        }
      },
      child: Icon(
        CupertinoIcons.heart_fill,
        color: widget.likedRecipes.contains(widget.recipe.id)
            ? Colors.red
            : Colors.white,
        size: 30.0,
      ),
    );
  }
}
