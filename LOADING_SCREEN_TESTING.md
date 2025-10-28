# Loading Screen Testing Guide

This guide helps you test the Lottie loading screen implementation across different browsers and scenarios.

## 🎯 What Should Happen

1. **On Initial Load:**
   - White background appears immediately
   - CSS spinner shows briefly (100-200ms)
   - Rocket Lottie animation replaces spinner
   - "Loading your portfolio..." text displays
   - Animation loops smoothly

2. **When Flutter Loads:**
   - Loading screen fades out (500ms animation)
   - Flutter app fades in simultaneously
   - Smooth transition, no flash or flicker

3. **If Lottie Fails:**
   - CSS spinner stays visible as fallback
   - Text updates to "Loading your portfolio..."
   - App still loads normally

## 🧪 Testing Scenarios

### Test 1: Normal Load (Chrome/Safari/Firefox)

**Steps:**
1. Build and deploy: `flutter build web --release`
2. Open in browser: `https://your-app.web.app`
3. Open DevTools Console

**Expected Console Logs:**
```
[Init] Starting initialization...
[Lottie] Library loaded
[Lottie] Rocket animation loaded and playing
[Version Check] Current App Version: 1.0.0
[Version Check] First visit - storing version without reload
[Flutter] First frame rendered
[Loading] Hiding loading screen
[Loading] Loading screen hidden
```

**What to Watch:**
- ✅ Spinner appears for <200ms
- ✅ Rocket animation loads and plays
- ✅ Text changes to "Loading your portfolio..."
- ✅ Smooth fade out after Flutter loads
- ✅ No console errors

---

### Test 2: Deep Link Load

**Steps:**
1. Open: `https://your-app.web.app/#/portfolio/PortFolio5fadbabc`
2. Watch console and loading screen

**Expected:**
- ✅ Loading screen shows (rocket animation)
- ✅ Portfolio loads directly (no redirect to home)
- ✅ Console: `[Version Check] First visit - storing version without reload`
- ✅ URL stays the same

---

### Test 3: Slow Connection (Network Throttling)

**Steps:**
1. Open DevTools > Network tab
2. Set throttling to "Slow 3G"
3. Hard refresh (Cmd/Ctrl + Shift + R)

**Expected:**
- ✅ Loading screen stays visible longer
- ✅ Animation continues looping
- ✅ Hides after Flutter loads or 8-second timeout
- ✅ Text pulsates (opacity animation)

---

### Test 4: Offline Mode (Service Worker Test)

**Steps:**
1. Load app once (to cache assets)
2. Open DevTools > Application > Service Workers
3. Check "Offline" checkbox
4. Hard refresh

**Expected:**
- ✅ Loading screen appears
- ✅ App loads from cache
- ✅ Rocket animation may use cached version
- ✅ Console: `[Service Worker] Serving from cache`

---

### Test 5: Lottie Fallback (Block CDN)

**Steps:**
1. Open DevTools > Network tab
2. Add block: `*cdnjs.cloudflare.com*`
3. Hard refresh

**Expected:**
- ✅ Spinner shows immediately
- ✅ Console: `[Lottie] Could not load Lottie library from CDN`
- ✅ Text: "Loading your portfolio..."
- ✅ Spinner keeps spinning until Flutter loads
- ✅ App loads normally

---

### Test 6: Multiple Browser Test

**Browsers to Test:**
- ✅ Chrome/Edge (Chromium)
- ✅ Safari (WebKit)
- ✅ Firefox (Gecko)
- ✅ Mobile Safari (iOS)
- ✅ Chrome Mobile (Android)

**What to Check:**
- Loading animation works in all browsers
- Fade transitions are smooth
- No layout shifts or flickers
- Console logs appear correctly

---

### Test 7: Version Update Flow

**Steps:**
1. Load app (version 1.0.0 stored)
2. Change `APP_VERSION` to `1.0.1` in `web/index.html`
3. Rebuild: `flutter build web --release`
4. Deploy
5. Reload app in same browser

**Expected Console:**
```
[Version Check] Version mismatch detected! Stored: 1.0.0, Current: 1.0.1
[Update] Preserving current URL: https://your-app.web.app/#/...
[Update] Starting update process...
[Cache Clear] Clearing all caches...
[Service Worker] Unregistering all service workers...
[Update] Update complete - forcing reload...
[Loading] Loading screen appears again
[Update] Restoring URL after update
[Flutter] First frame rendered
[Loading] Hiding loading screen
```

**What to Watch:**
- ✅ Page reloads automatically
- ✅ Loading screen shows during reload
- ✅ URL is preserved/restored
- ✅ New version stored in localStorage

---

## 🎬 Using the Test Page

A test page is available at `web/loading-test.html` for isolated testing:

**Steps:**
1. Start local server: `python3 -m http.server 8000`
2. Navigate to: `http://localhost:8000/web/loading-test.html`
3. Use control buttons to test different scenarios

