
// Compiles a dart2wasm-generated main module from `source` which can then
// instantiatable via the `instantiate` method.
//
// `source` needs to be a `Response` object (or promise thereof) e.g. created
// via the `fetch()` JS API.
export async function compileStreaming(source) {
  const builtins = {builtins: ['js-string']};
  return new CompiledApp(
      await WebAssembly.compileStreaming(source, builtins), builtins);
}

// Compiles a dart2wasm-generated wasm modules from `bytes` which is then
// instantiatable via the `instantiate` method.
export async function compile(bytes) {
  const builtins = {builtins: ['js-string']};
  return new CompiledApp(await WebAssembly.compile(bytes, builtins), builtins);
}

// DEPRECATED: Please use `compile` or `compileStreaming` to get a compiled app,
// use `instantiate` method to get an instantiated app and then call
// `invokeMain` to invoke the main function.
export async function instantiate(modulePromise, importObjectPromise) {
  var moduleOrCompiledApp = await modulePromise;
  if (!(moduleOrCompiledApp instanceof CompiledApp)) {
    moduleOrCompiledApp = new CompiledApp(moduleOrCompiledApp);
  }
  const instantiatedApp = await moduleOrCompiledApp.instantiate(await importObjectPromise);
  return instantiatedApp.instantiatedModule;
}

// DEPRECATED: Please use `compile` or `compileStreaming` to get a compiled app,
// use `instantiate` method to get an instantiated app and then call
// `invokeMain` to invoke the main function.
export const invoke = (moduleInstance, ...args) => {
  moduleInstance.exports.$invokeMain(args);
}

class CompiledApp {
  constructor(module, builtins) {
    this.module = module;
    this.builtins = builtins;
  }

