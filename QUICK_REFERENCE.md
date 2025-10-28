# Quick Reference Card

## 🚀 Deploying New Version

### Step 1: Update Version Number
**File:** `web/index.html` (Line 87)
```javascript
const APP_VERSION = '1.0.1'; // ← Change this
```

### Step 2: Build
```bash
flutter build web --release
```

### Step 3: Deploy
```bash
# Your deployment command (Firebase, Netlify, etc.)
firebase deploy --only hosting
```

### Step 4: Verify
- Open browser DevTools Console
- Look for: `[Version Check] Version mismatch detected!`
- Watch automatic cache clear and reload
- Verify URL is preserved after reload

---

## 🎨 Using Lottie Loading Widget

### Portfolio Detail Page (Full Screen)
```dart
if (snapshot.connectionState == ConnectionState.waiting) {
  return const LottieLoadingScaffold(
    loadingText: 'Loading Portfolio...',
    size: 300,
  );
}
```

### Portfolio List (Inline)
```dart
if (snapshot.connectionState == ConnectionState.waiting) {
  return const LottieLoadingWidget(
    loadingText: 'Loading Portfolios...',
    size: 250,
    backgroundColor: Color(0xffe0eae5),
  );
}
```

### Import Statement
```dart
import 'package:profolio/widgets/lottie_loading_widget.dart';
```

---

## 🐛 Troubleshooting

### Deep Links Not Working?
- Check: `localStorage.getItem('app_version')`
- Should show version without reload on first visit
- Console: `[Version Check] First visit - storing version without reload`

### Animation Not Showing?
- Check file exists: `lib/assets/lottieAnimations/rocketAnimation.json`
- Verify in `pubspec.yaml`: `- lib/assets/lottieAnimations/`
- Run: `flutter pub get`

### Version Not Updating?
- Set `AUTO_UPDATE_ENABLED = true`
- Wait 10 seconds between checks (cooldown)
- Clear manually: `localStorage.clear()` + reload

---

## 📝 Configuration

| Setting | Location | Default |
|---------|----------|---------|
| Version | `web/index.html` line 87 | `'1.0.0'` |
| Auto-update | `web/index.html` line 88 | `true` |
| Cooldown | `web/index.html` line 89 | `10000` ms |

---

## 📚 Documentation Files

- `IMPLEMENTATION_SUMMARY.md` - Complete implementation details
- `VERSION_CONTROL_README.md` - Web version control guide
- `lib/widgets/LOTTIE_LOADING_USAGE.md` - Flutter widget guide
- `QUICK_REFERENCE.md` - This file

---

## ✅ Checklist for Deployment

- [ ] Update `APP_VERSION` in `web/index.html`
- [ ] Set `AUTO_UPDATE_ENABLED = true` for production
- [ ] Run `flutter build web --release`
- [ ] Deploy to hosting
- [ ] Test web app loads with animation
- [ ] Test deep links work correctly
- [ ] Check browser console for version logs
- [ ] Verify localStorage has correct version

---

## 🎯 Quick Tips

1. **Development:** Set `AUTO_UPDATE_ENABLED = false` to avoid constant reloads
2. **Version Format:** Use semantic versioning (1.0.0, 1.1.0, 2.0.0)
3. **Testing:** Use incognito/private mode to test fresh installations
4. **Console Logs:** All operations are logged with prefixes like `[Version Check]`, `[Update]`, etc.
5. **Animation:** Loops automatically, no need to manage state

---

**That's it! You're ready to deploy! 🚀**
