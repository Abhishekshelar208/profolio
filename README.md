# 🚀 ProFolio - Portfolio Builder & Management Platform

![ProFolio Logo](lib/assets/images/perfectLogo.png)

**Build. Customize. Share.**

A comprehensive Flutter-based portfolio management platform that enables users to create, customize, and share professional portfolios with multiple design templates and management tools.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Design Templates](#design-templates)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Setup Instructions](#setup-instructions)
- [Firebase Configuration](#firebase-configuration)
- [Deep Linking](#deep-linking)
- [Admin Features](#admin-features)
- [API Reference](#api-reference)
- [Deployment](#deployment)
- [Contributing](#contributing)

## 🎯 Overview

ProFolio is a modern portfolio management platform built with Flutter that allows users to:
- Create professional portfolios with multiple design templates
- Customize content including projects, experiences, achievements, and skills
- Generate shareable links with deep linking support
- Manage portfolios through an admin dashboard
- Monetize different design templates with pricing tiers

## ✨ Features

### 🎨 **Multi-Template Portfolio System**
- **6 Unique Design Templates**: From minimalist (DesignOne) to modern dark themes (DesignSix)
- **Responsive Design**: Optimized for web, tablet, and mobile devices
- **Real-time Preview**: Live preview while editing portfolio content

### 👤 **User Management**
- **Firebase Authentication**: Secure user registration and login
- **Profile Management**: Complete user profile with social links
- **Multi-Portfolio Support**: Users can create multiple portfolios

### 🛠️ **Content Management**
- **Rich Media Upload**: Images, PDFs, and documents
- **Dynamic Sections**:
  - Personal Information & About
  - Skills with visual indicators
  - Work Experience with company details
  - Projects with live demo links
  - Achievements with badges
  - Contact forms with validation

### 🔗 **Sharing & Deep Linking**
- **Custom URL Generation**: `https://yourapp.com/#/portfolio/ID`
- **Cross-Platform Deep Links**: Works on web, mobile, and desktop
- **Social Media Sharing**: Direct integration with share APIs
- **QR Code Generation**: For easy portfolio sharing

### 💰 **Monetization System**
- **Tiered Pricing**: Different prices for design templates (₹49 - ₹499)
- **Payment Integration**: Coupon codes and payment verification
- **Admin Revenue Tracking**: Complete financial dashboard

### 📊 **Admin Dashboard**
- **Portfolio Analytics**: Usage statistics and popular designs
- **User Management**: View and manage all user accounts
- **Content Moderation**: Manage portfolio content and submissions
- **Revenue Tracking**: Financial analytics and reporting

## 🏗️ Architecture

### **Frontend Architecture**
```
📱 Flutter App
├── 🎨 UI Layer (Widgets & Screens)
├── 🔄 State Management (StatefulWidgets)
├── 🌐 Navigation (App Links & Routing)
└── 🔧 Services (Firebase, Storage, Utils)
```

### **Backend Architecture**
```
☁️ Firebase Backend
├── 🔐 Authentication (Firebase Auth)
├── 💾 Database (Realtime Database)
├── 📁 Storage (Firebase Storage)
└── 🌐 Hosting (Firebase Hosting)
```

### **Data Flow**
1. **User Registration** → Firebase Auth → Profile Creation
2. **Portfolio Creation** → Content Upload → Firebase Storage → Database Save
3. **Portfolio Sharing** → URL Generation → Deep Link Creation
4. **Admin Monitoring** → Real-time Analytics → Dashboard Updates

## 🎨 Design Templates

### **Available Templates:**

| Template | Price | Style | Features |
|----------|-------|-------|----------|
| **DesignOne** | ₹49 | Minimalist | Clean, professional, mobile-first |
| **DesignTwo** | ₹99 | Modern | Card-based layout, animations |
| **DesignThree** | ₹149 | Creative | Colorful, dynamic sections |
| **DesignFour** | ₹199 | Corporate | Professional, business-focused |
| **DesignFive** | ₹249 | Elegant | Sophisticated, clean aesthetics |
| **DesignSix** | ₹299 | Dark Modern | Glassmorphism, dark theme, animations |

### **Template Features:**
- **Responsive Design**: All templates adapt to different screen sizes
- **Animation System**: Smooth transitions and hover effects
- **Component Architecture**: Modular design with reusable components
- **Theme Consistency**: Consistent color schemes and typography
- **Accessibility**: Screen reader support and keyboard navigation

## 🛠️ Tech Stack

### **Frontend**
- **Framework**: Flutter 3.7.0+
- **Language**: Dart
- **UI Libraries**:
  - `google_fonts` - Typography
  - `lottie` - Animations  
  - `animated_theme_switcher` - Theme management
  - `url_launcher` - External links
  - `share_plus` - Social sharing

### **Backend & Services**
- **Authentication**: Firebase Auth
- **Database**: Firebase Realtime Database
- **Storage**: Firebase Storage
- **Analytics**: Firebase Analytics
- **Hosting**: Firebase Hosting

### **Additional Tools**
- **Deep Linking**: `app_links` package
- **File Handling**: `file_picker`, `image_picker`
- **PDF Generation**: `pdf`, `printing`
- **QR Codes**: `qr_flutter`
- **Video Integration**: `youtube_player_flutter`

## 📁 Project Structure

```
profolio/
├── 📱 lib/
│   ├── 🎨 assets/
│   │   ├── images/          # App images and logos
│   │   ├── icons/           # Custom icons
│   │   └── lottieAnimations/ # Animation files
│   │
│   ├── 📄 pages/
│   │   ├── adminPages/      # Admin dashboard screens
│   │   ├── allEditScreenOptions/ # Portfolio editing screens
│   │   ├── AchivementsSliders/  # Achievement components
│   │   ├── ConnectwithMe/   # Contact form components
│   │   ├── ExperienceSliders/ # Experience components
│   │   └── ProjectSliders/  # Project showcase components
│   │
│   ├── 🎨 portfolioDesings/
│   │   ├── designone.dart   # Template 1
│   │   ├── designtwo.dart   # Template 2
│   │   ├── designthreee.dart # Template 3
│   │   ├── designfour.dart  # Template 4
│   │   ├── design_five.dart # Template 5
│   │   └── design_six.dart  # Template 6
│   │
│   ├── 🔧 firebase_options.dart # Firebase configuration
│   └── 🚀 main.dart        # App entry point
│
├── 📦 pubspec.yaml         # Dependencies
└── 📚 README.md           # This file
```

## 🚀 Setup Instructions

### **Prerequisites**
- Flutter SDK 3.7.0+
- Firebase account
- Android Studio / VS Code
- Git

### **Installation**

1. **Clone the repository**
```bash
git clone https://github.com/your-username/profolio.git
cd profolio
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Firebase Setup** (See Firebase Configuration section)

4. **Run the application**
```bash
# For development
flutter run -d chrome  # Web
flutter run -d android # Android
flutter run -d ios     # iOS
```

5. **Build for production**
```bash
# Web build
flutter build web

# Mobile builds
flutter build apk     # Android
flutter build ios     # iOS
```

## 🔥 Firebase Configuration

### **1. Create Firebase Project**
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create new project: "ProFolio"
3. Enable required services

### **2. Enable Services**
```bash
# Authentication
- Email/Password authentication
- Google Sign-in (optional)

# Realtime Database
- Start in test mode
- Set up security rules

# Storage
- Start in test mode
- Configure CORS for web

# Hosting (for web deployment)
- Initialize hosting
- Set up custom domain
```

### **3. Add Configuration Files**
```bash
# Generate configuration
firebase init

# Add to pubspec.yaml
flutter pub add firebase_core
flutter pub add firebase_auth
flutter pub add firebase_database
flutter pub add firebase_storage
```

### **4. Security Rules**

**Realtime Database Rules:**
```json
{
  "rules": {
    "Portfolio": {
      "$portfolioId": {
        ".read": true,
        ".write": "$portfolioId.contains(auth.uid) || auth.uid === 'admin-uid'"
      }
    },
    "Users": {
      "$uid": {
        ".read": "$uid === auth.uid",
        ".write": "$uid === auth.uid"
      }
    }
  }
}
```

**Storage Rules:**
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /portfolios/{userId}/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## 🔗 Deep Linking

### **URL Structure**
```
https://your-domain.com/#/portfolio/PortFolio000017
```

### **Supported Platforms**

**Web:**
```html
<!-- Add to index.html -->
<base href="/">
```

**Android:**
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="https"
          android:host="your-domain.com" />
</intent-filter>
```

**iOS:**
```xml
<!-- ios/Runner/Info.plist -->
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>your-domain.com</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>https</string>
        </array>
    </dict>
</array>
```

### **Testing Deep Links**

```bash
# Android
adb shell am start -a android.intent.action.VIEW \
  -d "https://your-domain.com/#/portfolio/PortFolio000017"

# iOS Simulator
xcrun simctl openurl booted "https://your-domain.com/#/portfolio/PortFolio000017"

# Web
# Simply navigate to URL in browser
```

## 👨‍💼 Admin Features

### **Dashboard Analytics**
- Total portfolio count
- Design template usage statistics  
- Revenue tracking per template
- User growth metrics

### **Portfolio Management**
- View all user portfolios
- Edit/moderate content
- Enable/disable portfolios
- Generate admin reports

### **User Management**
- User account overview
- Portfolio ownership tracking
- Payment status monitoring
- Support ticket management

### **Financial Tracking**
- Revenue by template
- Payment verification logs
- Coupon usage analytics
- Monthly/yearly reports

## 🌐 API Reference

### **Portfolio Operations**

```dart
// Create portfolio
await FirebaseDatabase.instance
  .ref("Portfolio/$portfolioId")
  .set(portfolioData);

// Read portfolio  
final snapshot = await FirebaseDatabase.instance
  .ref("Portfolio/$portfolioId")
  .get();

// Update portfolio
await FirebaseDatabase.instance
  .ref("Portfolio/$portfolioId")
  .update(updatedData);

// Delete portfolio
await FirebaseDatabase.instance
  .ref("Portfolio/$portfolioId")
  .remove();
```

### **File Upload**

```dart
// Upload image
final storageRef = FirebaseStorage.instance
  .ref()
  .child('portfolios/$userId/images/$filename');
  
final uploadTask = storageRef.putFile(imageFile);
final snapshot = await uploadTask;
final downloadUrl = await snapshot.ref.getDownloadURL();
```

### **User Authentication**

```dart
// Sign up
final credential = await FirebaseAuth.instance
  .createUserWithEmailAndPassword(
    email: email,
    password: password,
  );

// Sign in
final credential = await FirebaseAuth.instance
  .signInWithEmailAndPassword(
    email: email, 
    password: password,
  );

// Sign out
await FirebaseAuth.instance.signOut();
```

## 🚀 Deployment

### **Web Deployment (Firebase Hosting)**

```bash
# Build web app
flutter build web

# Initialize Firebase hosting
firebase init hosting

# Deploy
firebase deploy

# Custom domain setup
firebase hosting:channel:create production
```

### **Mobile App Deployment**

**Android (Google Play Store):**
```bash
# Generate release APK
flutter build apk --release

# Generate App Bundle (recommended)
flutter build appbundle --release
```

**iOS (App Store):**
```bash
# Build iOS release
flutter build ios --release

# Archive in Xcode
open ios/Runner.xcworkspace
```

### **Environment Configuration**

```dart
// lib/config/environment.dart
class Environment {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://your-domain.com',
  );
  
  static const bool isProduction = bool.fromEnvironment('PRODUCTION');
}
```

## 🤝 Contributing

### **Development Workflow**

1. **Fork the repository**
2. **Create feature branch**: `git checkout -b feature/amazing-feature`
3. **Commit changes**: `git commit -m 'Add amazing feature'`
4. **Push to branch**: `git push origin feature/amazing-feature`
5. **Open Pull Request**

### **Code Standards**

```dart
// Use consistent naming conventions
class UserPortfolioService {
  Future<Portfolio> createPortfolio() async {
    // Implementation
  }
}

// Add documentation
/// Creates a new portfolio for the authenticated user
/// 
/// Returns [Portfolio] object if successful
/// Throws [Exception] if creation fails
Future<Portfolio> createPortfolio() async {
  // Implementation
}
```

### **Testing**

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/portfolio_test.dart

# Run widget tests
flutter test test/widgets/

# Generate coverage report
flutter test --coverage
```

## 📊 Performance & Analytics

### **Key Metrics**
- **Portfolio Creation Rate**: Tracks user engagement
- **Template Popularity**: Most used designs  
- **Conversion Rate**: Free to paid template upgrades
- **User Retention**: Monthly active users
- **Performance**: App load times and responsiveness

### **Monitoring Tools**
- Firebase Analytics
- Firebase Performance Monitoring
- Firebase Crashlytics
- Custom analytics dashboard

## 🔐 Security & Privacy

### **Data Protection**
- User data encryption
- Secure authentication flows
- Privacy-compliant data handling
- GDPR compliance ready

### **Security Measures**
- Firebase security rules
- Input validation and sanitization
- Secure file upload handling
- Rate limiting for API calls

## 📱 Platform Support

| Platform | Status | Features |
|----------|--------|----------|
| **Web** | ✅ Full Support | All features, deep linking |
| **Android** | ✅ Full Support | Native sharing, deep links |  
| **iOS** | ✅ Full Support | Native sharing, universal links |
| **Desktop** | 🔄 In Progress | Windows/macOS support |

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team & Support

- **Developer**: Abhishek Shelar
- **Email**: abhishekshelar@example.com
- **Website**: https://your-portfolio-site.com

### **Support Channels**
- 📧 Email: support@profolio.com
- 💬 Discord: ProFolio Community
- 📱 Twitter: @ProFolioApp
- 🐛 Issues: GitHub Issues

---

## 📈 Future Roadmap

See [FEATURES_ROADMAP.md](FEATURES_ROADMAP.md) for detailed feature suggestions and implementation timeline.

**Made with ❤️ using Flutter & Firebase**
