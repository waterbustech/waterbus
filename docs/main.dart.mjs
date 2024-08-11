
// `modulePromise` is a promise to the `WebAssembly.module` object to be
//   instantiated.
// `importObjectPromise` is a promise to an object that contains any additional
//   imports needed by the module that aren't provided by the standard runtime.
//   The fields on this object will be merged into the importObject with which
//   the module will be instantiated.
// This function returns a promise to the instantiated module.
export const instantiate = async (modulePromise, importObjectPromise) => {
    let dartInstance;

    // Prints to the console
    function printToConsole(value) {
      if (typeof dartPrint == "function") {
        dartPrint(value);
        return;
      }
      if (typeof console == "object" && typeof console.log != "undefined") {
        console.log(value);
        return;
      }
      if (typeof print == "function") {
        print(value);
        return;
      }

      throw "Unable to print message: " + js;
    }

    // Converts a Dart List to a JS array. Any Dart objects will be converted, but
    // this will be cheap for JSValues.
    function arrayFromDartList(constructor, list) {
      const exports = dartInstance.exports;
      const read = exports.$listRead;
      const length = exports.$listLength(list);
      const array = new constructor(length);
      for (let i = 0; i < length; i++) {
        array[i] = read(list, i);
      }
      return array;
    }

    // A special symbol attached to functions that wrap Dart functions.
    const jsWrappedDartFunctionSymbol = Symbol("JSWrappedDartFunction");

    function finalizeWrapper(dartFunction, wrapped) {
      wrapped.dartFunction = dartFunction;
      wrapped[jsWrappedDartFunctionSymbol] = true;
      return wrapped;
    }

    // Imports
    const dart2wasm = {

_1: (x0,x1,x2) => x0.set(x1,x2),
_2: (x0,x1,x2) => x0.set(x1,x2),
_6: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._6(f,arguments.length,x0) }),
_7: x0 => new window.FinalizationRegistry(x0),
_8: (x0,x1,x2,x3) => x0.register(x1,x2,x3),
_9: (x0,x1) => x0.unregister(x1),
_10: (x0,x1,x2) => x0.slice(x1,x2),
_11: (x0,x1) => x0.decode(x1),
_12: (x0,x1) => x0.segment(x1),
_13: () => new TextDecoder(),
_14: x0 => x0.buffer,
_15: x0 => x0.wasmMemory,
_16: () => globalThis.window._flutter_skwasmInstance,
_17: x0 => x0.rasterStartMilliseconds,
_18: x0 => x0.rasterEndMilliseconds,
_19: x0 => x0.imageBitmaps,
_167: x0 => x0.select(),
_168: (x0,x1) => x0.append(x1),
_169: x0 => x0.remove(),
_172: x0 => x0.unlock(),
_177: x0 => x0.getReader(),
_187: x0 => new MutationObserver(x0),
_206: (x0,x1,x2) => x0.addEventListener(x1,x2),
_207: (x0,x1,x2) => x0.removeEventListener(x1,x2),
_210: x0 => new ResizeObserver(x0),
_213: (x0,x1) => new Intl.Segmenter(x0,x1),
_214: x0 => x0.next(),
_215: (x0,x1) => new Intl.v8BreakIterator(x0,x1),
_292: x0 => x0.close(),
_293: (x0,x1,x2,x3,x4) => ({type: x0,data: x1,premultiplyAlpha: x2,colorSpaceConversion: x3,preferAnimation: x4}),
_294: x0 => new window.ImageDecoder(x0),
_295: x0 => x0.close(),
_296: x0 => ({frameIndex: x0}),
_297: (x0,x1) => x0.decode(x1),
_300: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._300(f,arguments.length,x0) }),
_301: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._301(f,arguments.length,x0) }),
_302: (x0,x1) => ({addView: x0,removeView: x1}),
_303: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._303(f,arguments.length,x0) }),
_304: f => finalizeWrapper(f, function() { return dartInstance.exports._304(f,arguments.length) }),
_305: (x0,x1) => ({initializeEngine: x0,autoStart: x1}),
_306: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._306(f,arguments.length,x0) }),
_307: x0 => ({runApp: x0}),
_308: x0 => new Uint8Array(x0),
_310: x0 => x0.preventDefault(),
_311: x0 => x0.stopPropagation(),
_312: (x0,x1) => x0.addListener(x1),
_313: (x0,x1) => x0.removeListener(x1),
_314: (x0,x1) => x0.prepend(x1),
_315: x0 => x0.remove(),
_316: x0 => x0.disconnect(),
_317: (x0,x1) => x0.addListener(x1),
_318: (x0,x1) => x0.removeListener(x1),
_320: (x0,x1) => x0.append(x1),
_321: x0 => x0.remove(),
_322: x0 => x0.stopPropagation(),
_326: x0 => x0.preventDefault(),
_327: (x0,x1) => x0.append(x1),
_328: x0 => x0.remove(),
_329: x0 => x0.preventDefault(),
_330: x0 => x0.preventDefault(),
_335: (x0,x1) => x0.appendChild(x1),
_336: (x0,x1,x2) => x0.insertBefore(x1,x2),
_337: (x0,x1) => x0.removeChild(x1),
_338: (x0,x1) => x0.appendChild(x1),
_339: (x0,x1) => x0.transferFromImageBitmap(x1),
_340: (x0,x1) => x0.append(x1),
_341: (x0,x1) => x0.append(x1),
_342: (x0,x1) => x0.append(x1),
_343: x0 => x0.remove(),
_344: x0 => x0.remove(),
_345: x0 => x0.remove(),
_346: (x0,x1) => x0.appendChild(x1),
_347: (x0,x1) => x0.appendChild(x1),
_348: x0 => x0.remove(),
_349: (x0,x1) => x0.append(x1),
_350: (x0,x1) => x0.append(x1),
_351: x0 => x0.remove(),
_352: (x0,x1) => x0.append(x1),
_353: (x0,x1) => x0.append(x1),
_354: (x0,x1,x2) => x0.insertBefore(x1,x2),
_355: (x0,x1) => x0.append(x1),
_356: (x0,x1,x2) => x0.insertBefore(x1,x2),
_357: x0 => x0.remove(),
_358: x0 => x0.remove(),
_359: (x0,x1) => x0.append(x1),
_360: x0 => x0.remove(),
_361: (x0,x1) => x0.append(x1),
_362: x0 => x0.remove(),
_363: x0 => x0.remove(),
_364: x0 => x0.getBoundingClientRect(),
_365: x0 => x0.remove(),
_366: x0 => x0.blur(),
_367: x0 => x0.remove(),
_368: x0 => x0.blur(),
_369: x0 => x0.remove(),
_382: (x0,x1) => x0.append(x1),
_383: x0 => x0.remove(),
_384: (x0,x1) => x0.append(x1),
_385: (x0,x1,x2) => x0.insertBefore(x1,x2),
_386: x0 => x0.preventDefault(),
_387: x0 => x0.preventDefault(),
_388: x0 => x0.preventDefault(),
_389: x0 => x0.preventDefault(),
_390: x0 => x0.remove(),
_391: (x0,x1) => x0.observe(x1),
_392: x0 => x0.disconnect(),
_393: (x0,x1) => x0.appendChild(x1),
_394: (x0,x1) => x0.appendChild(x1),
_395: (x0,x1) => x0.appendChild(x1),
_396: (x0,x1) => x0.append(x1),
_397: x0 => x0.remove(),
_398: (x0,x1) => x0.append(x1),
_400: (x0,x1) => x0.appendChild(x1),
_401: (x0,x1) => x0.append(x1),
_402: x0 => x0.remove(),
_403: (x0,x1) => x0.append(x1),
_407: (x0,x1) => x0.appendChild(x1),
_408: x0 => x0.remove(),
_968: () => globalThis.window.flutterConfiguration,
_969: x0 => x0.assetBase,
_974: x0 => x0.debugShowSemanticsNodes,
_975: x0 => x0.hostElement,
_976: x0 => x0.multiViewEnabled,
_977: x0 => x0.nonce,
_979: x0 => x0.fontFallbackBaseUrl,
_980: x0 => x0.useColorEmoji,
_984: x0 => x0.console,
_985: x0 => x0.devicePixelRatio,
_986: x0 => x0.document,
_987: x0 => x0.history,
_988: x0 => x0.innerHeight,
_989: x0 => x0.innerWidth,
_990: x0 => x0.location,
_991: x0 => x0.navigator,
_992: x0 => x0.visualViewport,
_993: x0 => x0.performance,
_995: (x0,x1) => x0.fetch(x1),
_998: (x0,x1) => x0.dispatchEvent(x1),
_999: (x0,x1) => x0.matchMedia(x1),
_1000: (x0,x1) => x0.getComputedStyle(x1),
_1002: x0 => x0.screen,
_1003: (x0,x1) => x0.requestAnimationFrame(x1),
_1004: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1004(f,arguments.length,x0) }),
_1009: (x0,x1) => x0.warn(x1),
_1013: () => globalThis.window,
_1014: () => globalThis.Intl,
_1015: () => globalThis.Symbol,
_1018: x0 => x0.clipboard,
_1019: x0 => x0.maxTouchPoints,
_1020: x0 => x0.vendor,
_1021: x0 => x0.language,
_1022: x0 => x0.platform,
_1023: x0 => x0.userAgent,
_1024: x0 => x0.languages,
_1025: x0 => x0.documentElement,
_1026: (x0,x1) => x0.querySelector(x1),
_1028: (x0,x1) => x0.createElement(x1),
_1030: (x0,x1) => x0.execCommand(x1),
_1034: (x0,x1) => x0.createTextNode(x1),
_1035: (x0,x1) => x0.createEvent(x1),
_1039: x0 => x0.head,
_1040: x0 => x0.body,
_1041: (x0,x1) => x0.title = x1,
_1044: x0 => x0.activeElement,
_1046: x0 => x0.visibilityState,
_1047: () => globalThis.document,
_1048: (x0,x1,x2) => x0.addEventListener(x1,x2),
_1049: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
_1050: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
_1052: (x0,x1,x2) => x0.removeEventListener(x1,x2),
_1055: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1055(f,arguments.length,x0) }),
_1056: x0 => x0.target,
_1058: x0 => x0.timeStamp,
_1059: x0 => x0.type,
_1060: x0 => x0._cancelable,
_1061: x0 => x0.preventDefault(),
_1065: (x0,x1,x2,x3) => x0.initEvent(x1,x2,x3),
_1069: x0 => x0.baseURI,
_1070: x0 => x0.firstChild,
_1075: x0 => x0.parentElement,
_1077: x0 => x0.parentNode,
_1080: (x0,x1) => x0.removeChild(x1),
_1081: (x0,x1) => x0.removeChild(x1),
_1082: x0 => x0.isConnected,
_1083: (x0,x1) => x0.textContent = x1,
_1087: (x0,x1) => x0.contains(x1),
_1092: x0 => x0.firstElementChild,
_1094: x0 => x0.nextElementSibling,
_1095: x0 => x0.clientHeight,
_1096: x0 => x0.clientWidth,
_1097: x0 => x0.offsetHeight,
_1098: x0 => x0.offsetWidth,
_1099: x0 => x0.id,
_1100: (x0,x1) => x0.id = x1,
_1103: (x0,x1) => x0.spellcheck = x1,
_1104: x0 => x0.tagName,
_1105: x0 => x0.style,
_1106: (x0,x1) => x0.append(x1),
_1107: (x0,x1) => x0.getAttribute(x1),
_1108: x0 => x0.getBoundingClientRect(),
_1111: (x0,x1) => x0.closest(x1),
_1113: (x0,x1) => x0.querySelectorAll(x1),
_1114: x0 => x0.remove(),
_1115: (x0,x1,x2) => x0.setAttribute(x1,x2),
_1117: (x0,x1) => x0.removeAttribute(x1),
_1118: (x0,x1) => x0.tabIndex = x1,
_1121: (x0,x1) => x0.focus(x1),
_1122: x0 => x0.scrollTop,
_1123: (x0,x1) => x0.scrollTop = x1,
_1124: x0 => x0.scrollLeft,
_1125: (x0,x1) => x0.scrollLeft = x1,
_1126: x0 => x0.classList,
_1127: (x0,x1) => x0.className = x1,
_1131: (x0,x1) => x0.getElementsByClassName(x1),
_1132: x0 => x0.click(),
_1134: (x0,x1) => x0.hasAttribute(x1),
_1136: (x0,x1) => x0.attachShadow(x1),
_1140: (x0,x1) => x0.getPropertyValue(x1),
_1142: (x0,x1,x2,x3) => x0.setProperty(x1,x2,x3),
_1144: (x0,x1) => x0.removeProperty(x1),
_1146: x0 => x0.offsetLeft,
_1147: x0 => x0.offsetTop,
_1148: x0 => x0.offsetParent,
_1150: (x0,x1) => x0.name = x1,
_1151: x0 => x0.content,
_1152: (x0,x1) => x0.content = x1,
_1165: (x0,x1) => x0.nonce = x1,
_1170: x0 => x0.now(),
_1172: (x0,x1) => x0.width = x1,
_1174: (x0,x1) => x0.height = x1,
_1178: (x0,x1) => x0.getContext(x1),
_1253: x0 => x0.status,
_1255: x0 => x0.body,
_1256: x0 => x0.arrayBuffer(),
_1261: x0 => x0.read(),
_1262: x0 => x0.value,
_1263: x0 => x0.done,
_1265: x0 => x0.name,
_1266: x0 => x0.x,
_1267: x0 => x0.y,
_1270: x0 => x0.top,
_1271: x0 => x0.right,
_1272: x0 => x0.bottom,
_1273: x0 => x0.left,
_1282: x0 => x0.height,
_1283: x0 => x0.width,
_1284: (x0,x1) => x0.value = x1,
_1286: (x0,x1) => x0.placeholder = x1,
_1287: (x0,x1) => x0.name = x1,
_1288: x0 => x0.selectionDirection,
_1289: x0 => x0.selectionStart,
_1290: x0 => x0.selectionEnd,
_1293: x0 => x0.value,
_1294: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
_1299: x0 => x0.readText(),
_1300: (x0,x1) => x0.writeText(x1),
_1301: x0 => x0.altKey,
_1302: x0 => x0.code,
_1303: x0 => x0.ctrlKey,
_1304: x0 => x0.key,
_1305: x0 => x0.keyCode,
_1306: x0 => x0.location,
_1307: x0 => x0.metaKey,
_1308: x0 => x0.repeat,
_1309: x0 => x0.shiftKey,
_1310: x0 => x0.isComposing,
_1311: (x0,x1) => x0.getModifierState(x1),
_1312: x0 => x0.state,
_1314: (x0,x1) => x0.go(x1),
_1315: (x0,x1,x2,x3) => x0.pushState(x1,x2,x3),
_1316: (x0,x1,x2,x3) => x0.replaceState(x1,x2,x3),
_1317: x0 => x0.pathname,
_1318: x0 => x0.search,
_1319: x0 => x0.hash,
_1322: x0 => x0.state,
_1327: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1327(f,arguments.length,x0,x1) }),
_1329: (x0,x1,x2) => x0.observe(x1,x2),
_1332: x0 => x0.attributeName,
_1333: x0 => x0.type,
_1334: x0 => x0.matches,
_1338: x0 => x0.matches,
_1339: x0 => x0.relatedTarget,
_1340: x0 => x0.clientX,
_1341: x0 => x0.clientY,
_1342: x0 => x0.offsetX,
_1343: x0 => x0.offsetY,
_1346: x0 => x0.button,
_1347: x0 => x0.buttons,
_1348: x0 => x0.ctrlKey,
_1349: (x0,x1) => x0.getModifierState(x1),
_1350: x0 => x0.pointerId,
_1351: x0 => x0.pointerType,
_1352: x0 => x0.pressure,
_1353: x0 => x0.tiltX,
_1354: x0 => x0.tiltY,
_1355: x0 => x0.getCoalescedEvents(),
_1356: x0 => x0.deltaX,
_1357: x0 => x0.deltaY,
_1358: x0 => x0.wheelDeltaX,
_1359: x0 => x0.wheelDeltaY,
_1360: x0 => x0.deltaMode,
_1365: x0 => x0.changedTouches,
_1367: x0 => x0.clientX,
_1368: x0 => x0.clientY,
_1369: x0 => x0.data,
_1370: (x0,x1) => x0.type = x1,
_1371: (x0,x1) => x0.max = x1,
_1372: (x0,x1) => x0.min = x1,
_1373: (x0,x1) => x0.value = x1,
_1374: x0 => x0.value,
_1375: x0 => x0.disabled,
_1376: (x0,x1) => x0.disabled = x1,
_1377: (x0,x1) => x0.placeholder = x1,
_1378: (x0,x1) => x0.name = x1,
_1379: (x0,x1) => x0.autocomplete = x1,
_1380: x0 => x0.selectionDirection,
_1381: x0 => x0.selectionStart,
_1382: x0 => x0.selectionEnd,
_1386: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
_1393: (x0,x1) => x0.add(x1),
_1396: (x0,x1) => x0.noValidate = x1,
_1397: (x0,x1) => x0.method = x1,
_1398: (x0,x1) => x0.action = x1,
_1426: x0 => x0.orientation,
_1427: x0 => x0.width,
_1428: x0 => x0.height,
_1429: (x0,x1) => x0.lock(x1),
_1446: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1446(f,arguments.length,x0,x1) }),
_1456: x0 => x0.length,
_1457: (x0,x1) => x0.item(x1),
_1458: x0 => x0.length,
_1459: (x0,x1) => x0.item(x1),
_1460: x0 => x0.iterator,
_1461: x0 => x0.Segmenter,
_1462: x0 => x0.v8BreakIterator,
_1465: x0 => x0.done,
_1466: x0 => x0.value,
_1467: x0 => x0.index,
_1471: (x0,x1) => x0.adoptText(x1),
_1473: x0 => x0.first(),
_1474: x0 => x0.next(),
_1475: x0 => x0.current(),
_1487: x0 => x0.hostElement,
_1488: x0 => x0.viewConstraints,
_1490: x0 => x0.maxHeight,
_1491: x0 => x0.maxWidth,
_1492: x0 => x0.minHeight,
_1493: x0 => x0.minWidth,
_1494: x0 => x0.loader,
_1495: () => globalThis._flutter,
_1496: (x0,x1) => x0.didCreateEngineInitializer(x1),
_1497: (x0,x1,x2) => x0.call(x1,x2),
_1498: () => globalThis.Promise,
_1499: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1499(f,arguments.length,x0,x1) }),
_1504: x0 => x0.length,
_1507: x0 => x0.tracks,
_1511: x0 => x0.image,
_1516: x0 => x0.codedWidth,
_1517: x0 => x0.codedHeight,
_1520: x0 => x0.duration,
_1524: x0 => x0.ready,
_1525: x0 => x0.selectedTrack,
_1526: x0 => x0.repetitionCount,
_1527: x0 => x0.frameCount,
_1573: (x0,x1,x2,x3,x4,x5,x6,x7) => ({apiKey: x0,authDomain: x1,databaseURL: x2,projectId: x3,storageBucket: x4,messagingSenderId: x5,measurementId: x6,appId: x7}),
_1574: (x0,x1) => globalThis.firebase_core.initializeApp(x0,x1),
_1575: x0 => globalThis.firebase_core.getApp(x0),
_1576: () => globalThis.firebase_core.getApp(),
_1598: x0 => x0.toJSON(),
_1599: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1599(f,arguments.length,x0) }),
_1600: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1600(f,arguments.length,x0) }),
_1601: (x0,x1,x2) => x0.onAuthStateChanged(x1,x2),
_1602: x0 => x0.call(),
_1603: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1603(f,arguments.length,x0) }),
_1604: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1604(f,arguments.length,x0) }),
_1605: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1605(f,arguments.length,x0) }),
_1606: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1606(f,arguments.length,x0) }),
_1607: (x0,x1,x2) => x0.onIdTokenChanged(x1,x2),
_1616: (x0,x1) => globalThis.firebase_auth.setPersistence(x0,x1),
_1618: (x0,x1) => globalThis.firebase_auth.signInWithCredential(x0,x1),
_1627: (x0,x1) => globalThis.firebase_auth.connectAuthEmulator(x0,x1),
_1644: (x0,x1) => globalThis.firebase_auth.GoogleAuthProvider.credential(x0,x1),
_1645: x0 => new firebase_auth.OAuthProvider(x0),
_1648: (x0,x1) => x0.credential(x1),
_1649: x0 => globalThis.firebase_auth.OAuthProvider.credentialFromResult(x0),
_1664: x0 => globalThis.firebase_auth.getAdditionalUserInfo(x0),
_1665: (x0,x1,x2) => ({errorMap: x0,persistence: x1,popupRedirectResolver: x2}),
_1666: (x0,x1) => globalThis.firebase_auth.initializeAuth(x0,x1),
_1667: (x0,x1,x2) => ({accessToken: x0,idToken: x1,rawNonce: x2}),
_1682: x0 => globalThis.firebase_auth.OAuthProvider.credentialFromError(x0),
_1704: () => globalThis.firebase_auth.debugErrorMap,
_1706: () => globalThis.firebase_auth.inMemoryPersistence,
_1708: () => globalThis.firebase_auth.browserSessionPersistence,
_1710: () => globalThis.firebase_auth.browserLocalPersistence,
_1712: () => globalThis.firebase_auth.indexedDBLocalPersistence,
_1747: x0 => globalThis.firebase_auth.multiFactor(x0),
_1748: (x0,x1) => globalThis.firebase_auth.getMultiFactorResolver(x0,x1),
_1765: x0 => x0.displayName,
_1766: x0 => x0.email,
_1767: x0 => x0.phoneNumber,
_1768: x0 => x0.photoURL,
_1769: x0 => x0.providerId,
_1770: x0 => x0.uid,
_1771: x0 => x0.emailVerified,
_1772: x0 => x0.isAnonymous,
_1773: x0 => x0.providerData,
_1774: x0 => x0.refreshToken,
_1775: x0 => x0.tenantId,
_1776: x0 => x0.metadata,
_1781: x0 => x0.providerId,
_1782: x0 => x0.signInMethod,
_1783: x0 => x0.accessToken,
_1784: x0 => x0.idToken,
_1785: x0 => x0.secret,
_1812: x0 => x0.creationTime,
_1813: x0 => x0.lastSignInTime,
_1818: x0 => x0.code,
_1820: x0 => x0.message,
_1832: x0 => x0.email,
_1833: x0 => x0.phoneNumber,
_1834: x0 => x0.tenantId,
_1855: x0 => x0.user,
_1858: x0 => x0.providerId,
_1859: x0 => x0.profile,
_1860: x0 => x0.username,
_1861: x0 => x0.isNewUser,
_1864: () => globalThis.firebase_auth.browserPopupRedirectResolver,
_1870: x0 => x0.displayName,
_1871: x0 => x0.enrollmentTime,
_1872: x0 => x0.factorId,
_1873: x0 => x0.uid,
_1875: x0 => x0.hints,
_1876: x0 => x0.session,
_1878: x0 => x0.phoneNumber,
_1890: (x0,x1) => x0.getItem(x1),
_1897: (x0,x1) => x0.createElement(x1),
_1933: () => globalThis.firebase_core.SDK_VERSION,
_1940: x0 => x0.apiKey,
_1942: x0 => x0.authDomain,
_1944: x0 => x0.databaseURL,
_1946: x0 => x0.projectId,
_1948: x0 => x0.storageBucket,
_1950: x0 => x0.messagingSenderId,
_1952: x0 => x0.measurementId,
_1954: x0 => x0.appId,
_1956: x0 => x0.name,
_1957: x0 => x0.options,
_1958: (x0,x1) => x0.debug(x1),
_1959: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1959(f,arguments.length,x0) }),
_1960: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1960(f,arguments.length,x0,x1) }),
_1961: (x0,x1) => ({createScript: x0,createScriptURL: x1}),
_1962: (x0,x1,x2) => x0.createPolicy(x1,x2),
_1963: (x0,x1) => x0.createScriptURL(x1),
_1964: (x0,x1,x2) => x0.createScript(x1,x2),
_1965: (x0,x1) => x0.appendChild(x1),
_1966: (x0,x1) => x0.appendChild(x1),
_1967: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1967(f,arguments.length,x0) }),
_1996: (x0,x1) => globalThis.enableVirtualBackground(x0,x1),
_1998: x0 => new MediaStream(x0),
_2010: (x0,x1) => x0.querySelector(x1),
_2011: (x0,x1) => x0.append(x1),
_2016: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
_2017: (x0,x1,x2) => x0.addEventListener(x1,x2),
_2025: (x0,x1,x2,x3) => x0.removeEventListener(x1,x2,x3),
_2057: (x0,x1) => x0.querySelector(x1),
_2058: (x0,x1) => x0.getAttribute(x1),
_2059: (x0,x1,x2) => x0.setAttribute(x1,x2),
_2061: (x0,x1) => x0.initialize(x1),
_2062: (x0,x1) => x0.initTokenClient(x1),
_2063: (x0,x1) => x0.initCodeClient(x1),
_2067: x0 => globalThis.Wakelock.toggle(x0),
_2069: (x0,x1) => x0.querySelector(x1),
_2070: (x0,x1) => x0.querySelector(x1),
_2105: () => globalThis.removeSplashFromWeb(),
_2120: x0 => new Array(x0),
_2123: (o, c) => o instanceof c,
_2127: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2127(f,arguments.length,x0) }),
_2128: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2128(f,arguments.length,x0) }),
_2132: (o, a) => o + a,
_2153: (decoder, codeUnits) => decoder.decode(codeUnits),
_2154: () => new TextDecoder("utf-8", {fatal: true}),
_2155: () => new TextDecoder("utf-8", {fatal: false}),
_2156: v => v.toString(),
_2157: (d, digits) => d.toFixed(digits),
_2161: x0 => new WeakRef(x0),
_2162: x0 => x0.deref(),
_2168: Date.now,
_2170: s => new Date(s * 1000).getTimezoneOffset() * 60 ,
_2171: s => {
      if (!/^\s*[+-]?(?:Infinity|NaN|(?:\.\d+|\d+(?:\.\d*)?)(?:[eE][+-]?\d+)?)\s*$/.test(s)) {
        return NaN;
      }
      return parseFloat(s);
    },
