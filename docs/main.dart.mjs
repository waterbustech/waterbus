let buildArgsList;

// `modulePromise` is a promise to the `WebAssembly.module` object to be
//   instantiated.
// `importObjectPromise` is a promise to an object that contains any additional
//   imports needed by the module that aren't provided by the standard runtime.
//   The fields on this object will be merged into the importObject with which
//   the module will be instantiated.
// This function returns a promise to the instantiated module.
export const instantiate = async (modulePromise, importObjectPromise) => {
    let dartInstance;

    function stringFromDartString(string) {
        const totalLength = dartInstance.exports.$stringLength(string);
        let result = '';
        let index = 0;
        while (index < totalLength) {
          let chunkLength = Math.min(totalLength - index, 0xFFFF);
          const array = new Array(chunkLength);
          for (let i = 0; i < chunkLength; i++) {
              array[i] = dartInstance.exports.$stringRead(string, index++);
          }
          result += String.fromCharCode(...array);
        }
        return result;
    }

    function stringToDartString(string) {
        const length = string.length;
        let range = 0;
        for (let i = 0; i < length; i++) {
            range |= string.codePointAt(i);
        }
        if (range < 256) {
            const dartString = dartInstance.exports.$stringAllocate1(length);
            for (let i = 0; i < length; i++) {
                dartInstance.exports.$stringWrite1(dartString, i, string.codePointAt(i));
            }
            return dartString;
        } else {
            const dartString = dartInstance.exports.$stringAllocate2(length);
            for (let i = 0; i < length; i++) {
                dartInstance.exports.$stringWrite2(dartString, i, string.charCodeAt(i));
            }
            return dartString;
        }
    }

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
        const length = dartInstance.exports.$listLength(list);
        const array = new constructor(length);
        for (let i = 0; i < length; i++) {
            array[i] = dartInstance.exports.$listRead(list, i);
        }
        return array;
    }

    buildArgsList = function(list) {
        const dartList = dartInstance.exports.$makeStringList();
        for (let i = 0; i < list.length; i++) {
            dartInstance.exports.$listAdd(dartList, stringToDartString(list[i]));
        }
        return dartList;
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
_6: f => finalizeWrapper(f,x0 => dartInstance.exports._6(f,x0)),
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
_164: x0 => x0.focus(),
_165: x0 => x0.select(),
_166: (x0,x1) => x0.append(x1),
_167: x0 => x0.remove(),
_170: x0 => x0.unlock(),
_175: x0 => x0.getReader(),
_185: x0 => new MutationObserver(x0),
_204: (x0,x1,x2) => x0.addEventListener(x1,x2),
_205: (x0,x1,x2) => x0.removeEventListener(x1,x2),
_208: x0 => new ResizeObserver(x0),
_211: (x0,x1) => new Intl.Segmenter(x0,x1),
_212: x0 => x0.next(),
_213: (x0,x1) => new Intl.v8BreakIterator(x0,x1),
_290: x0 => x0.close(),
_291: (x0,x1,x2,x3,x4) => ({type: x0,data: x1,premultiplyAlpha: x2,colorSpaceConversion: x3,preferAnimation: x4}),
_292: x0 => new window.ImageDecoder(x0),
_293: x0 => x0.close(),
_294: x0 => ({frameIndex: x0}),
_295: (x0,x1) => x0.decode(x1),
_298: f => finalizeWrapper(f,x0 => dartInstance.exports._298(f,x0)),
_299: f => finalizeWrapper(f,x0 => dartInstance.exports._299(f,x0)),
_300: (x0,x1) => ({addView: x0,removeView: x1}),
_301: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._301(f,arguments.length,x0) }),
_302: f => finalizeWrapper(f,() => dartInstance.exports._302(f)),
_303: (x0,x1) => ({initializeEngine: x0,autoStart: x1}),
_304: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._304(f,arguments.length,x0) }),
_305: x0 => ({runApp: x0}),
_306: x0 => new Uint8Array(x0),
_308: x0 => x0.preventDefault(),
_309: x0 => x0.stopPropagation(),
_310: (x0,x1) => x0.addListener(x1),
_311: (x0,x1) => x0.removeListener(x1),
_312: (x0,x1) => x0.prepend(x1),
_313: x0 => x0.remove(),
_314: x0 => x0.disconnect(),
_315: (x0,x1) => x0.addListener(x1),
_316: (x0,x1) => x0.removeListener(x1),
_319: (x0,x1) => x0.append(x1),
_320: x0 => x0.remove(),
_321: x0 => x0.stopPropagation(),
_325: x0 => x0.preventDefault(),
_326: (x0,x1) => x0.append(x1),
_327: x0 => x0.remove(),
_332: (x0,x1) => x0.appendChild(x1),
_333: (x0,x1,x2) => x0.insertBefore(x1,x2),
_334: (x0,x1) => x0.removeChild(x1),
_335: (x0,x1) => x0.appendChild(x1),
_336: (x0,x1) => x0.transferFromImageBitmap(x1),
_337: (x0,x1) => x0.append(x1),
_338: (x0,x1) => x0.append(x1),
_339: (x0,x1) => x0.append(x1),
_340: x0 => x0.remove(),
_341: x0 => x0.focus(),
_342: x0 => x0.focus(),
_343: x0 => x0.remove(),
_344: x0 => x0.focus(),
_345: x0 => x0.remove(),
_346: (x0,x1) => x0.appendChild(x1),
_347: (x0,x1) => x0.append(x1),
_348: x0 => x0.focus(),
_349: (x0,x1) => x0.append(x1),
_350: x0 => x0.remove(),
_351: (x0,x1) => x0.append(x1),
_352: (x0,x1) => x0.append(x1),
_353: (x0,x1,x2) => x0.insertBefore(x1,x2),
_354: (x0,x1) => x0.append(x1),
_355: (x0,x1,x2) => x0.insertBefore(x1,x2),
_356: x0 => x0.remove(),
_357: x0 => x0.remove(),
_358: x0 => x0.remove(),
_359: (x0,x1) => x0.append(x1),
_360: x0 => x0.remove(),
_361: x0 => x0.remove(),
_362: x0 => x0.getBoundingClientRect(),
_363: x0 => x0.remove(),
_364: x0 => x0.blur(),
_366: x0 => x0.focus(),
_367: x0 => x0.focus(),
_368: x0 => x0.remove(),
_369: x0 => x0.focus(),
_370: x0 => x0.focus(),
_371: x0 => x0.blur(),
_372: x0 => x0.remove(),
_385: (x0,x1) => x0.append(x1),
_386: x0 => x0.remove(),
_387: (x0,x1) => x0.append(x1),
_388: (x0,x1,x2) => x0.insertBefore(x1,x2),
_389: (x0,x1) => x0.append(x1),
_390: x0 => x0.focus(),
_391: x0 => x0.focus(),
_392: x0 => x0.focus(),
_393: x0 => x0.focus(),
_394: x0 => x0.focus(),
_395: (x0,x1) => x0.append(x1),
_396: x0 => x0.focus(),
_397: x0 => x0.blur(),
_398: x0 => x0.remove(),
_400: x0 => x0.preventDefault(),
_401: x0 => x0.focus(),
_402: x0 => x0.preventDefault(),
_403: x0 => x0.preventDefault(),
_404: x0 => x0.preventDefault(),
_405: x0 => x0.focus(),
_406: x0 => x0.focus(),
_407: (x0,x1) => x0.append(x1),
_408: x0 => x0.focus(),
_409: x0 => x0.focus(),
_410: x0 => x0.focus(),
_411: x0 => x0.focus(),
_412: (x0,x1) => x0.observe(x1),
_413: x0 => x0.disconnect(),
_414: (x0,x1) => x0.appendChild(x1),
_415: (x0,x1) => x0.appendChild(x1),
_416: (x0,x1) => x0.appendChild(x1),
_417: (x0,x1) => x0.append(x1),
_418: (x0,x1) => x0.append(x1),
_419: x0 => x0.remove(),
_420: (x0,x1) => x0.append(x1),
_422: (x0,x1) => x0.appendChild(x1),
_423: (x0,x1) => x0.append(x1),
_424: x0 => x0.remove(),
_425: (x0,x1) => x0.append(x1),
_429: (x0,x1) => x0.appendChild(x1),
_430: x0 => x0.remove(),
_981: () => globalThis.window.flutterConfiguration,
_982: x0 => x0.assetBase,
_986: x0 => x0.debugShowSemanticsNodes,
_987: x0 => x0.hostElement,
_988: x0 => x0.multiViewEnabled,
_989: x0 => x0.nonce,
_991: x0 => x0.fontFallbackBaseUrl,
_992: x0 => x0.useColorEmoji,
_996: x0 => x0.console,
_997: x0 => x0.devicePixelRatio,
_998: x0 => x0.document,
_999: x0 => x0.history,
_1000: x0 => x0.innerHeight,
_1001: x0 => x0.innerWidth,
_1002: x0 => x0.location,
_1003: x0 => x0.navigator,
_1004: x0 => x0.visualViewport,
_1005: x0 => x0.performance,
_1006: (x0,x1) => x0.fetch(x1),
_1009: (x0,x1) => x0.dispatchEvent(x1),
_1010: (x0,x1) => x0.matchMedia(x1),
_1011: (x0,x1) => x0.getComputedStyle(x1),
_1013: x0 => x0.screen,
_1014: (x0,x1) => x0.requestAnimationFrame(x1),
_1015: f => finalizeWrapper(f,x0 => dartInstance.exports._1015(f,x0)),
_1020: (x0,x1) => x0.warn(x1),
_1023: () => globalThis.window,
_1024: () => globalThis.Intl,
_1025: () => globalThis.Symbol,
_1028: x0 => x0.clipboard,
_1029: x0 => x0.maxTouchPoints,
_1030: x0 => x0.vendor,
_1031: x0 => x0.language,
_1032: x0 => x0.platform,
_1033: x0 => x0.userAgent,
_1034: x0 => x0.languages,
_1035: x0 => x0.documentElement,
_1036: (x0,x1) => x0.querySelector(x1),
_1039: (x0,x1) => x0.createElement(x1),
_1041: (x0,x1) => x0.execCommand(x1),
_1044: (x0,x1) => x0.createTextNode(x1),
_1045: (x0,x1) => x0.createEvent(x1),
_1050: x0 => x0.head,
_1051: x0 => x0.body,
_1052: (x0,x1) => x0.title = x1,
_1055: x0 => x0.activeElement,
_1057: x0 => x0.visibilityState,
_1058: () => globalThis.document,
_1059: (x0,x1,x2) => x0.addEventListener(x1,x2),
_1060: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
_1062: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
_1063: (x0,x1,x2) => x0.removeEventListener(x1,x2),
_1066: f => finalizeWrapper(f,x0 => dartInstance.exports._1066(f,x0)),
_1067: x0 => x0.target,
_1069: x0 => x0.timeStamp,
_1070: x0 => x0.type,
_1071: x0 => x0.preventDefault(),
_1075: (x0,x1,x2,x3) => x0.initEvent(x1,x2,x3),
_1079: x0 => x0.baseURI,
_1080: x0 => x0.firstChild,
_1086: x0 => x0.parentElement,
_1088: x0 => x0.parentNode,
_1091: (x0,x1) => x0.removeChild(x1),
_1092: (x0,x1) => x0.removeChild(x1),
_1094: (x0,x1) => x0.textContent = x1,
_1097: (x0,x1) => x0.contains(x1),
_1102: x0 => x0.firstElementChild,
_1104: x0 => x0.nextElementSibling,
_1105: x0 => x0.clientHeight,
_1106: x0 => x0.clientWidth,
_1107: x0 => x0.id,
_1108: (x0,x1) => x0.id = x1,
_1111: (x0,x1) => x0.spellcheck = x1,
_1112: x0 => x0.tagName,
_1113: x0 => x0.style,
_1114: (x0,x1) => x0.append(x1),
_1116: x0 => x0.getBoundingClientRect(),
_1119: (x0,x1) => x0.closest(x1),
_1122: (x0,x1) => x0.querySelectorAll(x1),
_1123: x0 => x0.remove(),
_1124: (x0,x1,x2) => x0.setAttribute(x1,x2),
_1125: (x0,x1) => x0.removeAttribute(x1),
_1126: (x0,x1) => x0.tabIndex = x1,
_1129: x0 => x0.scrollTop,
_1130: (x0,x1) => x0.scrollTop = x1,
_1131: x0 => x0.scrollLeft,
_1132: (x0,x1) => x0.scrollLeft = x1,
_1133: x0 => x0.classList,
_1134: (x0,x1) => x0.className = x1,
_1140: (x0,x1) => x0.getElementsByClassName(x1),
_1141: x0 => x0.click(),
_1143: (x0,x1) => x0.hasAttribute(x1),
_1145: (x0,x1) => x0.attachShadow(x1),
_1148: (x0,x1) => x0.getPropertyValue(x1),
_1150: (x0,x1,x2,x3) => x0.setProperty(x1,x2,x3),
_1152: (x0,x1) => x0.removeProperty(x1),
_1154: x0 => x0.offsetLeft,
_1155: x0 => x0.offsetTop,
_1156: x0 => x0.offsetParent,
_1158: (x0,x1) => x0.name = x1,
_1159: x0 => x0.content,
_1160: (x0,x1) => x0.content = x1,
_1173: (x0,x1) => x0.nonce = x1,
_1178: x0 => x0.now(),
_1180: (x0,x1) => x0.width = x1,
_1182: (x0,x1) => x0.height = x1,
_1185: (x0,x1) => x0.getContext(x1),
_1260: x0 => x0.status,
_1262: x0 => x0.body,
_1263: x0 => x0.arrayBuffer(),
_1268: x0 => x0.read(),
_1269: x0 => x0.value,
_1270: x0 => x0.done,
_1272: x0 => x0.name,
_1273: x0 => x0.x,
_1274: x0 => x0.y,
_1277: x0 => x0.top,
_1278: x0 => x0.right,
_1279: x0 => x0.bottom,
_1280: x0 => x0.left,
_1291: x0 => x0.height,
_1292: x0 => x0.width,
_1293: (x0,x1) => x0.value = x1,
_1296: (x0,x1) => x0.placeholder = x1,
_1297: (x0,x1) => x0.name = x1,
_1298: x0 => x0.selectionDirection,
_1299: x0 => x0.selectionStart,
_1300: x0 => x0.selectionEnd,
_1303: x0 => x0.value,
_1304: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
_1308: x0 => x0.readText(),
_1310: (x0,x1) => x0.writeText(x1),
_1311: x0 => x0.altKey,
_1312: x0 => x0.code,
_1313: x0 => x0.ctrlKey,
_1314: x0 => x0.key,
_1315: x0 => x0.keyCode,
_1316: x0 => x0.location,
_1317: x0 => x0.metaKey,
_1318: x0 => x0.repeat,
_1319: x0 => x0.shiftKey,
_1320: x0 => x0.isComposing,
_1321: (x0,x1) => x0.getModifierState(x1),
_1322: x0 => x0.state,
_1325: (x0,x1) => x0.go(x1),
_1326: (x0,x1,x2,x3) => x0.pushState(x1,x2,x3),
_1327: (x0,x1,x2,x3) => x0.replaceState(x1,x2,x3),
_1328: x0 => x0.pathname,
_1329: x0 => x0.search,
_1330: x0 => x0.hash,
_1333: x0 => x0.state,
_1338: f => finalizeWrapper(f,(x0,x1) => dartInstance.exports._1338(f,x0,x1)),
_1340: (x0,x1,x2) => x0.observe(x1,x2),
_1343: x0 => x0.attributeName,
_1344: x0 => x0.type,
_1345: x0 => x0.matches,
_1348: x0 => x0.matches,
_1349: x0 => x0.relatedTarget,
_1350: x0 => x0.clientX,
_1351: x0 => x0.clientY,
_1352: x0 => x0.offsetX,
_1353: x0 => x0.offsetY,
_1356: x0 => x0.button,
_1357: x0 => x0.buttons,
_1358: x0 => x0.ctrlKey,
_1359: (x0,x1) => x0.getModifierState(x1),
_1360: x0 => x0.pointerId,
_1361: x0 => x0.pointerType,
_1362: x0 => x0.pressure,
_1363: x0 => x0.tiltX,
_1364: x0 => x0.tiltY,
_1365: x0 => x0.getCoalescedEvents(),
_1366: x0 => x0.deltaX,
_1367: x0 => x0.deltaY,
_1368: x0 => x0.wheelDeltaX,
_1369: x0 => x0.wheelDeltaY,
_1370: x0 => x0.deltaMode,
_1375: x0 => x0.changedTouches,
_1377: x0 => x0.clientX,
_1378: x0 => x0.clientY,
_1379: x0 => x0.data,
_1380: (x0,x1) => x0.type = x1,
_1381: (x0,x1) => x0.max = x1,
_1382: (x0,x1) => x0.min = x1,
_1383: (x0,x1) => x0.value = x1,
_1384: x0 => x0.value,
_1385: x0 => x0.disabled,
_1386: (x0,x1) => x0.disabled = x1,
_1387: (x0,x1) => x0.placeholder = x1,
_1388: (x0,x1) => x0.name = x1,
_1389: (x0,x1) => x0.autocomplete = x1,
_1390: x0 => x0.selectionDirection,
_1391: x0 => x0.selectionStart,
_1392: x0 => x0.selectionEnd,
_1395: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
_1402: (x0,x1) => x0.add(x1),
_1405: (x0,x1) => x0.noValidate = x1,
_1406: (x0,x1) => x0.method = x1,
_1407: (x0,x1) => x0.action = x1,
_1435: x0 => x0.orientation,
_1436: x0 => x0.width,
_1437: x0 => x0.height,
_1438: (x0,x1) => x0.lock(x1),
_1455: f => finalizeWrapper(f,(x0,x1) => dartInstance.exports._1455(f,x0,x1)),
_1465: x0 => x0.length,
_1467: (x0,x1) => x0.item(x1),
_1468: x0 => x0.length,
_1469: (x0,x1) => x0.item(x1),
_1470: x0 => x0.iterator,
_1471: x0 => x0.Segmenter,
_1472: x0 => x0.v8BreakIterator,
_1475: x0 => x0.done,
_1476: x0 => x0.value,
_1477: x0 => x0.index,
_1481: (x0,x1) => x0.adoptText(x1),
_1482: x0 => x0.first(),
_1484: x0 => x0.next(),
_1485: x0 => x0.current(),
_1497: x0 => x0.hostElement,
_1498: x0 => x0.viewConstraints,
_1500: x0 => x0.maxHeight,
_1501: x0 => x0.maxWidth,
_1502: x0 => x0.minHeight,
_1503: x0 => x0.minWidth,
_1504: x0 => x0.loader,
_1505: () => globalThis._flutter,
_1506: (x0,x1) => x0.didCreateEngineInitializer(x1),
_1507: (x0,x1,x2) => x0.call(x1,x2),
_1508: () => globalThis.Promise,
_1509: f => finalizeWrapper(f,(x0,x1) => dartInstance.exports._1509(f,x0,x1)),
_1514: x0 => x0.length,
_1517: x0 => x0.tracks,
_1521: x0 => x0.image,
_1526: x0 => x0.codedWidth,
_1527: x0 => x0.codedHeight,
_1530: x0 => x0.duration,
_1534: x0 => x0.ready,
_1535: x0 => x0.selectedTrack,
_1536: x0 => x0.repetitionCount,
_1537: x0 => x0.frameCount,
_1583: (x0,x1,x2,x3,x4,x5,x6,x7) => ({apiKey: x0,authDomain: x1,databaseURL: x2,projectId: x3,storageBucket: x4,messagingSenderId: x5,measurementId: x6,appId: x7}),
_1584: (x0,x1) => globalThis.firebase_core.initializeApp(x0,x1),
_1585: x0 => globalThis.firebase_core.getApp(x0),
_1586: () => globalThis.firebase_core.getApp(),
_1608: x0 => x0.toJSON(),
_1609: f => finalizeWrapper(f,x0 => dartInstance.exports._1609(f,x0)),
_1610: f => finalizeWrapper(f,x0 => dartInstance.exports._1610(f,x0)),
_1611: (x0,x1,x2) => x0.onAuthStateChanged(x1,x2),
_1612: x0 => x0.call(),
_1613: f => finalizeWrapper(f,x0 => dartInstance.exports._1613(f,x0)),
_1614: f => finalizeWrapper(f,x0 => dartInstance.exports._1614(f,x0)),
_1615: f => finalizeWrapper(f,x0 => dartInstance.exports._1615(f,x0)),
_1616: f => finalizeWrapper(f,x0 => dartInstance.exports._1616(f,x0)),
_1617: (x0,x1,x2) => x0.onIdTokenChanged(x1,x2),
_1626: (x0,x1) => globalThis.firebase_auth.setPersistence(x0,x1),
_1628: (x0,x1) => globalThis.firebase_auth.signInWithCredential(x0,x1),
_1637: (x0,x1) => globalThis.firebase_auth.connectAuthEmulator(x0,x1),
_1654: (x0,x1) => globalThis.firebase_auth.GoogleAuthProvider.credential(x0,x1),
_1655: x0 => new firebase_auth.OAuthProvider(x0),
_1658: (x0,x1) => x0.credential(x1),
_1659: x0 => globalThis.firebase_auth.OAuthProvider.credentialFromResult(x0),
_1674: x0 => globalThis.firebase_auth.getAdditionalUserInfo(x0),
_1675: (x0,x1,x2) => ({errorMap: x0,persistence: x1,popupRedirectResolver: x2}),
_1676: (x0,x1) => globalThis.firebase_auth.initializeAuth(x0,x1),
_1677: (x0,x1,x2) => ({accessToken: x0,idToken: x1,rawNonce: x2}),
_1692: x0 => globalThis.firebase_auth.OAuthProvider.credentialFromError(x0),
_1714: () => globalThis.firebase_auth.debugErrorMap,
_1716: () => globalThis.firebase_auth.inMemoryPersistence,
_1718: () => globalThis.firebase_auth.browserSessionPersistence,
_1720: () => globalThis.firebase_auth.browserLocalPersistence,
_1722: () => globalThis.firebase_auth.indexedDBLocalPersistence,
_1757: x0 => globalThis.firebase_auth.multiFactor(x0),
_1758: (x0,x1) => globalThis.firebase_auth.getMultiFactorResolver(x0,x1),
_1775: x0 => x0.displayName,
_1776: x0 => x0.email,
_1777: x0 => x0.phoneNumber,
_1778: x0 => x0.photoURL,
_1779: x0 => x0.providerId,
_1780: x0 => x0.uid,
_1781: x0 => x0.emailVerified,
_1782: x0 => x0.isAnonymous,
_1783: x0 => x0.providerData,
_1784: x0 => x0.refreshToken,
_1785: x0 => x0.tenantId,
_1786: x0 => x0.metadata,
_1791: x0 => x0.providerId,
_1792: x0 => x0.signInMethod,
_1793: x0 => x0.accessToken,
_1794: x0 => x0.idToken,
_1795: x0 => x0.secret,
_1822: x0 => x0.creationTime,
_1823: x0 => x0.lastSignInTime,
_1828: x0 => x0.code,
_1830: x0 => x0.message,
_1842: x0 => x0.email,
_1843: x0 => x0.phoneNumber,
_1844: x0 => x0.tenantId,
_1865: x0 => x0.user,
_1868: x0 => x0.providerId,
_1869: x0 => x0.profile,
_1870: x0 => x0.username,
_1871: x0 => x0.isNewUser,
_1874: () => globalThis.firebase_auth.browserPopupRedirectResolver,
_1880: x0 => x0.displayName,
_1881: x0 => x0.enrollmentTime,
_1882: x0 => x0.factorId,
_1883: x0 => x0.uid,
_1885: x0 => x0.hints,
_1886: x0 => x0.session,
_1888: x0 => x0.phoneNumber,
_1900: (x0,x1) => x0.getItem(x1),
_1907: (x0,x1) => x0.createElement(x1),
_1943: () => globalThis.firebase_core.SDK_VERSION,
_1950: x0 => x0.apiKey,
_1952: x0 => x0.authDomain,
_1954: x0 => x0.databaseURL,
_1956: x0 => x0.projectId,
_1958: x0 => x0.storageBucket,
_1960: x0 => x0.messagingSenderId,
_1962: x0 => x0.measurementId,
_1964: x0 => x0.appId,
_1966: x0 => x0.name,
_1967: x0 => x0.options,
_1968: (x0,x1) => x0.debug(x1),
_1969: f => finalizeWrapper(f,x0 => dartInstance.exports._1969(f,x0)),
_1970: f => finalizeWrapper(f,(x0,x1) => dartInstance.exports._1970(f,x0,x1)),
_1971: (x0,x1) => ({createScript: x0,createScriptURL: x1}),
_1972: (x0,x1,x2) => x0.createPolicy(x1,x2),
_1973: (x0,x1) => x0.createScriptURL(x1),
_1974: (x0,x1,x2) => x0.createScript(x1,x2),
_1975: (x0,x1) => x0.appendChild(x1),
_1976: (x0,x1) => x0.appendChild(x1),
_1977: f => finalizeWrapper(f,x0 => dartInstance.exports._1977(f,x0)),
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
_2071: (x0,x1) => x0.initialize(x1),
_2072: (x0,x1) => x0.initTokenClient(x1),
_2073: (x0,x1) => x0.initCodeClient(x1),
_2077: x0 => globalThis.Wakelock.toggle(x0),
_2079: (x0,x1) => x0.querySelector(x1),
_2080: (x0,x1) => x0.querySelector(x1),
_2115: () => globalThis.removeSplashFromWeb(),
_2119: (x0,x1) => x0.matchMedia(x1),
_2130: x0 => new Array(x0),
_2133: (o, c) => o instanceof c,
_2137: f => finalizeWrapper(f,x0 => dartInstance.exports._2137(f,x0)),
_2138: f => finalizeWrapper(f,x0 => dartInstance.exports._2138(f,x0)),
_2142: (o, a) => o + a,
_2163: (decoder, codeUnits) => decoder.decode(codeUnits),
_2164: () => new TextDecoder("utf-8", {fatal: true}),
_2165: () => new TextDecoder("utf-8", {fatal: false}),
_2166: v => stringToDartString(v.toString()),
_2167: (d, digits) => stringToDartString(d.toFixed(digits)),
_2171: o => new WeakRef(o),
_2172: r => r.deref(),
_2177: Date.now,
_2179: s => new Date(s * 1000).getTimezoneOffset() * 60 ,
_2180: s => {
      const jsSource = stringFromDartString(s);
      if (!/^\s*[+-]?(?:Infinity|NaN|(?:\.\d+|\d+(?:\.\d*)?)(?:[eE][+-]?\d+)?)\s*$/.test(jsSource)) {
        return NaN;
      }
      return parseFloat(jsSource);
    },
