import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/blocs/user_bloc/user_bloc.dart';
import 'package:recipe_app/blocs/user_bloc/user_event.dart';
import 'package:recipe_app/data/models/recipe_model.dart';

class BookmarkWidgetForReels extends StatefulWidget {
  final List savedRecipes;
  final RecipeModel recipe;
  final String userId;
  const BookmarkWidgetForReels(
      {super.key,
      required this.recipe,
      required this.savedRecipes,
      required this.userId});

  @override
  State<BookmarkWidgetForReels> createState() => _BookmarkWidgetState();
}

class _BookmarkWidgetState extends State<BookmarkWidgetForReels> {
  late bool isBooked;

  @override
  void initState() {
    super.initState();
    if (widget.savedRecipes.contains(widget.recipe.id)) {
      isBooked = true;
    } else {
      isBooked = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isBooked) {
          widget.savedRecipes.removeWhere(
            (element) => element == widget.recipe.id,
          );
          context.read<UserBloc>().add(AddSavedRecipe(
              userId: widget.userId, savedRecipe: widget.savedRecipes));
          isBooked = false;
          setState(() {});
        } else {
          widget.savedRecipes.add(widget.recipe.id);
          context.read<UserBloc>().add(AddSavedRecipe(
              userId: widget.userId, savedRecipe: widget.savedRecipes));
          isBooked = true;
          setState(() {});
        }
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.deepPurple),
        padding: const EdgeInsets.all(10),
        child: Icon(
          Icons.bookmark,
          color: isBooked ? Colors.blue : Colors.white,
          size: 30.0,
        ),
      ),
    );
  }
}
