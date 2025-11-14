'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "8cf8463b34caa8ac871a52d5dd7ad1ef",
".git/config": "3f0f6f6177095cd9d9ac25cdbc14fbd9",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/HEAD": "4cf2d64e44205fe628ddd534e1151b58",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "5029bfab85b1c39281aa9697379ea444",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/sendemail-validate.sample": "4d67df3a8d5c98cb8565c07e42be0b04",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/index": "1a9ee1d50ac19cc6a177c6b510754e11",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "c5fa537a81372bff26312b9571c44b3f",
".git/logs/refs/heads/master": "c5fa537a81372bff26312b9571c44b3f",
".git/logs/refs/remotes/origin/master": "1175bfd64bf428d70340dd0852366f4e",
".git/objects/03/2fe904174b32b7135766696dd37e9a95c1b4fd": "80ba3eb567ab1b2327a13096a62dd17e",
".git/objects/06/2c7a357b095211ef269224b72dd692008da7ba": "3bb16c8bca813b513e940e7122cbf75a",
".git/objects/08/73f6e0b01b98c12a18e11956e587ac9d2264c2": "8325fbeac290674fbf599b09c2221c29",
".git/objects/11/38d3804d4a8176fe4c4487f1f78d2367c60e38": "6c4bf187559115ca9a70dca89db43bae",
".git/objects/12/f6aa0f072e855bfea6e05d613e3b9dfa0a9f5c": "daf79fb9bcdb1a7e714c89da10cda53c",
".git/objects/19/51408ec63ce32b5b1e03d242430d3655f4a4a4": "1a10cc07a2f52125110b9d9bf5274a1c",
".git/objects/1c/19efc1343e969f7b0d4dc51282fff0e8345d2b": "7debc69fcc3f9294d48e07c4c09e675b",
".git/objects/1d/e1b4bba431e811bebac52324844e7b9532160e": "add6a64ac441586f47ca1e1d63dcfc4f",
".git/objects/1f/9f6da882d04eec171c877c2ac81b37bda44cd9": "a8792da1cf5fdfbebfee8af1fe58cc86",
".git/objects/2b/a986f6f136f061ad7c345c47245788068e9218": "591c2ae0f2d54d8c6b9d59906e57581d",
".git/objects/33/31d9290f04df89cea3fb794306a371fcca1cd9": "e54527b2478950463abbc6b22442144e",
".git/objects/35/96d08a5b8c249a9ff1eb36682aee2a23e61bac": "e931dda039902c600d4ba7d954ff090f",
".git/objects/39/122a88eae5fc696a6185b020919a1db548aae4": "c6e5e82546b384af5110373403552ba8",
".git/objects/3a/863633a218d0740b7c16c2dd6bf5ea4bf7adfe": "267ea5391647feb18af3a233824d6158",
".git/objects/40/1184f2840fcfb39ffde5f2f82fe5957c37d6fa": "1ea653b99fd29cd15fcc068857a1dbb2",
".git/objects/46/4ab5882a2234c39b1a4dbad5feba0954478155": "2e52a767dc04391de7b4d0beb32e7fc4",
".git/objects/4a/4edfbeb81b6dca5b78223d0217bc640bcd5b0a": "db9caa46f6baf463e03403ca827e38bb",
".git/objects/4f/02e9875cb698379e68a23ba5d25625e0e2e4bc": "254bc336602c9480c293f5f1c64bb4c7",
".git/objects/4f/ba63b2606b1f1f8da4f7fb4391f2eeaf193d3a": "6f314072133648289c03270e4fad609a",
".git/objects/51/51bcf4890a178a85db82171857a0abb59eacc9": "993ff4c02356748d5ca83aa9c0b7e010",
".git/objects/51/a46648fa32a65f810dd4313640d8fb219a1827": "168e08e09aa26b0a8fe261d88341cc89",
".git/objects/57/7946daf6467a3f0a883583abfb8f1e57c86b54": "846aff8094feabe0db132052fd10f62a",
".git/objects/59/6f26a94acab29940b34a9b744832a12824fa74": "0b002c8070bba03cd66aaeb1a81782ab",
".git/objects/59/e456fdab493a5c6234d094cc45bee6b559a85c": "a478e875b95ce123b654ac4b6125b1c9",
".git/objects/5c/dbacd0b176c36c7d19f294aad40f3fb1cffc89": "c363300cbaa9bc9d31fa59dfb34338c7",
".git/objects/5f/bf1f5ee49ba64ffa8e24e19c0231e22add1631": "f19d414bb2afb15ab9eb762fd11311d6",
".git/objects/61/0865eab00daa17b3db8aff7a30cd670a3440ff": "43e39fef9b3734112963526cc2d062dc",
".git/objects/64/5116c20530a7bd227658a3c51e004a3f0aefab": "f10b5403684ce7848d8165b3d1d5bbbe",
".git/objects/6b/52a45868c4578dccbe07c139cbbf3445a0f9da": "2e08a953ec387b905ee3a147b0777664",
".git/objects/6d/215a4efa04fd3502ffc3936c1159ed8401ba07": "704fb1baf954c1ad3af9ebe2c0f86768",
".git/objects/76/2bd2a225b011c94dbff7b0eb51feef09e683cb": "8a65bc5ef08474d5ab2b88d5dcedb23e",
".git/objects/77/439fd33a018825947d56c3d3c9a2b2adce8230": "f137173eb1c4dcb99d8592212cb1a582",
".git/objects/78/0c968f2ccb67e4c46a3780bd069bd9282bbac7": "e25384e9f45d939fe0e0aaa7beb5fb75",
".git/objects/7b/62267f8a2aa8c0a99b03311d6e19eef8dc28f3": "521b670eca2655307ae846fd3fd2b299",
".git/objects/7d/88c86e66fe32216617ba8c2ddf58fa71cb9c00": "139cf5b06c487e74d9a6956399856a3f",
".git/objects/82/74d642c45378edc6e3f852ccd1e0b395e1e796": "42b0ba5d795b4c9f0cdb29acc517514d",
".git/objects/87/f7e8b7d2ab9c14b954f416ac3371c2093368ea": "48637dd95656679da798db0d03450522",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/8a/51a9b155d31c44b148d7e287fc2872e0cafd42": "9f785032380d7569e69b3d17172f64e8",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/91/4a40ccb508c126fa995820d01ea15c69bb95f7": "8963a99a625c47f6cd41ba314ebd2488",
".git/objects/93/be7fd9b9dcdd8564dafd7040a0c8c8f68d4080": "b27ff257c793a735fc818ff37f392ff9",
".git/objects/9f/cdd29d60e5c7df9bff9d59d574efc49dd6fce4": "dc82b108329e1dace0b2f0155a1622d8",
".git/objects/a3/1730c39f4c6d047ae94ee10db2f994040599ca": "18b0110ae5e0fd963caa725dc81e60d9",
".git/objects/a4/94e1b69830dd97299d53d382aef8661749a5c6": "a262cd737cb279d5bb90034976fd90e0",
".git/objects/a5/de584f4d25ef8aace1c5a0c190c3b31639895b": "9fbbb0db1824af504c56e5d959e1cdff",
".git/objects/a8/8c9340e408fca6e68e2d6cd8363dccc2bd8642": "11e9d76ebfeb0c92c8dff256819c0796",
".git/objects/a9/62a2fb6297c7e0817bb36f5817f27e1c6b0bfc": "e2f1fe9a6cedc16e3e16f68162ab143f",
".git/objects/aa/a48f30f1896cf044e1fa3d3263f4f7e82ff8f9": "54f301d0c73b0eedab3b78ff0e8e5be4",
".git/objects/b3/b5459fcc393e5cff3c80db6f27e5a18c8f1bde": "1934075bb8df57f7bb2253079ab7263f",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/bd/dbc766f0b743cd9a73666484717d6e0cf7be07": "f0afa9d60248717ed6638169e221c738",
".git/objects/c6/58cd5a88f08898cee884149005dbad9be3616b": "c09790921e375fcc5e44344339a90c1a",
".git/objects/c7/9dabdd325ddefa6145d4628044e5db6ce563c8": "4ed422288722e6e424cb263107aac632",
".git/objects/d2/0d972544ce9c18c1febff5f5f41524cb327da9": "961ff2a68da8a73bab0759c817a4a263",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/d9/3952e90f26e65356f31c60fc394efb26313167": "1401847c6f090e48e83740a00be1c303",
".git/objects/e8/59cf0203ea70b41774ce27466f03094338ea66": "6e1de63ecdbf152536719de03b10eb04",
".git/objects/e8/8916e2ba54f7373e9043510a06d332cc03cc60": "77c220c779866d6686a7e6251fb6ebc3",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/ef/b875788e4094f6091d9caa43e35c77640aaf21": "27e32738aea45acd66b98d36fc9fc9e0",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/f3/709a83aedf1f03d6e04459831b12355a9b9ef1": "538d2edfa707ca92ed0b867d6c3903d1",
".git/objects/f4/ede7f7fbdddfdef9047b2b9c742c0e0482455b": "0164477a8c7fc218644dcb7a09bf85dd",
".git/objects/f5/fd975bf580b4ef7a57298817f7e7cf3b6520f8": "6a59e1cc8efef9d00b5273f2f1465982",
".git/objects/fd/fecc62345481a1ef309ebf33ba3f5f5b2a4708": "98a80bb26a46f42f001dfa0aa4d82e0d",
".git/refs/heads/master": "0673e3d0724f686d306ad906e4058855",
".git/refs/remotes/origin/master": "0673e3d0724f686d306ad906e4058855",
".vscode/launch.json": "8536c0b1b0a5a6da1637feed7ca91d43",
".vscode/settings.json": "6c78da2528d04022019d2162dd38ecd1",
"assets/AssetManifest.bin": "9a9aae09b3e68c31d5abbc3f27a83ccd",
"assets/AssetManifest.bin.json": "57fe62c99be46e6b2a04fd0b1c3200ee",
"assets/AssetManifest.json": "f640b8550691fda700a9f02213e5809c",
"assets/assets/icons/icon-caution@3x.png": "8f984d63371c3c065a6600c8a3ce4610",
"assets/assets/icons/icon-close@3x.png": "acd36d73c212b0340765271095d4ab7a",
"assets/assets/icons/icon-correct@2x-green.png": "70325b6ace4a1fb08f6cdae73f72bb74",
"assets/assets/icons/icon-down_4@3x.png": "f7bd2048bda76031dc2c9f1c1851e39c",
"assets/assets/icons/icon-error@3x.png": "e5b60c16a6694859a9a342e66dc09609",
"assets/assets/icons/icon-info@3x.png": "f14fc07d89153a98cc979979c02757d8",
"assets/assets/icons/icon-notifications.png": "01e90e91bd50b2eb166784bac884b7e3",
"assets/assets/images/Base.png": "e50cdf464d7b2ac274867336c6c08e58",
"assets/assets/images/Chorm.png": "2eb2f7fdc7c0b91e0942a1ecc9a0b8ce",
"assets/assets/images/Gutter%2520at%2520Liquid%2520plant%2520for%2520Acid.png": "4020a69f2b7f3a57638c86b9804ea79e",
"assets/assets/images/Gutter%2520at%2520Liquid%2520plant%2520for%2520Alkaline.png": "14835c12f160ee58e0b4d0e32111c782",
"assets/assets/images/Gutter%2520at%2520reaction%2520tank%2520No.17.png": "a248eb89edf54684b6c633cca37856d2",
"assets/assets/images/Hood%2520at%2520QC%2520room.jpg": "2fecfa29d70d810874df54300fa3d703",
"assets/assets/images/IBC%2520for%2520Powder.png": "bf7a99900a6334439f291d69e79696da",
"assets/assets/images/IBC%2520for%2520Used%2520Oil.png": "4cd49906b9aae58a7de90224cee5412f",
"assets/assets/images/Liquid.png": "2eb2f7fdc7c0b91e0942a1ecc9a0b8ce",
"assets/assets/images/logoonly_tpkpng.png": "8351a8994e8b4049e562276d00c69682",
"assets/assets/images/logo_tpk.png": "6c5e90f3a6d7793651ae96a21318a911",
"assets/assets/images/Noxrust.png": "2b24b13c9e3b5b366624b9c3b96108dc",
"assets/assets/images/Powder.png": "a36c3f5f808923a18bf32e172b7ded43",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "fc94b44e8fd35cb7f41f0276d5db8a70",
"assets/NOTICES": "b36b1a2832580413226ad66db2c6a290",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5f72d664707e4d711a1c0c240912cd50",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"flutter_bootstrap.js": "1a9842481faf5db3901a86976158c102",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "c29f2499db23efa612e7c723d6e9c0de",
"/": "c29f2499db23efa612e7c723d6e9c0de",
"main.dart.js": "5a6b332c46df1d6b101f7a5f4e6f4792",
"manifest.json": "e875afea49b634ea01ade7c516dc4cf5",
"version.json": "7f86edf6c13624ed15391b7ecd82e7d0"};
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
