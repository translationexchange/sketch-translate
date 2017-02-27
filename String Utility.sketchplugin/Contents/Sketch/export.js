function onRun(context) {
  var sketch = context.api()

  var document = sketch.selectedDocument;
  var pages = document.pages;

  var layerObjects = [];

  var layers = NSMutableArray.array();

  for (var i = 0; i < pages.length; i++) {
      var page = pages[i].sketchObject;
      layers.addObjectsFromArray(page.children());
  }

  for (var i = 0; i < layers.length; i++) {
    var layer = layers[i];

    if (layer.class() == MSSymbolInstance) {
      var instance = layer;
      var master = instance.symbolMaster();
      var overrides = instance.overrides();

      var masterChildren = master.children();

      for (var j = 0; j < masterChildren.length; j++) {
        var layer = masterChildren[j];

        if (layer.class() == MSTextLayer && layer.name().startsWith("*")) {
          var text = layer.stringValue();

          if (overrides) {
            var textOverride = overrides.objectForKey(0).objectForKey(layer.objectID().toString());

            if (textOverride) {
              text = textOverride;
            }
          }

          var layerObject = {};
          layerObject.symbolInstance = instance;
          layerObject.layer = layer;
          layerObject.text = text;

          layerObjects.push(layerObject);
        }
      }
    }
  }

  var stringObjects = [];

  for (var i = 0; i < layerObjects.length; i++) {
    var layerObject = layerObjects[i];

    var identifierComponents = [];
    identifierComponents.push(unescape(layerObject.symbolInstance.name()));
    identifierComponents.push(unescape(layerObject.layer.name()));
    identifierComponents.push(unescape(layerObject.text.substring(0, 2)));
    identifierComponents.push(unescape(layerObject.text.length()));
    identifierComponents.push(unescape(layerObject.text.substring(layerObject.text.length() - 2, layerObject.text.length())));

    var stringObject = {};
    stringObject.seq_num = i + 1;
    stringObject.identifier = identifierComponents.join("");
    stringObject.info = {};
    stringObject.info.english = unescape(layerObject.text)
    stringObject.note = {};
    stringObject.note.fontName = unescape(layerObject.layer.font().displayName());
    stringObject.note.fontSize = layerObject.layer.fontSize();
    stringObject.note.textAlignment = layerObject.layer.textAlignment();
    stringObject.note.size = {};
    stringObject.note.size.width = parseFloat(layerObject.layer.rect().size.width);
    stringObject.note.size.height = parseFloat(layerObject.layer.rect().size.height);

    stringObjects.push(stringObject);
  }

  log(stringObjects);

  var savePanel = NSSavePanel.savePanel();
  savePanel.setAllowedFileTypes(["json"]);
  savePanel.setDirectoryURL(NSURL.fileURLWithPath("~/Documents/"));

  if (savePanel.runModal() == NSOKButton) {
    var jsonString = JSON.stringify(stringObjects, undefined, 2);

    var string = NSString.alloc().initWithString(jsonString);
    string.writeToURL_atomically_encoding_error(savePanel.URL(), true, NSUTF8StringEncoding, null);
  }
};