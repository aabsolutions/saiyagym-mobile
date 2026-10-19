# Classes called from Dart through JNI (package:jni). R8 can't see those
# calls, so in release builds it strips or renames them and the app dies at
# startup with NoSuchMethodError / ClassNotFoundException (stuck on the
# splash). The plugins don't ship these rules yet; drop them when they do.
# To check what Dart looks up: grep "'kotlin/|'io/flutter|'com/github" in
# the jni / *_android packages' lib/.

# shared_preferences_android 2.5 (used by easy_localization at startup).
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# package:jni runtime (callbacks / suspend functions).
-keep class com.github.dart_lang.jni.** { *; }
-keep class kotlin.Unit { *; }
-keep class kotlin.Result { *; }
-keep class kotlin.Result$Failure { *; }
-keep class kotlin.coroutines.Continuation { *; }
-keep class kotlin.coroutines.intrinsics.** { *; }
