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
  // `loadDynamicModule` is a JS function that takes two string names matching,
  //   in order, a wasm file produced by the dart2wasm compiler during dynamic
  //   module compilation and a corresponding js file produced by the same
  //   compilation. It should return a JS Array containing 2 elements. The first
  //   should be the bytes for the wasm module in a format supported by
  //   `WebAssembly.compile` or `WebAssembly.compileStreaming`. The second
  //   should be the result of using the JS 'import' API on the js file path.
  async instantiate(additionalImports, {loadDeferredWasm, loadDynamicModule} = {}) {
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

      throw "Unable to print message: " + value;
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
            _3: (o, t) => typeof o === t,
      _4: (o, c) => o instanceof c,
      _7: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._7(f,arguments.length,x0) }),
      _8: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._8(f,arguments.length,x0,x1) }),
      _9: (o, a) => o + a,
      _37: x0 => new Array(x0),
      _39: x0 => x0.length,
      _41: (x0,x1) => x0[x1],
      _42: (x0,x1,x2) => { x0[x1] = x2 },
      _43: x0 => new Promise(x0),
      _45: (x0,x1,x2) => new DataView(x0,x1,x2),
      _47: x0 => new Int8Array(x0),
      _48: (x0,x1,x2) => new Uint8Array(x0,x1,x2),
      _49: x0 => new Uint8Array(x0),
      _51: x0 => new Uint8ClampedArray(x0),
      _53: x0 => new Int16Array(x0),
      _55: x0 => new Uint16Array(x0),
      _57: x0 => new Int32Array(x0),
      _59: x0 => new Uint32Array(x0),
      _61: x0 => new Float32Array(x0),
      _63: x0 => new Float64Array(x0),
      _65: (x0,x1,x2) => x0.call(x1,x2),
      _70: (decoder, codeUnits) => decoder.decode(codeUnits),
      _71: () => new TextDecoder("utf-8", {fatal: true}),
      _72: () => new TextDecoder("utf-8", {fatal: false}),
      _73: (s) => +s,
      _74: x0 => new Uint8Array(x0),
      _75: (x0,x1,x2) => x0.set(x1,x2),
      _76: (x0,x1) => x0.transferFromImageBitmap(x1),
      _77: x0 => x0.arrayBuffer(),
      _78: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._78(f,arguments.length,x0) }),
      _79: x0 => new window.FinalizationRegistry(x0),
      _80: (x0,x1,x2,x3) => x0.register(x1,x2,x3),
      _81: (x0,x1) => x0.unregister(x1),
      _82: (x0,x1,x2) => x0.slice(x1,x2),
      _83: (x0,x1) => x0.decode(x1),
      _84: (x0,x1) => x0.segment(x1),
      _85: () => new TextDecoder(),
      _87: x0 => x0.click(),
      _88: x0 => x0.buffer,
      _89: x0 => x0.wasmMemory,
      _90: () => globalThis.window._flutter_skwasmInstance,
      _91: x0 => x0.rasterStartMilliseconds,
      _92: x0 => x0.rasterEndMilliseconds,
      _93: x0 => x0.imageBitmaps,
      _120: x0 => x0.remove(),
      _121: (x0,x1) => x0.append(x1),
      _122: (x0,x1,x2) => x0.insertBefore(x1,x2),
      _123: (x0,x1) => x0.querySelector(x1),
      _125: (x0,x1) => x0.removeChild(x1),
      _203: x0 => x0.stopPropagation(),
      _204: x0 => x0.preventDefault(),
      _206: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      _251: x0 => x0.unlock(),
      _252: x0 => x0.getReader(),
      _253: (x0,x1,x2) => x0.addEventListener(x1,x2),
      _254: (x0,x1,x2) => x0.removeEventListener(x1,x2),
      _255: (x0,x1) => x0.item(x1),
      _256: x0 => x0.next(),
      _257: x0 => x0.now(),
      _258: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._258(f,arguments.length,x0) }),
      _259: (x0,x1) => x0.addListener(x1),
      _260: (x0,x1) => x0.removeListener(x1),
      _261: (x0,x1) => x0.matchMedia(x1),
      _262: (x0,x1) => x0.revokeObjectURL(x1),
      _263: x0 => x0.close(),
      _264: (x0,x1,x2,x3,x4) => ({type: x0,data: x1,premultiplyAlpha: x2,colorSpaceConversion: x3,preferAnimation: x4}),
      _265: x0 => new window.ImageDecoder(x0),
      _266: x0 => ({frameIndex: x0}),
      _267: (x0,x1) => x0.decode(x1),
      _268: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._268(f,arguments.length,x0) }),
      _269: (x0,x1) => x0.getModifierState(x1),
      _270: (x0,x1) => x0.removeProperty(x1),
      _271: (x0,x1) => x0.prepend(x1),
      _272: x0 => x0.disconnect(),
      _273: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._273(f,arguments.length,x0) }),
      _274: (x0,x1) => x0.getAttribute(x1),
      _275: (x0,x1) => x0.contains(x1),
      _276: x0 => x0.blur(),
      _277: x0 => x0.hasFocus(),
      _278: (x0,x1) => x0.hasAttribute(x1),
      _279: (x0,x1) => x0.getModifierState(x1),
      _280: (x0,x1) => x0.appendChild(x1),
      _281: (x0,x1) => x0.createTextNode(x1),
      _282: (x0,x1) => x0.removeAttribute(x1),
      _283: x0 => x0.getBoundingClientRect(),
      _284: (x0,x1) => x0.observe(x1),
      _285: x0 => x0.disconnect(),
      _286: (x0,x1) => x0.closest(x1),
      _708: () => globalThis.window.flutterConfiguration,
      _710: x0 => x0.assetBase,
      _716: x0 => x0.debugShowSemanticsNodes,
      _717: x0 => x0.hostElement,
      _718: x0 => x0.multiViewEnabled,
      _719: x0 => x0.nonce,
      _721: x0 => x0.fontFallbackBaseUrl,
      _731: x0 => x0.console,
      _732: x0 => x0.devicePixelRatio,
      _733: x0 => x0.document,
      _734: x0 => x0.history,
      _735: x0 => x0.innerHeight,
      _736: x0 => x0.innerWidth,
      _737: x0 => x0.location,
      _738: x0 => x0.navigator,
      _739: x0 => x0.visualViewport,
      _740: x0 => x0.performance,
      _742: x0 => x0.URL,
      _744: (x0,x1) => x0.getComputedStyle(x1),
      _745: x0 => x0.screen,
      _746: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._746(f,arguments.length,x0) }),
      _747: (x0,x1) => x0.requestAnimationFrame(x1),
      _752: (x0,x1) => x0.warn(x1),
      _754: (x0,x1) => x0.debug(x1),
      _755: x0 => globalThis.parseFloat(x0),
      _756: () => globalThis.window,
      _757: () => globalThis.Intl,
      _758: () => globalThis.Symbol,
      _759: (x0,x1,x2,x3,x4) => globalThis.createImageBitmap(x0,x1,x2,x3,x4),
      _761: x0 => x0.clipboard,
      _762: x0 => x0.maxTouchPoints,
      _763: x0 => x0.vendor,
      _764: x0 => x0.language,
      _765: x0 => x0.platform,
      _766: x0 => x0.userAgent,
      _767: (x0,x1) => x0.vibrate(x1),
      _768: x0 => x0.languages,
      _769: x0 => x0.documentElement,
      _770: (x0,x1) => x0.querySelector(x1),
      _773: (x0,x1) => x0.createElement(x1),
      _776: (x0,x1) => x0.createEvent(x1),
      _777: x0 => x0.activeElement,
      _780: x0 => x0.head,
      _781: x0 => x0.body,
      _783: (x0,x1) => { x0.title = x1 },
      _786: x0 => x0.visibilityState,
      _787: () => globalThis.document,
      _788: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._788(f,arguments.length,x0) }),
      _789: (x0,x1) => x0.dispatchEvent(x1),
      _797: x0 => x0.target,
      _799: x0 => x0.timeStamp,
      _800: x0 => x0.type,
      _802: (x0,x1,x2,x3) => x0.initEvent(x1,x2,x3),
      _808: x0 => x0.baseURI,
      _809: x0 => x0.firstChild,
      _813: x0 => x0.parentElement,
      _815: (x0,x1) => { x0.textContent = x1 },
      _816: x0 => x0.parentNode,
      _818: x0 => x0.isConnected,
      _822: x0 => x0.firstElementChild,
      _824: x0 => x0.nextElementSibling,
      _825: x0 => x0.clientHeight,
      _826: x0 => x0.clientWidth,
      _827: x0 => x0.offsetHeight,
      _828: x0 => x0.offsetWidth,
      _829: x0 => x0.id,
      _830: (x0,x1) => { x0.id = x1 },
      _833: (x0,x1) => { x0.spellcheck = x1 },
      _834: x0 => x0.tagName,
      _835: x0 => x0.style,
      _837: (x0,x1) => x0.querySelectorAll(x1),
      _838: (x0,x1,x2) => x0.setAttribute(x1,x2),
      _839: x0 => x0.tabIndex,
      _840: (x0,x1) => { x0.tabIndex = x1 },
      _841: (x0,x1) => x0.focus(x1),
      _842: x0 => x0.scrollTop,
      _843: (x0,x1) => { x0.scrollTop = x1 },
      _844: x0 => x0.scrollLeft,
      _845: (x0,x1) => { x0.scrollLeft = x1 },
      _846: x0 => x0.classList,
      _848: (x0,x1) => { x0.className = x1 },
      _850: (x0,x1) => x0.getElementsByClassName(x1),
      _851: (x0,x1) => x0.attachShadow(x1),
      _854: x0 => x0.computedStyleMap(),
      _855: (x0,x1) => x0.get(x1),
      _861: (x0,x1) => x0.getPropertyValue(x1),
      _862: (x0,x1,x2,x3) => x0.setProperty(x1,x2,x3),
      _863: x0 => x0.offsetLeft,
      _864: x0 => x0.offsetTop,
      _865: x0 => x0.offsetParent,
      _867: (x0,x1) => { x0.name = x1 },
      _868: x0 => x0.content,
      _869: (x0,x1) => { x0.content = x1 },
      _873: (x0,x1) => { x0.src = x1 },
      _874: x0 => x0.naturalWidth,
      _875: x0 => x0.naturalHeight,
      _879: (x0,x1) => { x0.crossOrigin = x1 },
      _881: (x0,x1) => { x0.decoding = x1 },
      _882: x0 => x0.decode(),
      _887: (x0,x1) => { x0.nonce = x1 },
      _892: (x0,x1) => { x0.width = x1 },
      _894: (x0,x1) => { x0.height = x1 },
      _897: (x0,x1) => x0.getContext(x1),
      _958: x0 => x0.width,
      _959: x0 => x0.height,
      _961: (x0,x1) => x0.fetch(x1),
      _962: x0 => x0.status,
      _964: x0 => x0.body,
      _965: x0 => x0.arrayBuffer(),
      _968: x0 => x0.read(),
      _969: x0 => x0.value,
      _970: x0 => x0.done,
      _977: x0 => x0.name,
      _978: x0 => x0.x,
      _979: x0 => x0.y,
      _982: x0 => x0.top,
      _983: x0 => x0.right,
      _984: x0 => x0.bottom,
      _985: x0 => x0.left,
      _997: x0 => x0.height,
      _998: x0 => x0.width,
      _999: x0 => x0.scale,
      _1000: (x0,x1) => { x0.value = x1 },
      _1003: (x0,x1) => { x0.placeholder = x1 },
      _1005: (x0,x1) => { x0.name = x1 },
      _1006: x0 => x0.selectionDirection,
      _1007: x0 => x0.selectionStart,
      _1008: x0 => x0.selectionEnd,
      _1011: x0 => x0.value,
      _1013: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      _1014: x0 => x0.readText(),
      _1015: (x0,x1) => x0.writeText(x1),
      _1017: x0 => x0.altKey,
      _1018: x0 => x0.code,
      _1019: x0 => x0.ctrlKey,
      _1020: x0 => x0.key,
      _1021: x0 => x0.keyCode,
      _1022: x0 => x0.location,
      _1023: x0 => x0.metaKey,
      _1024: x0 => x0.repeat,
      _1025: x0 => x0.shiftKey,
      _1026: x0 => x0.isComposing,
      _1028: x0 => x0.state,
      _1029: (x0,x1) => x0.go(x1),
      _1031: (x0,x1,x2,x3) => x0.pushState(x1,x2,x3),
      _1032: (x0,x1,x2,x3) => x0.replaceState(x1,x2,x3),
      _1033: x0 => x0.pathname,
      _1034: x0 => x0.search,
      _1035: x0 => x0.hash,
      _1039: x0 => x0.state,
      _1042: (x0,x1) => x0.createObjectURL(x1),
      _1044: x0 => new Blob(x0),
      _1046: x0 => new MutationObserver(x0),
      _1047: (x0,x1,x2) => x0.observe(x1,x2),
      _1048: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1048(f,arguments.length,x0,x1) }),
      _1051: x0 => x0.attributeName,
      _1052: x0 => x0.type,
      _1053: x0 => x0.matches,
      _1054: x0 => x0.matches,
      _1058: x0 => x0.relatedTarget,
      _1060: x0 => x0.clientX,
      _1061: x0 => x0.clientY,
      _1062: x0 => x0.offsetX,
      _1063: x0 => x0.offsetY,
      _1066: x0 => x0.button,
      _1067: x0 => x0.buttons,
      _1068: x0 => x0.ctrlKey,
      _1072: x0 => x0.pointerId,
      _1073: x0 => x0.pointerType,
      _1074: x0 => x0.pressure,
      _1075: x0 => x0.tiltX,
      _1076: x0 => x0.tiltY,
      _1077: x0 => x0.getCoalescedEvents(),
      _1080: x0 => x0.deltaX,
      _1081: x0 => x0.deltaY,
      _1082: x0 => x0.wheelDeltaX,
      _1083: x0 => x0.wheelDeltaY,
      _1084: x0 => x0.deltaMode,
      _1091: x0 => x0.changedTouches,
      _1094: x0 => x0.clientX,
      _1095: x0 => x0.clientY,
      _1098: x0 => x0.data,
      _1101: (x0,x1) => { x0.disabled = x1 },
      _1103: (x0,x1) => { x0.type = x1 },
      _1104: (x0,x1) => { x0.max = x1 },
      _1105: (x0,x1) => { x0.min = x1 },
      _1106: (x0,x1) => { x0.value = x1 },
      _1107: x0 => x0.value,
      _1108: (x0,x1) => { x0.disabled = x1 },
      _1109: x0 => x0.disabled,
      _1111: (x0,x1) => { x0.placeholder = x1 },
      _1113: (x0,x1) => { x0.name = x1 },
      _1114: (x0,x1) => { x0.autocomplete = x1 },
      _1116: x0 => x0.selectionDirection,
      _1117: x0 => x0.selectionStart,
      _1119: x0 => x0.selectionEnd,
      _1122: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      _1123: (x0,x1) => x0.add(x1),
      _1126: (x0,x1) => { x0.noValidate = x1 },
      _1127: (x0,x1) => { x0.method = x1 },
      _1128: (x0,x1) => { x0.action = x1 },
      _1129: (x0,x1) => new OffscreenCanvas(x0,x1),
      _1135: (x0,x1) => x0.getContext(x1),
      _1137: x0 => x0.convertToBlob(),
      _1154: x0 => x0.orientation,
      _1155: x0 => x0.width,
      _1156: x0 => x0.height,
      _1157: (x0,x1) => x0.lock(x1),
      _1176: x0 => new ResizeObserver(x0),
      _1179: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1179(f,arguments.length,x0,x1) }),
      _1187: x0 => x0.length,
      _1188: x0 => x0.iterator,
      _1189: x0 => x0.Segmenter,
      _1190: x0 => x0.v8BreakIterator,
      _1191: (x0,x1) => new Intl.Segmenter(x0,x1),
      _1192: x0 => x0.done,
      _1193: x0 => x0.value,
      _1194: x0 => x0.index,
      _1198: (x0,x1) => new Intl.v8BreakIterator(x0,x1),
      _1199: (x0,x1) => x0.adoptText(x1),
      _1200: x0 => x0.first(),
      _1201: x0 => x0.next(),
      _1202: x0 => x0.current(),
      _1213: x0 => x0.hostElement,
      _1214: x0 => x0.viewConstraints,
      _1217: x0 => x0.maxHeight,
      _1218: x0 => x0.maxWidth,
      _1219: x0 => x0.minHeight,
      _1220: x0 => x0.minWidth,
      _1221: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1221(f,arguments.length,x0) }),
      _1222: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1222(f,arguments.length,x0) }),
      _1223: (x0,x1) => ({addView: x0,removeView: x1}),
      _1226: x0 => x0.loader,
      _1227: () => globalThis._flutter,
      _1228: (x0,x1) => x0.didCreateEngineInitializer(x1),
      _1229: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1229(f,arguments.length,x0) }),
      _1230: f => finalizeWrapper(f, function() { return dartInstance.exports._1230(f,arguments.length) }),
      _1231: (x0,x1) => ({initializeEngine: x0,autoStart: x1}),
      _1234: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1234(f,arguments.length,x0) }),
      _1235: x0 => ({runApp: x0}),
      _1237: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1237(f,arguments.length,x0,x1) }),
      _1238: x0 => x0.length,
      _1239: () => globalThis.window.ImageDecoder,
      _1240: x0 => x0.tracks,
      _1242: x0 => x0.completed,
      _1244: x0 => x0.image,
      _1250: x0 => x0.displayWidth,
      _1251: x0 => x0.displayHeight,
      _1252: x0 => x0.duration,
      _1255: x0 => x0.ready,
      _1256: x0 => x0.selectedTrack,
      _1257: x0 => x0.repetitionCount,
      _1258: x0 => x0.frameCount,
      _1306: (x0,x1) => x0.createElement(x1),
      _1312: (x0,x1,x2) => x0.addEventListener(x1,x2),
      _1313: x0 => x0.preventDefault(),
      _1314: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1314(f,arguments.length,x0) }),
      _1315: (x0,x1,x2) => x0.addEventListener(x1,x2),
      _1316: (x0,x1,x2) => x0.removeEventListener(x1,x2),
      _1324: x0 => ({type: x0}),
      _1325: (x0,x1) => new Blob(x0,x1),
      _1330: x0 => x0.arrayBuffer(),
      _1336: x0 => x0.cancel(),
      _1339: x0 => x0.read(),
      _1340: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1340(f,arguments.length,x0) }),
      _1341: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      _1342: (x0,x1,x2,x3) => x0.removeEventListener(x1,x2,x3),
      _1343: (x0,x1) => x0.createElement(x1),
      _1344: (x0,x1,x2) => x0.setAttribute(x1,x2),
      _1350: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
      _1351: (x0,x1) => x0.canShare(x1),
      _1352: (x0,x1) => x0.share(x1),
      _1354: (x0,x1,x2) => ({files: x0,title: x1,text: x2}),
      _1355: (x0,x1) => ({files: x0,text: x1}),
      _1356: (x0,x1) => ({files: x0,title: x1}),
      _1357: x0 => ({files: x0}),
      _1358: (x0,x1) => ({title: x0,text: x1}),
      _1360: x0 => x0.click(),
      _1361: x0 => x0.remove(),
      _1366: x0 => globalThis.URL.createObjectURL(x0),
      _1372: (x0,x1) => x0.querySelector(x1),
      _1373: (x0,x1) => x0.append(x1),
      _1375: (x0,x1) => globalThis.enableVirtualBackground(x0,x1),
      _1376: () => globalThis.disableVirtualBackground(),
      _1377: x0 => new MediaStream(x0),
      _1378: () => new MediaStream(),
      _1379: x0 => x0.getVideoTracks(),
      _1380: (x0,x1) => x0.addTrack(x1),
      _1381: x0 => x0.getAudioTracks(),
      _1382: (x0,x1) => x0.getElementById(x1),
      _1383: x0 => x0.load(),
      _1386: x0 => x0.decode(),
      _1387: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
      _1388: (x0,x1,x2) => x0.setRequestHeader(x1,x2),
      _1389: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1389(f,arguments.length,x0) }),
      _1390: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1390(f,arguments.length,x0) }),
      _1391: x0 => x0.send(),
      _1392: () => new XMLHttpRequest(),
      _1393: x0 => globalThis.Wakelock.toggle(x0),
      _1415: x0 => x0.toJSON(),
      _1416: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1416(f,arguments.length,x0) }),
      _1417: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1417(f,arguments.length,x0) }),
      _1418: (x0,x1,x2) => x0.onAuthStateChanged(x1,x2),
      _1419: x0 => x0.call(),
      _1420: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1420(f,arguments.length,x0) }),
      _1421: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1421(f,arguments.length,x0) }),
      _1422: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1422(f,arguments.length,x0) }),
      _1423: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1423(f,arguments.length,x0) }),
      _1424: (x0,x1,x2) => x0.onIdTokenChanged(x1,x2),
      _1433: (x0,x1) => globalThis.firebase_auth.setPersistence(x0,x1),
      _1436: x0 => globalThis.firebase_auth.signInAnonymously(x0),
      _1444: (x0,x1) => globalThis.firebase_auth.connectAuthEmulator(x0,x1),
      _1467: x0 => globalThis.firebase_auth.OAuthProvider.credentialFromResult(x0),
      _1482: x0 => globalThis.firebase_auth.getAdditionalUserInfo(x0),
      _1483: (x0,x1,x2) => ({errorMap: x0,persistence: x1,popupRedirectResolver: x2}),
      _1484: (x0,x1) => globalThis.firebase_auth.initializeAuth(x0,x1),
      _1490: x0 => globalThis.firebase_auth.OAuthProvider.credentialFromError(x0),
      _1505: () => globalThis.firebase_auth.debugErrorMap,
      _1506: () => globalThis.firebase_auth.inMemoryPersistence,
      _1508: () => globalThis.firebase_auth.browserSessionPersistence,
      _1510: () => globalThis.firebase_auth.browserLocalPersistence,
      _1512: () => globalThis.firebase_auth.indexedDBLocalPersistence,
      _1515: x0 => globalThis.firebase_auth.multiFactor(x0),
      _1516: (x0,x1) => globalThis.firebase_auth.getMultiFactorResolver(x0,x1),
      _1532: x0 => x0.displayName,
      _1533: x0 => x0.email,
      _1534: x0 => x0.phoneNumber,
      _1535: x0 => x0.photoURL,
      _1536: x0 => x0.providerId,
      _1537: x0 => x0.uid,
      _1538: x0 => x0.emailVerified,
      _1539: x0 => x0.isAnonymous,
      _1540: x0 => x0.providerData,
      _1541: x0 => x0.refreshToken,
      _1542: x0 => x0.tenantId,
      _1543: x0 => x0.metadata,
      _1545: x0 => x0.providerId,
      _1546: x0 => x0.signInMethod,
      _1547: x0 => x0.accessToken,
      _1548: x0 => x0.idToken,
      _1549: x0 => x0.secret,
      _1560: x0 => x0.creationTime,
      _1561: x0 => x0.lastSignInTime,
      _1566: x0 => x0.code,
      _1568: x0 => x0.message,
      _1580: x0 => x0.email,
      _1581: x0 => x0.phoneNumber,
      _1582: x0 => x0.tenantId,
      _1605: x0 => x0.user,
      _1608: x0 => x0.providerId,
      _1609: x0 => x0.profile,
      _1610: x0 => x0.username,
      _1611: x0 => x0.isNewUser,
      _1614: () => globalThis.firebase_auth.browserPopupRedirectResolver,
      _1619: x0 => x0.displayName,
      _1620: x0 => x0.enrollmentTime,
      _1621: x0 => x0.factorId,
      _1622: x0 => x0.uid,
      _1624: x0 => x0.hints,
      _1625: x0 => x0.session,
      _1627: x0 => x0.phoneNumber,
      _1639: (x0,x1) => x0.getItem(x1),
      _1643: (x0,x1) => x0.appendChild(x1),
      _1647: () => new AudioContext(),
      _1648: (x0,x1) => x0.createMediaElementSource(x1),
      _1649: x0 => x0.createStereoPanner(),
      _1650: (x0,x1) => x0.connect(x1),
      _1651: x0 => x0.play(),
      _1652: x0 => x0.pause(),
      _1653: (x0,x1) => x0.removeItem(x1),
      _1654: (x0,x1,x2) => x0.setItem(x1,x2),
      _1658: (x0,x1) => x0.getUserMedia(x1),
      _1659: x0 => x0.stop(),
      _1670: (x0,x1) => x0.item(x1),
      _1671: () => new FileReader(),
      _1673: (x0,x1) => x0.readAsArrayBuffer(x1),
      _1674: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1674(f,arguments.length,x0) }),
      _1675: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1675(f,arguments.length,x0) }),
      _1676: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1676(f,arguments.length,x0) }),
      _1677: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1677(f,arguments.length,x0) }),
      _1678: (x0,x1) => x0.removeChild(x1),
      _1681: x0 => x0.deviceMemory,
      _1683: (x0,x1,x2,x3,x4,x5,x6,x7) => ({apiKey: x0,authDomain: x1,databaseURL: x2,projectId: x3,storageBucket: x4,messagingSenderId: x5,measurementId: x6,appId: x7}),
      _1684: (x0,x1) => globalThis.firebase_core.initializeApp(x0,x1),
      _1685: x0 => globalThis.firebase_core.getApp(x0),
      _1686: () => globalThis.firebase_core.getApp(),
      _1716: () => globalThis.firebase_core.SDK_VERSION,
      _1722: x0 => x0.apiKey,
      _1724: x0 => x0.authDomain,
      _1726: x0 => x0.databaseURL,
      _1728: x0 => x0.projectId,
      _1730: x0 => x0.storageBucket,
      _1732: x0 => x0.messagingSenderId,
      _1734: x0 => x0.measurementId,
      _1736: x0 => x0.appId,
      _1738: x0 => x0.name,
      _1739: x0 => x0.options,
      _1740: (x0,x1) => x0.debug(x1),
      _1741: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1741(f,arguments.length,x0) }),
      _1742: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1742(f,arguments.length,x0,x1) }),
      _1743: (x0,x1) => ({createScript: x0,createScriptURL: x1}),
      _1744: (x0,x1,x2) => x0.createPolicy(x1,x2),
      _1745: (x0,x1) => x0.createScriptURL(x1),
      _1746: (x0,x1,x2) => x0.createScript(x1,x2),
      _1747: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1747(f,arguments.length,x0) }),
      _1748: () => globalThis.removeSplashFromWeb(),
      _1750: Date.now,
      _1752: s => new Date(s * 1000).getTimezoneOffset() * 60,
      _1753: s => {
        if (!/^\s*[+-]?(?:Infinity|NaN|(?:\.\d+|\d+(?:\.\d*)?)(?:[eE][+-]?\d+)?)\s*$/.test(s)) {
          return NaN;
        }
        return parseFloat(s);
      },
      _1754: () => {
        let stackString = new Error().stack.toString();
        let frames = stackString.split('\n');
        let drop = 2;
        if (frames[0] === 'Error') {
            drop += 1;
        }
        return frames.slice(drop).join('\n');
      },
      _1755: () => typeof dartUseDateNowForTicks !== "undefined",
      _1756: () => 1000 * performance.now(),
      _1757: () => Date.now(),
      _1758: () => {
        // On browsers return `globalThis.location.href`
        if (globalThis.location != null) {
          return globalThis.location.href;
        }
        return null;
      },
      _1759: () => {
        return typeof process != "undefined" &&
               Object.prototype.toString.call(process) == "[object process]" &&
               process.platform == "win32"
      },
      _1760: () => new WeakMap(),
      _1761: (map, o) => map.get(o),
      _1762: (map, o, v) => map.set(o, v),
      _1763: x0 => new WeakRef(x0),
      _1764: x0 => x0.deref(),
      _1771: () => globalThis.WeakRef,
      _1774: s => JSON.stringify(s),
      _1775: s => printToConsole(s),
      _1776: (o, p, r) => o.replaceAll(p, () => r),
      _1777: (o, p, r) => o.replace(p, () => r),
      _1778: Function.prototype.call.bind(String.prototype.toLowerCase),
      _1779: s => s.toUpperCase(),
      _1780: s => s.trim(),
      _1781: s => s.trimLeft(),
      _1782: s => s.trimRight(),
      _1783: (string, times) => string.repeat(times),
      _1784: Function.prototype.call.bind(String.prototype.indexOf),
      _1785: (s, p, i) => s.lastIndexOf(p, i),
      _1786: (string, token) => string.split(token),
      _1787: Object.is,
      _1788: o => o instanceof Array,
      _1789: (a, i) => a.push(i),
      _1790: (a, i) => a.splice(i, 1)[0],
      _1792: (a, l) => a.length = l,
      _1793: a => a.pop(),
      _1794: (a, i) => a.splice(i, 1),
      _1795: (a, s) => a.join(s),
      _1796: (a, s, e) => a.slice(s, e),
      _1798: (a, b) => a == b ? 0 : (a > b ? 1 : -1),
      _1799: a => a.length,
      _1800: (a, l) => a.length = l,
      _1801: (a, i) => a[i],
      _1802: (a, i, v) => a[i] = v,
      _1804: o => {
        if (o instanceof ArrayBuffer) return 0;
        if (globalThis.SharedArrayBuffer !== undefined &&
            o instanceof SharedArrayBuffer) {
          return 1;
        }
        return 2;
      },
      _1805: (o, offsetInBytes, lengthInBytes) => {
        var dst = new ArrayBuffer(lengthInBytes);
        new Uint8Array(dst).set(new Uint8Array(o, offsetInBytes, lengthInBytes));
        return new DataView(dst);
      },
      _1807: o => o instanceof Uint8Array,
      _1808: (o, start, length) => new Uint8Array(o.buffer, o.byteOffset + start, length),
      _1809: o => o instanceof Int8Array,
      _1810: (o, start, length) => new Int8Array(o.buffer, o.byteOffset + start, length),
      _1811: o => o instanceof Uint8ClampedArray,
      _1812: (o, start, length) => new Uint8ClampedArray(o.buffer, o.byteOffset + start, length),
      _1813: o => o instanceof Uint16Array,
      _1814: (o, start, length) => new Uint16Array(o.buffer, o.byteOffset + start, length),
      _1815: o => o instanceof Int16Array,
      _1816: (o, start, length) => new Int16Array(o.buffer, o.byteOffset + start, length),
      _1817: o => o instanceof Uint32Array,
      _1818: (o, start, length) => new Uint32Array(o.buffer, o.byteOffset + start, length),
      _1819: o => o instanceof Int32Array,
      _1820: (o, start, length) => new Int32Array(o.buffer, o.byteOffset + start, length),
      _1822: (o, start, length) => new BigInt64Array(o.buffer, o.byteOffset + start, length),
      _1823: o => o instanceof Float32Array,
      _1824: (o, start, length) => new Float32Array(o.buffer, o.byteOffset + start, length),
      _1825: o => o instanceof Float64Array,
      _1826: (o, start, length) => new Float64Array(o.buffer, o.byteOffset + start, length),
      _1827: (t, s) => t.set(s),
      _1828: l => new DataView(new ArrayBuffer(l)),
      _1829: (o) => new DataView(o.buffer, o.byteOffset, o.byteLength),
      _1830: o => o.byteLength,
      _1831: o => o.buffer,
      _1832: o => o.byteOffset,
      _1833: Function.prototype.call.bind(Object.getOwnPropertyDescriptor(DataView.prototype, 'byteLength').get),
      _1834: (b, o) => new DataView(b, o),
      _1835: (b, o, l) => new DataView(b, o, l),
      _1836: Function.prototype.call.bind(DataView.prototype.getUint8),
      _1837: Function.prototype.call.bind(DataView.prototype.setUint8),
      _1838: Function.prototype.call.bind(DataView.prototype.getInt8),
      _1839: Function.prototype.call.bind(DataView.prototype.setInt8),
      _1840: Function.prototype.call.bind(DataView.prototype.getUint16),
      _1841: Function.prototype.call.bind(DataView.prototype.setUint16),
      _1842: Function.prototype.call.bind(DataView.prototype.getInt16),
      _1843: Function.prototype.call.bind(DataView.prototype.setInt16),
      _1844: Function.prototype.call.bind(DataView.prototype.getUint32),
      _1845: Function.prototype.call.bind(DataView.prototype.setUint32),
      _1846: Function.prototype.call.bind(DataView.prototype.getInt32),
      _1847: Function.prototype.call.bind(DataView.prototype.setInt32),
      _1848: Function.prototype.call.bind(DataView.prototype.getBigUint64),
      _1850: Function.prototype.call.bind(DataView.prototype.getBigInt64),
      _1851: Function.prototype.call.bind(DataView.prototype.setBigInt64),
      _1852: Function.prototype.call.bind(DataView.prototype.getFloat32),
      _1853: Function.prototype.call.bind(DataView.prototype.setFloat32),
      _1854: Function.prototype.call.bind(DataView.prototype.getFloat64),
      _1855: Function.prototype.call.bind(DataView.prototype.setFloat64),
      _1868: (ms, c) =>
      setTimeout(() => dartInstance.exports.$invokeCallback(c),ms),
      _1869: (handle) => clearTimeout(handle),
      _1870: (ms, c) =>
      setInterval(() => dartInstance.exports.$invokeCallback(c), ms),
      _1871: (handle) => clearInterval(handle),
      _1872: (c) =>
      queueMicrotask(() => dartInstance.exports.$invokeCallback(c)),
      _1873: () => Date.now(),
      _1878: o => Object.keys(o),
      _1879: (x0,x1) => x0.postMessage(x1),
      _1880: x0 => new Worker(x0),
      _1881: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1881(f,arguments.length,x0) }),
      _1882: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1882(f,arguments.length,x0) }),
      _1883: (x0,x1) => new RTCRtpScriptTransform(x0,x1),
      _1884: (x0,x1,x2) => x0.postMessage(x1,x2),
      _1886: x0 => globalThis.RTCRtpReceiver.getCapabilities(x0),
      _1887: x0 => new RTCPeerConnection(x0),
      _1888: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1888(f,arguments.length,x0) }),
      _1889: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1889(f,arguments.length,x0) }),
      _1890: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1890(f,arguments.length,x0) }),
      _1891: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1891(f,arguments.length,x0) }),
      _1892: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1892(f,arguments.length,x0) }),
      _1893: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1893(f,arguments.length,x0) }),
      _1894: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1894(f,arguments.length,x0) }),
      _1895: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1895(f,arguments.length,x0) }),
      _1896: x0 => x0.close(),
      _1898: (x0,x1) => x0.createOffer(x1),
      _1899: (x0,x1) => x0.createAnswer(x1),
      _1902: (x0,x1) => ({type: x0,sdp: x1}),
      _1903: (x0,x1) => x0.setLocalDescription(x1),
      _1904: (x0,x1) => ({type: x0,sdp: x1}),
      _1905: (x0,x1) => x0.setRemoteDescription(x1),
      _1906: (x0,x1,x2) => ({candidate: x0,sdpMid: x1,sdpMLineIndex: x2}),
      _1907: (x0,x1) => x0.addIceCandidate(x1),
      _1909: x0 => x0.getStats(),
      _1910: x0 => globalThis.Object.keys(x0),
      _1911: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._1911(f,arguments.length,x0,x1) }),
      _1914: (x0,x1,x2,x3) => ({ordered: x0,protocol: x1,negotiated: x2,id: x3}),
      _1915: (x0,x1,x2) => x0.createDataChannel(x1,x2),
      _1919: (x0,x1) => x0.removeTrack(x1),
      _1920: x0 => x0.getSenders(),
      _1923: (x0,x1,x2) => x0.addTransceiver(x1,x2),
      _1925: (x0,x1) => { x0.binaryType = x1 },
      _1926: x0 => new WebSocket(x0),
      _1927: (x0,x1) => new WebSocket(x0,x1),
      _1928: (x0,x1) => x0.send(x1),
      _1929: x0 => x0.close(),
      _1930: () => new XMLHttpRequest(),
      _1931: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
      _1932: (x0,x1,x2) => x0.setRequestHeader(x1,x2),
      _1933: (x0,x1) => x0.getResponseHeader(x1),
      _1934: (x0,x1) => x0.send(x1),
      _1935: x0 => x0.abort(),
      _1936: (x0,x1,x2) => x0.open(x1,x2),
      _1937: x0 => x0.send(),
      _1938: x0 => x0.getAllResponseHeaders(),
      _1939: (x0,x1,x2) => x0.transaction(x1,x2),
      _1940: (x0,x1) => x0.objectStore(x1),
      _1941: (x0,x1) => x0.getAllKeys(x1),
      _1942: (x0,x1) => x0.getAll(x1),
      _1944: (x0,x1) => x0.delete(x1),
      _1945: (x0,x1,x2) => x0.put(x1,x2),
      _1947: x0 => x0.close(),
      _1949: (x0,x1,x2) => x0.open(x1,x2),
      _1950: (x0,x1) => x0.contains(x1),
      _1953: (x0,x1) => x0.createObjectStore(x1),
      _1954: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1954(f,arguments.length,x0) }),
      _1955: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1955(f,arguments.length,x0) }),
      _1990: (x0,x1) => x0.setCodecPreferences(x1),
      _1991: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1991(f,arguments.length,x0) }),
      _1992: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1992(f,arguments.length,x0) }),
      _1993: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1993(f,arguments.length,x0) }),
      _1994: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._1994(f,arguments.length,x0) }),
      _1996: x0 => x0.close(),
      _1997: (x0,x1) => ({video: x0,audio: x1}),
      _1998: (x0,x1) => x0.getDisplayMedia(x1),
      _1999: x0 => x0.enumerateDevices(),
      _2002: (x0,x1) => x0.replaceTrack(x1),
      _2005: x0 => x0.getStats(),
      _2006: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._2006(f,arguments.length,x0,x1) }),
      _2007: x0 => x0.getStats(),
      _2008: f => finalizeWrapper(f, function(x0,x1) { return dartInstance.exports._2008(f,arguments.length,x0,x1) }),
      _2010: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2010(f,arguments.length,x0) }),
      _2011: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2011(f,arguments.length,x0) }),
      _2012: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2012(f,arguments.length,x0) }),
      _2023: (x0,x1) => x0.removeTrack(x1),
      _2033: (x0,x1) => x0.item(x1),
      _2034: (x0,x1,x2,x3,x4,x5) => ({method: x0,headers: x1,body: x2,credentials: x3,redirect: x4,signal: x5}),
      _2035: (x0,x1) => globalThis.fetch(x0,x1),
      _2036: (x0,x1) => x0.get(x1),
      _2037: f => finalizeWrapper(f, function(x0,x1,x2) { return dartInstance.exports._2037(f,arguments.length,x0,x1,x2) }),
      _2038: (x0,x1) => x0.forEach(x1),
      _2039: x0 => x0.abort(),
      _2040: () => new AbortController(),
      _2041: x0 => x0.getReader(),
      _2042: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2042(f,arguments.length,x0) }),
      _2043: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2043(f,arguments.length,x0) }),
      _2044: x0 => x0.openCursor(),
      _2045: x0 => x0.continue(),
      _2046: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2046(f,arguments.length,x0) }),
      _2047: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2047(f,arguments.length,x0) }),
      _2050: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2050(f,arguments.length,x0) }),
      _2051: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._2051(f,arguments.length,x0) }),
      _2059: (x0,x1) => x0.key(x1),
      _2060: x0 => x0.trustedTypes,
      _2061: (x0,x1) => { x0.text = x1 },
      _2070: (s, m) => {
        try {
          return new RegExp(s, m);
        } catch (e) {
          return String(e);
        }
      },
      _2071: (x0,x1) => x0.exec(x1),
      _2072: (x0,x1) => x0.test(x1),
      _2073: x0 => x0.pop(),
      _2075: o => o === undefined,
      _2077: o => typeof o === 'function' && o[jsWrappedDartFunctionSymbol] === true,
      _2079: o => {
        const proto = Object.getPrototypeOf(o);
        return proto === Object.prototype || proto === null;
      },
      _2080: o => o instanceof RegExp,
      _2081: (l, r) => l === r,
      _2082: o => o,
      _2083: o => o,
      _2084: o => o,
      _2085: b => !!b,
      _2086: o => o.length,
      _2088: (o, i) => o[i],
      _2089: f => f.dartFunction,
      _2090: () => ({}),
      _2091: () => [],
      _2093: () => globalThis,
      _2094: (constructor, args) => {
        const factoryFunction = constructor.bind.apply(
            constructor, [null, ...args]);
        return new factoryFunction();
      },
      _2095: (o, p) => p in o,
      _2096: (o, p) => o[p],
      _2097: (o, p, v) => o[p] = v,
      _2098: (o, m, a) => o[m].apply(o, a),
      _2100: o => String(o),
      _2101: (p, s, f) => p.then(s, (e) => f(e, e === undefined)),
      _2102: o => {
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
        // Feature check for `SharedArrayBuffer` before doing a type-check.
        if (globalThis.SharedArrayBuffer !== undefined &&
            o instanceof SharedArrayBuffer) {
            return 17;
        }
        return 18;
      },
      _2103: o => [o],
      _2104: (o0, o1) => [o0, o1],
      _2105: (o0, o1, o2) => [o0, o1, o2],
      _2106: (o0, o1, o2, o3) => [o0, o1, o2, o3],
      _2107: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI8ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _2108: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI8ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _2111: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _2112: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _2113: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _2114: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _2115: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF64ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      _2116: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF64ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      _2117: x0 => new ArrayBuffer(x0),
      _2118: s => {
        if (/[[\]{}()*+?.\\^$|]/.test(s)) {
            s = s.replace(/[[\]{}()*+?.\\^$|]/g, '\\$&');
        }
        return s;
      },
      _2119: x0 => x0.input,
      _2120: x0 => x0.index,
      _2121: x0 => x0.groups,
      _2122: x0 => x0.flags,
      _2123: x0 => x0.multiline,
      _2124: x0 => x0.ignoreCase,
      _2125: x0 => x0.unicode,
      _2126: x0 => x0.dotAll,
      _2127: (x0,x1) => { x0.lastIndex = x1 },
      _2128: (o, p) => p in o,
      _2129: (o, p) => o[p],
      _2130: (o, p, v) => o[p] = v,
      _2131: (o, p) => delete o[p],
      _2132: x0 => x0.random(),
      _2133: (x0,x1) => x0.getRandomValues(x1),
      _2134: () => globalThis.crypto,
      _2135: () => globalThis.Math,
      _2136: Function.prototype.call.bind(Number.prototype.toString),
      _2137: Function.prototype.call.bind(BigInt.prototype.toString),
      _2138: Function.prototype.call.bind(Number.prototype.toString),
      _2139: (d, digits) => d.toFixed(digits),
      _2147: (x0,x1) => globalThis.startPictureInPicture(x0,x1),
      _2148: () => globalThis.document,
      _2154: (x0,x1) => { x0.height = x1 },
      _2156: (x0,x1) => { x0.width = x1 },
      _2165: x0 => x0.style,
      _2168: x0 => x0.src,
      _2169: (x0,x1) => { x0.src = x1 },
      _2170: x0 => x0.naturalWidth,
      _2171: x0 => x0.naturalHeight,
      _2187: x0 => x0.status,
      _2188: (x0,x1) => { x0.responseType = x1 },
      _2190: x0 => x0.response,
      _2227: x0 => x0.readyState,
      _2229: (x0,x1) => { x0.timeout = x1 },
      _2231: (x0,x1) => { x0.withCredentials = x1 },
      _2232: x0 => x0.upload,
      _2233: x0 => x0.responseURL,
      _2234: x0 => x0.status,
      _2235: x0 => x0.statusText,
      _2237: (x0,x1) => { x0.responseType = x1 },
      _2238: x0 => x0.response,
      _2239: x0 => x0.responseText,
      _2250: x0 => x0.loaded,
      _2251: x0 => x0.total,
      _2297: (x0,x1) => { x0.draggable = x1 },
      _2313: x0 => x0.style,
      _2672: (x0,x1) => { x0.download = x1 },
      _2697: (x0,x1) => { x0.href = x1 },
      _2885: x0 => x0.videoWidth,
      _2886: x0 => x0.videoHeight,
      _2915: x0 => x0.error,
      _2917: (x0,x1) => { x0.src = x1 },
      _2919: (x0,x1) => { x0.srcObject = x1 },
      _2922: (x0,x1) => { x0.crossOrigin = x1 },
      _2925: (x0,x1) => { x0.preload = x1 },
      _2929: x0 => x0.currentTime,
      _2930: (x0,x1) => { x0.currentTime = x1 },
      _2931: x0 => x0.duration,
      _2936: (x0,x1) => { x0.playbackRate = x1 },
      _2943: (x0,x1) => { x0.autoplay = x1 },
      _2945: (x0,x1) => { x0.loop = x1 },
      _2947: (x0,x1) => { x0.controls = x1 },
      _2949: (x0,x1) => { x0.volume = x1 },
      _2951: (x0,x1) => { x0.muted = x1 },
      _2966: x0 => x0.code,
      _2967: x0 => x0.message,
      _3238: (x0,x1) => { x0.accept = x1 },
      _3252: x0 => x0.files,
      _3278: (x0,x1) => { x0.multiple = x1 },
      _3296: (x0,x1) => { x0.type = x1 },
      _3545: x0 => x0.src,
      _3546: (x0,x1) => { x0.src = x1 },
      _3548: (x0,x1) => { x0.type = x1 },
      _3552: (x0,x1) => { x0.async = x1 },
      _3556: (x0,x1) => { x0.crossOrigin = x1 },
      _3558: (x0,x1) => { x0.text = x1 },
      _3566: (x0,x1) => { x0.charset = x1 },
      _4010: () => globalThis.window,
      _4049: x0 => x0.self,
      _4053: x0 => x0.location,
      _4072: x0 => x0.navigator,
      _4329: x0 => x0.indexedDB,
      _4334: x0 => x0.trustedTypes,
      _4335: x0 => x0.sessionStorage,
      _4336: x0 => x0.localStorage,
      _4347: x0 => x0.protocol,
      _4351: x0 => x0.hostname,
      _4353: x0 => x0.port,
      _4440: x0 => x0.geolocation,
      _4443: x0 => x0.mediaDevices,
      _4445: x0 => x0.permissions,
      _4446: x0 => x0.maxTouchPoints,
      _4453: x0 => x0.appCodeName,
      _4454: x0 => x0.appName,
      _4455: x0 => x0.appVersion,
      _4456: x0 => x0.platform,
      _4457: x0 => x0.product,
      _4458: x0 => x0.productSub,
      _4459: x0 => x0.userAgent,
      _4460: x0 => x0.vendor,
      _4461: x0 => x0.vendorSub,
      _4463: x0 => x0.language,
      _4464: x0 => x0.languages,
      _4470: x0 => x0.hardwareConcurrency,
      _4509: x0 => x0.data,
      _4660: x0 => x0.length,
      _4890: x0 => x0.binaryType,
      _4891: (x0,x1) => { x0.binaryType = x1 },
      _4947: x0 => x0.signalingState,
      _4948: x0 => x0.iceGatheringState,
      _4949: x0 => x0.iceConnectionState,
      _4950: x0 => x0.connectionState,
      _4963: (x0,x1) => { x0.onicegatheringstatechange = x1 },
      _4977: x0 => x0.type,
      _4979: x0 => x0.sdp,
      _4987: x0 => x0.candidate,
      _4988: x0 => x0.sdpMid,
      _4989: x0 => x0.sdpMLineIndex,
      _5011: x0 => x0.candidate,
      _5047: x0 => x0.track,
      _5050: (x0,x1) => { x0.transform = x1 },
      _5110: x0 => x0.codecs,
      _5112: x0 => x0.headerExtensions,
      _5120: x0 => x0.track,
      _5125: (x0,x1) => { x0.transform = x1 },
      _5137: x0 => x0.sender,
      _5180: x0 => x0.receiver,
      _5181: x0 => x0.track,
      _5182: x0 => x0.streams,
      _5183: x0 => x0.transceiver,
      _5199: x0 => x0.label,
      _5211: (x0,x1) => { x0.onopen = x1 },
      _5213: (x0,x1) => { x0.onbufferedamountlow = x1 },
      _5219: (x0,x1) => { x0.onclose = x1 },
      _5221: (x0,x1) => { x0.onmessage = x1 },
      _5228: (x0,x1) => { x0.maxPacketLifeTime = x1 },
      _5230: (x0,x1) => { x0.maxRetransmits = x1 },
      _5240: x0 => x0.channel,
      _6022: x0 => x0.destination,
      _6537: x0 => x0.target,
      _6577: x0 => x0.signal,
      _6589: x0 => x0.length,
      _6637: x0 => x0.firstChild,
      _6648: () => globalThis.document,
      _6729: x0 => x0.body,
      _6731: x0 => x0.head,
      _7060: (x0,x1) => { x0.id = x1 },
      _7087: x0 => x0.children,
      _7393: x0 => x0.clientX,
      _7394: x0 => x0.clientY,
      _7406: x0 => x0.offsetX,
      _7407: x0 => x0.offsetY,
      _8405: x0 => x0.value,
      _8407: x0 => x0.done,
      _8584: x0 => x0.size,
      _8585: x0 => x0.type,
      _8591: x0 => x0.name,
      _8597: x0 => x0.length,
      _8602: x0 => x0.result,
      _9096: x0 => x0.url,
      _9098: x0 => x0.status,
      _9100: x0 => x0.statusText,
      _9101: x0 => x0.headers,
      _9102: x0 => x0.body,
      _9883: x0 => x0.id,
      _9890: x0 => x0.kind,
      _9891: x0 => x0.id,
      _9892: x0 => x0.label,
      _9893: x0 => x0.enabled,
      _9894: (x0,x1) => { x0.enabled = x1 },
      _9895: x0 => x0.muted,
      _10212: x0 => x0.deviceId,
      _10213: x0 => x0.kind,
      _10214: x0 => x0.label,
      _10215: x0 => x0.groupId,
      _10540: x0 => x0.result,
      _10541: x0 => x0.error,
      _10546: (x0,x1) => { x0.onsuccess = x1 },
      _10548: (x0,x1) => { x0.onerror = x1 },
      _10552: (x0,x1) => { x0.onupgradeneeded = x1 },
      _10570: x0 => x0.version,
      _10571: x0 => x0.objectStoreNames,
      _10638: x0 => x0.key,
      _10641: x0 => x0.value,
      _11201: (x0,x1) => { x0.border = x1 },
      _11479: (x0,x1) => { x0.display = x1 },
      _11643: (x0,x1) => { x0.height = x1 },
      _11837: (x0,x1) => { x0.objectFit = x1 },
      _12265: (x0,x1) => { x0.transform = x1 },
      _12333: (x0,x1) => { x0.width = x1 },
      _12701: x0 => x0.name,
      _12702: x0 => x0.message,
      _13417: () => globalThis.console,
      _13444: x0 => x0.name,
      _13445: x0 => x0.message,
      _13446: x0 => x0.code,
      _13448: x0 => x0.customData,

    };

    const baseImports = {
      dart2wasm: dart2wasm,
      Math: Math,
      Date: Date,
      Object: Object,
      Array: Array,
      Reflect: Reflect,
      S: new Proxy({}, { get(_, prop) { return prop; } }),

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
      "intoCharCodeArray": (s, a, start) => {
        if (s === '') return 0;

        const write = dartInstance.exports.$wasmI16ArraySet;
        for (var i = 0; i < s.length; ++i) {
          write(a, start++, s.charCodeAt(i));
        }
        return s.length;
      },
      "test": (s) => typeof s == "string",
    };


    

    dartInstance = await WebAssembly.instantiate(this.module, {
      ...baseImports,
      ...additionalImports,
      
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
