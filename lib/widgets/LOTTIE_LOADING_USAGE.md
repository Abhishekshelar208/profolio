# Lottie Loading Widget Usage Guide

This guide explains how to use the reusable Lottie loading widget that displays the rocket animation throughout the app.

## Overview

The app now uses a consistent loading animation (rocket Lottie) instead of the default `CircularProgressIndicator`. This provides a better user experience and matches the web app's loading screen.

## Widgets Available

### 1. `LottieLoadingWidget`
Basic widget that can be used anywhere in your app.

```dart
LottieLoadingWidget(
  loadingText: 'Loading...',     // Optional text below animation
  size: 200,                      // Optional size (default: 200)
  backgroundColor: Colors.white,  // Optional background color
)
```

### 2. `LottieLoadingScaffold`
Full-screen scaffold version for page-level loading.

```dart
LottieLoadingScaffold(
  loadingText: 'Loading Portfolio...', // Optional text
  size: 300,                            // Optional size (default: 300)
  backgroundColor: Colors.white,        // Optional background color
)
```

## Usage Examples

### Example 1: Portfolio Loader
```dart
FutureBuilder<DatabaseEvent>(
  future: portfolioRef.once(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const LottieLoadingScaffold(
        loadingText: 'Loading Portfolio...',
        size: 300,
      );
    }
    // ... rest of your code
  },
)
```

### Example 2: Stream Builder (Portfolio List)
```dart
StreamBuilder(
  stream: portfolioQuery.onValue,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const LottieLoadingWidget(
        loadingText: 'Loading Portfolios...',
        size: 250,
        backgroundColor: Color(0xffe0eae5),
      );
    }
    // ... rest of your code
  },
)
```

### Example 3: In a Dialog or Modal
```dart
showDialog(
  context: context,
  builder: (context) => Dialog(
    child: SizedBox(
      height: 300,
      width: 300,
      child: LottieLoadingWidget(
        loadingText: 'Processing...',
        size: 150,
      ),
    ),
  ),
);
```

### Example 4: Custom Implementation
```dart
Center(
  child: LottieLoadingWidget(
    loadingText: 'Please wait...',
    size: 180,
    backgroundColor: Colors.transparent,
  ),
)
```

## Migration Guide

### Before (Old Code)
```dart
if (isLoading) {
  return Center(
    child: CircularProgressIndicator(
      color: Colors.blue,
      strokeWidth: 3,
    ),
  );
}
```

### After (New Code)
```dart
if (isLoading) {
  return const LottieLoadingWidget(
    loadingText: 'Loading...',
    size: 200,
  );
}
```

## Files Already Updated

✅ `lib/pages/portfoliodetailloader.dart` - Portfolio loading page  
✅ `lib/pages/portfoliolist.dart` - Portfolio list loading

## Recommended Updates

Consider updating these files to use the Lottie loading widget:

- `lib/pages/allEditScreenOptions/EditSocialLinksPage.dart`
- `lib/pages/adminPages/GenerateCouponCodePage.dart`
- `lib/pages/adminPages/AdminDashboardPage.dart`
- `lib/pages/adminPages/ShopListPage.dart`
- `lib/pages/designSelectionPage.dart`
- And other pages with `CircularProgressIndicator`

## Benefits

1. **Consistent UX** - Same loading animation across web and mobile
2. **Better Branding** - Custom rocket animation matches your brand
3. **Reusable** - Single widget used everywhere
4. **Configurable** - Customizable size, text, and background
5. **Fallback** - Shows CircularProgressIndicator if Lottie fails to load

## Animation File Location

The rocket animation is located at:
```
assets/lottieAnimations/rocketAnimation.json
```

Make sure this file is properly included in your `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/lottieAnimations/rocketAnimation.json
```

## Troubleshooting

### Animation not showing?
- Check that the animation file exists at `assets/lottieAnimations/rocketAnimation.json`
- Verify `lottie` package is added to `pubspec.yaml`
- Run `flutter pub get` to install dependencies
- Check console for error messages

### Widget too large/small?
- Adjust the `size` parameter
- Default is 200 for `LottieLoadingWidget` and 300 for `LottieLoadingScaffold`

### Background color issues?
- Set `backgroundColor` parameter to match your screen's background
- Use `Colors.transparent` for transparent background

## Notes

- The widget includes an error fallback that shows `CircularProgressIndicator` if the Lottie animation fails to load
- Text is optional - omit `loadingText` parameter for animation only
- Animation loops automatically
- Widget is const-constructible when possible for better performance