_2181: () => {
          let stackString = new Error().stack.toString();
          let frames = stackString.split('\n');
          let drop = 2;
          if (frames[0] === 'Error') {
              drop += 1;
          }
          return frames.slice(drop).join('\n');
        },
_2182: () => typeof dartUseDateNowForTicks !== "undefined",
_2183: () => 1000 * performance.now(),
_2184: () => Date.now(),
_2185: () => {
      // On browsers return `globalThis.location.href`
      if (globalThis.location != null) {
        return stringToDartString(globalThis.location.href);
      }
      return null;
    },
_2186: () => {
        return typeof process != undefined &&
               Object.prototype.toString.call(process) == "[object process]" &&
               process.platform == "win32"
      },
_2187: () => new WeakMap(),
_2188: (map, o) => map.get(o),
_2189: (map, o, v) => map.set(o, v),
_2190: s => stringToDartString(JSON.stringify(stringFromDartString(s))),
_2191: s => printToConsole(stringFromDartString(s)),
_2201: (o, t) => o instanceof t,
_2203: f => finalizeWrapper(f,x0 => dartInstance.exports._2203(f,x0)),
_2204: f => finalizeWrapper(f,x0 => dartInstance.exports._2204(f,x0)),
_2205: o => Object.keys(o),
_2206: (ms, c) =>
              setTimeout(() => dartInstance.exports.$invokeCallback(c),ms),
