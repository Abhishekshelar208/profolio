# Flutter and Firebase safe rules
-dontwarn io.flutter.embedding.**
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.app.** { *; }

-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**
