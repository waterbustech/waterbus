
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
_189: x0 => new MutationObserver(x0),
_208: (x0,x1,x2) => x0.addEventListener(x1,x2),
_209: (x0,x1,x2) => x0.removeEventListener(x1,x2),
_212: x0 => new ResizeObserver(x0),
_215: (x0,x1) => new Intl.Segmenter(x0,x1),
_216: x0 => x0.next(),
_217: (x0,x1) => new Intl.v8BreakIterator(x0,x1),
_294: x0 => x0.close(),
_295: (x0,x1,x2,x3,x4) => ({type: x0,data: x1,premultiplyAlpha: x2,colorSpaceConversion: x3,preferAnimation: x4}),
_296: x0 => new window.ImageDecoder(x0),
_297: x0 => x0.close(),
_298: x0 => ({frameIndex: x0}),
_299: (x0,x1) => x0.decode(x1),
_302: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._302(f,arguments.length,x0) }),
_303: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._303(f,arguments.length,x0) }),
_304: (x0,x1) => ({addView: x0,removeView: x1}),
_305: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._305(f,arguments.length,x0) }),
_306: f => finalizeWrapper(f, function() { return dartInstance.exports._306(f,arguments.length) }),
_307: (x0,x1) => ({initializeEngine: x0,autoStart: x1}),
_308: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._308(f,arguments.length,x0) }),
_309: x0 => ({runApp: x0}),
_310: x0 => new Uint8Array(x0),
_312: x0 => x0.preventDefault(),
_313: x0 => x0.stopPropagation(),
_314: (x0,x1) => x0.addListener(x1),
_315: (x0,x1) => x0.removeListener(x1),
_316: (x0,x1) => x0.prepend(x1),
_317: x0 => x0.remove(),
_318: x0 => x0.disconnect(),
_319: (x0,x1) => x0.addListener(x1),
_320: (x0,x1) => x0.removeListener(x1),
_322: (x0,x1) => x0.append(x1),
_323: x0 => x0.remove(),
_324: x0 => x0.stopPropagation(),
_328: x0 => x0.preventDefault(),
_329: (x0,x1) => x0.append(x1),
_330: x0 => x0.remove(),
_331: x0 => x0.preventDefault(),
_336: (x0,x1) => x0.appendChild(x1),
_337: (x0,x1,x2) => x0.insertBefore(x1,x2),
_338: (x0,x1) => x0.removeChild(x1),
_339: (x0,x1) => x0.appendChild(x1),
_340: (x0,x1) => x0.transferFromImageBitmap(x1),
_341: (x0,x1) => x0.append(x1),
_342: (x0,x1) => x0.append(x1),
_343: (x0,x1) => x0.append(x1),
_344: x0 => x0.remove(),
_345: x0 => x0.remove(),
_346: x0 => x0.remove(),
_347: (x0,x1) => x0.appendChild(x1),
_348: (x0,x1) => x0.appendChild(x1),
_349: x0 => x0.remove(),
_350: (x0,x1) => x0.append(x1),
_351: (x0,x1) => x0.append(x1),
_352: x0 => x0.remove(),
_353: (x0,x1) => x0.append(x1),
_354: (x0,x1) => x0.append(x1),
_355: (x0,x1,x2) => x0.insertBefore(x1,x2),
_356: (x0,x1) => x0.append(x1),
_357: (x0,x1,x2) => x0.insertBefore(x1,x2),
_358: x0 => x0.remove(),
_359: x0 => x0.remove(),
_360: (x0,x1) => x0.append(x1),
_361: x0 => x0.remove(),
_362: (x0,x1) => x0.append(x1),
_363: x0 => x0.remove(),
_364: x0 => x0.remove(),
_365: x0 => x0.getBoundingClientRect(),
_366: x0 => x0.remove(),
_367: x0 => x0.blur(),
_368: x0 => x0.remove(),
_369: x0 => x0.blur(),
_370: x0 => x0.remove(),
_383: (x0,x1) => x0.append(x1),
_384: x0 => x0.remove(),
_385: (x0,x1) => x0.append(x1),
_386: (x0,x1,x2) => x0.insertBefore(x1,x2),
_387: x0 => x0.preventDefault(),
_388: x0 => x0.preventDefault(),
_389: x0 => x0.preventDefault(),
_390: x0 => x0.preventDefault(),
_391: x0 => x0.remove(),
_392: (x0,x1) => x0.observe(x1),
_393: x0 => x0.disconnect(),
_394: (x0,x1) => x0.appendChild(x1),
_395: (x0,x1) => x0.appendChild(x1),
_396: (x0,x1) => x0.appendChild(x1),
_397: (x0,x1) => x0.append(x1),
_398: x0 => x0.remove(),
_399: (x0,x1) => x0.append(x1),
_401: (x0,x1) => x0.appendChild(x1),
_402: (x0,x1) => x0.append(x1),
_403: x0 => x0.remove(),
_404: (x0,x1) => x0.append(x1),
_408: (x0,x1) => x0.appendChild(x1),
_409: x0 => x0.remove(),
_969: () => globalThis.window.flutterConfiguration,
_970: x0 => x0.assetBase,
_975: x0 => x0.debugShowSemanticsNodes,
_976: x0 => x0.hostElement,
_977: x0 => x0.multiViewEnabled,
_978: x0 => x0.nonce,
_980: x0 => x0.fontFallbackBaseUrl,
_981: x0 => x0.useColorEmoji,
_985: x0 => x0.console,
_986: x0 => x0.devicePixelRatio,
_987: x0 => x0.document,
_988: x0 => x0.history,
_989: x0 => x0.innerHeight,
_990: x0 => x0.innerWidth,
_991: x0 => x0.location,
_992: x0 => x0.navigator,
_993: x0 => x0.visualViewport,
_994: x0 => x0.performance,
_995: (x0,x1) => x0.fetch(x1),
_1000: (x0,x1) => x0.dispatchEvent(x1),
_1001: (x0,x1) => x0.matchMedia(x1),
_1002: (x0,x1) => x0.getComputedStyle(x1),
_1004: x0 => x0.screen,
_1005: (x0,x1) => x0.requestAnimationFrame(x1),
_1006: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1006(f,arguments.length,x0) }),
_1010: (x0,x1) => x0.warn(x1),
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
_1029: (x0,x1) => x0.createElement(x1),
_1031: (x0,x1) => x0.execCommand(x1),
_1035: (x0,x1) => x0.createTextNode(x1),
_1036: (x0,x1) => x0.createEvent(x1),
_1040: x0 => x0.head,
_1041: x0 => x0.body,
_1042: (x0,x1) => x0.title = x1,
_1045: x0 => x0.activeElement,
_1047: x0 => x0.visibilityState,
_1048: () => globalThis.document,
_1049: (x0,x1,x2) => x0.addEventListener(x1,x2),
_1050: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
_1051: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
_1052: (x0,x1,x2) => x0.removeEventListener(x1,x2),
_1055: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1055(f,arguments.length,x0) }),
_1056: x0 => x0.target,
_1058: x0 => x0.timeStamp,
_1059: x0 => x0.type,
_1061: x0 => x0.preventDefault(),
_1065: (x0,x1,x2,x3) => x0.initEvent(x1,x2,x3),
_1069: x0 => x0.baseURI,
_1070: x0 => x0.firstChild,
_1076: x0 => x0.parentElement,
_1078: x0 => x0.parentNode,
_1081: (x0,x1) => x0.removeChild(x1),
_1082: (x0,x1) => x0.removeChild(x1),
_1083: x0 => x0.isConnected,
_1084: (x0,x1) => x0.textContent = x1,
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
_1107: (x0,x1) => x0.append(x1),
_1108: (x0,x1) => x0.getAttribute(x1),
_1109: x0 => x0.getBoundingClientRect(),
_1112: (x0,x1) => x0.closest(x1),
_1114: (x0,x1) => x0.querySelectorAll(x1),
_1115: x0 => x0.remove(),
_1116: (x0,x1,x2) => x0.setAttribute(x1,x2),
_1118: (x0,x1) => x0.removeAttribute(x1),
_1119: (x0,x1) => x0.tabIndex = x1,
_1121: (x0,x1) => x0.focus(x1),
_1122: x0 => x0.scrollTop,
_1123: (x0,x1) => x0.scrollTop = x1,
_1124: x0 => x0.scrollLeft,
_1125: (x0,x1) => x0.scrollLeft = x1,
_1126: x0 => x0.classList,
_1127: (x0,x1) => x0.className = x1,
_1131: (x0,x1) => x0.getElementsByClassName(x1),
_1132: x0 => x0.click(),
_1133: (x0,x1) => x0.hasAttribute(x1),
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
_1256: x0 => x0.status,
_1258: x0 => x0.body,
_1259: x0 => x0.arrayBuffer(),
_1264: x0 => x0.read(),
_1265: x0 => x0.value,
_1266: x0 => x0.done,
_1268: x0 => x0.name,
_1269: x0 => x0.x,
_1270: x0 => x0.y,
_1273: x0 => x0.top,
_1274: x0 => x0.right,
_1275: x0 => x0.bottom,
_1276: x0 => x0.left,
_1285: x0 => x0.height,
_1286: x0 => x0.width,
_1287: (x0,x1) => x0.value = x1,
_1289: (x0,x1) => x0.placeholder = x1,
_1290: (x0,x1) => x0.name = x1,
_1291: x0 => x0.selectionDirection,
_1292: x0 => x0.selectionStart,
_1293: x0 => x0.selectionEnd,
_1296: x0 => x0.value,
_1298: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
_1303: x0 => x0.readText(),
_1304: (x0,x1) => x0.writeText(x1),
_1305: x0 => x0.altKey,
_1306: x0 => x0.code,
_1307: x0 => x0.ctrlKey,
_1308: x0 => x0.key,
_1309: x0 => x0.keyCode,
_1310: x0 => x0.location,
_1311: x0 => x0.metaKey,
_1312: x0 => x0.repeat,
_1313: x0 => x0.shiftKey,
_1314: x0 => x0.isComposing,
_1315: (x0,x1) => x0.getModifierState(x1),
_1316: x0 => x0.state,
_1319: (x0,x1) => x0.go(x1),
_1320: (x0,x1,x2,x3) => x0.pushState(x1,x2,x3),
_1321: (x0,x1,x2,x3) => x0.replaceState(x1,x2,x3),
_1322: x0 => x0.pathname,
_1323: x0 => x0.search,
_1324: x0 => x0.hash,
_1327: x0 => x0.state,
_1333: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1333(f,arguments.length,x0,x1) }),
_1335: (x0,x1,x2) => x0.observe(x1,x2),
_1338: x0 => x0.attributeName,
_1339: x0 => x0.type,
_1340: x0 => x0.matches,
_1344: x0 => x0.matches,
_1345: x0 => x0.relatedTarget,
_1346: x0 => x0.clientX,
_1347: x0 => x0.clientY,
_1348: x0 => x0.offsetX,
_1349: x0 => x0.offsetY,
_1352: x0 => x0.button,
_1353: x0 => x0.buttons,
_1354: x0 => x0.ctrlKey,
_1355: (x0,x1) => x0.getModifierState(x1),
_1356: x0 => x0.pointerId,
_1357: x0 => x0.pointerType,
_1358: x0 => x0.pressure,
_1359: x0 => x0.tiltX,
_1360: x0 => x0.tiltY,
_1361: x0 => x0.getCoalescedEvents(),
_1362: x0 => x0.deltaX,
_1363: x0 => x0.deltaY,
_1364: x0 => x0.wheelDeltaX,
_1365: x0 => x0.wheelDeltaY,
_1366: x0 => x0.deltaMode,
_1371: x0 => x0.changedTouches,
_1373: x0 => x0.clientX,
_1374: x0 => x0.clientY,
_1375: x0 => x0.data,
_1376: (x0,x1) => x0.type = x1,
_1377: (x0,x1) => x0.max = x1,
_1378: (x0,x1) => x0.min = x1,
_1379: (x0,x1) => x0.value = x1,
_1380: x0 => x0.value,
_1381: x0 => x0.disabled,
_1382: (x0,x1) => x0.disabled = x1,
_1383: (x0,x1) => x0.placeholder = x1,
_1384: (x0,x1) => x0.name = x1,
_1385: (x0,x1) => x0.autocomplete = x1,
_1386: x0 => x0.selectionDirection,
_1387: x0 => x0.selectionStart,
_1388: x0 => x0.selectionEnd,
_1392: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
_1399: (x0,x1) => x0.add(x1),
_1402: (x0,x1) => x0.noValidate = x1,
_1403: (x0,x1) => x0.method = x1,
_1404: (x0,x1) => x0.action = x1,
_1431: x0 => x0.orientation,
_1432: x0 => x0.width,
_1433: x0 => x0.height,
_1434: (x0,x1) => x0.lock(x1),
_1451: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1451(f,arguments.length,x0,x1) }),
_1461: x0 => x0.length,
_1462: (x0,x1) => x0.item(x1),
_1463: x0 => x0.length,
_1464: (x0,x1) => x0.item(x1),
_1465: x0 => x0.iterator,
_1466: x0 => x0.Segmenter,
_1467: x0 => x0.v8BreakIterator,
_1470: x0 => x0.done,
_1471: x0 => x0.value,
_1472: x0 => x0.index,
_1476: (x0,x1) => x0.adoptText(x1),
_1478: x0 => x0.first(),
_1479: x0 => x0.next(),
_1480: x0 => x0.current(),
_1493: x0 => x0.hostElement,
_1494: x0 => x0.viewConstraints,
_1496: x0 => x0.maxHeight,
_1497: x0 => x0.maxWidth,
_1498: x0 => x0.minHeight,
_1499: x0 => x0.minWidth,
_1500: x0 => x0.loader,
_1501: () => globalThis._flutter,
_1502: (x0,x1) => x0.didCreateEngineInitializer(x1),
_1503: (x0,x1,x2) => x0.call(x1,x2),
_1504: () => globalThis.Promise,
_1505: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1505(f,arguments.length,x0,x1) }),
_1508: x0 => x0.length,
_1511: x0 => x0.tracks,
_1515: x0 => x0.image,
_1520: x0 => x0.codedWidth,
_1521: x0 => x0.codedHeight,
_1524: x0 => x0.duration,
_1528: x0 => x0.ready,
_1529: x0 => x0.selectedTrack,
_1530: x0 => x0.repetitionCount,
_1531: x0 => x0.frameCount,
_1579: (x0,x1,x2) => x0.addEventListener(x1,x2),
_1592: x0 => ({type: x0}),
_1593: (x0,x1) => new Blob(x0,x1),
_1610: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
_1611: (x0,x1,x2,x3) => x0.removeEventListener(x1,x2,x3),
_1616: (x0,x1,x2,x3,x4,x5,x6,x7) => ({apiKey: x0,authDomain: x1,databaseURL: x2,projectId: x3,storageBucket: x4,messagingSenderId: x5,measurementId: x6,appId: x7}),
_1617: (x0,x1) => globalThis.firebase_core.initializeApp(x0,x1),
_1618: x0 => globalThis.firebase_core.getApp(x0),
_1619: () => globalThis.firebase_core.getApp(),
_1641: x0 => x0.toJSON(),
_1642: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1642(f,arguments.length,x0) }),
_1643: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1643(f,arguments.length,x0) }),
_1644: (x0,x1,x2) => x0.onAuthStateChanged(x1,x2),
_1645: x0 => x0.call(),
_1646: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1646(f,arguments.length,x0) }),
_1647: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1647(f,arguments.length,x0) }),
_1648: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1648(f,arguments.length,x0) }),
_1649: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1649(f,arguments.length,x0) }),
_1650: (x0,x1,x2) => x0.onIdTokenChanged(x1,x2),
_1659: (x0,x1) => globalThis.firebase_auth.setPersistence(x0,x1),
_1661: (x0,x1) => globalThis.firebase_auth.signInWithCredential(x0,x1),
_1670: (x0,x1) => globalThis.firebase_auth.connectAuthEmulator(x0,x1),
_1687: (x0,x1) => globalThis.firebase_auth.GoogleAuthProvider.credential(x0,x1),
_1688: x0 => new firebase_auth.OAuthProvider(x0),
_1691: (x0,x1) => x0.credential(x1),
_1692: x0 => globalThis.firebase_auth.OAuthProvider.credentialFromResult(x0),
_1707: x0 => globalThis.firebase_auth.getAdditionalUserInfo(x0),
_1708: (x0,x1,x2) => ({errorMap: x0,persistence: x1,popupRedirectResolver: x2}),
_1709: (x0,x1) => globalThis.firebase_auth.initializeAuth(x0,x1),
_1710: (x0,x1,x2) => ({accessToken: x0,idToken: x1,rawNonce: x2}),
_1725: x0 => globalThis.firebase_auth.OAuthProvider.credentialFromError(x0),
_1747: () => globalThis.firebase_auth.debugErrorMap,
_1749: () => globalThis.firebase_auth.inMemoryPersistence,
_1751: () => globalThis.firebase_auth.browserSessionPersistence,
_1753: () => globalThis.firebase_auth.browserLocalPersistence,
_1755: () => globalThis.firebase_auth.indexedDBLocalPersistence,
_1790: x0 => globalThis.firebase_auth.multiFactor(x0),
_1791: (x0,x1) => globalThis.firebase_auth.getMultiFactorResolver(x0,x1),
_1808: x0 => x0.displayName,
_1809: x0 => x0.email,
_1810: x0 => x0.phoneNumber,
_1811: x0 => x0.photoURL,
_1812: x0 => x0.providerId,
_1813: x0 => x0.uid,
_1814: x0 => x0.emailVerified,
_1815: x0 => x0.isAnonymous,
_1816: x0 => x0.providerData,
_1817: x0 => x0.refreshToken,
_1818: x0 => x0.tenantId,
_1819: x0 => x0.metadata,
_1824: x0 => x0.providerId,
_1825: x0 => x0.signInMethod,
_1826: x0 => x0.accessToken,
_1827: x0 => x0.idToken,
_1828: x0 => x0.secret,
_1855: x0 => x0.creationTime,
_1856: x0 => x0.lastSignInTime,
_1861: x0 => x0.code,
_1863: x0 => x0.message,
_1875: x0 => x0.email,
_1876: x0 => x0.phoneNumber,
_1877: x0 => x0.tenantId,
_1898: x0 => x0.user,
_1901: x0 => x0.providerId,
_1902: x0 => x0.profile,
_1903: x0 => x0.username,
_1904: x0 => x0.isNewUser,
_1907: () => globalThis.firebase_auth.browserPopupRedirectResolver,
_1913: x0 => x0.displayName,
_1914: x0 => x0.enrollmentTime,
_1915: x0 => x0.factorId,
_1916: x0 => x0.uid,
_1918: x0 => x0.hints,
_1919: x0 => x0.session,
_1921: x0 => x0.phoneNumber,
_1933: (x0,x1) => x0.getItem(x1),
_1940: (x0,x1) => x0.createElement(x1),
_1976: () => globalThis.firebase_core.SDK_VERSION,
_1983: x0 => x0.apiKey,
_1985: x0 => x0.authDomain,
_1987: x0 => x0.databaseURL,
_1989: x0 => x0.projectId,
_1991: x0 => x0.storageBucket,
_1993: x0 => x0.messagingSenderId,
_1995: x0 => x0.measurementId,
_1997: x0 => x0.appId,
_1999: x0 => x0.name,
_2000: x0 => x0.options,
_2001: (x0,x1) => x0.debug(x1),
_2002: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2002(f,arguments.length,x0) }),
_2003: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._2003(f,arguments.length,x0,x1) }),
_2004: (x0,x1) => ({createScript: x0,createScriptURL: x1}),
_2005: (x0,x1,x2) => x0.createPolicy(x1,x2),
_2006: (x0,x1) => x0.createScriptURL(x1),
_2007: (x0,x1,x2) => x0.createScript(x1,x2),
_2008: (x0,x1) => x0.appendChild(x1),
_2009: (x0,x1) => x0.appendChild(x1),
_2010: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2010(f,arguments.length,x0) }),
_2039: (x0,x1) => globalThis.enableVirtualBackground(x0,x1),
_2041: x0 => new MediaStream(x0),
_2053: (x0,x1) => x0.querySelector(x1),
_2054: (x0,x1) => x0.append(x1),
_2101: (x0,x1) => x0.querySelector(x1),
_2102: (x0,x1) => x0.getAttribute(x1),
_2103: (x0,x1,x2) => x0.setAttribute(x1,x2),
_2105: (x0,x1) => x0.initialize(x1),
_2106: (x0,x1) => x0.initTokenClient(x1),
_2107: (x0,x1) => x0.initCodeClient(x1),
_2111: () => new AudioContext(),
_2112: (x0,x1) => x0.createMediaElementSource(x1),
_2113: x0 => x0.createStereoPanner(),
_2114: (x0,x1) => x0.connect(x1),
_2115: x0 => x0.load(),
_2116: x0 => x0.remove(),
_2117: x0 => x0.play(),
_2118: x0 => x0.pause(),
_2119: x0 => globalThis.Wakelock.toggle(x0),
_2140: (x0,x1) => x0.querySelector(x1),
_2141: (x0,x1) => x0.querySelector(x1),
_2158: () => globalThis.removeSplashFromWeb(),
_2159: x0 => globalThis.URL.createObjectURL(x0),
_2160: x0 => x0.click(),
_2161: x0 => x0.remove(),
_2176: x0 => new Array(x0),
_2179: (o, c) => o instanceof c,
_2183: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2183(f,arguments.length,x0) }),
_2184: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2184(f,arguments.length,x0) }),
_2188: (o, a) => o + a,
_2209: (decoder, codeUnits) => decoder.decode(codeUnits),
_2210: () => new TextDecoder("utf-8", {fatal: true}),
_2211: () => new TextDecoder("utf-8", {fatal: false}),
_2212: v => v.toString(),
_2213: (d, digits) => d.toFixed(digits),
_2217: x0 => new WeakRef(x0),
_2218: x0 => x0.deref(),
_2224: Date.now,
_2226: s => new Date(s * 1000).getTimezoneOffset() * 60 ,
_2227: s => {
      if (!/^\s*[+-]?(?:Infinity|NaN|(?:\.\d+|\d+(?:\.\d*)?)(?:[eE][+-]?\d+)?)\s*$/.test(s)) {
        return NaN;
      }
      return parseFloat(s);
    },
