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

function presentExport(context) {
  loadBundleIfRequired(context);
  [GPSketch presentExport];
}

function presentImport(context) {
  loadBundleIfRequired(context);
  [GPSketch presentImport];
}