@import "lib/runtime.js"

function loadBundleIfRequired(context) {
    if (NSClassFromString("GPSketch") == null) {
        runtime.loadBundle("StringUtility.bundle");
        [GPSketch setPluginContextDictionary:context];
    }
    try {
        [GPSketch setPluginContextDictionary:context];
    } catch (e) {}
}

function presentStandardExport(context) {
  loadBundleIfRequired(context);
  [GPSketch presentStandardExport];
}

function presentStandardImport(context) {
  loadBundleIfRequired(context);
  [GPSketch presentStandardImport];
}

function presentTranslationExchangeExport(context) {
  loadBundleIfRequired(context);
  [GPSketch presentTranslationExchangeExport];
}

function presentTranslationExchangeImport(context) {
  loadBundleIfRequired(context);
  [GPSketch presentTranslationExchangeImport];
}