_2172: () => {
          let stackString = new Error().stack.toString();
          let frames = stackString.split('\n');
          let drop = 2;
          if (frames[0] === 'Error') {
              drop += 1;
          }
          return frames.slice(drop).join('\n');
        },
_2173: () => typeof dartUseDateNowForTicks !== "undefined",
_2174: () => 1000 * performance.now(),
_2175: () => Date.now(),
_2176: () => {
      // On browsers return `globalThis.location.href`
      if (globalThis.location != null) {
        return globalThis.location.href;
      }
      return null;
    },
_2177: () => {
        return typeof process != "undefined" &&
               Object.prototype.toString.call(process) == "[object process]" &&
               process.platform == "win32"
      },
_2178: () => new WeakMap(),
_2179: (map, o) => map.get(o),
_2180: (map, o, v) => map.set(o, v),
_2181: () => globalThis.WeakRef,
_2192: s => JSON.stringify(s),
_2193: s => printToConsole(s),
_2194: a => a.join(''),
_2195: (o, a, b) => o.replace(a, b),
_2197: (s, t) => s.split(t),
_2198: s => s.toLowerCase(),
_2199: s => s.toUpperCase(),
_2200: s => s.trim(),
_2201: s => s.trimLeft(),
_2202: s => s.trimRight(),
_2204: (s, p, i) => s.indexOf(p, i),
_2205: (s, p, i) => s.lastIndexOf(p, i),
_2206: (s) => s.replace(/\$/g, "$$$$"),
_2207: Object.is,
_2208: s => s.toUpperCase(),
_2209: s => s.toLowerCase(),
_2210: (a, i) => a.push(i),
_2214: a => a.pop(),
_2215: (a, i) => a.splice(i, 1),
_2217: (a, s) => a.join(s),
_2220: (a, b) => a == b ? 0 : (a > b ? 1 : -1),
_2221: a => a.length,
_2222: (a, l) => a.length = l,
_2223: (a, i) => a[i],
_2224: (a, i, v) => a[i] = v,
_2227: (o, start, length) => new Uint8Array(o.buffer, o.byteOffset + start, length),
_2228: (o, start, length) => new Int8Array(o.buffer, o.byteOffset + start, length),
_2229: (o, start, length) => new Uint8ClampedArray(o.buffer, o.byteOffset + start, length),
_2230: (o, start, length) => new Uint16Array(o.buffer, o.byteOffset + start, length),
_2231: (o, start, length) => new Int16Array(o.buffer, o.byteOffset + start, length),
_2232: (o, start, length) => new Uint32Array(o.buffer, o.byteOffset + start, length),
_2233: (o, start, length) => new Int32Array(o.buffer, o.byteOffset + start, length),
_2236: (o, start, length) => new Float32Array(o.buffer, o.byteOffset + start, length),
_2237: (o, start, length) => new Float64Array(o.buffer, o.byteOffset + start, length),
_2240: (o) => new DataView(o.buffer, o.byteOffset, o.byteLength),
_2242: o => o.buffer,
_2243: o => o.byteOffset,
_2244: Function.prototype.call.bind(Object.getOwnPropertyDescriptor(DataView.prototype, 'byteLength').get),
_2245: (b, o) => new DataView(b, o),
_2246: (b, o, l) => new DataView(b, o, l),
_2247: Function.prototype.call.bind(DataView.prototype.getUint8),
_2248: Function.prototype.call.bind(DataView.prototype.setUint8),
_2249: Function.prototype.call.bind(DataView.prototype.getInt8),
_2250: Function.prototype.call.bind(DataView.prototype.setInt8),
_2251: Function.prototype.call.bind(DataView.prototype.getUint16),
_2252: Function.prototype.call.bind(DataView.prototype.setUint16),
_2253: Function.prototype.call.bind(DataView.prototype.getInt16),
_2254: Function.prototype.call.bind(DataView.prototype.setInt16),
_2255: Function.prototype.call.bind(DataView.prototype.getUint32),
_2256: Function.prototype.call.bind(DataView.prototype.setUint32),
_2257: Function.prototype.call.bind(DataView.prototype.getInt32),
_2258: Function.prototype.call.bind(DataView.prototype.setInt32),
_2261: Function.prototype.call.bind(DataView.prototype.getBigInt64),
_2262: Function.prototype.call.bind(DataView.prototype.setBigInt64),
_2263: Function.prototype.call.bind(DataView.prototype.getFloat32),
_2264: Function.prototype.call.bind(DataView.prototype.setFloat32),
_2265: Function.prototype.call.bind(DataView.prototype.getFloat64),
_2266: Function.prototype.call.bind(DataView.prototype.setFloat64),
_2267: (x0,x1) => x0.getRandomValues(x1),
_2268: x0 => new Uint8Array(x0),
_2269: () => globalThis.crypto,
_2281: (o, t) => o instanceof t,
_2283: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2283(f,arguments.length,x0) }),
_2284: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2284(f,arguments.length,x0) }),
_2285: o => Object.keys(o),
_2286: (ms, c) =>
              setTimeout(() => dartInstance.exports.$invokeCallback(c),ms),