**Test Buttons:**
- **Test Lottie Animation** - Loads rocket animation from assets
- **Test Spinner Fallback** - Shows CSS spinner manually
- **Simulate App Load (3s)** - Hides loading after 3 seconds
- **Reset Test** - Reloads the page

---

## 📱 Mobile Device Testing

### iOS Safari:
1. Build: `flutter build web --release`
2. Deploy to hosting
3. Open on iPhone/iPad
4. Check:
   - ✅ Animation plays smoothly
   - ✅ No layout issues on small screens
   - ✅ Touch events don't interfere with loading
   - ✅ Home screen bookmark works

### Android Chrome:
1. Deploy to hosting
2. Open on Android device
3. Check:
   - ✅ Animation performs well
   - ✅ Text is readable
   - ✅ No janky animations
   - ✅ PWA install prompt appears after load

---

## 🐛 Troubleshooting

### Animation Doesn't Load
**Check:**
1. Open console - look for errors
2. Verify CDN is accessible: `https://cdnjs.cloudflare.com/ajax/libs/lottie-web/5.12.2/lottie.min.js`
3. Check animation file path: `assets/assets/lottieAnimations/rocketAnimation.json`
4. Verify fallback spinner appears

**Fix:**
- Spinner should show as fallback
- Check network tab for 404 errors
- Ensure animation file is in build output

---

### Loading Screen Won't Hide
**Check:**
1. Console for `[Flutter] First frame rendered` event
2. Check for JavaScript errors
3. Verify timeout is working (8 seconds)

**Fix:**
- Timeout should hide it regardless
- Check if `hideLoadingScreen()` function is called
- Look for infinite loops in console

---

### Flicker or Flash on Load
**Check:**
1. CSS transitions are applied
2. `opacity` animations working
3. No conflicting styles

**Fix:**
- Verify `.fade-out` class has `opacity: 0`
- Check `transition: opacity 0.5s` is applied
- Ensure no `display: none` before fade

---

### Performance Issues
**Check:**
1. Animation file size (should be ~133KB)
2. Device CPU usage
3. Frame rate in DevTools Performance tab

**Optimize:**
- Lottie uses SVG renderer (good performance)
- Animation loops efficiently
- Consider reducing animation complexity if needed

---

## ✅ Acceptance Criteria

Before deploying to production, verify:

- [ ] Loading screen appears immediately on all browsers
- [ ] Rocket animation loads and plays smoothly
- [ ] Fallback spinner works if Lottie fails
- [ ] Loading screen hides when Flutter loads
- [ ] Timeout works (8 seconds max)
- [ ] Deep links work without redirect
- [ ] Version updates work correctly
- [ ] URL is preserved during updates
- [ ] No console errors in production
- [ ] Mobile devices work properly
- [ ] Smooth transitions (no flicker)
- [ ] Text is readable and centered

---

## 📊 Performance Benchmarks

**Good Performance:**
- Spinner appears: <100ms
- Lottie loads: 200-500ms
- Animation starts: <600ms
- Flutter loads: 1-3 seconds
- Total time to app: 2-4 seconds

**Acceptable Performance:**
- Slower connections: 3-6 seconds
- Timeout fallback: 8 seconds max

**Red Flags:**
- ❌ Loading takes >10 seconds
- ❌ Animation doesn't play
- ❌ Console shows errors
- ❌ Page stays white/blank

---

## 🔍 Browser Console Commands

Useful commands for testing:

```javascript
// Check stored version
localStorage.getItem('app_version')

// Check last version check time
localStorage.getItem('last_version_check')

// Check pending URL
localStorage.getItem('pending_url_after_update')

// Clear version (force update check)
localStorage.removeItem('app_version')

// Clear all data
localStorage.clear()
caches.keys().then(names => names.forEach(name => caches.delete(name)))

// Force show loading screen (for testing)
document.getElementById('loading-screen').style.display = 'flex'
document.getElementById('loading-screen').classList.remove('fade-out')

// Force hide loading screen (for testing)
document.getElementById('loading-screen').classList.add('fade-out')
```

---

## 📝 Test Checklist

Print this and check off as you test:

**Desktop Browsers:**
- [ ] Chrome - Normal load
- [ ] Chrome - Slow 3G
- [ ] Safari - Normal load
- [ ] Firefox - Normal load
- [ ] Edge - Normal load

**Mobile Browsers:**
- [ ] iOS Safari - iPhone
- [ ] iOS Safari - iPad
- [ ] Chrome - Android

**Scenarios:**
- [ ] First visit (no version stored)
- [ ] Deep link load
- [ ] Version update
- [ ] Offline mode
- [ ] CDN blocked (fallback)
- [ ] Network throttling

**Quality:**
- [ ] No console errors
- [ ] Smooth animations
- [ ] Quick load time
- [ ] Proper fade transitions
- [ ] Text readable
- [ ] Spinner fallback works

---

**Testing Complete!** ✅

Once all items are checked, your loading screen is ready for production! 🚀
