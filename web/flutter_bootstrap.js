"use strict";

// Placeholder values replaced by the Flutter build process.
{{flutter_js}}
{{flutter_build_config}}

let loadedAssets = 0;
let totalAssets = 0;

/**
 * Load and parse the asset manifest to get asset file paths.
 * @returns {Promise<string[]>}
 */
async function fetchAssetList() {
  try {
    const response = await fetch('assets/AssetManifest.json');
    if (!response.ok) {
      console.warn('AssetManifest.json not found, skipping preloading.');
      return [];
    }

    const manifest = await response.json();
    return Object.values(manifest).flat().map(url => `assets/${url}`);
  } catch (err) {
    console.error('Failed to load AssetManifest.json:', err);
    return [];
  }
}

/**
 * Load a single asset.
 * @param {string} url
 */
async function loadAsset(url) {
  try {
    const response = await fetch(url);
    if (!response.ok) {
      throw new Error(`Failed to load ${url}: ${response.statusText}`);
    }
  } catch (err) {
    console.error(`Error loading asset: ${url}`, err);
  }
}

/**
 * Load a batch of assets and update progress.
 * @param {string[]} urls
 */
async function loadBatch(urls) {
  const promises = urls.map(async (url) => {
    await loadAsset(url);
    loadedAssets++;
    updateProgressBar();
  });

  try {
    await Promise.all(promises);
  } catch (err) {
    console.error('Error loading asset batch:', err);
  }
}

/**
 * Preload all assets from manifest.
 */
async function preloadAssets() {
  const assets = await fetchAssetList();
  totalAssets = assets.length;

  if (totalAssets === 0) {
    updateProgressBar(); // Show 100%
    return;
  }

  loadedAssets = 0;
  const batchSize = 20;

  for (let i = 0; i < assets.length; i += batchSize) {
    const batch = assets.slice(i, i + batchSize);
    await loadBatch(batch);
  }
}

/**
 * Update the visual progress bar.
 */
function updateProgressBar() {
  const progressBar = document.getElementById('progress-bar');
  if (!progressBar) return;

  const percent = totalAssets > 0
    ? Math.floor((loadedAssets / totalAssets) * 100)
    : 100;

  progressBar.style.width = `${percent}%`;
}

/**
 * Remove splash/loading container from DOM.
 */
function removeSplashScreen() {
  const container = document.querySelector(".main-container");
  if (container) {
    container.remove();
  }
}

// Flutter app bootstrap
_flutter.loader.load({
  serviceWorkerSettings: {
    serviceWorkerVersion: {{flutter_service_worker_version}},
  },
  onEntrypointLoaded: async (engineInitializer) => {
    await preloadAssets();

    const appRunner = await engineInitializer.initializeEngine({});
    await appRunner.runApp();

    setTimeout(removeSplashScreen, 250); // Small delay to reduce visual jank
  }
});