_2207: (handle) => clearTimeout(handle),
_2208: (ms, c) =>
          setInterval(() => dartInstance.exports.$invokeCallback(c), ms),
_2209: (handle) => clearInterval(handle),
_2210: (c) =>
              queueMicrotask(() => dartInstance.exports.$invokeCallback(c)),
_2211: () => Date.now(),
_2304: f => finalizeWrapper(f,x0 => dartInstance.exports._2304(f,x0)),
_2305: f => finalizeWrapper(f,x0 => dartInstance.exports._2305(f,x0)),
_2306: f => finalizeWrapper(f,x0 => dartInstance.exports._2306(f,x0)),
_2322: x0 => x0.getAudioTracks(),
_2323: x0 => x0.getVideoTracks(),
_2355: f => finalizeWrapper(f,x0 => dartInstance.exports._2355(f,x0)),
_2356: f => finalizeWrapper(f,x0 => dartInstance.exports._2356(f,x0)),
_2412: x0 => x0.trustedTypes,
_2413: (x0,x1) => x0.src = x1,
_2414: (x0,x1) => x0.createScriptURL(x1),
_2415: (x0,x1) => x0.debug(x1),
_2416: f => finalizeWrapper(f,x0 => dartInstance.exports._2416(f,x0)),
_2417: x0 => ({createScriptURL: x0}),
_2418: (x0,x1) => x0.appendChild(x1),
_2431: (x0,x1) => x0.appendChild(x1),
_2432: (x0,x1) => x0.item(x1),
_2435: x0 => x0.trustedTypes,
_2437: (x0,x1) => x0.text = x1,
_2438: (a, i) => a.push(i),
_2442: a => a.pop(),
_2443: (a, i) => a.splice(i, 1),
_2445: (a, s) => a.join(s),
_2448: (a, b) => a == b ? 0 : (a > b ? 1 : -1),
_2449: a => a.length,
_2450: (a, l) => a.length = l,
_2451: (a, i) => a[i],
_2452: (a, i, v) => a[i] = v,
_2454: a => a.join(''),
_2455: (o, a, b) => o.replace(a, b),
_2457: (s, t) => s.split(t),
_2458: s => s.toLowerCase(),
_2459: s => s.toUpperCase(),
_2460: s => s.trim(),
_2461: s => s.trimLeft(),
_2462: s => s.trimRight(),
_2464: (s, p, i) => s.indexOf(p, i),
_2465: (s, p, i) => s.lastIndexOf(p, i),
_2467: (o, start, length) => new Uint8Array(o.buffer, o.byteOffset + start, length),
_2468: (o, start, length) => new Int8Array(o.buffer, o.byteOffset + start, length),
_2469: (o, start, length) => new Uint8ClampedArray(o.buffer, o.byteOffset + start, length),
_2470: (o, start, length) => new Uint16Array(o.buffer, o.byteOffset + start, length),
_2471: (o, start, length) => new Int16Array(o.buffer, o.byteOffset + start, length),
_2472: (o, start, length) => new Uint32Array(o.buffer, o.byteOffset + start, length),
_2473: (o, start, length) => new Int32Array(o.buffer, o.byteOffset + start, length),
_2476: (o, start, length) => new Float32Array(o.buffer, o.byteOffset + start, length),
_2477: (o, start, length) => new Float64Array(o.buffer, o.byteOffset + start, length),
_2478: Object.is,
_2481: (o) => new DataView(o.buffer, o.byteOffset, o.byteLength),
_2483: o => o.buffer,
_2484: o => o.byteOffset,
_2485: Function.prototype.call.bind(Object.getOwnPropertyDescriptor(DataView.prototype, 'byteLength').get),
_2486: (b, o) => new DataView(b, o),
_2487: (b, o, l) => new DataView(b, o, l),
_2488: Function.prototype.call.bind(DataView.prototype.getUint8),
_2489: Function.prototype.call.bind(DataView.prototype.setUint8),
_2490: Function.prototype.call.bind(DataView.prototype.getInt8),
_2491: Function.prototype.call.bind(DataView.prototype.setInt8),
_2492: Function.prototype.call.bind(DataView.prototype.getUint16),
_2493: Function.prototype.call.bind(DataView.prototype.setUint16),
_2494: Function.prototype.call.bind(DataView.prototype.getInt16),
_2495: Function.prototype.call.bind(DataView.prototype.setInt16),
_2496: Function.prototype.call.bind(DataView.prototype.getUint32),
_2497: Function.prototype.call.bind(DataView.prototype.setUint32),
_2498: Function.prototype.call.bind(DataView.prototype.getInt32),
_2499: Function.prototype.call.bind(DataView.prototype.setInt32),
_2502: Function.prototype.call.bind(DataView.prototype.getBigInt64),
_2503: Function.prototype.call.bind(DataView.prototype.setBigInt64),
_2504: Function.prototype.call.bind(DataView.prototype.getFloat32),
_2505: Function.prototype.call.bind(DataView.prototype.setFloat32),
_2506: Function.prototype.call.bind(DataView.prototype.getFloat64),
_2507: Function.prototype.call.bind(DataView.prototype.setFloat64),
_2508: (x0,x1) => x0.getRandomValues(x1),
_2509: x0 => new Uint8Array(x0),
_2510: () => globalThis.crypto,
_2513: s => stringToDartString(stringFromDartString(s).toUpperCase()),
_2514: s => stringToDartString(stringFromDartString(s).toLowerCase()),
_2516: (s, m) => {
          try {
            return new RegExp(s, m);
          } catch (e) {
            return String(e);
          }
        },
