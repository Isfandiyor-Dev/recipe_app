import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/data/models/recipe_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_app/ui/screens/recipe_details_screen.dart';
import 'package:recipe_app/ui/widgets/like_widget_for_profile.dart';
import 'package:user_repository/user_repository.dart';

class LikedRecipeCard extends StatelessWidget {
  final UserModel userModel;
  final RecipeModel recipeModel;

  const LikedRecipeCard(
      {super.key, required this.recipeModel, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  RecipeDetailsScreen(recipeModel: recipeModel),
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.green.shade600,
          borderRadius: BorderRadius.circular(10.r),
          image: DecorationImage(
            image: recipeModel.imageUrl != ''
                ? CachedNetworkImageProvider(recipeModel.imageUrl)
                : const CachedNetworkImageProvider(
                    "https://media.istockphoto.com/id/1409329028/vector/no-picture-available-placeholder-thumbnail-icon-illustration-design.jpg?s=612x612&w=0&k=20&c=_zOuJu755g2eEUioiOUdz_mHKJQJn-tDgIAhQzyeKUQ="),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.darken,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                LikeWidgetForProfile(
                    recipe: recipeModel,
                    likedRecipes: userModel.likedReceiptsId,
                    userId: userModel.id)
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipeModel.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.h,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Likes: ${recipeModel.likesCount}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.h,
                  ),
                  overflow: TextOverflow.ellipsis,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
