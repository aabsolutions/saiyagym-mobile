// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(nutritionRepository)
final nutritionRepositoryProvider = NutritionRepositoryProvider._();

final class NutritionRepositoryProvider
    extends
        $FunctionalProvider<
          NutritionRepository,
          NutritionRepository,
          NutritionRepository
        >
    with $Provider<NutritionRepository> {
  NutritionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nutritionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nutritionRepositoryHash();

  @$internal
  @override
  $ProviderElement<NutritionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NutritionRepository create(Ref ref) {
    return nutritionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NutritionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NutritionRepository>(value),
    );
  }
}

String _$nutritionRepositoryHash() =>
    r'9cbd290db3da3aec0b75dd07fd282080fa28d02c';

@ProviderFor(foods)
final foodsProvider = FoodsProvider._();

final class FoodsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Cached<List<Food>>>,
          Cached<List<Food>>,
          FutureOr<Cached<List<Food>>>
        >
    with
        $FutureModifier<Cached<List<Food>>>,
        $FutureProvider<Cached<List<Food>>> {
  FoodsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'foodsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$foodsHash();

  @$internal
  @override
  $FutureProviderElement<Cached<List<Food>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Cached<List<Food>>> create(Ref ref) {
    return foods(ref);
  }
}

String _$foodsHash() => r'b8255a697c5391d502a631b723d5df17e69b172a';

@ProviderFor(mealSuggestions)
final mealSuggestionsProvider = MealSuggestionsProvider._();

final class MealSuggestionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Cached<MealSuggestions>>,
          Cached<MealSuggestions>,
          FutureOr<Cached<MealSuggestions>>
        >
    with
        $FutureModifier<Cached<MealSuggestions>>,
        $FutureProvider<Cached<MealSuggestions>> {
  MealSuggestionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mealSuggestionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealSuggestionsHash();

  @$internal
  @override
  $FutureProviderElement<Cached<MealSuggestions>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Cached<MealSuggestions>> create(Ref ref) {
    return mealSuggestions(ref);
  }
}

String _$mealSuggestionsHash() => r'c82ebec35418413c3c63d42890be83eedc40cdd5';

@ProviderFor(guidelines)
final guidelinesProvider = GuidelinesProvider._();

final class GuidelinesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Cached<List<Guideline>>>,
          Cached<List<Guideline>>,
          FutureOr<Cached<List<Guideline>>>
        >
    with
        $FutureModifier<Cached<List<Guideline>>>,
        $FutureProvider<Cached<List<Guideline>>> {
  GuidelinesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'guidelinesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$guidelinesHash();

  @$internal
  @override
  $FutureProviderElement<Cached<List<Guideline>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Cached<List<Guideline>>> create(Ref ref) {
    return guidelines(ref);
  }
}

String _$guidelinesHash() => r'578580946a3442800e9424416b62a1ee1f7b7ac3';

@ProviderFor(CalculatorChoiceController)
final calculatorChoiceControllerProvider =
    CalculatorChoiceControllerProvider._();

final class CalculatorChoiceControllerProvider
    extends
        $AsyncNotifierProvider<CalculatorChoiceController, CalculatorChoice> {
  CalculatorChoiceControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'calculatorChoiceControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$calculatorChoiceControllerHash();

  @$internal
  @override
  CalculatorChoiceController create() => CalculatorChoiceController();
}

String _$calculatorChoiceControllerHash() =>
    r'454ce4df82d0a013b04fe1bbf5b819372fd49d5f';

abstract class _$CalculatorChoiceController
    extends $AsyncNotifier<CalculatorChoice> {
  FutureOr<CalculatorChoice> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<CalculatorChoice>, CalculatorChoice>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CalculatorChoice>, CalculatorChoice>,
              AsyncValue<CalculatorChoice>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