_2517: (x0,x1) => x0.exec(x1),
_2518: (x0,x1) => x0.test(x1),
_2519: (x0,x1) => x0.exec(x1),
_2520: (x0,x1) => x0.exec(x1),
_2521: x0 => x0.pop(),
_2525: (x0,x1,x2) => x0[x1] = x2,
_2527: o => o === undefined,
_2528: o => typeof o === 'boolean',
_2529: o => typeof o === 'number',
_2531: o => typeof o === 'string',
_2534: o => o instanceof Int8Array,
_2535: o => o instanceof Uint8Array,
_2536: o => o instanceof Uint8ClampedArray,
_2537: o => o instanceof Int16Array,
_2538: o => o instanceof Uint16Array,
_2539: o => o instanceof Int32Array,
_2540: o => o instanceof Uint32Array,
_2541: o => o instanceof Float32Array,
_2542: o => o instanceof Float64Array,
_2543: o => o instanceof ArrayBuffer,
_2544: o => o instanceof DataView,
_2545: o => o instanceof Array,
_2546: o => typeof o === 'function' && o[jsWrappedDartFunctionSymbol] === true,
_2548: o => {
            const proto = Object.getPrototypeOf(o);
            return proto === Object.prototype || proto === null;
          },
_2549: o => o instanceof RegExp,
_2550: (l, r) => l === r,
_2551: o => o,
_2552: o => o,
_2553: o => o,
_2554: b => !!b,
_2555: o => o.length,
_2558: (o, i) => o[i],
_2559: f => f.dartFunction,
_2560: l => arrayFromDartList(Int8Array, l),
_2561: l => arrayFromDartList(Uint8Array, l),
_2562: l => arrayFromDartList(Uint8ClampedArray, l),
_2563: l => arrayFromDartList(Int16Array, l),
_2564: l => arrayFromDartList(Uint16Array, l),
_2565: l => arrayFromDartList(Int32Array, l),
_2566: l => arrayFromDartList(Uint32Array, l),
_2567: l => arrayFromDartList(Float32Array, l),
_2568: l => arrayFromDartList(Float64Array, l),
_2569: (data, length) => {
          const view = new DataView(new ArrayBuffer(length));
          for (let i = 0; i < length; i++) {
              view.setUint8(i, dartInstance.exports.$byteDataGetUint8(data, i));
          }
          return view;
        },