_2287: (handle) => clearTimeout(handle),
_2288: (ms, c) =>
          setInterval(() => dartInstance.exports.$invokeCallback(c), ms),
_2289: (handle) => clearInterval(handle),
_2290: (c) =>
              queueMicrotask(() => dartInstance.exports.$invokeCallback(c)),
_2291: () => Date.now(),
_2384: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2384(f,arguments.length,x0) }),
_2385: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2385(f,arguments.length,x0) }),
_2386: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2386(f,arguments.length,x0) }),
_2402: x0 => x0.getAudioTracks(),
_2403: x0 => x0.getVideoTracks(),
_2435: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2435(f,arguments.length,x0) }),
_2436: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2436(f,arguments.length,x0) }),
_2492: x0 => x0.trustedTypes,
_2493: (x0,x1) => x0.src = x1,
_2494: (x0,x1) => x0.createScriptURL(x1),
_2495: (x0,x1) => x0.debug(x1),
_2496: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2496(f,arguments.length,x0) }),
_2497: x0 => ({createScriptURL: x0}),
_2498: (x0,x1) => x0.appendChild(x1),
_2511: (x0,x1) => x0.appendChild(x1),
_2512: (x0,x1) => x0.item(x1),
_2515: x0 => x0.trustedTypes,
_2517: (x0,x1) => x0.text = x1,
_2519: (s, m) => {
          try {
            return new RegExp(s, m);
          } catch (e) {
            return String(e);
          }
        },
