var CACHE = 'offline';

function fromCache(request) {
  return caches.open(CACHE).then(function (cache) {
    return cache.match(request);
  });
}

function update(request) {
  return caches.open(CACHE).then(function (cache) {
    return fetch(request).then(function (response) {
      return cache.put(request, response.clone()).then(function () {
        return response;
      });
    });
  });
}

function refresh(response) {
  return self.clients.matchAll().then(function (clients) {
    clients.forEach(function (client) {
      var message = {
        type: 'refresh',
        url: response.url,
        eTag: response.headers.get('ETag')
      };
      client.postMessage(JSON.stringify(message));
    });
  });
}

self.addEventListener('install', function(event) {
  console.log('[sw] Installing...');
  event.waitUntil(
    caches.open(CACHE).then(function(cache) {
      return cache.addAll([
        '/pwa.html'
      ]);
    })
  );
});

self.addEventListener('fetch', function(event) {
  console.log('[sw] Serving content');
  event.respondWith(fromCache('/pwa.html'));
  event.waitUntil(
    update('/pwa.html').then(refresh)
  );
});
