# Version Control & Auto-Update System

This document explains the version control and auto-update mechanism implemented in the Profolio web app.

## Features

✅ **Automatic Version Detection** - Detects version changes and triggers updates automatically  
✅ **Cache Management** - Clears all browser caches when new version is detected  
✅ **Service Worker Control** - Unregisters and re-registers service workers on update  
✅ **Loading Screen** - Displays animated rocket Lottie animation during initialization  
✅ **Loop Prevention** - 10-second cooldown between version checks  
✅ **Toggle Control** - Easy enable/disable for development vs production  
✅ **Network-First Caching** - Service worker uses network-first strategy with cache fallback  

## How It Works

### 1. Version Detection
The system compares the current `APP_VERSION` in `web/index.html` with the version stored in localStorage:

```javascript
const APP_VERSION = '1.0.0'; // Update this when releasing new version
```

### 2. Auto-Update Flow
When a version mismatch is detected:
1. Current URL (including hash/query params) is saved
2. All browser caches are cleared
3. All service workers are unregistered
4. New version is stored in localStorage
5. Page performs a hard reload
6. After reload, original URL is restored (preserving deep links)

**Important:** On first visit, the version is stored WITHOUT reloading to prevent navigation loss.

### 3. Loading Screen
- Displays the rocket Lottie animation from `lib/assets/lottieAnimations/rocketAnimation.json`
- Shows while version checking and app initialization
- Hides when Flutter fires `flutter-first-frame` event or after 5-second timeout

### 4. Service Worker
Optional `service-worker.js` implements:
- Network-first caching strategy
- Automatic activation with `skipWaiting()`
- Immediate client control with `clients.claim()`
- Runtime and precache management

## Usage

### Updating the Version

When you deploy a new version:

1. Open `web/index.html`
2. Update the version number:
   ```javascript
   const APP_VERSION = '1.0.1'; // Increment version
   ```
3. Build and deploy your app:
   ```bash
   flutter build web --release
   ```

### Toggle Auto-Update

For **development** (disable auto-update):
```javascript
const AUTO_UPDATE_ENABLED = false;
```

For **production** (enable auto-update):
```javascript
const AUTO_UPDATE_ENABLED = true;
```

### Adjust Cooldown Period

Change the cooldown between version checks (in milliseconds):
```javascript
const VERSION_CHECK_COOLDOWN = 10000; // 10 seconds (default)
```

## Configuration Options

| Option | Location | Default | Description |
|--------|----------|---------|-------------|
| `APP_VERSION` | `web/index.html` | `'1.0.0'` | Current app version |
| `AUTO_UPDATE_ENABLED` | `web/index.html` | `true` | Enable/disable auto-updates |
| `VERSION_CHECK_COOLDOWN` | `web/index.html` | `10000` | Cooldown in milliseconds |
| Loading timeout | `web/index.html` | `5000` | Max loading screen duration |

## Browser Console Logs

The system logs all activities to the console for debugging:

```
[Init] Starting initialization...
[Lottie] Library loaded
[Lottie] Rocket animation loaded
[Version Check] Current App Version: 1.0.0
[Version Check] Stored Version: null
[Version Check] Version is up to date
[Flutter] First frame rendered
[Loading] Hiding loading screen
```

When an update is detected:
```
[Version Check] Version mismatch detected! Stored: 1.0.0, Current: 1.0.1
[Update] Starting update process...
[Cache Clear] Clearing all caches...
[Cache Clear] Deleting cache: flutter-app-cache
[Service Worker] Unregistering all service workers...
[Update] Update complete - forcing reload...
```

## Service Worker Registration (Optional)

If you want to use the service worker, add this to your `web/index.html` before the closing `</body>` tag:

```javascript
<script>
  if ('serviceWorker' in navigator) {
    navigator.serviceWorker.register('service-worker.js')
      .then((registration) => {
        console.log('[Service Worker] Registered:', registration);
      })
      .catch((error) => {
        console.error('[Service Worker] Registration failed:', error);
      });
  }
</script>
```

## Testing the System

### Test Version Update:

1. Open your app in a browser
2. Open DevTools Console
3. Check current version: `localStorage.getItem('app_version')`
4. Change `APP_VERSION` in `web/index.html` to a different value
5. Rebuild: `flutter build web --release`
6. Reload the page
7. Watch console logs for update process
8. Verify new version: `localStorage.getItem('app_version')`

### Test Loading Screen:

1. Open your app in a browser
2. You should see the rocket animation
3. Animation should disappear when Flutter loads or after 5 seconds

### Clear Everything and Start Fresh:

```javascript
// Run in browser console
localStorage.clear();
caches.keys().then(names => names.forEach(name => caches.delete(name)));
navigator.serviceWorker.getRegistrations().then(regs => regs.forEach(reg => reg.unregister()));
location.reload();
```

## Troubleshooting

### Animation not loading?
- Check that `lib/assets/lottieAnimations/rocketAnimation.json` exists
- Verify the path in Lottie load: `'assets/assets/lottieAnimations/rocketAnimation.json'`
- Check browser console for error messages

### Version not updating?
- Ensure `AUTO_UPDATE_ENABLED` is set to `true`
- Check if cooldown period has passed (10 seconds default)
- Clear browser cache manually and try again
- Verify version string has actually changed

### Loading screen not hiding?
- Check if Flutter is firing the `flutter-first-frame` event
- Timeout fallback should hide it after 5 seconds regardless
- Check browser console for errors

### Deep links not working?
- The system now preserves URLs during updates (including hash routes)
- On first visit, version is stored WITHOUT reloading
- Check console for `[Version Check] First visit - storing version without reload`
- If you see unwanted redirects, check if there's a `pending_url_after_update` in localStorage

## Best Practices

1. **Version Naming**: Use semantic versioning (e.g., `1.0.0`, `1.1.0`, `2.0.0`)
2. **Development**: Disable auto-update during development
3. **Production**: Enable auto-update for production deployments
4. **Testing**: Always test version updates in staging before production
5. **Monitoring**: Watch console logs to verify update process

## Files Modified/Created

- ✅ `web/index.html` - Main HTML with version control logic and loading screen
- ✅ `web/service-worker.js` - Optional service worker with network-first strategy
- ✅ `VERSION_CONTROL_README.md` - This documentation file

## Additional Notes

- The system uses `localStorage` to track versions and timestamps
- All console logs are prefixed with tags like `[Version Check]`, `[Update]`, etc.
- The loading screen fades out smoothly with CSS animation
- Service worker is optional - the version control works without it
- Lottie animation is loaded from CDN (cdnjs.cloudflare.com)

## Support

For issues or questions, check:
1. Browser console logs
2. Network tab in DevTools
3. Application tab > Storage > Local Storage
4. Application tab > Cache Storage
5. Application tab > Service Workers