  // The second argument is an options object containing:
  // `loadDeferredWasm` is a JS function that takes a module name matching a
  //   wasm file produced by the dart2wasm compiler and returns the bytes to
  //   load the module. These bytes can be in either a format supported by
  //   `WebAssembly.compile` or `WebAssembly.compileStreaming`.
  async instantiate(additionalImports, {loadDeferredWasm} = {}) {
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
      _192: x0 => x0.select(),
      _193: (x0,x1) => x0.append(x1),
      _194: x0 => x0.remove(),
      _197: x0 => x0.unlock(),
      _202: x0 => x0.getReader(),
      _211: x0 => new MutationObserver(x0),
      _222: (x0,x1,x2) => x0.addEventListener(x1,x2),
      _223: (x0,x1,x2) => x0.removeEventListener(x1,x2),
      _226: x0 => new ResizeObserver(x0),
      _229: (x0,x1) => new Intl.Segmenter(x0,x1),
      _230: x0 => x0.next(),
      _231: (x0,x1) => new Intl.v8BreakIterator(x0,x1),
      _308: x0 => x0.close(),
      _309: (x0,x1,x2,x3,x4) => ({type: x0,data: x1,premultiplyAlpha: x2,colorSpaceConversion: x3,preferAnimation: x4}),
      _310: x0 => new window.ImageDecoder(x0),
      _311: x0 => x0.close(),
      _312: x0 => ({frameIndex: x0}),
      _313: (x0,x1) => x0.decode(x1),
      _316: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._316(f,arguments.length,x0) }),
      _317: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._317(f,arguments.length,x0) }),
      _318: (x0,x1) => ({addView: x0,removeView: x1}),
      _319: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._319(f,arguments.length,x0) }),
      _320: f => finalizeWrapper(f, function() { return dartInstance.exports._320(f,arguments.length) }),
      _321: (x0,x1) => ({initializeEngine: x0,autoStart: x1}),
      _322: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._322(f,arguments.length,x0) }),
      _323: x0 => ({runApp: x0}),
      _324: x0 => new Uint8Array(x0),
      _326: x0 => x0.preventDefault(),
      _327: x0 => x0.stopPropagation(),
      _328: (x0,x1) => x0.addListener(x1),
      _329: (x0,x1) => x0.removeListener(x1),
      _330: (x0,x1) => x0.prepend(x1),
      _331: x0 => x0.remove(),
      _332: x0 => x0.disconnect(),
      _333: (x0,x1) => x0.addListener(x1),
      _334: (x0,x1) => x0.removeListener(x1),
      _335: x0 => x0.blur(),
      _336: (x0,x1) => x0.append(x1),
      _337: x0 => x0.remove(),
      _338: x0 => x0.stopPropagation(),
      _342: x0 => x0.preventDefault(),
      _343: (x0,x1) => x0.append(x1),
      _344: x0 => x0.remove(),
      _345: x0 => x0.preventDefault(),
      _350: (x0,x1) => x0.removeChild(x1),
      _351: (x0,x1) => x0.appendChild(x1),
      _352: (x0,x1,x2) => x0.insertBefore(x1,x2),
      _353: (x0,x1) => x0.appendChild(x1),
      _354: (x0,x1) => x0.transferFromImageBitmap(x1),
      _356: (x0,x1) => x0.append(x1),
      _357: (x0,x1) => x0.append(x1),
      _358: (x0,x1) => x0.append(x1),
      _359: x0 => x0.remove(),
      _360: x0 => x0.remove(),
      _361: x0 => x0.remove(),
      _362: (x0,x1) => x0.appendChild(x1),
      _363: (x0,x1) => x0.appendChild(x1),
      _364: x0 => x0.remove(),
      _365: (x0,x1) => x0.append(x1),
      _366: (x0,x1) => x0.append(x1),
      _367: x0 => x0.remove(),
      _368: (x0,x1) => x0.append(x1),
      _369: (x0,x1) => x0.append(x1),
      _370: (x0,x1,x2) => x0.insertBefore(x1,x2),
      _371: (x0,x1) => x0.append(x1),
      _372: (x0,x1,x2) => x0.insertBefore(x1,x2),
      _373: x0 => x0.remove(),
      _374: (x0,x1) => x0.append(x1),
      _375: x0 => x0.remove(),
      _376: (x0,x1) => x0.append(x1),
      _377: x0 => x0.remove(),
      _378: x0 => x0.remove(),
      _379: x0 => x0.getBoundingClientRect(),
      _380: x0 => x0.remove(),
      _393: (x0,x1) => x0.append(x1),
      _394: x0 => x0.remove(),
      _395: (x0,x1) => x0.append(x1),
      _396: (x0,x1,x2) => x0.insertBefore(x1,x2),
      _397: x0 => x0.preventDefault(),
      _398: x0 => x0.preventDefault(),
      _399: x0 => x0.preventDefault(),
      _400: x0 => x0.preventDefault(),
      _401: (x0,x1) => x0.observe(x1),
      _402: x0 => x0.disconnect(),
      _403: (x0,x1) => x0.appendChild(x1),
      _404: (x0,x1) => x0.appendChild(x1),
      _405: (x0,x1) => x0.appendChild(x1),
      _406: (x0,x1) => x0.append(x1),
      _407: x0 => x0.remove(),
      _408: (x0,x1) => x0.append(x1),
      _410: (x0,x1) => x0.appendChild(x1),
      _411: (x0,x1) => x0.append(x1),
      _412: x0 => x0.remove(),
      _413: (x0,x1) => x0.append(x1),
      _414: x0 => x0.remove(),
      _418: (x0,x1) => x0.appendChild(x1),
      _419: x0 => x0.remove(),
      _978: () => globalThis.window.flutterConfiguration,
      _979: x0 => x0.assetBase,
      _984: x0 => x0.debugShowSemanticsNodes,
      _985: x0 => x0.hostElement,
      _986: x0 => x0.multiViewEnabled,
      _987: x0 => x0.nonce,
      _989: x0 => x0.fontFallbackBaseUrl,
      _995: x0 => x0.console,
      _996: x0 => x0.devicePixelRatio,
      _997: x0 => x0.document,
      _998: x0 => x0.history,
      _999: x0 => x0.innerHeight,
      _1000: x0 => x0.innerWidth,
      _1001: x0 => x0.location,
      _1002: x0 => x0.navigator,
      _1003: x0 => x0.visualViewport,
      _1004: x0 => x0.performance,
      _1007: (x0,x1) => x0.dispatchEvent(x1),
      _1008: (x0,x1) => x0.matchMedia(x1),
      _1010: (x0,x1) => x0.getComputedStyle(x1),
      _1011: x0 => x0.screen,
      _1012: (x0,x1) => x0.requestAnimationFrame(x1),
      _1013: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1013(f,arguments.length,x0) }),
      _1018: (x0,x1) => x0.warn(x1),
      _1021: () => globalThis.window,
      _1022: () => globalThis.Intl,
      _1023: () => globalThis.Symbol,
      _1026: x0 => x0.clipboard,
      _1027: x0 => x0.maxTouchPoints,
      _1028: x0 => x0.vendor,
      _1029: x0 => x0.language,
      _1030: x0 => x0.platform,
      _1031: x0 => x0.userAgent,
      _1032: x0 => x0.languages,
      _1033: x0 => x0.documentElement,
      _1034: (x0,x1) => x0.querySelector(x1),
      _1038: (x0,x1) => x0.createElement(x1),
      _1039: (x0,x1) => x0.execCommand(x1),
      _1042: (x0,x1) => x0.createTextNode(x1),
      _1043: (x0,x1) => x0.createEvent(x1),
      _1047: x0 => x0.head,
      _1048: x0 => x0.body,
      _1049: (x0,x1) => x0.title = x1,
      _1052: x0 => x0.activeElement,
      _1054: x0 => x0.visibilityState,
      _1056: x0 => x0.hasFocus(),
      _1057: () => globalThis.document,
      _1058: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      _1059: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      _1062: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1062(f,arguments.length,x0) }),
      _1063: x0 => x0.target,
      _1065: x0 => x0.timeStamp,
      _1066: x0 => x0.type,
      _1068: x0 => x0.preventDefault(),
      _1070: (x0,x1,x2,x3) => x0.initEvent(x1,x2,x3),
      _1076: x0 => x0.baseURI,
      _1077: x0 => x0.firstChild,
      _1082: x0 => x0.parentElement,
      _1084: x0 => x0.parentNode,
      _1088: (x0,x1) => x0.removeChild(x1),
      _1089: (x0,x1) => x0.removeChild(x1),
      _1090: x0 => x0.isConnected,
      _1091: (x0,x1) => x0.textContent = x1,
      _1095: (x0,x1) => x0.contains(x1),
      _1101: x0 => x0.firstElementChild,
      _1103: x0 => x0.nextElementSibling,
      _1104: x0 => x0.clientHeight,
      _1105: x0 => x0.clientWidth,
      _1106: x0 => x0.offsetHeight,
      _1107: x0 => x0.offsetWidth,
      _1108: x0 => x0.id,
      _1109: (x0,x1) => x0.id = x1,
      _1112: (x0,x1) => x0.spellcheck = x1,
      _1113: x0 => x0.tagName,
      _1114: x0 => x0.style,
      _1115: (x0,x1) => x0.append(x1),
      _1117: (x0,x1) => x0.getAttribute(x1),
      _1118: x0 => x0.getBoundingClientRect(),
      _1121: (x0,x1) => x0.closest(x1),
      _1124: (x0,x1) => x0.querySelectorAll(x1),
      _1126: x0 => x0.remove(),
      _1127: (x0,x1,x2) => x0.setAttribute(x1,x2),
      _1128: (x0,x1) => x0.removeAttribute(x1),
      _1129: (x0,x1) => x0.tabIndex = x1,
      _1132: (x0,x1) => x0.focus(x1),
      _1133: x0 => x0.scrollTop,
      _1134: (x0,x1) => x0.scrollTop = x1,
      _1135: x0 => x0.scrollLeft,
      _1136: (x0,x1) => x0.scrollLeft = x1,
      _1137: x0 => x0.classList,
      _1138: (x0,x1) => x0.className = x1,
      _1144: (x0,x1) => x0.getElementsByClassName(x1),
      _1146: x0 => x0.click(),
      _1147: (x0,x1) => x0.hasAttribute(x1),
      _1150: (x0,x1) => x0.attachShadow(x1),
      _1155: (x0,x1) => x0.getPropertyValue(x1),
      _1157: (x0,x1,x2,x3) => x0.setProperty(x1,x2,x3),
      _1159: (x0,x1) => x0.removeProperty(x1),
      _1161: x0 => x0.offsetLeft,
      _1162: x0 => x0.offsetTop,
      _1163: x0 => x0.offsetParent,
      _1165: (x0,x1) => x0.name = x1,
      _1166: x0 => x0.content,
      _1167: (x0,x1) => x0.content = x1,
      _1185: (x0,x1) => x0.nonce = x1,
      _1191: x0 => x0.now(),
      _1193: (x0,x1) => x0.width = x1,
      _1195: (x0,x1) => x0.height = x1,
      _1199: (x0,x1) => x0.getContext(x1),
      _1275: (x0,x1) => x0.fetch(x1),
      _1276: x0 => x0.status,
      _1278: x0 => x0.body,
      _1279: x0 => x0.arrayBuffer(),
      _1285: x0 => x0.read(),
      _1286: x0 => x0.value,
      _1287: x0 => x0.done,
      _1289: x0 => x0.name,
      _1290: x0 => x0.x,
      _1291: x0 => x0.y,
      _1294: x0 => x0.top,
      _1295: x0 => x0.right,
      _1296: x0 => x0.bottom,
      _1297: x0 => x0.left,
      _1306: x0 => x0.height,
      _1307: x0 => x0.width,
      _1308: (x0,x1) => x0.value = x1,
      _1310: (x0,x1) => x0.placeholder = x1,
      _1311: (x0,x1) => x0.name = x1,
      _1312: x0 => x0.selectionDirection,
      _1313: x0 => x0.selectionStart,
      _1314: x0 => x0.selectionEnd,
      _1317: x0 => x0.value,
      _1319: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      _1322: x0 => x0.readText(),
      _1323: (x0,x1) => x0.writeText(x1),
      _1324: x0 => x0.altKey,
      _1325: x0 => x0.code,
      _1326: x0 => x0.ctrlKey,
      _1327: x0 => x0.key,
      _1328: x0 => x0.keyCode,
      _1329: x0 => x0.location,
      _1330: x0 => x0.metaKey,
      _1331: x0 => x0.repeat,
      _1332: x0 => x0.shiftKey,
      _1333: x0 => x0.isComposing,
      _1334: (x0,x1) => x0.getModifierState(x1),
      _1336: x0 => x0.state,
      _1337: (x0,x1) => x0.go(x1),
      _1339: (x0,x1,x2,x3) => x0.pushState(x1,x2,x3),
      _1341: (x0,x1,x2,x3) => x0.replaceState(x1,x2,x3),
      _1342: x0 => x0.pathname,
      _1343: x0 => x0.search,
      _1344: x0 => x0.hash,
      _1348: x0 => x0.state,
      _1356: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1356(f,arguments.length,x0,x1) }),
      _1358: (x0,x1,x2) => x0.observe(x1,x2),
      _1361: x0 => x0.attributeName,
      _1362: x0 => x0.type,
      _1363: x0 => x0.matches,
      _1366: x0 => x0.matches,
      _1368: x0 => x0.relatedTarget,
      _1369: x0 => x0.clientX,
      _1370: x0 => x0.clientY,
      _1371: x0 => x0.offsetX,
      _1372: x0 => x0.offsetY,
      _1375: x0 => x0.button,
      _1376: x0 => x0.buttons,
      _1377: x0 => x0.ctrlKey,
      _1378: (x0,x1) => x0.getModifierState(x1),
      _1381: x0 => x0.pointerId,
      _1382: x0 => x0.pointerType,
      _1383: x0 => x0.pressure,
      _1384: x0 => x0.tiltX,
      _1385: x0 => x0.tiltY,
      _1386: x0 => x0.getCoalescedEvents(),
      _1388: x0 => x0.deltaX,
      _1389: x0 => x0.deltaY,
      _1390: x0 => x0.wheelDeltaX,
      _1391: x0 => x0.wheelDeltaY,
      _1392: x0 => x0.deltaMode,
      _1398: x0 => x0.changedTouches,
      _1400: x0 => x0.clientX,
      _1401: x0 => x0.clientY,
      _1403: x0 => x0.data,
      _1406: (x0,x1) => x0.disabled = x1,
      _1407: (x0,x1) => x0.type = x1,
      _1408: (x0,x1) => x0.max = x1,
      _1409: (x0,x1) => x0.min = x1,
      _1410: (x0,x1) => x0.value = x1,
      _1411: x0 => x0.value,
      _1412: x0 => x0.disabled,
      _1413: (x0,x1) => x0.disabled = x1,
      _1414: (x0,x1) => x0.placeholder = x1,
      _1415: (x0,x1) => x0.name = x1,
      _1416: (x0,x1) => x0.autocomplete = x1,
      _1417: x0 => x0.selectionDirection,
      _1418: x0 => x0.selectionStart,
      _1419: x0 => x0.selectionEnd,
      _1423: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      _1428: (x0,x1) => x0.add(x1),
      _1432: (x0,x1) => x0.noValidate = x1,
      _1433: (x0,x1) => x0.method = x1,
      _1434: (x0,x1) => x0.action = x1,
      _1459: x0 => x0.orientation,
      _1460: x0 => x0.width,
      _1461: x0 => x0.height,
      _1462: (x0,x1) => x0.lock(x1),
      _1478: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1478(f,arguments.length,x0,x1) }),
      _1489: x0 => x0.length,
      _1491: (x0,x1) => x0.item(x1),
      _1492: x0 => x0.length,
      _1493: (x0,x1) => x0.item(x1),
      _1494: x0 => x0.iterator,
      _1495: x0 => x0.Segmenter,
      _1496: x0 => x0.v8BreakIterator,
      _1499: x0 => x0.done,
      _1500: x0 => x0.value,
      _1501: x0 => x0.index,
      _1505: (x0,x1) => x0.adoptText(x1),
      _1506: x0 => x0.first(),
      _1507: x0 => x0.next(),
      _1508: x0 => x0.current(),
      _1522: x0 => x0.hostElement,
      _1523: x0 => x0.viewConstraints,
      _1525: x0 => x0.maxHeight,
      _1526: x0 => x0.maxWidth,
      _1527: x0 => x0.minHeight,
      _1528: x0 => x0.minWidth,
      _1529: x0 => x0.loader,
      _1530: () => globalThis._flutter,
      _1531: (x0,x1) => x0.didCreateEngineInitializer(x1),
      _1532: (x0,x1,x2) => x0.call(x1,x2),
      _1533: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1533(f,arguments.length,x0,x1) }),
      _1534: x0 => new Promise(x0),
      _1537: x0 => x0.length,
      _1540: x0 => x0.tracks,
      _1544: x0 => x0.image,
      _1551: x0 => x0.displayWidth,
      _1552: x0 => x0.displayHeight,
      _1553: x0 => x0.duration,
      _1556: x0 => x0.ready,
      _1557: x0 => x0.selectedTrack,
      _1558: x0 => x0.repetitionCount,
      _1559: x0 => x0.frameCount,
      _1607: (x0,x1,x2) => x0.addEventListener(x1,x2),
      _1620: x0 => ({type: x0}),
      _1621: (x0,x1) => new Blob(x0,x1),
      _1633: x0 => x0.cancel(),
      _1638: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      _1639: (x0,x1,x2,x3) => x0.removeEventListener(x1,x2,x3),
      _1644: (x0,x1,x2,x3,x4,x5,x6,x7) => ({apiKey: x0,authDomain: x1,databaseURL: x2,projectId: x3,storageBucket: x4,messagingSenderId: x5,measurementId: x6,appId: x7}),
      _1645: (x0,x1) => globalThis.firebase_core.initializeApp(x0,x1),
      _1646: x0 => globalThis.firebase_core.getApp(x0),
      _1647: () => globalThis.firebase_core.getApp(),
      _1669: x0 => x0.toJSON(),
      _1670: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1670(f,arguments.length,x0) }),
      _1671: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1671(f,arguments.length,x0) }),
      _1672: (x0,x1,x2) => x0.onAuthStateChanged(x1,x2),
      _1673: x0 => x0.call(),
      _1674: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1674(f,arguments.length,x0) }),
      _1675: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1675(f,arguments.length,x0) }),
      _1676: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1676(f,arguments.length,x0) }),
      _1677: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1677(f,arguments.length,x0) }),
      _1678: (x0,x1,x2) => x0.onIdTokenChanged(x1,x2),
      _1687: (x0,x1) => globalThis.firebase_auth.setPersistence(x0,x1),
      _1689: (x0,x1) => globalThis.firebase_auth.signInWithCredential(x0,x1),
      _1698: (x0,x1) => globalThis.firebase_auth.connectAuthEmulator(x0,x1),
      _1715: (x0,x1) => globalThis.firebase_auth.GoogleAuthProvider.credential(x0,x1),
      _1716: x0 => new firebase_auth.OAuthProvider(x0),
      _1719: (x0,x1) => x0.credential(x1),
      _1720: x0 => globalThis.firebase_auth.OAuthProvider.credentialFromResult(x0),
      _1735: x0 => globalThis.firebase_auth.getAdditionalUserInfo(x0),
      _1736: (x0,x1,x2) => ({errorMap: x0,persistence: x1,popupRedirectResolver: x2}),
      _1737: (x0,x1) => globalThis.firebase_auth.initializeAuth(x0,x1),
      _1738: (x0,x1,x2) => ({accessToken: x0,idToken: x1,rawNonce: x2}),
      _1753: x0 => globalThis.firebase_auth.OAuthProvider.credentialFromError(x0),
      _1775: () => globalThis.firebase_auth.debugErrorMap,
      _1777: () => globalThis.firebase_auth.inMemoryPersistence,
      _1779: () => globalThis.firebase_auth.browserSessionPersistence,
      _1781: () => globalThis.firebase_auth.browserLocalPersistence,
      _1783: () => globalThis.firebase_auth.indexedDBLocalPersistence,
      _1818: x0 => globalThis.firebase_auth.multiFactor(x0),
      _1819: (x0,x1) => globalThis.firebase_auth.getMultiFactorResolver(x0,x1),
      _1836: x0 => x0.displayName,
      _1837: x0 => x0.email,
      _1838: x0 => x0.phoneNumber,
      _1839: x0 => x0.photoURL,
      _1840: x0 => x0.providerId,
      _1841: x0 => x0.uid,
      _1842: x0 => x0.emailVerified,
      _1843: x0 => x0.isAnonymous,
      _1844: x0 => x0.providerData,
      _1845: x0 => x0.refreshToken,
      _1846: x0 => x0.tenantId,
      _1847: x0 => x0.metadata,
      _1852: x0 => x0.providerId,
      _1853: x0 => x0.signInMethod,
      _1854: x0 => x0.accessToken,
      _1855: x0 => x0.idToken,
      _1856: x0 => x0.secret,
      _1883: x0 => x0.creationTime,
      _1884: x0 => x0.lastSignInTime,
      _1889: x0 => x0.code,
      _1891: x0 => x0.message,
      _1903: x0 => x0.email,
      _1904: x0 => x0.phoneNumber,
      _1905: x0 => x0.tenantId,
      _1926: x0 => x0.user,
      _1929: x0 => x0.providerId,
      _1930: x0 => x0.profile,
      _1931: x0 => x0.username,
      _1932: x0 => x0.isNewUser,
      _1935: () => globalThis.firebase_auth.browserPopupRedirectResolver,
      _1941: x0 => x0.displayName,
      _1942: x0 => x0.enrollmentTime,
      _1943: x0 => x0.factorId,
      _1944: x0 => x0.uid,
      _1946: x0 => x0.hints,
      _1947: x0 => x0.session,
      _1949: x0 => x0.phoneNumber,
      _1961: (x0,x1) => x0.getItem(x1),
      _1968: (x0,x1) => x0.createElement(x1),
      _2004: () => globalThis.firebase_core.SDK_VERSION,
      _2011: x0 => x0.apiKey,
      _2013: x0 => x0.authDomain,
      _2015: x0 => x0.databaseURL,
      _2017: x0 => x0.projectId,
      _2019: x0 => x0.storageBucket,
      _2021: x0 => x0.messagingSenderId,
      _2023: x0 => x0.measurementId,
      _2025: x0 => x0.appId,
      _2027: x0 => x0.name,
      _2028: x0 => x0.options,
      _2029: (x0,x1) => x0.debug(x1),
      _2030: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2030(f,arguments.length,x0) }),
      _2031: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._2031(f,arguments.length,x0,x1) }),
      _2032: (x0,x1) => ({createScript: x0,createScriptURL: x1}),
      _2033: (x0,x1,x2) => x0.createPolicy(x1,x2),
      _2034: (x0,x1) => x0.createScriptURL(x1),
      _2035: (x0,x1,x2) => x0.createScript(x1,x2),
      _2036: (x0,x1) => x0.appendChild(x1),
      _2037: (x0,x1) => x0.appendChild(x1),
      _2038: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2038(f,arguments.length,x0) }),
      _2068: (x0,x1) => globalThis.enableVirtualBackground(x0,x1),
      _2070: x0 => new MediaStream(x0),
      _2082: (x0,x1) => x0.querySelector(x1),
      _2083: (x0,x1) => x0.append(x1),
      _2130: (x0,x1) => x0.querySelector(x1),
      _2131: (x0,x1) => x0.getAttribute(x1),
      _2132: (x0,x1,x2) => x0.setAttribute(x1,x2),
      _2134: (x0,x1) => x0.initialize(x1),
      _2135: (x0,x1) => x0.initTokenClient(x1),
      _2136: (x0,x1) => x0.initCodeClient(x1),
      _2140: () => new AudioContext(),
      _2141: (x0,x1) => x0.createMediaElementSource(x1),
      _2142: x0 => x0.createStereoPanner(),
      _2143: (x0,x1) => x0.connect(x1),
      _2144: x0 => x0.load(),
      _2145: x0 => x0.remove(),
      _2146: x0 => x0.play(),
      _2147: x0 => x0.pause(),
      _2148: x0 => globalThis.Wakelock.toggle(x0),
      _2169: (x0,x1) => x0.querySelector(x1),
      _2170: (x0,x1) => x0.querySelector(x1),
      _2187: () => globalThis.removeSplashFromWeb(),
      _2188: x0 => globalThis.URL.createObjectURL(x0),
      _2189: x0 => x0.click(),
      _2190: x0 => x0.remove(),
      _2203: x0 => new Array(x0),
      _2205: x0 => x0.length,
      _2207: (x0,x1) => x0[x1],
      _2208: (x0,x1,x2) => x0[x1] = x2,
      _2211: (x0,x1,x2) => new DataView(x0,x1,x2),
      _2213: x0 => new Int8Array(x0),
      _2214: (x0,x1,x2) => new Uint8Array(x0,x1,x2),
      _2215: x0 => new Uint8Array(x0),
      _2223: x0 => new Int32Array(x0),
      _2225: x0 => new Uint32Array(x0),
      _2227: x0 => new Float32Array(x0),
      _2229: x0 => new Float64Array(x0),
      _2231: (o, c) => o instanceof c,
      _2235: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2235(f,arguments.length,x0) }),
      _2236: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2236(f,arguments.length,x0) }),
      _2240: (o, a) => o + a,
      _2261: (decoder, codeUnits) => decoder.decode(codeUnits),
      _2262: () => new TextDecoder("utf-8", {fatal: true}),
      _2263: () => new TextDecoder("utf-8", {fatal: false}),
      _2264: x0 => new WeakRef(x0),
      _2265: x0 => x0.deref(),
      _2271: Date.now,
      _2273: s => new Date(s * 1000).getTimezoneOffset() * 60,
      _2274: s => {
        if (!/^\s*[+-]?(?:Infinity|NaN|(?:\.\d+|\d+(?:\.\d*)?)(?:[eE][+-]?\d+)?)\s*$/.test(s)) {
          return NaN;
        }
        return parseFloat(s);
      },
      _2275: () => {
        let stackString = new Error().stack.toString();
        let frames = stackString.split('\n');
        let drop = 2;
        if (frames[0] === 'Error') {
            drop += 1;
        }
        return frames.slice(drop).join('\n');
      },
      _2276: () => typeof dartUseDateNowForTicks !== "undefined",
      _2277: () => 1000 * performance.now(),
      _2278: () => Date.now(),
      _2279: () => {
        // On browsers return `globalThis.location.href`
        if (globalThis.location != null) {
          return globalThis.location.href;
        }
        return null;
      },
      _2280: () => {
        return typeof process != "undefined" &&
               Object.prototype.toString.call(process) == "[object process]" &&
               process.platform == "win32"
      },
      _2281: () => new WeakMap(),
      _2282: (map, o) => map.get(o),
      _2283: (map, o, v) => map.set(o, v),
      _2284: () => globalThis.WeakRef,
      _2295: s => JSON.stringify(s),
      _2296: s => printToConsole(s),
      _2297: a => a.join(''),
      _2298: (o, a, b) => o.replace(a, b),
      _2300: (s, t) => s.split(t),
      _2301: s => s.toLowerCase(),
      _2302: s => s.toUpperCase(),
      _2303: s => s.trim(),
      _2304: s => s.trimLeft(),
      _2305: s => s.trimRight(),
      _2307: (s, p, i) => s.indexOf(p, i),
      _2308: (s, p, i) => s.lastIndexOf(p, i),
      _2309: (s) => s.replace(/\$/g, "$$$$"),
      _2310: Object.is,
      _2311: s => s.toUpperCase(),
      _2312: s => s.toLowerCase(),
      _2313: (a, i) => a.push(i),
      _2317: a => a.pop(),
      _2318: (a, i) => a.splice(i, 1),
      _2320: (a, s) => a.join(s),
      _2323: (a, b) => a == b ? 0 : (a > b ? 1 : -1),
      _2324: a => a.length,
      _2325: (a, l) => a.length = l,
      _2326: (a, i) => a[i],
      _2327: (a, i, v) => a[i] = v,
      _2330: (o, start, length) => new Uint8Array(o.buffer, o.byteOffset + start, length),
      _2331: (o, start, length) => new Int8Array(o.buffer, o.byteOffset + start, length),
      _2332: (o, start, length) => new Uint8ClampedArray(o.buffer, o.byteOffset + start, length),
      _2333: (o, start, length) => new Uint16Array(o.buffer, o.byteOffset + start, length),
      _2334: (o, start, length) => new Int16Array(o.buffer, o.byteOffset + start, length),
      _2335: (o, start, length) => new Uint32Array(o.buffer, o.byteOffset + start, length),
      _2336: (o, start, length) => new Int32Array(o.buffer, o.byteOffset + start, length),
      _2338: (o, start, length) => new BigInt64Array(o.buffer, o.byteOffset + start, length),
      _2339: (o, start, length) => new Float32Array(o.buffer, o.byteOffset + start, length),
      _2340: (o, start, length) => new Float64Array(o.buffer, o.byteOffset + start, length),
      _2342: l => new DataView(new ArrayBuffer(l)),
      _2343: (o) => new DataView(o.buffer, o.byteOffset, o.byteLength),
      _2344: o => o.byteLength,
      _2345: o => o.buffer,
      _2346: o => o.byteOffset,
      _2347: Function.prototype.call.bind(Object.getOwnPropertyDescriptor(DataView.prototype, 'byteLength').get),
      _2348: (b, o) => new DataView(b, o),
      _2349: (b, o, l) => new DataView(b, o, l),
      _2350: Function.prototype.call.bind(DataView.prototype.getUint8),
      _2351: Function.prototype.call.bind(DataView.prototype.setUint8),
      _2352: Function.prototype.call.bind(DataView.prototype.getInt8),
      _2353: Function.prototype.call.bind(DataView.prototype.setInt8),
      _2354: Function.prototype.call.bind(DataView.prototype.getUint16),
      _2355: Function.prototype.call.bind(DataView.prototype.setUint16),
      _2356: Function.prototype.call.bind(DataView.prototype.getInt16),
      _2357: Function.prototype.call.bind(DataView.prototype.setInt16),
      _2358: Function.prototype.call.bind(DataView.prototype.getUint32),
      _2359: Function.prototype.call.bind(DataView.prototype.setUint32),
      _2360: Function.prototype.call.bind(DataView.prototype.getInt32),
      _2361: Function.prototype.call.bind(DataView.prototype.setInt32),
      _2364: Function.prototype.call.bind(DataView.prototype.getBigInt64),
      _2365: Function.prototype.call.bind(DataView.prototype.setBigInt64),
      _2366: Function.prototype.call.bind(DataView.prototype.getFloat32),
      _2367: Function.prototype.call.bind(DataView.prototype.setFloat32),
      _2368: Function.prototype.call.bind(DataView.prototype.getFloat64),
      _2369: Function.prototype.call.bind(DataView.prototype.setFloat64),
      _2382: () => new XMLHttpRequest(),
      _2383: (x0,x1,x2) => x0.open(x1,x2),
      _2384: (x0,x1,x2) => x0.setRequestHeader(x1,x2),
      _2385: (x0,x1,x2) => x0.setRequestHeader(x1,x2),
      _2386: x0 => x0.abort(),
      _2387: x0 => x0.abort(),
      _2388: x0 => x0.abort(),
      _2389: x0 => x0.abort(),
      _2390: (x0,x1) => x0.send(x1),
      _2391: x0 => x0.send(),
      _2393: x0 => x0.getAllResponseHeaders(),
      _2395: (o, t) => o instanceof t,
      _2397: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2397(f,arguments.length,x0) }),
      _2398: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2398(f,arguments.length,x0) }),
      _2399: o => Object.keys(o),
      _2400: (ms, c) =>
      setTimeout(() => dartInstance.exports.$invokeCallback(c),ms),
      _2401: (handle) => clearTimeout(handle),
      _2402: (ms, c) =>
      setInterval(() => dartInstance.exports.$invokeCallback(c), ms),
      _2403: (handle) => clearInterval(handle),
      _2404: (c) =>
      queueMicrotask(() => dartInstance.exports.$invokeCallback(c)),
      _2405: () => Date.now(),
      _2481: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2481(f,arguments.length,x0) }),
      _2482: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2482(f,arguments.length,x0) }),
      _2483: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2483(f,arguments.length,x0) }),
      _2499: x0 => x0.getAudioTracks(),
      _2500: x0 => x0.getVideoTracks(),
      _2564: (x0,x1,x2,x3,x4,x5) => ({method: x0,headers: x1,body: x2,credentials: x3,redirect: x4,signal: x5}),
      _2565: (x0,x1,x2) => x0.fetch(x1,x2),
      _2566: (x0,x1) => x0.get(x1),
      _2567: f => finalizeWrapper(f, function(x0,x1,x2) { return dartInstance.exports._2567(f,arguments.length,x0,x1,x2) }),
      _2568: (x0,x1) => x0.forEach(x1),
      _2569: x0 => x0.abort(),
      _2570: () => new AbortController(),
      _2571: x0 => x0.getReader(),
      _2572: x0 => x0.read(),
      _2579: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2579(f,arguments.length,x0) }),
      _2580: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2580(f,arguments.length,x0) }),
      _2638: x0 => x0.trustedTypes,
      _2639: (x0,x1) => x0.src = x1,
      _2640: (x0,x1) => x0.createScriptURL(x1),
      _2641: (x0,x1) => x0.debug(x1),
      _2642: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2642(f,arguments.length,x0) }),
      _2643: x0 => ({createScriptURL: x0}),
      _2644: (x0,x1) => x0.appendChild(x1),
      _2660: (x0,x1) => x0.appendChild(x1),
      _2661: (x0,x1) => x0.item(x1),
      _2664: x0 => x0.trustedTypes,
      _2666: (x0,x1) => x0.text = x1,
      _2667: (s, m) => {
        try {
          return new RegExp(s, m);
        } catch (e) {
          return String(e);
        }
      },
      _2668: (x0,x1) => x0.exec(x1),
      _2669: (x0,x1) => x0.test(x1),
      _2670: (x0,x1) => x0.exec(x1),
      _2671: (x0,x1) => x0.exec(x1),
      _2672: x0 => x0.pop(),
      _2674: o => o === undefined,
      _2693: o => typeof o === 'function' && o[jsWrappedDartFunctionSymbol] === true,
      _2695: o => {
        const proto = Object.getPrototypeOf(o);
        return proto === Object.prototype || proto === null;
      },
      _2696: o => o instanceof RegExp,
      _2697: (l, r) => l === r,
      _2698: o => o,
      _2699: o => o,
      _2700: o => o,
      _2701: b => !!b,
      _2702: o => o.length,
      _2705: (o, i) => o[i],
      _2706: f => f.dartFunction,
      _2707: l => arrayFromDartList(Int8Array, l),
      _2708: l => arrayFromDartList(Uint8Array, l),
      _2709: l => arrayFromDartList(Uint8ClampedArray, l),
      _2710: l => arrayFromDartList(Int16Array, l),
      _2711: l => arrayFromDartList(Uint16Array, l),
      _2712: l => arrayFromDartList(Int32Array, l),
      _2713: l => arrayFromDartList(Uint32Array, l),
      _2714: l => arrayFromDartList(Float32Array, l),
      _2715: l => arrayFromDartList(Float64Array, l),
      _2716: x0 => new ArrayBuffer(x0),
      _2717: (data, length) => {
        const getValue = dartInstance.exports.$byteDataGetUint8;
        const view = new DataView(new ArrayBuffer(length));
        for (let i = 0; i < length; i++) {
          view.setUint8(i, getValue(data, i));
        }
        return view;
      },
      _2718: l => arrayFromDartList(Array, l),
      _2719: () => ({}),
      _2720: () => [],
      _2721: l => new Array(l),
      _2722: () => globalThis,
      _2723: (constructor, args) => {
        const factoryFunction = constructor.bind.apply(
            constructor, [null, ...args]);
        return new factoryFunction();
      },
      _2724: (o, p) => p in o,
      _2725: (o, p) => o[p],
      _2726: (o, p, v) => o[p] = v,
      _2727: (o, m, a) => o[m].apply(o, a),
      _2729: o => String(o),
      _2730: (p, s, f) => p.then(s, f),
      _2731: o => {
        if (o === undefined) return 1;
        var type = typeof o;
        if (type === 'boolean') return 2;
        if (type === 'number') return 3;
        if (type === 'string') return 4;
        if (o instanceof Array) return 5;
        if (ArrayBuffer.isView(o)) {
          if (o instanceof Int8Array) return 6;
          if (o instanceof Uint8Array) return 7;
          if (o instanceof Uint8ClampedArray) return 8;
          if (o instanceof Int16Array) return 9;
          if (o instanceof Uint16Array) return 10;
          if (o instanceof Int32Array) return 11;
          if (o instanceof Uint32Array) return 12;
          if (o instanceof Float32Array) return 13;
          if (o instanceof Float64Array) return 14;
          if (o instanceof DataView) return 15;
        }
        if (o instanceof ArrayBuffer) return 16;
        return 17;
      },
      _2732: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI8ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _2733: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI8ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _2736: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _2738: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _2740: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF64ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _2742: s => {
        if (/[[\]{}()*+?.\\^$|]/.test(s)) {
            s = s.replace(/[[\]{}()*+?.\\^$|]/g, '\\$&');
        }
        return s;
      },
      _2744: x0 => x0.input,
      _2745: x0 => x0.index,
      _2746: x0 => x0.groups,
      _2750: x0 => x0.flags,
      _2751: x0 => x0.multiline,
      _2752: x0 => x0.ignoreCase,
      _2753: x0 => x0.unicode,
      _2754: x0 => x0.dotAll,
      _2755: (x0,x1) => x0.lastIndex = x1,
      _2757: (o, p) => o[p],
      _2758: (o, p, v) => o[p] = v,
      _2759: (o, p) => delete o[p],
      _2760: x0 => x0.random(),
      _2761: x0 => x0.random(),
      _2762: (x0,x1) => x0.getRandomValues(x1),
      _2763: () => globalThis.crypto,
      _2765: () => globalThis.Math,
      _2767: Function.prototype.call.bind(Number.prototype.toString),
      _2768: (d, digits) => d.toFixed(digits),
      _2852: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2852(f,arguments.length,x0) }),
      _2853: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2853(f,arguments.length,x0) }),
      _2854: (x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12) => ({client_id: x0,scope: x1,include_granted_scopes: x2,redirect_uri: x3,callback: x4,state: x5,enable_granular_consent: x6,enable_serial_consent: x7,login_hint: x8,hd: x9,ux_mode: x10,select_account: x11,error_callback: x12}),
      _2855: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2855(f,arguments.length,x0) }),
      _2856: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2856(f,arguments.length,x0) }),
      _2857: (x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10) => ({client_id: x0,callback: x1,scope: x2,include_granted_scopes: x3,prompt: x4,enable_granular_consent: x5,enable_serial_consent: x6,login_hint: x7,hd: x8,state: x9,error_callback: x10}),
      _2859: () => globalThis.google.accounts.oauth2,
      _2869: x0 => x0.code,
      _2872: x0 => x0.error,
      _2879: x0 => x0.access_token,
      _2880: x0 => x0.expires_in,
      _2886: x0 => x0.error,
      _2889: x0 => x0.type,
      _2894: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2894(f,arguments.length,x0) }),
      _2897: (x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16) => ({client_id: x0,auto_select: x1,callback: x2,login_uri: x3,native_callback: x4,cancel_on_tap_outside: x5,prompt_parent_id: x6,nonce: x7,context: x8,state_cookie_domain: x9,ux_mode: x10,allowed_parent_origin: x11,intermediate_iframe_close_callback: x12,itp_support: x13,login_hint: x14,hd: x15,use_fedcm_for_prompt: x16}),
      _2901: () => globalThis.google.accounts.id,
      _2906: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2906(f,arguments.length,x0) }),
      _2907: (x0,x1) => x0.prompt(x1),
      _2930: x0 => x0.isNotDisplayed(),
      _2932: x0 => x0.isSkippedMoment(),
      _2934: x0 => x0.isDismissedMoment(),
      _2938: x0 => x0.getNotDisplayedReason(),
      _2941: x0 => x0.getSkippedReason(),
      _2943: x0 => x0.getDismissedReason(),
      _2946: x0 => x0.error,
      _2948: x0 => x0.credential,
      _2956: x0 => globalThis.onGoogleLibraryLoad = x0,
      _2957: f => finalizeWrapper(f, function() { return dartInstance.exports._2957(f,arguments.length) }),
      _2974: () => globalThis.XMLHttpRequest.UNSENT,
      _2978: () => globalThis.XMLHttpRequest.DONE,
      _2988: x0 => x0.readyState,
      _2990: (x0,x1) => x0.timeout = x1,
      _2992: (x0,x1) => x0.withCredentials = x1,
      _2993: x0 => x0.upload,
      _2994: x0 => x0.responseURL,
      _2995: x0 => x0.status,
      _2996: x0 => x0.statusText,
      _2998: (x0,x1) => x0.responseType = x1,
      _2999: x0 => x0.response,
      _3013: x0 => x0.loaded,
      _3014: x0 => x0.total,
      _3078: x0 => x0.style,
      _3434: (x0,x1) => x0.download = x1,
      _3459: (x0,x1) => x0.href = x1,
      _3703: x0 => x0.error,
      _3705: (x0,x1) => x0.src = x1,
      _3710: (x0,x1) => x0.crossOrigin = x1,
      _3713: (x0,x1) => x0.preload = x1,
      _3717: x0 => x0.currentTime,
      _3718: (x0,x1) => x0.currentTime = x1,
      _3719: x0 => x0.duration,
      _3724: (x0,x1) => x0.playbackRate = x1,
      _3733: (x0,x1) => x0.loop = x1,
      _3737: (x0,x1) => x0.volume = x1,
      _3752: x0 => x0.code,
      _3753: x0 => x0.message,
      _4332: x0 => x0.src,
      _4333: (x0,x1) => x0.src = x1,
      _4335: (x0,x1) => x0.type = x1,
      _4339: (x0,x1) => x0.async = x1,
      _4341: (x0,x1) => x0.defer = x1,
      _4343: (x0,x1) => x0.crossOrigin = x1,
      _4345: (x0,x1) => x0.text = x1,
      _4353: (x0,x1) => x0.charset = x1,
      _4814: () => globalThis.window,
      _4873: x0 => x0.location,
      _4892: x0 => x0.navigator,
      _5137: x0 => x0.trustedTypes,
      _5138: x0 => x0.sessionStorage,
      _5154: x0 => x0.hostname,
      _5244: x0 => x0.geolocation,
      _5247: x0 => x0.mediaDevices,
      _5249: x0 => x0.permissions,
      _5263: x0 => x0.userAgent,
      _7929: x0 => x0.destination,
      _8503: x0 => x0.signal,
      _8517: x0 => x0.length,
      _8598: () => globalThis.document,
      _8689: x0 => x0.body,
      _8691: x0 => x0.head,
      _9050: (x0,x1) => x0.id = x1,
      _9066: x0 => x0.children,
      _10555: x0 => x0.value,
      _10557: x0 => x0.done,
      _11279: x0 => x0.url,
      _11281: x0 => x0.status,
      _11283: x0 => x0.statusText,
      _11284: x0 => x0.headers,
      _11285: x0 => x0.body,
      _12088: x0 => x0.id,
      _12100: x0 => x0.kind,
      _12101: x0 => x0.id,
      _12102: x0 => x0.label,
      _12103: x0 => x0.enabled,
      _12105: x0 => x0.muted,
      _13739: (x0,x1) => x0.display = x1,
      _15742: () => globalThis.console,
      _15776: x0 => x0.name,
      _15777: x0 => x0.message,
      _15778: x0 => x0.code,
      _15780: x0 => x0.customData,

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
      "fromCharCodeArray": (a, start, end) => {
        if (end <= start) return '';

        const read = dartInstance.exports.$wasmI16ArrayGet;
        let result = '';
        let index = start;
        const chunkLength = Math.min(end - index, 500);
        let array = new Array(chunkLength);
        while (index < end) {
          const newChunkLength = Math.min(end - index, 500);
          for (let i = 0; i < newChunkLength; i++) {
            array[i] = read(a, index++);
          }
          if (newChunkLength < chunkLength) {
            array = array.slice(0, newChunkLength);
          }
          result += String.fromCharCode(...array);
        }
        return result;
      },
    };

    const deferredLibraryHelper = {
      "loadModule": async (moduleName) => {
        if (!loadDeferredWasm) {
          throw "No implementation of loadDeferredWasm provided.";
        }
        const source = await Promise.resolve(loadDeferredWasm(moduleName));
        const module = await ((source instanceof Response)
            ? WebAssembly.compileStreaming(source, this.builtins)
            : WebAssembly.compile(source, this.builtins));
        return await WebAssembly.instantiate(module, {
          ...baseImports,
          ...additionalImports,
          "wasm:js-string": jsStringPolyfill,
          "module0": dartInstance.exports,
        });
      },
    };

    dartInstance = await WebAssembly.instantiate(this.module, {
      ...baseImports,
      ...additionalImports,
      "deferredLibraryHelper": deferredLibraryHelper,
      "wasm:js-string": jsStringPolyfill,
    });

    return new InstantiatedApp(this, dartInstance);
  }
}

class InstantiatedApp {
  constructor(compiledApp, instantiatedModule) {
    this.compiledApp = compiledApp;
    this.instantiatedModule = instantiatedModule;
  }

  // Call the main function with the given arguments.
  invokeMain(...args) {
    this.instantiatedModule.exports.$invokeMain(args);
  }
}