_2228: () => {
          let stackString = new Error().stack.toString();
          let frames = stackString.split('\n');
          let drop = 2;
          if (frames[0] === 'Error') {
              drop += 1;
          }
          return frames.slice(drop).join('\n');
        },
_2229: () => typeof dartUseDateNowForTicks !== "undefined",
_2230: () => 1000 * performance.now(),
_2231: () => Date.now(),
_2232: () => {
      // On browsers return `globalThis.location.href`
      if (globalThis.location != null) {
        return globalThis.location.href;
      }
      return null;
    },
_2233: () => {
        return typeof process != "undefined" &&
               Object.prototype.toString.call(process) == "[object process]" &&
               process.platform == "win32"
      },
_2234: () => new WeakMap(),
_2235: (map, o) => map.get(o),
_2236: (map, o, v) => map.set(o, v),
_2237: () => globalThis.WeakRef,
_2248: s => JSON.stringify(s),
_2249: s => printToConsole(s),
_2250: a => a.join(''),
_2251: (o, a, b) => o.replace(a, b),
_2253: (s, t) => s.split(t),
_2254: s => s.toLowerCase(),
_2255: s => s.toUpperCase(),
_2256: s => s.trim(),
_2257: s => s.trimLeft(),
_2258: s => s.trimRight(),
_2260: (s, p, i) => s.indexOf(p, i),
_2261: (s, p, i) => s.lastIndexOf(p, i),
_2262: (s) => s.replace(/\$/g, "$$$$"),
_2263: Object.is,
_2264: s => s.toUpperCase(),
_2265: s => s.toLowerCase(),
_2266: (a, i) => a.push(i),
_2270: a => a.pop(),
_2271: (a, i) => a.splice(i, 1),
_2273: (a, s) => a.join(s),
_2276: (a, b) => a == b ? 0 : (a > b ? 1 : -1),
_2277: a => a.length,
_2278: (a, l) => a.length = l,
_2279: (a, i) => a[i],
_2280: (a, i, v) => a[i] = v,
_2283: (o, start, length) => new Uint8Array(o.buffer, o.byteOffset + start, length),
_2284: (o, start, length) => new Int8Array(o.buffer, o.byteOffset + start, length),
_2285: (o, start, length) => new Uint8ClampedArray(o.buffer, o.byteOffset + start, length),
_2286: (o, start, length) => new Uint16Array(o.buffer, o.byteOffset + start, length),
_2287: (o, start, length) => new Int16Array(o.buffer, o.byteOffset + start, length),
_2288: (o, start, length) => new Uint32Array(o.buffer, o.byteOffset + start, length),
_2289: (o, start, length) => new Int32Array(o.buffer, o.byteOffset + start, length),
_2292: (o, start, length) => new Float32Array(o.buffer, o.byteOffset + start, length),
_2293: (o, start, length) => new Float64Array(o.buffer, o.byteOffset + start, length),
_2296: (o) => new DataView(o.buffer, o.byteOffset, o.byteLength),
_2297: o => o.byteLength,
_2298: o => o.buffer,
_2299: o => o.byteOffset,
_2300: Function.prototype.call.bind(Object.getOwnPropertyDescriptor(DataView.prototype, 'byteLength').get),
_2301: (b, o) => new DataView(b, o),
_2302: (b, o, l) => new DataView(b, o, l),
_2303: Function.prototype.call.bind(DataView.prototype.getUint8),
_2304: Function.prototype.call.bind(DataView.prototype.setUint8),
_2305: Function.prototype.call.bind(DataView.prototype.getInt8),
_2306: Function.prototype.call.bind(DataView.prototype.setInt8),
_2307: Function.prototype.call.bind(DataView.prototype.getUint16),
_2308: Function.prototype.call.bind(DataView.prototype.setUint16),
_2309: Function.prototype.call.bind(DataView.prototype.getInt16),
_2310: Function.prototype.call.bind(DataView.prototype.setInt16),
_2311: Function.prototype.call.bind(DataView.prototype.getUint32),
_2312: Function.prototype.call.bind(DataView.prototype.setUint32),
_2313: Function.prototype.call.bind(DataView.prototype.getInt32),
_2314: Function.prototype.call.bind(DataView.prototype.setInt32),
_2317: Function.prototype.call.bind(DataView.prototype.getBigInt64),
_2318: Function.prototype.call.bind(DataView.prototype.setBigInt64),
_2319: Function.prototype.call.bind(DataView.prototype.getFloat32),
_2320: Function.prototype.call.bind(DataView.prototype.setFloat32),
_2321: Function.prototype.call.bind(DataView.prototype.getFloat64),
_2322: Function.prototype.call.bind(DataView.prototype.setFloat64),
_2323: (x0,x1) => x0.getRandomValues(x1),
_2324: x0 => new Uint8Array(x0),
_2325: () => globalThis.crypto,
_2336: () => new XMLHttpRequest(),
_2337: (x0,x1,x2) => x0.open(x1,x2),
_2338: (x0,x1,x2) => x0.setRequestHeader(x1,x2),
_2339: (x0,x1,x2) => x0.setRequestHeader(x1,x2),
_2340: x0 => x0.abort(),
_2341: x0 => x0.abort(),
_2342: x0 => x0.abort(),
_2343: x0 => x0.abort(),
_2344: (x0,x1) => x0.send(x1),
_2345: x0 => x0.send(),
_2347: x0 => x0.getAllResponseHeaders(),
_2349: (o, t) => o instanceof t,
_2351: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2351(f,arguments.length,x0) }),
_2352: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2352(f,arguments.length,x0) }),
_2353: o => Object.keys(o),
_2354: (ms, c) =>
              setTimeout(() => dartInstance.exports.$invokeCallback(c),ms),
