import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_bloc.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_event.dart';
import 'package:recipe_app/blocs/recipes_bloc/recipes_state.dart';
import 'package:recipe_app/data/models/recipe_model.dart';
import 'package:recipe_app/data/services/recipes_dio_service.dart';
import 'package:mocktail/mocktail.dart';

class MockRecipesDioService extends Mock implements RecipesDioService {}

void main() {
  late RecipesBloc recipesBloc;
  late MockRecipesDioService mockRecipesDioService;

  setUp(() {
    mockRecipesDioService = MockRecipesDioService();
    recipesBloc = RecipesBloc(recipesDioService: mockRecipesDioService);
  });

  tearDown(() {
    recipesBloc.close();
  });

  test('initial state is RecipesInitialState', () {
    expect(recipesBloc.state, equals(RecipesInitialState()));
  });

  blocTest<RecipesBloc, RecipesState>(
    'emits [RecipesLoadingState, RecipesLoadedState] when GetRecipesEvent is added and succeeds',
    build: () {
      when(() => mockRecipesDioService.fetchRecipes()).thenAnswer(
            (_) async => [
          RecipeModel(
            id: '1',
            creatorId: 'creator_123',
            title: 'Test Recipe',
            ingredients: 'Flour, Sugar, Eggs',
            stagesOfPreparation: 'Mix, Bake, Serve',
            categoryId: 'dessert',
            cookingTime: 30,
            likesCount: 120,
            comments: [],
            imageUrl: 'https://example.com/image.png',
            videoUrl: 'https://example.com/video.mp4',
            date: '2023-08-13',
          ),
        ],
      );
      return recipesBloc;
    },
    act: (bloc) => bloc.add(GetRecipesEvent()),
    expect: () => [
      RecipesLoadingState(),
      isA<RecipesLoadedState>()
          .having((state) => state.recipes.length, 'recipes length', 1),
    ],
  );

  blocTest<RecipesBloc, RecipesState>(
    'emits [RecipesLoadingState, RecipesErrorState] when GetRecipesEvent is added and fails',
    build: () {
      when(() => mockRecipesDioService.fetchRecipes())
          .thenThrow(Exception('Failed to fetch recipes'));
      return RecipesBloc(recipesDioService: mockRecipesDioService);
    },
    act: (bloc) => bloc.add(GetRecipesEvent()),
    expect: () => [
      RecipesLoadingState(),
      isA<RecipesErrorState>().having((state) => state.error, 'error',
          'Exception: Failed to fetch recipes'),
    ],
  );
}
