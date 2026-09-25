{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.load({
  onEntrypointLoaded: async function(engineInitializer) {
    const appRunner = await engineInitializer.initializeEngine();
    await appRunner.runApp();

    // Smoothly remove the HTML splash loader once Flutter has started
    const loader = document.getElementById('app-splash-loader');
    if (loader) {
      loader.classList.add('fade-out');
      setTimeout(function() {
        if (loader.parentNode) {
          loader.parentNode.removeChild(loader);
        }
      }, 400);
    }
  }
});