_2355: (handle) => clearTimeout(handle),
_2356: (ms, c) =>
          setInterval(() => dartInstance.exports.$invokeCallback(c), ms),
_2357: (handle) => clearInterval(handle),
_2358: (c) =>
              queueMicrotask(() => dartInstance.exports.$invokeCallback(c)),
_2359: () => Date.now(),
_2469: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2469(f,arguments.length,x0) }),
_2470: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2470(f,arguments.length,x0) }),
_2471: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2471(f,arguments.length,x0) }),
_2487: x0 => x0.getAudioTracks(),
_2488: x0 => x0.getVideoTracks(),
_2505: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
_2511: () => new XMLHttpRequest(),
_2512: (x0,x1,x2) => x0.setRequestHeader(x1,x2),
_2513: x0 => x0.abort(),
_2514: x0 => x0.getAllResponseHeaders(),
_2520: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2520(f,arguments.length,x0) }),
_2521: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2521(f,arguments.length,x0) }),
_2578: x0 => x0.trustedTypes,
_2579: (x0,x1) => x0.src = x1,
_2580: (x0,x1) => x0.createScriptURL(x1),
_2581: (x0,x1) => x0.debug(x1),
_2582: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2582(f,arguments.length,x0) }),
_2583: x0 => ({createScriptURL: x0}),
_2584: (x0,x1) => x0.appendChild(x1),
_2600: (x0,x1) => x0.appendChild(x1),
_2601: (x0,x1) => x0.item(x1),
_2604: x0 => x0.trustedTypes,
_2606: (x0,x1) => x0.text = x1,
_2608: (s, m) => {
          try {
            return new RegExp(s, m);
          } catch (e) {
            return String(e);
          }
        },
