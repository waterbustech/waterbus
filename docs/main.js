const prefixVideoId = "video_RTCVideoRenderer-";
let segmentStream;

function enableVirtualBackground(backgroundImage, textureId) {
  window.setBackgroundImage(backgroundImage);
  if (segmentStream) {
    return;
  }

  const videoElement = document.getElementById(prefixVideoId + textureId);

  if (videoElement) {
    const originalStream = videoElement.srcObject;
    if (originalStream) {
      const videoTrack = originalStream.getVideoTracks()[0];
      if (videoTrack) {
        const trackGenerator = new MediaStreamTrackGenerator({
          kind: "video",
        });
        const trackProcessor = new MediaStreamTrackProcessor({
          track: videoTrack,
        });

        const transformer = new TransformStream({
          transform: (frame, controller) => window.segment(frame, controller),
        });

        trackProcessor.readable
          .pipeThrough(transformer)
          .pipeTo(trackGenerator.writable);

        segmentStream = new MediaStream([trackGenerator]);
        videoElement.srcObject = segmentStream;

        return segmentStream;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}

function disableVirtualBackground() {
  segmentStream = null;
  window.setBackgroundImage(null);
  stopPictureInPicture();
}

function startPictureInPicture(textureId, enabled) {
  const videoId = prefixVideoId + textureId;
  const videoElement = document.getElementById(videoId);

  stopPictureInPicture();

  if (videoElement && videoElement instanceof HTMLVideoElement && enabled) {
    videoElement.requestPictureInPicture();
  }
}

function stopPictureInPicture() {
  if (document.pictureInPictureElement) {
    document.exitPictureInPicture();
  }
}

window.addEventListener("load", function () {
  _flutter.loader.loadEntrypoint({
    serviceWorker: {
      serviceWorkerVersion: serviceWorkerVersion,
    },
    onEntrypointLoaded: function (engineInitializer) {
      let config = { renderer: "html" };
      engineInitializer.initializeEngine(config).then(function (appRunner) {
        appRunner.runApp();
      });
    },
  });
});
