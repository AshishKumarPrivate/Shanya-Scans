# --- FLUTTER / PLAY CORE SUPPORT ---
-keep class com.google.android.play.** { *; }
-dontwarn com.google.android.play.**

# --- RAZORPAY KEEP RULES ---

# Required for Google Pay
-keep class com.google.android.apps.nbu.paisa.** { *; }

# Required for Razorpay
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**