_2609: (x0,x1) => x0.exec(x1),
_2610: (x0,x1) => x0.test(x1),
_2611: (x0,x1) => x0.exec(x1),
_2612: (x0,x1) => x0.exec(x1),
_2613: x0 => x0.pop(),
_2617: (x0,x1,x2) => x0[x1] = x2,
_2619: o => o === undefined,
_2620: o => typeof o === 'boolean',
_2621: o => typeof o === 'number',
_2623: o => typeof o === 'string',
_2626: o => o instanceof Int8Array,
_2627: o => o instanceof Uint8Array,
_2628: o => o instanceof Uint8ClampedArray,
_2629: o => o instanceof Int16Array,
_2630: o => o instanceof Uint16Array,
_2631: o => o instanceof Int32Array,
_2632: o => o instanceof Uint32Array,
_2633: o => o instanceof Float32Array,
_2634: o => o instanceof Float64Array,
_2635: o => o instanceof ArrayBuffer,
_2636: o => o instanceof DataView,
_2637: o => o instanceof Array,
_2638: o => typeof o === 'function' && o[jsWrappedDartFunctionSymbol] === true,
_2640: o => {
            const proto = Object.getPrototypeOf(o);
            return proto === Object.prototype || proto === null;
          },
_2641: o => o instanceof RegExp,
_2642: (l, r) => l === r,
_2643: o => o,
_2644: o => o,
_2645: o => o,
_2646: b => !!b,
_2647: o => o.length,
_2650: (o, i) => o[i],
_2651: f => f.dartFunction,
_2652: l => arrayFromDartList(Int8Array, l),
_2653: (data, length) => {
          const jsBytes = new Uint8Array(length);
          const getByte = dartInstance.exports.$uint8ListGet;
          for (let i = 0; i < length; i++) {
            jsBytes[i] = getByte(data, i);
          }
          return jsBytes;
        },
