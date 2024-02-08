# Keep class members in ConcurrentHashMap
-keepclassmembers class java.util.concurrent.ConcurrentHashMap$TreeBin {
  <fields>;
  <methods>;
}

-keepclassmembers class java.util.concurrent.ConcurrentHashMap {
  int sizeCtl;
  int transferIndex;
  long baseCount;
  int cellsBusy;
}

-keepclassmembers class java.util.concurrent.ConcurrentHashMap$CounterCell {
  long value;
}

# Keep class members in IntSummaryStatistics, LongSummaryStatistics, DoubleSummaryStatistics
-keepclassmembers class java.util.IntSummaryStatistics {
  long count;
  long sum;
  int min;
  int max;
}

-keepclassmembers class java.util.LongSummaryStatistics {
  long count;
  long sum;
  long min;
  long max;
}

-keepclassmembers class java.util.DoubleSummaryStatistics {
  long count;
  double sum;
  double min;
  double max;
}

-dontwarn j$.util.concurrent.ConcurrentHashMap$TreeBin
-dontwarn j$.util.concurrent.ConcurrentHashMap
-dontwarn j$.util.concurrent.ConcurrentHashMap$CounterCell
-dontwarn j$.util.IntSummaryStatistics
-dontwarn j$.util.LongSummaryStatistics
-dontwarn j$.util.DoubleSummaryStatistics

# Jackson Databind
-keepnames class com.fasterxml.** { *; }
-keep class org.codehaus.** { *; }
-keepnames class org.codehaus.** { *; }
-keep class java.beans.** { *; }
-keep class com.fasterxml.** { *; }
-keep class org.opencv.** { *; }


-keep class java.beans.ConstructorProperties.** { *; }
-keep class java.beans.Transient.** { *; }
-keep class javax.lang.model.SourceVersion.** { *; }
-keep class javax.lang.model.element.Element.** { *; }
-keep class javax.lang.model.element.ElementKind.** { *; }
-keep class javax.lang.model.element.Modifier.** { *; }
-keep class javax.lang.model.type.TypeMirror.** { *; }
-keep class javax.lang.model.type.TypeVisitor.** { *; }
-keep class javax.lang.model.util.SimpleTypeVisitor8.** { *; }
-keep class org.w3c.dom.bootstrap.DOMImplementationRegistry.** { *; }

-keep public class com.google.android.gms.* { public *; }
-keepnames @com.google.android.gms.common.annotation.KeepName class *
-keepclassmembernames class * {
    @com.google.android.gms.common.annotation.KeepName *;
}
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
## Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-dontwarn io.flutter.embedding.**
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class io.flutter.app.FlutterPlayStoreSplitApplication { *; }

## Flutter WebRTC
-keep class com.cloudwebrtc.webrtc.** { *; }
-keep class org.webrtc.** { *; }
-keep class org.webrtc.* { *; }
-keep class org.webrtc.audio.* { *; }
-keep class org.webrtc.voiceengine.* { *; }

-keep public class com.google.android.gms.* { public *; }
-keepnames @com.google.android.gms.common.annotation.KeepName class *
-keepclassmembernames class * {
    @com.google.android.gms.common.annotation.KeepName *;
}
-keep class org.webrtc.* { *; }
-keep class org.webrtc.audio.* { *; }
-keep class org.webrtc.voiceengine.* { *; }
-keep class org.telegram.messenger.* { *; }
-keep class org.telegram.messenger.camera.* { *; }
-keep class org.telegram.messenger.secretmedia.* { *; }
-keep class org.telegram.messenger.support.* { *; }
-keep class org.telegram.messenger.support.* { *; }
-keep class org.telegram.messenger.time.* { *; }
-keep class org.telegram.messenger.video.* { *; }
-keep class org.telegram.messenger.voip.* { *; }
-keep class org.telegram.SQLite.** { *; }
-keep class com.google.android.exoplayer2.ext.** { *; }

# Huawei Services
-keep class com.huawei.hianalytics.**{ *; }
-keep class com.huawei.updatesdk.**{ *; }
-keep class com.huawei.hms.**{ *; }

# Don't warn about checkerframework and Kotlin annotations
-dontwarn org.checkerframework.**
-dontwarn javax.annotation.**

# Use -keep to explicitly keep any other classes shrinking would remove
-dontoptimize
-dontobfuscate

# Retain generic signatures of TypeToken and its subclasses with R8 version 3.0 and higher.
-keep,allowobfuscation,allowshrinking class com.google.gson.reflect.TypeToken
-keep,allowobfuscation,allowshrinking class * extends com.google.gson.reflect.TypeToken