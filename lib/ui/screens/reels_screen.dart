import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_bloc.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_event.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_state.dart';
import 'package:recipe_app/blocs/user_bloc/user_event.dart';
import 'package:recipe_app/data/models/recipe_model.dart';
import 'package:recipe_app/ui/screens/recipe_details_screen.dart';
import 'package:recipe_app/ui/widgets/bookmark_widget_for_reels.dart';
import 'package:recipe_app/ui/widgets/comment_bottom_sheet.dart';
import 'package:recipe_app/ui/widgets/like_widget_for_reels.dart';
import 'package:recipe_app/utils/current_user.dart';
import 'package:share_plus/share_plus.dart';
import 'package:user_repository/user_repository.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../blocs/user_bloc/user_bloc.dart';
import '../../blocs/user_bloc/user_state.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RecipesBloc>().add(GetRecipesEvent());
    context
        .read<UserBloc>()
        .add(GetUserEvent(CurrentUser.currentUser!.localId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UserBloc, UserState>(
        buildWhen: (previousState, currentState) {
          return currentState is UserStateLoaded;
        },
        builder: (context, userState) {
          if (userState is UserStateLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (userState is UserStateLoaded) {
            final user = userState.userModel;
            return BlocBuilder<RecipesBloc, RecipesState>(
              buildWhen: (previousState, currentState) {
                return currentState is RecipesLoadedState;
              },
              builder: (context, recipesState) {
                if (recipesState is RecipesLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (recipesState is RecipesLoadedState) {
                  final recipes = recipesState.recipes;
                  final videoRecipes = [];
                  for (var element in recipes) {
                    if (element.videoUrl != "") {
                      videoRecipes.add(element);
                    }
                  }
                  return PageView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: videoRecipes.length,
                    itemBuilder: (context, index) {
                      return VideoPlayerWidget(
                        recipeModel: videoRecipes[index],
                        videoUrl: videoRecipes[index].videoUrl,
                        userModel: user,
                      );
                    },
                  );
                } else if (recipesState is RecipesErrorState) {
                  return Center(child: Text(recipesState.error));
                } else {
                  return const Center(child: Text('No recipes found.'));
                }
              },
            );
          }
          return const Center(
            child: Text("Not Found Recipes"),
          );
        },
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final RecipeModel recipeModel;
  final UserModel userModel;
  final String videoUrl;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    required this.recipeModel,
    required this.userModel,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _controller;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    // Agar controller mavjud bo'lmasa yoki URL o'zgarsa, yangi controller yaratish
    if (_controller == null || _controller!.dataSource != widget.videoUrl) {
      _controller?.dispose(); // Eski controllerni tozalash
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
        ..initialize().then((_) {
          setState(() {});
          _controller!.play();
        });
      _controller!.setLooping(true);
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
        _isPlaying = false;
      } else {
        _controller!.play();
        _isPlaying = true;
      }
    });
  }

  @override
  void didUpdateWidget(covariant VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Widget o'zgarsa, video boshqaruvchini qayta yuklash
    if (widget.videoUrl != oldWidget.videoUrl) {
      _initializeVideo();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _shareRecipe(RecipeModel recipe) {
    final String shareText = '''
Check out this recipe:
Title: ${recipe.title}
Ingredients: ${recipe.ingredients}
Preparation: ${recipe.stagesOfPreparation}
Cooking Time: ${recipe.cookingTime} minutes
Category: ${recipe.categoryId}
Likes: ${recipe.likesCount}

Image: ${recipe.imageUrl}
''';

    Share.share(shareText, subject: 'Check out this recipe!');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _controller != null && _controller!.value.isInitialized
            ? SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
              )
            : const Center(child: CircularProgressIndicator()),
        Positioned(
            right: 20,
            bottom: 270,
            child: LikeWidgetForReels(
                recipe: widget.recipeModel,
                likedRecipes: widget.userModel.likedReceiptsId,
                userId: widget.userModel.id)),
        Positioned(
          right: 10,
          bottom: 200,
          child: IconButton(
            onPressed: () async {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) => CommentButtomSheet(
                  userModel: widget.userModel,
                  recipeModel: widget.recipeModel,
                ),
              );
            },
            icon: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.deepPurple),
              padding: const EdgeInsets.all(10),
              child: const Icon(
                Icons.message_rounded,
                color: Colors.white,
                size: 30.0,
              ),
            ),
          ),
        ),
        Positioned(
            right: 20,
            bottom: 150,
            child: BookmarkWidgetForReels(
                recipe: widget.recipeModel,
                savedRecipes: widget.userModel.savedReceiptsId,
                userId: widget.userModel.id)),
        Positioned(
          right: 10,
          bottom: 80,
          child: IconButton(
            onPressed: () {
              _shareRecipe(widget.recipeModel);
            },
            icon: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.deepPurple),
              padding: const EdgeInsets.all(10),
              child: const Icon(
                Icons.share,
                color: Colors.white,
                size: 30.0,
              ),
            ),
          ),
        ),
        Positioned(
          right: 10,
          bottom: 20,
          child: IconButton(
            onPressed: _togglePlayPause,
            icon: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.deepPurple),
              padding: const EdgeInsets.all(10),
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 30.0,
              ),
            ),
          ),
        ),
        Positioned(
          right: 130,
          bottom: 20,
          child: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RecipeDetailsScreen(recipeModel: widget.recipeModel),
                  ));
            },
            icon: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.deepPurple),
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Go Recipe Details",
                  style: TextStyle(
                      fontSize: 25.h,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                )),
          ),
        ),
      ],
    );
  }
}
