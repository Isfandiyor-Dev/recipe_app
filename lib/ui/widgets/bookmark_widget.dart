import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_bloc.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_event.dart';
import 'package:recipe_app/blocs/user_bloc/user_bloc.dart';
import 'package:recipe_app/blocs/user_bloc/user_event.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_app/data/models/recipe_model.dart';

class BookmarkWidget extends StatefulWidget {
  final List savedRecipes;
  final RecipeModel recipe;
  final String userId;
  const BookmarkWidget(
      {super.key,
      required this.recipe,
      required this.savedRecipes,
      required this.userId});

  @override
  State<BookmarkWidget> createState() => _BookmarkWidgetState();
}

class _BookmarkWidgetState extends State<BookmarkWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.savedRecipes.contains(widget.recipe.id)) {
          widget.savedRecipes.removeWhere(
            (element) => element == widget.recipe.id,
          );
          context.read<UserBloc>().add(AddSavedRecipe(
              userId: widget.userId, savedRecipe: widget.savedRecipes));
          context.read<RecipesBloc>().add(GetRecipesEvent());
        } else {
          widget.savedRecipes.add(widget.recipe.id);
          context.read<UserBloc>().add(AddSavedRecipe(
              userId: widget.userId, savedRecipe: widget.savedRecipes));
          context.read<RecipesBloc>().add(GetRecipesEvent());
        }
      },
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.savedRecipes.contains(widget.recipe.id)
                ? Colors.blue
                : Colors.white),
        padding: EdgeInsets.all(5.h),
        child: Icon(Icons.bookmark,
            color: widget.savedRecipes.contains(widget.recipe.id)
                ? Colors.white
                : null),
      ),
    );
  }
}
