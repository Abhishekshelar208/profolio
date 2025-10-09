# Google Sign-In Implementation Guide for Flutter Web App

## Complete Step-by-Step Implementation (500 words)

### Overview
This guide explains how to implement Google Sign-In in your Flutter web application using Firebase Authentication, based on the ProFolio project implementation. The web implementation is simpler than mobile as it uses Firebase's built-in popup authentication without requiring additional SDK setup.

---

## Step 1: Firebase Project Setup (Console Configuration)

**1.1 Create Firebase Project:**
- Go to [Firebase Console](https://console.firebase.google.com)
- Click "Add Project" and enter your project name
- Enable Google Analytics (optional)

**1.2 Add Web App to Project:**
- In Project Overview, click the Web icon (`</>`)
- Register your app with a nickname (e.g., "MyApp Web")
- Copy the Firebase configuration (apiKey, authDomain, projectId, etc.)
- You'll need these values for `firebase_options.dart`

**1.3 Enable Google Sign-In Provider:**
- Navigate to **Authentication** → **Sign-in method**
- Click **Google** in the providers list
- Toggle **Enable** switch
- Add your **Project support email** (required)
- Save the configuration

**1.4 Configure Authorized Domains:**
- In Authentication → Settings → Authorized domains
- Add your domains: `localhost`, your production domain
- Firebase automatically authorizes `*.firebaseapp.com` and `*.web.app`

---

## Step 2: Flutter Project Dependencies

**2.1 Update `pubspec.yaml`:**
```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.24.0
  firebase_auth: ^4.16.0
  firebase_database: ^10.4.0  # If using Realtime Database
  google_fonts: ^6.1.0  # For UI styling
```

**Important:** For web, you DON'T need `google_sign_in` package. Firebase Auth handles everything.

**2.2 Run:**
```bash
flutter pub get
```

---

## Step 3: Configure Firebase Options

**3.1 Create/Update `lib/firebase_options.dart`:**
```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    // Add other platforms as needed
    throw UnsupportedError('Platform not supported');
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'your-project-id',
    authDomain: 'your-project-id.firebaseapp.com',
    storageBucket: 'your-project-id.appspot.com',
  );
}
```

Replace `YOUR_*` values with actual Firebase config from Step 1.2.

---

## Step 4: Initialize Firebase in Main

**4.1 Update `lib/main.dart`:**
```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

---

## Step 5: Implement Sign-In Logic

**5.1 Create Sign-In Function:**
```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<User?> signInWithGoogle() async {
  try {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleAuthProvider googleProvider = GoogleAuthProvider();

    // CRITICAL: Use signInWithPopup for web
    if (kIsWeb) {
      final UserCredential userCredential = 
        await auth.signInWithPopup(googleProvider);
      return userCredential.user;
    } else {
      // For mobile: use signInWithProvider or google_sign_in package
      final UserCredential userCredential = 
        await auth.signInWithProvider(googleProvider);
      return userCredential.user;
    }
  } catch (e) {
    print('Error signing in: $e');
    return null;
  }
}
```

**5.2 Use in Your UI:**
```dart
ElevatedButton(
  onPressed: () async {
    final user = await signInWithGoogle();
    if (user != null) {
      print('Signed in: ${user.email}');
      // Navigate to home screen
    }
  },
  child: Row(
    children: [
      Image.network(
        'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
        height: 24,
      ),
      SizedBox(width: 12),
      Text('Sign in with Google'),
    ],
  ),
)
```

---

## Step 6: Handle Authentication State

**6.1 Listen to Auth Changes:**
```dart
StreamBuilder<User?>(
  stream: FirebaseAuth.instance.authStateChanges(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return HomeScreen(); // User logged in
    }
    return LoginScreen(); // User not logged in
  },
)
```

---

## Common Issues & Solutions

**Issue 1: "Popup blocked"**
- Solution: User must initiate sign-in (button click), not automatic

**Issue 2: "Unauthorized domain"**
- Solution: Add domain in Firebase Console → Authentication → Authorized domains

**Issue 3: "API key error"**
- Solution: Verify firebase_options.dart has correct values from Firebase Console

---

## Testing

**Local Testing:**
```bash
flutter run -d chrome --web-port=8080
```

Access at: `http://localhost:8080`

**Production Build:**
```bash
flutter build web
```

Deploy the `build/web` folder to Firebase Hosting or your server.

---

## Security Best Practices

1. **Never commit** real API keys to public repos
2. Use **environment variables** for sensitive config
3. Enable **App Check** in Firebase Console for production
4. Implement **proper error handling** for failed sign-ins
5. Add **sign-out functionality**: `FirebaseAuth.instance.signOut()`

---

## Summary

The web implementation uses `signInWithPopup()` which opens Google's OAuth in a popup window. Firebase handles all OAuth complexity—no SHA certificates, no additional SDKs needed. Just configure Firebase Console, add dependencies, and call the popup method. The authentication state persists automatically across page refreshes through Firebase's session management.
