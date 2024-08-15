sealed class RecipesEvent {}

class GetRecipesEvent extends RecipesEvent {}

class DeleteRecipeEvent extends RecipesEvent {
  String id;

  DeleteRecipeEvent({required this.id});
}

class GetRecipeById extends RecipesEvent {
  String userId;

  GetRecipeById({required this.userId});
}

class AddComment extends RecipesEvent {
  String recipeId;
  String commentatorImageUrl;
  String commentatorName;
  String text;

  AddComment({
    required this.recipeId,
    required this.commentatorImageUrl,
    required this.commentatorName,
    required this.text,
  });
}