_2520: (x0,x1) => x0.exec(x1),
_2521: (x0,x1) => x0.test(x1),
_2522: (x0,x1) => x0.exec(x1),
_2523: (x0,x1) => x0.exec(x1),
_2524: x0 => x0.pop(),
_2528: (x0,x1,x2) => x0[x1] = x2,
_2530: o => o === undefined,
_2531: o => typeof o === 'boolean',
_2532: o => typeof o === 'number',
_2534: o => typeof o === 'string',
_2537: o => o instanceof Int8Array,
_2538: o => o instanceof Uint8Array,
_2539: o => o instanceof Uint8ClampedArray,
_2540: o => o instanceof Int16Array,
_2541: o => o instanceof Uint16Array,
_2542: o => o instanceof Int32Array,
_2543: o => o instanceof Uint32Array,
_2544: o => o instanceof Float32Array,
_2545: o => o instanceof Float64Array,
_2546: o => o instanceof ArrayBuffer,
_2547: o => o instanceof DataView,
_2548: o => o instanceof Array,
_2549: o => typeof o === 'function' && o[jsWrappedDartFunctionSymbol] === true,
_2551: o => {
            const proto = Object.getPrototypeOf(o);
            return proto === Object.prototype || proto === null;
          },
_2552: o => o instanceof RegExp,
_2553: (l, r) => l === r,
_2554: o => o,
_2555: o => o,
_2556: o => o,
_2557: b => !!b,
_2558: o => o.length,
_2561: (o, i) => o[i],
_2562: f => f.dartFunction,
_2563: l => arrayFromDartList(Int8Array, l),
_2564: (data, length) => {
          const jsBytes = new Uint8Array(length);
          const getByte = dartInstance.exports.$uint8ListGet;
          for (let i = 0; i < length; i++) {
            jsBytes[i] = getByte(data, i);
          }
          return jsBytes;
        },
