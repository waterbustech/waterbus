'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"version.json": "2570ec70e8b541cbd14835a2b99cdf9c",
"main.js": "2660012ca564ffb97e9ff0df09225f59",
"main.dart.mjs": "281b43f887c44b623a01b5aae28d45ab",
"flutter_bootstrap.js": "7b645ff1df9a75ca2de33d4c12c93dc2",
"manifest.json": "d90c0b47dc8e8adfad4ba27997292770",
"e2ee.worker.dart.js.map": "4e5c080598a536bada660879e15e7458",
"canvaskit/skwasm_heavy.js.symbols": "46b46c94de195a01ac43d2ca5a3b2d8a",
"canvaskit/skwasm.wasm": "dcce4cb468f929d2254e5cc800dac2c6",
"canvaskit/canvaskit.js.symbols": "0fcf7af235b4b40c5c4e84788c8f944c",
"canvaskit/chromium/canvaskit.js.symbols": "2568caaf88b28baf5cfa215dd2538881",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.wasm": "b829d6d49c8a725934f27548a99c0786",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/canvaskit.wasm": "eea9ded7b9d474ce36106c7dead17ce6",
"canvaskit/skwasm.js.symbols": "39e1e2ea4b9a60cb3b720358a867ddda",
"canvaskit/skwasm_heavy.wasm": "637c592ea139b8c499354113362ef7c1",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"favicon.png": "1d2267187b24320362ad4c360bbf7d4f",
"assets/FontManifest.json": "c31b56ded68c376dbc6df56991452789",
"assets/AssetManifest.bin.json": "7aa4a9e5f248ded74b2c3ce51e1ab89e",
"assets/fonts/MaterialIcons-Regular.otf": "5e0824cdf4c64234cc9fe78bd66e45c2",
"assets/NOTICES": "d6506546347d266aac509d6a054a9549",
"assets/assets/sounds/recording.mp3": "3984da678018c5a373a8a339e2a83fbe",
"assets/assets/sounds/hand_raising.mp3": "c4e251e9d10667d5998346524bb24da4",
"assets/assets/sounds/leave.mp3": "2d794d83898ef23dcf3af03c1352975f",
"assets/assets/sounds/joined.mp3": "ec9c1a40bfb665ba1295fe769b0c14df",
"assets/assets/images/desktop-background-3.jpg.webp": "2038a7ba0ddda31167e8f30cecb04895",
"assets/assets/images/desktop-background-4.jpg.webp": "0fea99ba24bf15d9bd2d68889ef376fc",
"assets/assets/images/desktop-background-9.jpg.webp": "ff93dab63878939bfd72fdc94c9dce06",
"assets/assets/images/desktop-background-5.jpg.webp": "0a8974488d35197850a14996b458e9a6",
"assets/assets/images/img_hello_message_3.gif": "ce25f2b98b2eed1329883302ffa9802f",
"assets/assets/images/background-5.jpg.webp": "649147052cde49ff4328fda72540d794",
"assets/assets/images/desktop-background-2.jpg.webp": "82ac2d6b62fa760404b67eaca95a9476",
"assets/assets/images/img_hello_message_7.gif": "d57e024b8a197acebb1253a007fae491",
"assets/assets/images/desktop-background-1.jpg.webp": "8a1b5eff30f2b868a336b9c8f2c05c27",
"assets/assets/images/background-6.jpg.webp": "8a1b5eff30f2b868a336b9c8f2c05c27",
"assets/assets/images/img_hello_message_6.gif": "1af85dd0af2fe858e569445c1506fb41",
"assets/assets/images/desktop-background-8.jpg.webp": "ffeaeb0843ff4dcabb37ff389cbf0bc6",
"assets/assets/images/desktop-background-6.jpg.webp": "1c496537afe77cc2825c7c85af9977b9",
"assets/assets/images/img_hello_message_5.gif": "fc6f81a9e5403c7715e66b5f784f9e47",
"assets/assets/images/img_hello_message_4.gif": "7fc03fceb1f62428f8fb5c5c302003c6",
"assets/assets/images/background-1.jpg.webp": "c40d31c7892be5af05ff17f169704ef2",
"assets/assets/images/desktop-background-7.jpg.webp": "9628b0065920e85b79e5718da6df106e",
"assets/assets/images/background-4.jpg.webp": "a34c40aaecd9de2bf10b17120537f4cc",
"assets/assets/images/place_holder.gif": "d5ade0f0cd0f73a1ceb17eeb42d57f6b",
"assets/assets/images/img_hello_message_2.gif": "3e99d0f7bf46f72df40b79117e753931",
"assets/assets/images/background-2.jpg.webp": "e99a327b4d1bb187658b4988e95c0446",
"assets/assets/images/background-3.jpg.webp": "822bb7ec9bae35212ab296220a85f4f3",
"assets/assets/images/img_hello_message_1.gif": "22d4a6b08e6cdfcfd29bff082a177c2d",
"assets/assets/images/logo_rounded.png": "8d5f97aaf4b961ef30de578603d77d34",
"assets/assets/fonts/pixelify/PixelifySans-Medium.ttf": "2081a0b1dd9a57d373839da37ef2bedd",
"assets/assets/fonts/pixelify/PixelifySans-Bold.ttf": "efc12ef1e774941865527ec2c0a3636c",
"assets/assets/fonts/pixelify/PixelifySans-SemiBold.ttf": "43dddc46855022399125a476c93a69cd",
"assets/assets/fonts/pixelify/PixelifySans-Regular.ttf": "d6b4fe0a9425d5e9b459d654109498b4",
"assets/assets/icons/ic_check.png": "6cdfa3cdb0fc158cd3b7fc0309d0e0db",
"assets/assets/icons/ic_google.png": "dc81337428308233cab399bdf883af12",
"assets/assets/icons/ic_add_members.png": "e9531e765fb8e41ad0c813e55839f303",
"assets/assets/icons/ic_github.png": "ec3a60c8c6539a07eb70b52f6737ea6e",
"assets/assets/icons/ic_incognito.png": "3a944696387b8408f035d190cf1bdde9",
"assets/assets/icons/color-picker.png": "c4562944601e4deaa733c0980eb7a994",
"assets/assets/icons/launcher_icon.png": "fab0e61c82d1603206fa0ed75567d723",
"assets/assets/lotties/request-zoom-out-lottie.json": "71aef842e5af8acf8a0802f8d5ea54dc",
"assets/assets/lotties/beauty-filters-lottie.json": "b76452af0cde1101ae7b7cb2da05a18b",
"assets/assets/lotties/broadcast-lottie.json": "926c9c116d6227d1943df855141d5188",
"assets/assets/lotties/unlock-lottie.json": "d50824e33b800af50edc51bd29c6fed2",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "e8b38a28f440320b4be7e7bff1bb3000",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/phosphor_flutter/lib/fonts/Phosphor-Thin.ttf": "f128e0009c7b98aba23cafe9c2a5eb06",
"assets/packages/phosphor_flutter/lib/fonts/Phosphor-Fill.ttf": "5d304fa130484129be6bf4b79a675638",
"assets/packages/phosphor_flutter/lib/fonts/Phosphor-Light.ttf": "f2dc1cd993671b155e3235044280ba47",
"assets/packages/phosphor_flutter/lib/fonts/Phosphor-Bold.ttf": "8fedcf7067a22a2a320214168689b05c",
"assets/packages/phosphor_flutter/lib/fonts/Phosphor.ttf": "003d691b53ee8fab57d5db497ddc54db",
"assets/packages/phosphor_flutter/lib/fonts/Phosphor-Duotone.ttf": "c48df336708c750389fa8d06ec830dab",
"assets/packages/flutter_image_compress_web/assets/pica.min.js": "6208ed6419908c4b04382adc8a3053a2",
"assets/packages/iconsax_flutter/fonts/FlutterIconsax.ttf": "6ebc7bc5b74956596611c6774d8beb5b",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/lucide_icons_flutter/assets/build_font/LucideVariable-w300.ttf": "904024f5104e1316f350484ff64d9396",
"assets/packages/lucide_icons_flutter/assets/build_font/LucideVariable-w200.ttf": "8df6d1bf4050204dcb0b66fb1f2baf6c",
"assets/packages/lucide_icons_flutter/assets/build_font/LucideVariable-w400.ttf": "018c3b90a34a3cb086be1759eec35c20",
"assets/packages/lucide_icons_flutter/assets/build_font/LucideVariable-w100.ttf": "555caa3e6592639cd4b76b60f9bb4995",
"assets/packages/lucide_icons_flutter/assets/build_font/LucideVariable-w500.ttf": "7d9aea0ec0eb3e6cd76124b50d1ae83b",
"assets/packages/lucide_icons_flutter/assets/build_font/LucideVariable-w600.ttf": "0e6707d57a50f57349fba3c9aa22738c",
"assets/packages/lucide_icons_flutter/assets/lucide.ttf": "09ceef8f7467f518c11ff9297543dcdd",
"assets/AssetManifest.json": "af3faa88065caa0ccc472fc51ca92073",
"virtual-background.js": "88763f051e72ead2382b4960023ae0f3",
"e2ee.worker.dart.js.deps": "aed8376d40e82073393ae3b1a4083dd6",
"CNAME": "22e138ff2999420ef1e17b352f694cdc",
"icons/favicon.ico": "46faa5e24264f611ba9d26b89c69b184",
"icons/Icon-maskable-512.png": "7175d335fef897f38223f627f72a89e6",
"icons/Icon-512.png": "7175d335fef897f38223f627f72a89e6",
"icons/apple-touch-icon.png": "e98abdfac338801aac3e127563755a6a",
"icons/Icon-192.png": "bba41cc5a249ef628e330e47adcbcf79",
"icons/Icon-maskable-192.png": "bba41cc5a249ef628e330e47adcbcf79",
"main.dart.wasm": "cdadb3487a28b423d816a4f7c1ace27f",
"firebase-config.js": "3cace7044ff795b44681c8e36f909561",
"index.html": "710df6a46bccbfacff03b9f989f0cf03",
"/": "710df6a46bccbfacff03b9f989f0cf03",
"e2ee.worker.dart.js": "403a5c08e4376b23180169d189ca4062",
"main.dart.js": "4b09580d0ddecfea9565770e2eda87f8",
"splash/img/light-3x.png": "936b473a12f7f6f0896c1b8ae48b5018",
"splash/img/light-4x.png": "c6b8b185fd50bd55b6809ee9051beba6",
"splash/img/dark-4x.png": "c6b8b185fd50bd55b6809ee9051beba6",
"splash/img/light-1x.png": "a505742cbf63b1e15ca7c720dcbe3443",
"splash/img/light-2x.png": "7175d335fef897f38223f627f72a89e6",
"splash/img/dark-2x.png": "7175d335fef897f38223f627f72a89e6",
"splash/img/dark-3x.png": "936b473a12f7f6f0896c1b8ae48b5018",
"splash/img/dark-1x.png": "a505742cbf63b1e15ca7c720dcbe3443"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"main.dart.wasm",
"main.dart.mjs",
"index.html",
"flutter_bootstrap.js",
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
