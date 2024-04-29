import * as vision from "https://cdn.jsdelivr.net/npm/@mediapipe/tasks-vision/vision_bundle.js";

const segmentCanvas = new OffscreenCanvas(1, 1);
const segmentCtx = segmentCanvas.getContext("2d");
const runningMode = "VIDEO";

let imageSegmenter;
let segmentationResults;
let backgroundImage;

async function initialize() {
  const fileSet = await vision.FilesetResolver.forVisionTasks(
    "https://cdn.jsdelivr.net/npm/@mediapipe/tasks-vision@latest/wasm"
  );

  imageSegmenter = await vision.ImageSegmenter.createFromOptions(fileSet, {
    baseOptions: {
      modelAssetPath:
        "https://storage.googleapis.com/mediapipe-models/image_segmenter/selfie_multiclass_256x256/float32/1/selfie_multiclass_256x256.tflite",
      delegate: "GPU",
    },
    outputconfidenceMasks: false,
    outputConfidenceMasks: true,
    runningMode: runningMode,
  });
}

function maskToBitmap(mask, videoWidth, videoHeight) {
  const dataArray = new Uint8ClampedArray(videoWidth * videoHeight * 4);
  const result = mask.getAsUint8Array();
  for (let i = 0; i < result.length; i += 1) {
    dataArray[i * 4] = result[i];
    dataArray[i * 4 + 1] = result[i];
    dataArray[i * 4 + 2] = result[i];
    dataArray[i * 4 + 3] = result[i];
  }
  const dataNew = new ImageData(dataArray, videoWidth, videoHeight);

  return createImageBitmap(dataNew);
}

async function drawVirtualBackground(frame, controller) {
  if (!segmentCanvas || !segmentCtx || !segmentationResults || !frame) return;

  if (segmentationResults?.confidenceMasks) {
    segmentCtx.filter = "blur(10px)";
    segmentCtx.globalCompositeOperation = "copy";

    const mask = segmentationResults?.confidenceMasks[0];
    const bitmap = await maskToBitmap(mask, mask.width, mask.height);
    segmentCtx.drawImage(
      bitmap,
      0,
      0,
      segmentCanvas.width,
      segmentCanvas.height
    );
    segmentCtx.filter = "none";
    segmentCtx.globalCompositeOperation = "source-in";
    if (backgroundImage) {
      segmentCtx.drawImage(
        backgroundImage,
        0,
        0,
        backgroundImage.width,
        backgroundImage.height,
        0,
        0,
        segmentCanvas.width,
        segmentCanvas.height
      );
    } else {
      segmentCtx.fillStyle = "#00FF00";
      segmentCtx.fillRect(0, 0, segmentCanvas.width, segmentCanvas.height);
    }

    segmentCtx.globalCompositeOperation = "destination-over";
  }
  segmentCtx.drawImage(frame, 0, 0, segmentCanvas.width, segmentCanvas.height);

  const segmentedFrame = new VideoFrame(segmentCanvas, {
    timestamp: frame.timestamp,
  });
  controller.enqueue(segmentedFrame);
  frame.close();
}

async function setBackgroundImage(base64String) {
  if (!base64String) {
    backgroundImage = null;
    return;
  }

  var img = new Image();

  img.src = "data:image/png;base64," + base64String;

  img.onload = function () {
    var canvas = document.createElement("canvas");
    canvas.width = img.width;
    canvas.height = img.height;
    var ctx = canvas.getContext("2d");
    ctx.drawImage(img, 0, 0);
    var imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);

    createImageBitmap(imageData).then((bitmap) => {
      backgroundImage = bitmap;
    });
  };
}

async function segment(frame, controller) {
  const height = frame.codedHeight;
  const width = frame.codedWidth;

  segmentCanvas.height = height;
  segmentCanvas.width = width;

  segmentCtx.drawImage(frame, 0, 0, width, height);

  if (!backgroundImage) {
    const newFrame = new VideoFrame(segmentCanvas, {
      timestamp: frame.timestamp,
    });
    frame.close();
    controller.enqueue(newFrame);
    return;
  }

  let startTimeMs = performance.now();
  imageSegmenter?.segmentForVideo(
    segmentCanvas,
    startTimeMs,
    (result) => (segmentationResults = result)
  );

  drawVirtualBackground(frame, controller);
}

initialize();

window.segment = segment;
window.setBackgroundImage = setBackgroundImage;