_2565: l => arrayFromDartList(Uint8ClampedArray, l),
_2566: l => arrayFromDartList(Int16Array, l),
_2567: l => arrayFromDartList(Uint16Array, l),
_2568: l => arrayFromDartList(Int32Array, l),
_2569: l => arrayFromDartList(Uint32Array, l),
_2570: l => arrayFromDartList(Float32Array, l),
_2571: l => arrayFromDartList(Float64Array, l),
_2572: (data, length) => {
          const read = dartInstance.exports.$byteDataGetUint8;
          const view = new DataView(new ArrayBuffer(length));
          for (let i = 0; i < length; i++) {
              view.setUint8(i, read(data, i));
          }
          return view;
        },
_2573: l => arrayFromDartList(Array, l),
_2574:       (s, length) => {
        if (length == 0) return '';

        const read = dartInstance.exports.$stringRead1;
        let result = '';
        let index = 0;
        const chunkLength = Math.min(length - index, 500);
        let array = new Array(chunkLength);
        while (index < length) {
          const newChunkLength = Math.min(length - index, 500);
          for (let i = 0; i < newChunkLength; i++) {
            array[i] = read(s, index++);
          }
          if (newChunkLength < chunkLength) {
            array = array.slice(0, newChunkLength);
          }
          result += String.fromCharCode(...array);
        }
        return result;
      }
      ,
