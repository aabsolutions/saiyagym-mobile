import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:saiyagym_mobile/features/auth/domain/entities/user.dart';

part 'session.freezed.dart';

@freezed
abstract class Session with _$Session {
  const factory Session({
    required User user,

    /// Opened from the local copy because the API wasn't reachable.
    @Default(false) bool isOffline,
  }) = _Session;
}
