// Service Worker for Profolio Web App
// Version control and caching strategy

const CACHE_NAME = 'profolio-cache-v1';
const RUNTIME_CACHE = 'profolio-runtime-v1';

// Resources to cache on install
const PRECACHE_URLS = [
  '/',
  '/index.html',
  '/manifest.json',
  '/favicon.png'
];

// Install event - precache essential resources
self.addEventListener('install', (event) => {
  console.log('[Service Worker] Installing...');
  
  // Skip waiting to activate immediately
  self.skipWaiting();
  
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then((cache) => {
        console.log('[Service Worker] Precaching resources');
        return cache.addAll(PRECACHE_URLS);
      })
      .catch((error) => {
        console.error('[Service Worker] Precaching failed:', error);
      })
  );
});

// Activate event - clean up old caches and take control immediately
self.addEventListener('activate', (event) => {
  console.log('[Service Worker] Activating...');
  
  event.waitUntil(
    (async () => {
      // Clean up old caches
      const cacheNames = await caches.keys();
      await Promise.all(
        cacheNames
          .filter((cacheName) => {
            return cacheName !== CACHE_NAME && cacheName !== RUNTIME_CACHE;
          })
          .map((cacheName) => {
            console.log('[Service Worker] Deleting old cache:', cacheName);
            return caches.delete(cacheName);
          })
      );
      
      // Take control of all clients immediately
      await self.clients.claim();
      console.log('[Service Worker] Activated and claimed clients');
    })()
  );
});

// Fetch event - network-first strategy
self.addEventListener('fetch', (event) => {
  // Skip non-GET requests
  if (event.request.method !== 'GET') {
    return;
  }

  event.respondWith(
    (async () => {
      try {
        // Try network first
        console.log('[Service Worker] Fetching from network:', event.request.url);
        const networkResponse = await fetch(event.request);
        
        // Cache successful responses
        if (networkResponse && networkResponse.status === 200) {
          const cache = await caches.open(RUNTIME_CACHE);
          cache.put(event.request, networkResponse.clone());
        }
        
        return networkResponse;
      } catch (error) {
        // Network failed, try cache
        console.log('[Service Worker] Network failed, trying cache:', event.request.url);
        
        // Try runtime cache first
        let cachedResponse = await caches.match(event.request, { cacheName: RUNTIME_CACHE });
        
        // If not in runtime cache, try precache
        if (!cachedResponse) {
          cachedResponse = await caches.match(event.request, { cacheName: CACHE_NAME });
        }
        
        if (cachedResponse) {
          console.log('[Service Worker] Serving from cache:', event.request.url);
          return cachedResponse;
        }
        
        // If nothing in cache, return error
        console.error('[Service Worker] No cache available for:', event.request.url);
        throw error;
      }
    })()
  );
});

// Message event - handle messages from clients
self.addEventListener('message', (event) => {
  console.log('[Service Worker] Message received:', event.data);
  
  if (event.data && event.data.type === 'SKIP_WAITING') {
    self.skipWaiting();
  }
});

console.log('[Service Worker] Script loaded');