_2575:     (s, length) => {
      if (length == 0) return '';

      const read = dartInstance.exports.$stringRead2;
      let result = '';
      let index = 0;
      const chunkLength = Math.min(length - index, 500);
      let array = new Array(chunkLength);
      while (index < length) {
        const newChunkLength = Math.min(length - index, 500);
        for (let i = 0; i < newChunkLength; i++) {
          array[i] = read(s, index++);
        }
        if (newChunkLength < chunkLength) {
          array = array.slice(0, newChunkLength);
        }
        result += String.fromCharCode(...array);
      }
      return result;
    }
    ,
_2576:     (s) => {
      let length = s.length;
      let range = 0;
      for (let i = 0; i < length; i++) {
        range |= s.codePointAt(i);
      }
      const exports = dartInstance.exports;
      if (range < 256) {
        if (length <= 10) {
          if (length == 1) {
            return exports.$stringAllocate1_1(s.codePointAt(0));
          }
          if (length == 2) {
            return exports.$stringAllocate1_2(s.codePointAt(0), s.codePointAt(1));
          }
          if (length == 3) {
            return exports.$stringAllocate1_3(s.codePointAt(0), s.codePointAt(1), s.codePointAt(2));
          }
          if (length == 4) {
            return exports.$stringAllocate1_4(s.codePointAt(0), s.codePointAt(1), s.codePointAt(2), s.codePointAt(3));
          }
          if (length == 5) {
            return exports.$stringAllocate1_5(s.codePointAt(0), s.codePointAt(1), s.codePointAt(2), s.codePointAt(3), s.codePointAt(4));
          }
          if (length == 6) {
            return exports.$stringAllocate1_6(s.codePointAt(0), s.codePointAt(1), s.codePointAt(2), s.codePointAt(3), s.codePointAt(4), s.codePointAt(5));
          }
          if (length == 7) {
            return exports.$stringAllocate1_7(s.codePointAt(0), s.codePointAt(1), s.codePointAt(2), s.codePointAt(3), s.codePointAt(4), s.codePointAt(5), s.codePointAt(6));
          }
          if (length == 8) {
            return exports.$stringAllocate1_8(s.codePointAt(0), s.codePointAt(1), s.codePointAt(2), s.codePointAt(3), s.codePointAt(4), s.codePointAt(5), s.codePointAt(6), s.codePointAt(7));
          }
          if (length == 9) {
            return exports.$stringAllocate1_9(s.codePointAt(0), s.codePointAt(1), s.codePointAt(2), s.codePointAt(3), s.codePointAt(4), s.codePointAt(5), s.codePointAt(6), s.codePointAt(7), s.codePointAt(8));
          }
          if (length == 10) {
            return exports.$stringAllocate1_10(s.codePointAt(0), s.codePointAt(1), s.codePointAt(2), s.codePointAt(3), s.codePointAt(4), s.codePointAt(5), s.codePointAt(6), s.codePointAt(7), s.codePointAt(8), s.codePointAt(9));
          }
        }
        const dartString = exports.$stringAllocate1(length);
        const write = exports.$stringWrite1;
        for (let i = 0; i < length; i++) {
          write(dartString, i, s.codePointAt(i));
        }
        return dartString;
      } else {
        const dartString = exports.$stringAllocate2(length);
        const write = exports.$stringWrite2;
        for (let i = 0; i < length; i++) {
          write(dartString, i, s.charCodeAt(i));
        }
        return dartString;
      }
    }
    ,
