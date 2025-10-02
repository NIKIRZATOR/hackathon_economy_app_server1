'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "3af327570751542ca36bbca2fcc42136",
"assets/AssetManifest.bin.json": "2a250fe42dee80289c4c4be828fef294",
"assets/AssetManifest.json": "d50b9284e15fb0657bd156afb09a0d13",
"assets/assets/audio/music/background.mp3": "7773c92d2a94af7dffb24a5f2e378cdd",
"assets/assets/audio/sfx/build.mp3": "6dbc30afb96def73797ff5d67279e92f",
"assets/assets/audio/sfx/building_level-up.mp3": "5f4d7ff5790cef139b575acc91377e5e",
"assets/assets/audio/sfx/cash_register.mp3": "0491a20bd0eb8a7daa47aedae783255d",
"assets/assets/audio/sfx/coins.mp3": "434dff858f245f64498f525f11103f79",
"assets/assets/audio/sfx/destroy.mp3": "8ed9eb79b88885f72d003481c91553ba",
"assets/assets/audio/sfx/error.mp3": "e0da8e89116d3b2ff4b6d8f5fde6cc70",
"assets/assets/audio/sfx/level_up.mp3": "0b6fff3fb38d18bbeea7e7279a85eeaa",
"assets/assets/audio/sfx/mission_colmlete.mp3": "08f212560afaa087dcbcb627dd164921",
"assets/assets/audio/sfx/open_dialog.mp3": "9426165c823727d243282c7d40bf1b19",
"assets/assets/fonts/Halvar/Bold/HalvarBreitschrift-Bold-Web.ttf": "9d1d434b11ba793dffb019c0418e3570",
"assets/assets/fonts/Halvar/Bold/HalvarBreitschrift-BoldSuperSlanted-Web.ttf": "247d0c62ec91a1bf846465a77a470b34",
"assets/assets/fonts/Halvar/ExtraBold/HalvarBreitschrift-ExtraBold-Web.ttf": "96bb54cdc2f3ee7599c9719421f32ad4",
"assets/assets/fonts/Halvar/Medium/HalvarBreitschrift-Medium-Web.ttf": "1264debe4d41b936d565f10b7d549fa0",
"assets/assets/fonts/Halvar/Medium/HalvarBreitschrift-MediumSuperSlanted-Web.ttf": "afef6843cfed7362da0a5e65f50cf2fb",
"assets/assets/fonts/Halvar/Regular/HalvarBreitschrift-Regular-Web.ttf": "c045162c9e5fad5c2a66df46e5925117",
"assets/assets/fonts/Halvar/Regular/HalvarBreitschrift-RegularSuperSlanted-Web.ttf": "6512f7bbef79acf74540799731c406cd",
"assets/assets/images/almanac/card+mobile.png": "06435e9c2736dfeac0cfdb68e19ff2ba",
"assets/assets/images/almanac/card_betterPremium.png": "114972186e860a3cceed64f797e88d82",
"assets/assets/images/almanac/card_CKA.png": "ee39fcb77420bf960a14318cc951d44c",
"assets/assets/images/almanac/card_gazfond.png": "de7f4803e8ab08b397f7877b73df87e5",
"assets/assets/images/almanac/card_gazneft.png": "efb58135a0b7bbe0ab767d1f56f2face",
"assets/assets/images/almanac/card_mir.png": "e4e05e455e723357674f722b9c48ae09",
"assets/assets/images/almanac/card_pensia.png": "4e0ac3b5e92cc5b06989c5bf73331380",
"assets/assets/images/almanac/card_samozan.png": "ee819e8b797cc2cd1467857f92c26338",
"assets/assets/images/almanac/card_supreme.png": "8b4a0e96c08c599d3f23069330b1ac74",
"assets/assets/images/almanac/card_zenit.png": "9de9f66abec86cdf30af9a34c571f7f3",
"assets/assets/images/almanac/creditcard_180premium.png": "6291c2129f5b7375c891c6eaef78121b",
"assets/assets/images/almanac/creditcard_90.png": "0584fba71e6c4ff929943950cb84de93",
"assets/assets/images/almanac/creditcard_flex.png": "b10a23dc32b54adbfda29ff48b528a80",
"assets/assets/images/almanac/creditcard_simple.png": "cf37a7de20f09b4f0460c34ea8b71381",
"assets/assets/images/buildings/bank.png": "776847a710f8a1e36fbbd00457a5589b",
"assets/assets/images/buildings/cafe.png": "bf61f76bc34642c54d0cf0981c1d2609",
"assets/assets/images/buildings/cinema.png": "a4fe20340466a20d6d050378b73b3dd1",
"assets/assets/images/buildings/city_hall.png": "c32eb3f282df6fb8c943d4e25b04d0f4",
"assets/assets/images/buildings/clothes_store.png": "0d491bdedd15d7de8fc569cb7f15b5fc",
"assets/assets/images/buildings/construction_company.png": "543939939fc5b2ac39801593a2a4841a",
"assets/assets/images/buildings/farm.png": "88796dd211523ac6657db49ebaabfb05",
"assets/assets/images/buildings/feed_mill.png": "fb354b438303e4fd39bcf2c862316719",
"assets/assets/images/buildings/fire_station.png": "b22ba5cd8e3f0639c18138be4edec8c1",
"assets/assets/images/buildings/gas_station.png": "a391bfc64f3c2044b7ae76e01530c2cc",
"assets/assets/images/buildings/grocery_store.png": "42e0523c2249039de50a553e2ca0ebb9",
"assets/assets/images/buildings/hospital.png": "de7f20d8478cf27ca57627c22fa017a8",
"assets/assets/images/buildings/investment_center.png": "f9a662754c01fe1a7f140affa0c2a2b3",
"assets/assets/images/buildings/library.png": "be897477f9eb799529ea1761700b3ce7",
"assets/assets/images/buildings/oil_refinery.png": "0623cb33364422a5ad303e529dca67b0",
"assets/assets/images/buildings/paper_mill.png": "e699664e39ce918d2d51f794ad71a4e8",
"assets/assets/images/buildings/pharmaceutical_laboratory.png": "cf30a794fe10f707cda14b6138c2db48",
"assets/assets/images/buildings/pharmacy.png": "93b2b7dd5d9c6c672de891f0c470562d",
"assets/assets/images/buildings/police_station.png": "05c158be193ce9ec43f8e1b32ecfb328",
"assets/assets/images/buildings/sawmill.png": "5dc62906d03c512af6a831be95c3e9b4",
"assets/assets/images/buildings/school.png": "1834f34ba4ac6411a63351127c7933d9",
"assets/assets/images/buildings/textile_mill.png": "26ab1c674b238a49517b301e83bf38e7",
"assets/assets/images/buildings/university.png": "4882c7a9c953cdbf645fe40a503de33c",
"assets/assets/images/buildings/water_tower.png": "9e20ad8f18767fa9e885f0c86f8ce41e",
"assets/assets/images/grass_32.png": "17a8e8ac8d9a4333df13315330a551dc",
"assets/assets/images/Misha/Misha_ask.png": "b5bd960d0ffab926947e2eea16f79d44",
"assets/assets/images/Misha/Misha_celebrate.png": "58f241e1515a2a07b9d340f7c7e476d5",
"assets/assets/images/Misha/Misha_gift.png": "fa2ce3d8644fc6223c1969150831c091",
"assets/assets/images/Misha/Misha_happy.png": "db2d3f57f79aa4ce1982c781ba76003c",
"assets/assets/images/Misha/Misha_ill.png": "8c3a18f18c9677118fedbcc4c7d4c5b2",
"assets/assets/images/Misha/Misha_like.png": "13a3d837b26c8aa28624bff4dfbf0310",
"assets/assets/images/Misha/Misha_LOL.png": "09df3865d1bb1da3a69c6c9db680571d",
"assets/assets/images/Misha/Misha_love.png": "c555ceb267fff85dff00433c9ca1a2a4",
"assets/assets/images/Misha/Misha_money.png": "96dfb42051b1969a6eabb5909b46e840",
"assets/assets/images/Misha/Misha_neutral.png": "29c859b17d28876cbc0a3a2ea0f4bdae",
"assets/assets/images/Misha/Misha_neutral2.png": "8d4c6c67fe6cecf00a2ea005b711e3e8",
"assets/assets/images/Misha/Misha_neutral3.png": "b2e644a634de6a3f31b4d53f3911b4b7",
"assets/assets/images/Misha/Misha_points.png": "db518e23c847afd0e15874a533df49ba",
"assets/assets/images/Misha/Misha_smile.png": "87ab2c2d20aa708db9ebbeae83f6e02d",
"assets/assets/images/resources/brick.png": "0079b13099e83910348166126bbfa732",
"assets/assets/images/resources/coffee_beans.png": "9f886279f249e5fa3a5ced779b5b1091",
"assets/assets/images/resources/coin.png": "fc78bcf917c117bb045e02151ca5dbe2",
"assets/assets/images/resources/fabric.png": "c96cdbe90e43994a115ee63e0380382e",
"assets/assets/images/resources/fuel.png": "fdd56d9815ae8b4efd342751453ce2ca",
"assets/assets/images/resources/paper.png": "efb277d55f262f64641cc20a4ee34b66",
"assets/assets/images/resources/pill.png": "763c8a8101f137c8639a7bd27d06e3b9",
"assets/assets/images/resources/product.png": "19c93a170cb4c83bf07643d4895e6afb",
"assets/assets/images/resources/star.png": "a2e2bc2837fb85294bdef12c133f19a4",
"assets/assets/images/resources/water.png": "008ccfdf6df4f6d2acc6f16e8009b760",
"assets/assets/images/road_gor.png": "f5308421aab5b2f548bbd7831531c899",
"assets/assets/images/svg/gazprombank_logo.svg": "1601adfc9f4ad02f47a324a27576065f",
"assets/assets/images/svg/gazpromneft_card_bg.svg": "51d16621cc6eda223a27a824dfb6307a",
"assets/assets/images/svg/gazpromneft_logo.svg": "db46ab3fc1f8d208796393204b8d1b65",
"assets/assets/images/svg/mir_car_bg.svg": "b9edc4989f7ea2b5ef9b3806a75d60ec",
"assets/assets/images/svg/mir_logo.svg": "3478d065116ff702017b1aa6f25fb939",
"assets/assets/images/svg/star.svg": "111e2016e72d11f07a358e7af5e9de9d",
"assets/assets/images/svg/sumpere_card_bg.svg": "fa9cd1ead38a5255d0dc0725ffa97ffb",
"assets/assets/mock_data/building_type_inputs.json": "024ceed7db1c123ae5623c79f6d9f13f",
"assets/assets/mock_data/building_type_outputs.json": "c12034c70db22b8d4b7a0cf30d0a0c2e",
"assets/assets/mock_data/levels_tasks.json": "200df5014fd535c2f8af759a04a60bf0",
"assets/assets/mock_data/mock_building_type.json": "1804d16a1aa7a4be1aec199ec1f26195",
"assets/assets/mock_data/mock_resource_items.json": "962868cea7f2f442bb4f51f20aa4f6ea",
"assets/assets/mock_data/mock_user_model.json": "28b7a845c4db98619048d6335c5003b8",
"assets/assets/mock_data/mock_user_resources.json": "1c06f43d4a5f5956d4a45ba02a3db441",
"assets/assets/mock_data/user_buildings.json": "dcb89eb7ab233141f8e3d9aead9e11ad",
"assets/FontManifest.json": "d8d59e19c2a728cc3255b47f64dd9332",
"assets/fonts/MaterialIcons-Regular.otf": "2f8719e5375ddb97902ac4fc92652d94",
"assets/NOTICES": "3e948607c9fcd1ee9167841395720711",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"flutter_bootstrap.js": "c6fef21bb377cf51c01bfbb9f47afe39",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "a6da448131b3c0b9679ffcc5bc280dd0",
"/": "a6da448131b3c0b9679ffcc5bc280dd0",
"main.dart.js": "458d7c439834a0f84e222960be831a27",
"manifest.json": "a1a24dd64384cea5f939443ea5eee481",
"version.json": "840aa8d0f97555e909ca5df69556efec"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
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
