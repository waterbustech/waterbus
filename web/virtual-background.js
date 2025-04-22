import * as vision from "https://cdn.jsdelivr.net/npm/@mediapipe/tasks-vision/vision_bundle.js";

const segmentCanvas = new OffscreenCanvas(1, 1);
const segmentCtx = segmentCanvas.getContext("2d");
const runningMode = "VIDEO";

let imageSegmenter;
let segmentationResults;
let backgroundImage;
let isModelInitialized = false;

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

  // Warm-up model to reduce first-frame lag
  const warmupCanvas = new OffscreenCanvas(256, 256);
  imageSegmenter.segmentForVideo(warmupCanvas, performance.now(), () => {});
  isModelInitialized = true;
}

function maskToBitmap(mask, videoWidth, videoHeight) {
  const dataArray = new Uint8ClampedArray(videoWidth * videoHeight * 4);
  const result = mask.getAsUint8Array();
  for (let i = 0; i < result.length; i++) {
    const value = result[i];
    dataArray.set([value, value, value, value], i * 4);
  }
  const dataNew = new ImageData(dataArray, videoWidth, videoHeight);
  return createImageBitmap(dataNew);
}

async function drawVirtualBackground(frame, controller) {
  if (!segmentCanvas || !segmentCtx || !segmentationResults || !frame) return;

  const mask = segmentationResults?.confidenceMasks?.[0];
  if (mask) {
    const bitmap = await maskToBitmap(mask, mask.width, mask.height);

    // Blur the background
    segmentCtx.filter = "blur(10px)";
    segmentCtx.globalCompositeOperation = "copy";
    segmentCtx.drawImage(
      bitmap,
      0,
      0,
      segmentCanvas.width,
      segmentCanvas.height
    );

    // Draw the background image or color
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

    // Draw the foreground (person)
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

  const img = new Image();
  img.src = "data:image/png;base64," + base64String;
  img.onload = function () {
    const canvas = document.createElement("canvas");
    canvas.width = img.width;
    canvas.height = img.height;
    const ctx = canvas.getContext("2d");
    ctx.drawImage(img, 0, 0);
    const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
    createImageBitmap(imageData).then((bitmap) => {
      backgroundImage = bitmap;
    });
  };
}

async function segment(frame, controller) {
  if (!isModelInitialized) return;

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

  const startTimeMs = performance.now();
  imageSegmenter.segmentForVideo(
    segmentCanvas,
    startTimeMs,
    (result) => (segmentationResults = result)
  );

  drawVirtualBackground(frame, controller);
}

// Automatically initialize on page load
document.addEventListener("DOMContentLoaded", initialize);

// Expose functions for external usage
window.segment = segment;
window.setBackgroundImage = setBackgroundImage;