_2577: () => ({}),
_2578: () => [],
_2579: l => new Array(l),
_2580: () => globalThis,
_2581: (constructor, args) => {
      const factoryFunction = constructor.bind.apply(
          constructor, [null, ...args]);
      return new factoryFunction();
    },
_2582: (o, p) => p in o,
_2583: (o, p) => o[p],
_2584: (o, p, v) => o[p] = v,
_2585: (o, m, a) => o[m].apply(o, a),
_2587: o => String(o),
_2588: (p, s, f) => p.then(s, f),
_2589: s => {
      if (/[[\]{}()*+?.\\^$|]/.test(s)) {
          s = s.replace(/[[\]{}()*+?.\\^$|]/g, '\\$&');
      }
      return s;
    },
_2591: x0 => x0.input,
_2592: x0 => x0.index,
_2593: x0 => x0.groups,
_2594: x0 => x0.length,
_2596: (x0,x1) => x0[x1],
_2599: x0 => x0.flags,
_2600: x0 => x0.multiline,
_2601: x0 => x0.ignoreCase,
_2602: x0 => x0.unicode,
_2603: x0 => x0.dotAll,
_2604: (x0,x1) => x0.lastIndex = x1,
_2606: (o, p) => o[p],
_2607: (o, p, v) => o[p] = v,
_2608: (o, p) => delete o[p],
_2671: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2671(f,arguments.length,x0) }),
_2672: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2672(f,arguments.length,x0) }),
_2673: (x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12) => ({client_id: x0,scope: x1,include_granted_scopes: x2,redirect_uri: x3,callback: x4,state: x5,enable_granular_consent: x6,enable_serial_consent: x7,login_hint: x8,hd: x9,ux_mode: x10,select_account: x11,error_callback: x12}),
_2674: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2674(f,arguments.length,x0) }),
_2675: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2675(f,arguments.length,x0) }),
_2676: (x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10) => ({client_id: x0,callback: x1,scope: x2,include_granted_scopes: x3,prompt: x4,enable_granular_consent: x5,enable_serial_consent: x6,login_hint: x7,hd: x8,state: x9,error_callback: x10}),
_2678: () => globalThis.google.accounts.oauth2,
_2688: x0 => x0.code,
_2691: x0 => x0.error,
_2698: x0 => x0.access_token,
_2699: x0 => x0.expires_in,
_2705: x0 => x0.error,
_2708: x0 => x0.type,
_2713: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2713(f,arguments.length,x0) }),
_2716: (x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16) => ({client_id: x0,auto_select: x1,callback: x2,login_uri: x3,native_callback: x4,cancel_on_tap_outside: x5,prompt_parent_id: x6,nonce: x7,context: x8,state_cookie_domain: x9,ux_mode: x10,allowed_parent_origin: x11,intermediate_iframe_close_callback: x12,itp_support: x13,login_hint: x14,hd: x15,use_fedcm_for_prompt: x16}),
_2720: () => globalThis.google.accounts.id,
_2725: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2725(f,arguments.length,x0) }),
_2726: (x0,x1) => x0.prompt(x1),
_2749: x0 => x0.isNotDisplayed(),
_2751: x0 => x0.isSkippedMoment(),
_2753: x0 => x0.isDismissedMoment(),
_2757: x0 => x0.getNotDisplayedReason(),
_2760: x0 => x0.getSkippedReason(),
_2762: x0 => x0.getDismissedReason(),
_2765: x0 => x0.error,
_2767: x0 => x0.credential,
_2775: x0 => globalThis.onGoogleLibraryLoad = x0,
_2776: f => finalizeWrapper(f, function() { return dartInstance.exports._2776(f,arguments.length) }),
_4154: (x0,x1) => x0.src = x1,
_4155: x0 => x0.src,
_4156: (x0,x1) => x0.type = x1,
_4160: (x0,x1) => x0.async = x1,
_4162: (x0,x1) => x0.defer = x1,
_4164: (x0,x1) => x0.crossOrigin = x1,
_4166: (x0,x1) => x0.text = x1,
_4175: (x0,x1) => x0.charset = x1,
_4574: () => globalThis.window,
_4634: x0 => x0.location,
_4654: x0 => x0.navigator,
_4910: x0 => x0.trustedTypes,
_4911: x0 => x0.sessionStorage,
_4928: x0 => x0.hostname,
_5120: x0 => x0.geolocation,
_5123: x0 => x0.mediaDevices,
_5125: x0 => x0.permissions,
_5135: x0 => x0.userAgent,
_9458: x0 => x0.length,
_9541: () => globalThis.document,
_9631: x0 => x0.body,
_9632: x0 => x0.head,
_9997: (x0,x1) => x0.id = x1,
_10008: x0 => x0.children,
_11477: x0 => x0.id,
_11489: x0 => x0.kind,
_11490: x0 => x0.id,
_11491: x0 => x0.label,
_11493: x0 => x0.enabled,
_11494: x0 => x0.muted,
_15377: () => globalThis.console,
_15406: x0 => x0.name,
_15407: x0 => x0.message,
_15408: x0 => x0.code,
_15410: x0 => x0.customData
    };

    const baseImports = {
        dart2wasm: dart2wasm,


        Math: Math,
        Date: Date,
        Object: Object,
        Array: Array,
        Reflect: Reflect,
    };

    const jsStringPolyfill = {
        "charCodeAt": (s, i) => s.charCodeAt(i),
        "compare": (s1, s2) => {
            if (s1 < s2) return -1;
            if (s1 > s2) return 1;
            return 0;
        },
        "concat": (s1, s2) => s1 + s2,
        "equals": (s1, s2) => s1 === s2,
        "fromCharCode": (i) => String.fromCharCode(i),
        "length": (s) => s.length,
        "substring": (s, a, b) => s.substring(a, b),
    };

    dartInstance = await WebAssembly.instantiate(await modulePromise, {
        ...baseImports,
        ...(await importObjectPromise),
        "wasm:js-string": jsStringPolyfill,
    });

    return dartInstance;
}

// Call the main function for the instantiated module
// `moduleInstance` is the instantiated dart2wasm module
// `args` are any arguments that should be passed into the main function.
export const invoke = (moduleInstance, ...args) => {
  moduleInstance.exports.$invokeMain(args);
}