_2654: l => arrayFromDartList(Uint8ClampedArray, l),
_2655: l => arrayFromDartList(Int16Array, l),
_2656: l => arrayFromDartList(Uint16Array, l),
_2657: l => arrayFromDartList(Int32Array, l),
_2658: l => arrayFromDartList(Uint32Array, l),
_2659: l => arrayFromDartList(Float32Array, l),
_2660: l => arrayFromDartList(Float64Array, l),
_2661: (data, length) => {
          const read = dartInstance.exports.$byteDataGetUint8;
          const view = new DataView(new ArrayBuffer(length));
          for (let i = 0; i < length; i++) {
              view.setUint8(i, read(data, i));
          }
          return view;
        },
_2662: l => arrayFromDartList(Array, l),
_2663:       (s, length) => {
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
_2664:     (s, length) => {
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
_2665:     (s) => {
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
_2666: () => ({}),
_2667: () => [],
_2668: l => new Array(l),
_2669: () => globalThis,
_2670: (constructor, args) => {
      const factoryFunction = constructor.bind.apply(
          constructor, [null, ...args]);
      return new factoryFunction();
    },
_2671: (o, p) => p in o,
_2672: (o, p) => o[p],
_2673: (o, p, v) => o[p] = v,
_2674: (o, m, a) => o[m].apply(o, a),
_2676: o => String(o),
_2677: (p, s, f) => p.then(s, f),
_2678: s => {
      if (/[[\]{}()*+?.\\^$|]/.test(s)) {
          s = s.replace(/[[\]{}()*+?.\\^$|]/g, '\\$&');
      }
      return s;
    },
_2680: x0 => x0.input,
_2681: x0 => x0.index,
_2682: x0 => x0.groups,
_2683: x0 => x0.length,
_2685: (x0,x1) => x0[x1],
_2688: x0 => x0.flags,
_2689: x0 => x0.multiline,
_2690: x0 => x0.ignoreCase,
_2691: x0 => x0.unicode,
_2692: x0 => x0.dotAll,
_2693: (x0,x1) => x0.lastIndex = x1,
_2695: (o, p) => o[p],
_2696: (o, p, v) => o[p] = v,
_2697: (o, p) => delete o[p],
_2764: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2764(f,arguments.length,x0) }),
_2765: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2765(f,arguments.length,x0) }),
_2766: (x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12) => ({client_id: x0,scope: x1,include_granted_scopes: x2,redirect_uri: x3,callback: x4,state: x5,enable_granular_consent: x6,enable_serial_consent: x7,login_hint: x8,hd: x9,ux_mode: x10,select_account: x11,error_callback: x12}),
_2767: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2767(f,arguments.length,x0) }),
_2768: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2768(f,arguments.length,x0) }),
_2769: (x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10) => ({client_id: x0,callback: x1,scope: x2,include_granted_scopes: x3,prompt: x4,enable_granular_consent: x5,enable_serial_consent: x6,login_hint: x7,hd: x8,state: x9,error_callback: x10}),
_2771: () => globalThis.google.accounts.oauth2,
_2781: x0 => x0.code,
_2784: x0 => x0.error,
_2791: x0 => x0.access_token,
_2792: x0 => x0.expires_in,
_2798: x0 => x0.error,
_2801: x0 => x0.type,
_2806: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2806(f,arguments.length,x0) }),
_2809: (x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16) => ({client_id: x0,auto_select: x1,callback: x2,login_uri: x3,native_callback: x4,cancel_on_tap_outside: x5,prompt_parent_id: x6,nonce: x7,context: x8,state_cookie_domain: x9,ux_mode: x10,allowed_parent_origin: x11,intermediate_iframe_close_callback: x12,itp_support: x13,login_hint: x14,hd: x15,use_fedcm_for_prompt: x16}),
_2813: () => globalThis.google.accounts.id,
_2818: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2818(f,arguments.length,x0) }),
_2819: (x0,x1) => x0.prompt(x1),
_2842: x0 => x0.isNotDisplayed(),
_2844: x0 => x0.isSkippedMoment(),
_2846: x0 => x0.isDismissedMoment(),
_2850: x0 => x0.getNotDisplayedReason(),
_2853: x0 => x0.getSkippedReason(),
_2855: x0 => x0.getDismissedReason(),
_2858: x0 => x0.error,
_2860: x0 => x0.credential,
_2868: x0 => globalThis.onGoogleLibraryLoad = x0,
_2869: f => finalizeWrapper(f, function() { return dartInstance.exports._2869(f,arguments.length) }),
_2886: () => globalThis.XMLHttpRequest.UNSENT,
_2890: () => globalThis.XMLHttpRequest.DONE,
_2900: x0 => x0.readyState,
_2902: (x0,x1) => x0.timeout = x1,
_2904: (x0,x1) => x0.withCredentials = x1,
_2905: x0 => x0.upload,
_2906: x0 => x0.responseURL,
_2907: x0 => x0.status,
_2908: x0 => x0.statusText,
_2910: (x0,x1) => x0.responseType = x1,
_2911: x0 => x0.response,
_2925: x0 => x0.loaded,
_2926: x0 => x0.total,
_2990: x0 => x0.style,
_3346: (x0,x1) => x0.download = x1,
_3371: (x0,x1) => x0.href = x1,
_3615: x0 => x0.error,
_3617: (x0,x1) => x0.src = x1,
_3622: (x0,x1) => x0.crossOrigin = x1,
_3625: (x0,x1) => x0.preload = x1,
_3629: x0 => x0.currentTime,
_3630: (x0,x1) => x0.currentTime = x1,
_3631: x0 => x0.duration,
_3636: (x0,x1) => x0.playbackRate = x1,
_3645: (x0,x1) => x0.loop = x1,
_3649: (x0,x1) => x0.volume = x1,
_3664: x0 => x0.code,
_3665: x0 => x0.message,
_4244: x0 => x0.src,
_4245: (x0,x1) => x0.src = x1,
_4247: (x0,x1) => x0.type = x1,
_4251: (x0,x1) => x0.async = x1,
_4253: (x0,x1) => x0.defer = x1,
_4255: (x0,x1) => x0.crossOrigin = x1,
_4257: (x0,x1) => x0.text = x1,
_4265: (x0,x1) => x0.charset = x1,
_4726: () => globalThis.window,
_4786: x0 => x0.location,
_4805: x0 => x0.navigator,
_5050: x0 => x0.trustedTypes,
_5051: x0 => x0.sessionStorage,
_5067: x0 => x0.hostname,
_5157: x0 => x0.geolocation,
_5160: x0 => x0.mediaDevices,
_5162: x0 => x0.permissions,
_5176: x0 => x0.userAgent,
_7843: x0 => x0.destination,
_8431: x0 => x0.length,
_8512: () => globalThis.document,
_8603: x0 => x0.body,
_8605: x0 => x0.head,
_8964: (x0,x1) => x0.id = x1,
_8980: x0 => x0.children,
_12002: x0 => x0.id,
_12014: x0 => x0.kind,
_12015: x0 => x0.id,
_12016: x0 => x0.label,
_12017: x0 => x0.enabled,
_12019: x0 => x0.muted,
_13653: (x0,x1) => x0.display = x1,
_15656: () => globalThis.console,
_15690: x0 => x0.name,
_15691: x0 => x0.message,
_15692: x0 => x0.code,
_15694: x0 => x0.customData
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

