// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Submission state of the login / register forms (loading + error).

@ProviderFor(AuthFormController)
final authFormControllerProvider = AuthFormControllerProvider._();

/// Submission state of the login / register forms (loading + error).
final class AuthFormControllerProvider
    extends $AsyncNotifierProvider<AuthFormController, void> {
  /// Submission state of the login / register forms (loading + error).
  AuthFormControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authFormControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authFormControllerHash();

  @$internal
  @override
  AuthFormController create() => AuthFormController();
}

String _$authFormControllerHash() =>
    r'01e6c6e73728cf946f2b4dd55a6df07add7f4354';

/// Submission state of the login / register forms (loading + error).

abstract class _$AuthFormController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// `POST /auth/password/forgot`. Success means "email sent if the account
/// exists" — the API never tells which.

@ProviderFor(ForgotPasswordController)
final forgotPasswordControllerProvider = ForgotPasswordControllerProvider._();

/// `POST /auth/password/forgot`. Success means "email sent if the account
/// exists" — the API never tells which.
final class ForgotPasswordControllerProvider
    extends $AsyncNotifierProvider<ForgotPasswordController, bool> {
  /// `POST /auth/password/forgot`. Success means "email sent if the account
  /// exists" — the API never tells which.
  ForgotPasswordControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'forgotPasswordControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$forgotPasswordControllerHash();

  @$internal
  @override
  ForgotPasswordController create() => ForgotPasswordController();
}

String _$forgotPasswordControllerHash() =>
    r'3a39d95dc46fd21cba486d2f6a8ae38692083280';

/// `POST /auth/password/forgot`. Success means "email sent if the account
/// exists" — the API never tells which.

abstract class _$ForgotPasswordController extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
