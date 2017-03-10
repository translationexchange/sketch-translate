function pagesForLanguage(context, language) {
  var sketch = context.api();

  var document = sketch.selectedDocument.sketchObject;
  var pages = document.pages();

  var pagesForLanguage = pages.filteredArrayUsingPredicate(NSPredicate.predicateWithFormat("name ENDSWITH %@", ": " + language));

  if (pagesForLanguage.length == 0) {
    var originPages = pages.filteredArrayUsingPredicate(NSPredicate.predicateWithFormat("NOT (name CONTAINS[cd] %@)", ": "));

    pagesForLanguage = [];

    for (var i = 0; i < originPages.length; i++) {
      var originPage = originPages[i];

      log(originPage);

      var pageForLanguage = originPage.copy();
      pageForLanguage.setName(pageForLanguage.name() + ": " + language);

      document.documentData().addPage(pageForLanguage);

      pagesForLanguage.push(pageForLanguage);
    }
  }

  document.setCurrentPage(document.currentPage());

  return pagesForLanguage;
}

function layersForPages(pages) {
  var layers = NSMutableArray.array();

  for (var i = 0; i < pages.length; i++) {
      var page = pages[i];
      layers.addObjectsFromArray(page.children());
  }

  return layers;
}

function findOverrideObjectWithIdentifier(layers, identifier) {
  var identifierComponents = identifier.split("-");
  var symbolName = identifierComponents[0];
  var layerName = identifierComponents[1];
  var first2Characters = identifierComponents[2];
  var textLength = parseInt(identifierComponents[3]);
  var last2Characters = identifierComponents[4];

  for (var i = 0; i < layers.length; i++) {
    var layer = layers[i];

    if (layer.class() === MSSymbolInstance && layer.name() == symbolName) {
      var instance = layer;
      var master = instance.symbolMaster();

      var masterChildren = master.children();

      for (var j = 0; j < masterChildren.length; j++) {
        var layer = masterChildren[j];

        if (layer.class() === MSTextLayer && layer.name() == layerName) {
          var text = unescape(layer.stringValue());

          if (text.startsWith(first2Characters) && text.length == textLength && text.endsWith(last2Characters)) {
            var overrideObject = {};
            overrideObject.symbolInstance = instance;
            overrideObject.layer = layer;

            return overrideObject;
          }
        }
      }
    }
  }

  return null;
}

function onRun(context) {
  var sketch = context.api();

  var document = sketch.selectedDocument;
  var pages = document.pages;

  var openPanel = NSOpenPanel.openPanel();
  openPanel.setAllowedFileTypes(["json"]);
  openPanel.setDirectoryURL(NSURL.fileURLWithPath("~/Documents/"));

  var stringObjects = [];

  if (openPanel.runModal() == NSOKButton) {
    var url = openPanel.URLs().firstObject();
    
    var string = NSString.stringWithContentsOfFile_encoding_error(url, NSUTF8StringEncoding, null);

    if (string) {
      stringObjects = JSON.parse(string.toString());
    }
  }

  log(stringObjects);

  for (var i = 0; i < stringObjects.length; i++) {
    var stringObject = stringObjects[i];

    for (var language in stringObject.info) {
      var text = stringObject.info[language];

      var pages = pagesForLanguage(context, language);
      var layers = layersForPages(pages);
      var overrideObject = findOverrideObjectWithIdentifier(layers, stringObject.identifier);

      if (overrideObject) {
        var mutableOverrides = overrideObject.symbolInstance.overrides().mutableCopy();
        var mutableValuesDict = mutableOverrides.objectForKey(0).mutableCopy();
        mutableValuesDict.setObject_forKey(text, overrideObject.layer.objectID());
        mutableOverrides.setObject_forKey(mutableValuesDict, 0)

        log(mutableOverrides);

        overrideObject.symbolInstance.setOverrides(mutableOverrides);
      }
    }
  }
};