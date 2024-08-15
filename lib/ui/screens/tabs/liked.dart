import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_bloc.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_state.dart';
import 'package:recipe_app/blocs/user_bloc/user_bloc.dart';
import 'package:recipe_app/blocs/user_bloc/user_state.dart';
import 'package:recipe_app/ui/widgets/liked_recipe_card.dart';

class LikedTab extends StatefulWidget {
  const LikedTab({super.key});

  @override
  State<LikedTab> createState() => _LikedTabState();
}

class _LikedTabState extends State<LikedTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
        buildWhen: (previousState, currentState) {
      return currentState is UserStateLoaded;
    }, builder: (context, state) {
      if (state is UserStateLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is UserStateLoaded) {
        final user = state.userModel;
        return BlocBuilder<RecipesBloc, RecipesState>(
          buildWhen: (previousState, currentState) {
            return currentState is RecipesLoadedState;
          },
          builder: (context, state) {
            if (state is RecipesLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RecipesLoadedState) {
              final recipes = state.recipes;
              final likedRecipes = [];
              for (var element in recipes) {
                if (user.likedReceiptsId.contains(element.id)) {
                  likedRecipes.add(element);
                }
              }

              if (likedRecipes.isEmpty) {
                return const Center(child: Text('No Liked Recipes'));
              }

              return GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: likedRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = likedRecipes[index];
                  return LikedRecipeCard(
                    recipeModel: recipe,
                    userModel: user,
                  );
                },
              );
            } else if (state is RecipesErrorState) {
              return Center(child: Text('Error: ${state.error}'));
            } else {
              return const Center(child: Text('Something went wrong.'));
            }
          },
        );
      } else {
        return const Center(
          child: Text("Not Found Saved Resipe"),
        );
      }
    });
  }
}
