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
