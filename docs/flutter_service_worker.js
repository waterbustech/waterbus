'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "41af6e9d5e6bee42dd6237692ccbef1b",
"e2ee.worker.dart.js.deps": "077d219194189738bf1c834375679175",
"version.json": "dd19601ce4f1b3dba957d95ec84d0b15",
"e2ee.worker.dart.js": "d390fd2fa6ffff3125f093f74cf264c1",
"splash/img/light-2x.png": "d9c4b03903f768eb6c02a5104b0d8fc8",
"splash/img/dark-4x.png": "3a836bbe57724629d99cc05600d5d265",
"splash/img/light-3x.png": "ee01a817aba01c3d97bbc2f9442dc6d8",
"splash/img/dark-3x.png": "ee01a817aba01c3d97bbc2f9442dc6d8",
"splash/img/light-4x.png": "3a836bbe57724629d99cc05600d5d265",
"splash/img/dark-2x.png": "d9c4b03903f768eb6c02a5104b0d8fc8",
"splash/img/dark-1x.png": "b83dbac80f57b374571c5c98e8d78558",
"splash/img/light-1x.png": "b83dbac80f57b374571c5c98e8d78558",
"index.html": "5a46d8819f48a960e46e33c30471cf7d",
"/": "5a46d8819f48a960e46e33c30471cf7d",
"CNAME": "22e138ff2999420ef1e17b352f694cdc",
"main.dart.js": "445b9e154e9c701f54d0d3b2c3920f70",
"virtual-background.js": "91d7895606e8e40e919d59ccb239f4f8",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"main.js": "a9f8d19c5975d25182aa768e14549ea5",
"favicon.png": "4348ff05382c2e6c1f7224818de985b7",
"main.dart.mjs": "a1ca465cd22f0063faa12cd23b04dcec",
"icons/favicon.ico": "464175ee868c2051e520b2886a65531f",
"icons/Icon-192.png": "0754943750c8292c49998f2779ba272b",
"icons/Icon-maskable-192.png": "0754943750c8292c49998f2779ba272b",
"icons/Icon-maskable-512.png": "0b597fc789f3f5e23ff3d36fa8b1b17a",
"icons/waterbus-favicon.png": "d2bc6390739ebc0e5ddd467bd1cd28ed",
"icons/Icon-512.png": "0b597fc789f3f5e23ff3d36fa8b1b17a",
"manifest.json": "d90c0b47dc8e8adfad4ba27997292770",
"main.dart.wasm": "35112f92e02dbf5d7e6e7de73ec858a1",
"firebase-config.js": "3cace7044ff795b44681c8e36f909561",
"e2ee.worker.dart.js.map": "e09bc80d7015b48e0b4c72b7ba5f718b",
"assets/AssetManifest.json": "3cb2dd29e78c0dbb9655bf61468b0f3e",
"assets/NOTICES": "38c173ceaa6596d89afe9ae00a6e5a7a",
"assets/FontManifest.json": "d54568910761c8af414cbc969b40e8d8",
"assets/AssetManifest.bin.json": "efcd769aae5848341c3092b9dd13a377",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/flutter_phosphor_icons/fonts/Phosphor.ttf": "ae434202ddb6730654adbf02f8f3bc5d",
"assets/packages/flutter_image_compress_web/assets/pica.min.js": "6208ed6419908c4b04382adc8a3053a2",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "8350ef361f327a1e6981ec1c2dee85cc",
"assets/fonts/MaterialIcons-Regular.otf": "478df4f7bff338a0b402e52daf99dd9e",
"assets/assets/images/background-4.jpg.webp": "a34c40aaecd9de2bf10b17120537f4cc",
"assets/assets/images/background-5.jpg.webp": "649147052cde49ff4328fda72540d794",
"assets/assets/images/logo_rounded.png": "7f6447229a95192be0c8d71452e8d4da",
"assets/assets/images/desktop-background-6.jpg.webp": "1c496537afe77cc2825c7c85af9977b9",
"assets/assets/images/desktop-background-7.jpg.webp": "9628b0065920e85b79e5718da6df106e",
"assets/assets/images/world-map.png": "f85466dc484d56b6a04115d169535af3",
"assets/assets/images/desktop-background-1.jpg.webp": "8a1b5eff30f2b868a336b9c8f2c05c27",
"assets/assets/images/background-3.jpg.webp": "822bb7ec9bae35212ab296220a85f4f3",
"assets/assets/images/background-2.jpg.webp": "e99a327b4d1bb187658b4988e95c0446",
"assets/assets/images/img_hello_message_1.gif": "22d4a6b08e6cdfcfd29bff082a177c2d",
"assets/assets/images/dash.gif": "8d1edeb2af6106c3666e22d9abcfb8a7",
"assets/assets/images/img_hello_message_2.gif": "3e99d0f7bf46f72df40b79117e753931",
"assets/assets/images/img_hello_message_3.gif": "ce25f2b98b2eed1329883302ffa9802f",
"assets/assets/images/desktop-background-5.jpg.webp": "0a8974488d35197850a14996b458e9a6",
"assets/assets/images/desktop-background-4.jpg.webp": "0fea99ba24bf15d9bd2d68889ef376fc",
"assets/assets/images/img_app_logo.png": "167ed1eca18ef1f6f05988533fb25119",
"assets/assets/images/img_hello_message_7.gif": "d57e024b8a197acebb1253a007fae491",
"assets/assets/images/img_hello_message_6.gif": "1af85dd0af2fe858e569445c1506fb41",
"assets/assets/images/background-6.jpg.webp": "8a1b5eff30f2b868a336b9c8f2c05c27",
"assets/assets/images/img_hello_message_4.gif": "7fc03fceb1f62428f8fb5c5c302003c6",
"assets/assets/images/img_hello_message_5.gif": "fc6f81a9e5403c7715e66b5f784f9e47",
"assets/assets/images/background-1.jpg.webp": "c40d31c7892be5af05ff17f169704ef2",
"assets/assets/images/login-banner.jpeg.webp": "9f321f7c60daa8d8eb6b7173eed740f3",
"assets/assets/images/desktop-background-8.jpg.webp": "ffeaeb0843ff4dcabb37ff389cbf0bc6",
"assets/assets/images/desktop-background-9.jpg.webp": "ff93dab63878939bfd72fdc94c9dce06",
"assets/assets/images/desktop-background-2.jpg.webp": "82ac2d6b62fa760404b67eaca95a9476",
"assets/assets/images/desktop-background-3.jpg.webp": "2038a7ba0ddda31167e8f30cecb04895",
"assets/assets/images/img_logo.png": "60487b4970142ae7b45d079bf91966c1",
"assets/assets/lotties/request-zoom-out-lottie.json": "71aef842e5af8acf8a0802f8d5ea54dc",
"assets/assets/lotties/beauty-filters-lottie.json": "b76452af0cde1101ae7b7cb2da05a18b",
"assets/assets/lotties/unlock-lottie.json": "d50824e33b800af50edc51bd29c6fed2",
"assets/assets/lotties/broadcast-lottie.json": "926c9c116d6227d1943df855141d5188",
"assets/assets/icons/ic_google.png": "dc81337428308233cab399bdf883af12",
"assets/assets/icons/launcher_icon_android12.png": "c77b7cd0d8077193eefa01502b6bc191",
"assets/assets/icons/ic_code.png": "cdd8a92d006717e902e4755cff5d217b",
"assets/assets/icons/ic_add_members.png": "e9531e765fb8e41ad0c813e55839f303",
"assets/assets/icons/ic_github.png": "ec3a60c8c6539a07eb70b52f6737ea6e",
"assets/assets/icons/ic_paint.png": "a547540742de1c81060377be684cb698",
"assets/assets/icons/ic_end_call.png": "3e3c5aded9673ca129bf746107a3f3c1",
"assets/assets/icons/ic_new_meeting.png": "06c1aab3aa874b40836bbb0620dd192c",
"assets/assets/icons/ic_notes.png": "b8f4bcd84d1a05aa67e8ade01712a37b",
"assets/assets/icons/ic_incognito.png": "3a944696387b8408f035d190cf1bdde9",
"assets/assets/icons/launcher_icon.png": "142fa53d39f2fd5ef839c8d11d07e8c5",
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
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c"};
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
