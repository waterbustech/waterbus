'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"e2ee.worker.dart.js.deps": "4b8b36d123c11a1af7ea3372b39f1649",
"version.json": "9d17a49700ef50ae274e8df4de844800",
"e2ee.worker.dart.js": "05c7eac27b61c9971691da54e78dbb1b",
"splash/img/light-2x.png": "d9c4b03903f768eb6c02a5104b0d8fc8",
"splash/img/dark-4x.png": "3a836bbe57724629d99cc05600d5d265",
"splash/img/light-3x.png": "ee01a817aba01c3d97bbc2f9442dc6d8",
"splash/img/dark-3x.png": "ee01a817aba01c3d97bbc2f9442dc6d8",
"splash/img/light-4x.png": "3a836bbe57724629d99cc05600d5d265",
"splash/img/dark-2x.png": "d9c4b03903f768eb6c02a5104b0d8fc8",
"splash/img/dark-1x.png": "b83dbac80f57b374571c5c98e8d78558",
"splash/img/light-1x.png": "b83dbac80f57b374571c5c98e8d78558",
"index.html": "6634080a34aff7d28a0ac8c039f4a5c6",
"/": "6634080a34aff7d28a0ac8c039f4a5c6",
"main.dart.js": "61f0911f37bf6723f6ec8b2177437bf6",
"flutter.js": "c71a09214cb6f5f8996a531350400a9a",
"favicon.png": "28c107c6d4249222351916b886909266",
"icons/Icon-192.png": "e20819461f0f8b0361dc09b9c5327172",
"icons/Icon-maskable-192.png": "e20819461f0f8b0361dc09b9c5327172",
"icons/Icon-maskable-512.png": "54d80a33f784a7cebbecba4534058e07",
"icons/Icon-512.png": "54d80a33f784a7cebbecba4534058e07",
"manifest.json": "d90c0b47dc8e8adfad4ba27997292770",
"firebase-config.js": "3cace7044ff795b44681c8e36f909561",
"e2ee.worker.dart.js.map": "ceaada11256513064f3acf8ec257198c",
"assets/AssetManifest.json": "3cabba3d79f5bafa64a52fc6e7dea601",
"assets/NOTICES": "95deabdb825b23e2719be9cc8c79a2b6",
"assets/FontManifest.json": "d54568910761c8af414cbc969b40e8d8",
"assets/AssetManifest.bin.json": "76ed96343551db95c8dc426c5d5ac322",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "89ed8f4e49bcdfc0b5bfc9b24591e347",
"assets/packages/flutter_phosphor_icons/fonts/Phosphor.ttf": "ae434202ddb6730654adbf02f8f3bc5d",
"assets/packages/flutter_image_compress_web/assets/pica.min.js": "6208ed6419908c4b04382adc8a3053a2",
"assets/packages/wakelock_web/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "d2721e66fd91bdac0d22d880acdfc1f1",
"assets/fonts/MaterialIcons-Regular.otf": "6f28080606187e01f175c8d5666a1401",
"assets/assets/images/background-4.jpg.webp": "a34c40aaecd9de2bf10b17120537f4cc",
"assets/assets/images/background-5.jpg.webp": "649147052cde49ff4328fda72540d794",
"assets/assets/images/logo_rounded.png": "7f6447229a95192be0c8d71452e8d4da",
"assets/assets/images/desktop-background-6.jpg.webp": "1c496537afe77cc2825c7c85af9977b9",
"assets/assets/images/desktop-background-7.jpg.webp": "9628b0065920e85b79e5718da6df106e",
"assets/assets/images/world-map.png": "f85466dc484d56b6a04115d169535af3",
"assets/assets/images/desktop-background-1.jpg.webp": "8a1b5eff30f2b868a336b9c8f2c05c27",
"assets/assets/images/background-3.jpg.webp": "822bb7ec9bae35212ab296220a85f4f3",
"assets/assets/images/background-2.jpg.webp": "e99a327b4d1bb187658b4988e95c0446",
"assets/assets/images/dash.gif": "8d1edeb2af6106c3666e22d9abcfb8a7",
"assets/assets/images/desktop-background-5.jpg.webp": "0a8974488d35197850a14996b458e9a6",
"assets/assets/images/desktop-background-4.jpg.webp": "0fea99ba24bf15d9bd2d68889ef376fc",
"assets/assets/images/img_app_logo.png": "167ed1eca18ef1f6f05988533fb25119",
"assets/assets/images/background-6.jpg.webp": "8a1b5eff30f2b868a336b9c8f2c05c27",
"assets/assets/images/background-1.jpg.webp": "c40d31c7892be5af05ff17f169704ef2",
"assets/assets/images/login-banner.jpeg.webp": "9f321f7c60daa8d8eb6b7173eed740f3",
"assets/assets/images/desktop-background-8.jpg.webp": "ffeaeb0843ff4dcabb37ff389cbf0bc6",
"assets/assets/images/desktop-background-9.jpg.webp": "ff93dab63878939bfd72fdc94c9dce06",
"assets/assets/images/desktop-background-2.jpg.webp": "82ac2d6b62fa760404b67eaca95a9476",
"assets/assets/images/desktop-background-3.jpg.webp": "2038a7ba0ddda31167e8f30cecb04895",
"assets/assets/images/img_logo.png": "60487b4970142ae7b45d079bf91966c1",
"assets/assets/lotties/beauty-filters-lottie.json": "b76452af0cde1101ae7b7cb2da05a18b",
"assets/assets/lotties/unlock-lottie.json": "e1dfac6c8d7437e6e9f704a6dd2e1f59",
"assets/assets/lotties/broadcast-lottie.json": "926c9c116d6227d1943df855141d5188",
"assets/assets/icons/ic_google.png": "dc81337428308233cab399bdf883af12",
"assets/assets/icons/ic_camera_video.png": "70a74eb7b487da0037fc8cfd14ca3305",
"assets/assets/icons/launcher_icon_android12.png": "c77b7cd0d8077193eefa01502b6bc191",
"assets/assets/icons/ic_apple.png": "25abe98bf799d94089e59ffa5797b091",
"assets/assets/icons/ic_code.png": "cdd8a92d006717e902e4755cff5d217b",
"assets/assets/icons/ic_folder.png": "ead0fdbd70e4dcd7775de84cf12c2f28",
"assets/assets/icons/ic_profile.png": "ff22a7d131647c54106ea252c6094bc5",
"assets/assets/icons/ic_facebook.png": "a0254d8a3679f032bca037f09d5ddea1",
"assets/assets/icons/ic_github.png": "ec3a60c8c6539a07eb70b52f6737ea6e",
"assets/assets/icons/ic_paint.png": "a547540742de1c81060377be684cb698",
"assets/assets/icons/ic_log_out.png": "1c844f03d5df3926f702b49db6b87fa5",
"assets/assets/icons/ic_end_call.png": "3e3c5aded9673ca129bf746107a3f3c1",
"assets/assets/icons/ic_new_meeting.png": "06c1aab3aa874b40836bbb0620dd192c",
"assets/assets/icons/ic_settings.png": "11a1858d005ecf6b26d9f966e3ca39c6",
"assets/assets/icons/sparkling.png": "940c6ed948fdbb11a4d8564926a477b1",
"assets/assets/icons/ic_notes.png": "b8f4bcd84d1a05aa67e8ade01712a37b",
"assets/assets/icons/launcher_icon.png": "142fa53d39f2fd5ef839c8d11d07e8c5",
"assets/assets/icons/ic_archive.png": "91d923c7015ca8f35971d236be99b7e9",
"assets/assets/icons/ic_shield.png": "18407fba9a08b899307e521fd39e09f7",
"assets/assets/welcome.java": "7e89c7746564993c1fda2187afb74586",
"assets/assets/fonts/jetbrains-mono/static/JetBrainsMono-Bold.ttf": "f855a5300fbbb56439586d4ca8a131b2",
"assets/assets/fonts/jetbrains-mono/static/JetBrainsMono-Regular.ttf": "b678c7a6800a9d944ae8342905c07cb7",
"assets/assets/fonts/anonymous-pro/AnonymousPro-Bold.ttf": "f5e69393343726e8479a8f5d77f50739",
"assets/assets/fonts/anonymous-pro/AnonymousPro-Regular.ttf": "1c0a292f3473dd6684c2cbee0f6ee5f3",
"assets/assets/fonts/pixelify/PixelifySans-Regular.ttf": "d6b4fe0a9425d5e9b459d654109498b4",
"assets/assets/fonts/pixelify/PixelifySans-Medium.ttf": "2081a0b1dd9a57d373839da37ef2bedd",
"assets/assets/fonts/pixelify/PixelifySans-Bold.ttf": "efc12ef1e774941865527ec2c0a3636c",
"assets/assets/fonts/pixelify/PixelifySans-SemiBold.ttf": "43dddc46855022399125a476c93a69cd",
"assets/assets/fonts/ubuntu-mono/UbuntuMono-Bold.ttf": "d3e281ca75369e8517b3910bc46a7ed0",
"assets/assets/fonts/ubuntu-mono/UbuntuMono-Regular.ttf": "c8ca9c5cab2861cf95fc328900e6f1a3",
"assets/assets/fonts/source-code-pro/static/SourceCodePro-Regular.ttf": "d1f776b31a50ae68ace3819fdc58b065",
"assets/assets/fonts/source-code-pro/static/SourceCodePro-Bold.ttf": "2ffe6059c12752d6c7c20cb5e8f78bea",
"assets/assets/fonts/fira-pro/static/FiraCode-Regular.ttf": "301dd380625eb548238ae3c39ec9f12b",
"assets/assets/fonts/fira-pro/static/FiraCode-Bold.ttf": "016bcf67f409675ff98373081ba753dd",
"assets/assets/fonts/helvetica/helvetica-neue-regular.ttf": "ea05f6114b3efb842e31b45781e087cf",
"assets/assets/fonts/helvetica/helvetica-neue-light.ttf": "0a4d37b22558e86fc49120e96fcc2d01",
"assets/assets/fonts/helvetica/helvetica-neue-medium.ttf": "bd96bc9a5d9c3b07b628529db257e176",
"canvaskit/skwasm.js": "445e9e400085faead4493be2224d95aa",
"canvaskit/skwasm.js.symbols": "741d50ffba71f89345996b0aa8426af8",
"canvaskit/canvaskit.js.symbols": "38cba9233b92472a36ff011dc21c2c9f",
"canvaskit/skwasm.wasm": "e42815763c5d05bba43f9d0337fa7d84",
"canvaskit/chromium/canvaskit.js.symbols": "4525682ef039faeb11f24f37436dca06",
"canvaskit/chromium/canvaskit.js": "43787ac5098c648979c27c13c6f804c3",
"canvaskit/chromium/canvaskit.wasm": "f5934e694f12929ed56a671617acd254",
"canvaskit/canvaskit.js": "c86fbd9e7b17accae76e5ad116583dc4",
"canvaskit/canvaskit.wasm": "3d2a2d663e8c5111ac61a46367f751ac",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