_2570: l => arrayFromDartList(Array, l),
_2571: stringFromDartString,
_2572: stringToDartString,
_2573: () => ({}),
_2574: () => [],
_2575: l => new Array(l),
_2576: () => globalThis,
_2577: (constructor, args) => {
      const factoryFunction = constructor.bind.apply(
          constructor, [null, ...args]);
      return new factoryFunction();
    },
_2578: (o, p) => p in o,
_2579: (o, p) => o[p],
_2580: (o, p, v) => o[p] = v,
_2581: (o, m, a) => o[m].apply(o, a),
_2583: o => String(o),
_2584: (p, s, f) => p.then(s, f),
_2585: s => {
      let jsString = stringFromDartString(s);
      if (/[[\]{}()*+?.\\^$|]/.test(jsString)) {
          jsString = jsString.replace(/[[\]{}()*+?.\\^$|]/g, '\\$&');
      }
      return stringToDartString(jsString);
    },
_2587: x0 => x0.input,
_2588: x0 => x0.index,
_2589: x0 => x0.groups,
_2590: x0 => x0.length,
_2592: (x0,x1) => x0[x1],
_2596: x0 => x0.flags,
_2597: x0 => x0.multiline,
_2598: x0 => x0.ignoreCase,
_2599: x0 => x0.unicode,
_2600: x0 => x0.dotAll,
_2601: (x0,x1) => x0.lastIndex = x1,
_2603: (o, p) => o[p],
_2604: (o, p, v) => o[p] = v,
_2605: (o, p) => delete o[p],
_2626: f => finalizeWrapper(f,x0 => dartInstance.exports._2626(f,x0)),
_2627: f => finalizeWrapper(f,x0 => dartInstance.exports._2627(f,x0)),
_2628: (x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12) => ({client_id: x0,scope: x1,include_granted_scopes: x2,redirect_uri: x3,callback: x4,state: x5,enable_granular_consent: x6,enable_serial_consent: x7,login_hint: x8,hd: x9,ux_mode: x10,select_account: x11,error_callback: x12}),
_2629: f => finalizeWrapper(f,x0 => dartInstance.exports._2629(f,x0)),
_2630: f => finalizeWrapper(f,x0 => dartInstance.exports._2630(f,x0)),
_2631: (x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10) => ({client_id: x0,callback: x1,scope: x2,include_granted_scopes: x3,prompt: x4,enable_granular_consent: x5,enable_serial_consent: x6,login_hint: x7,hd: x8,state: x9,error_callback: x10}),
_2633: () => globalThis.google.accounts.oauth2,
_2643: x0 => x0.code,
_2646: x0 => x0.error,
_2653: x0 => x0.access_token,
_2654: x0 => x0.expires_in,
_2660: x0 => x0.error,
_2663: x0 => x0.type,
_2668: f => finalizeWrapper(f,x0 => dartInstance.exports._2668(f,x0)),
_2671: (x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16) => ({client_id: x0,auto_select: x1,callback: x2,login_uri: x3,native_callback: x4,cancel_on_tap_outside: x5,prompt_parent_id: x6,nonce: x7,context: x8,state_cookie_domain: x9,ux_mode: x10,allowed_parent_origin: x11,intermediate_iframe_close_callback: x12,itp_support: x13,login_hint: x14,hd: x15,use_fedcm_for_prompt: x16}),
_2675: () => globalThis.google.accounts.id,
_2680: f => finalizeWrapper(f,x0 => dartInstance.exports._2680(f,x0)),
_2681: (x0,x1) => x0.prompt(x1),
_2704: x0 => x0.isNotDisplayed(),
_2706: x0 => x0.isSkippedMoment(),
_2708: x0 => x0.isDismissedMoment(),
_2712: x0 => x0.getNotDisplayedReason(),
_2715: x0 => x0.getSkippedReason(),
_2717: x0 => x0.getDismissedReason(),
_2720: x0 => x0.error,
_2722: x0 => x0.credential,
_2730: x0 => globalThis.onGoogleLibraryLoad = x0,
_2731: f => finalizeWrapper(f,() => dartInstance.exports._2731(f)),
_4109: (x0,x1) => x0.src = x1,
_4110: x0 => x0.src,
_4111: (x0,x1) => x0.type = x1,
_4115: (x0,x1) => x0.async = x1,
_4117: (x0,x1) => x0.defer = x1,
_4119: (x0,x1) => x0.crossOrigin = x1,
_4121: (x0,x1) => x0.text = x1,
_4130: (x0,x1) => x0.charset = x1,
_4529: () => globalThis.window,
_4589: x0 => x0.location,
_4609: x0 => x0.navigator,
_4865: x0 => x0.trustedTypes,
_4866: x0 => x0.sessionStorage,
_4883: x0 => x0.hostname,
_5075: x0 => x0.geolocation,
_5078: x0 => x0.mediaDevices,
_5080: x0 => x0.permissions,
_5090: x0 => x0.userAgent,
_9413: x0 => x0.length,
_9496: () => globalThis.document,
_9586: x0 => x0.body,
_9587: x0 => x0.head,
_9952: (x0,x1) => x0.id = x1,
_9963: x0 => x0.children,
_11432: x0 => x0.id,
_11444: x0 => x0.kind,
_11445: x0 => x0.id,
_11446: x0 => x0.label,
_11448: x0 => x0.enabled,
_11449: x0 => x0.muted,
_15332: () => globalThis.console,
_15354: () => globalThis.window,
_15375: x0 => x0.matches,
_15379: x0 => x0.platform,
_15384: x0 => x0.navigator,
_15402: x0 => x0.name,
_15403: x0 => x0.message,
_15404: x0 => x0.code,
_15406: x0 => x0.customData
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
    const dartMain = moduleInstance.exports.$getMain();
    const dartArgs = buildArgsList(args);
    moduleInstance.exports.$invokeMain(dartMain, dartArgs);
}
