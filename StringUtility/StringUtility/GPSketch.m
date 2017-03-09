//
//  GPSketch.m
//  StringUtility
//
//  Created by Konstantin Kabanov on 09/03/2017.
//  Copyright © 2017 GoPro Inc. All rights reserved.
//

#import "GPSketch.h"
#import "MSDocument.h"
#import "MSPage.h"
#import "MSSymbolInstance.h"
#import "MSTextLayer.h"
#import "GPOverridedLayerInfo.h"

#import "GPExportOptionsWindowController.h"

static NSDictionary *_context;
static NSWindowController *_currentWindowController;

@implementation GPSketch

+ (void)setPluginContextDictionary:(NSDictionary *)context {
    _context = context;
}

+ (void)presentExport {
    MSDocument *document = _context[@"document"];
    NSWindowController *documentWindowController = [document.windowControllers firstObject];
    
    GPExportOptionsWindowController *windowController = [[GPExportOptionsWindowController alloc] init];
    _currentWindowController = windowController;
    
    [documentWindowController.window beginSheet:windowController.window completionHandler:^(NSModalResponse returnCode) {
        _currentWindowController = nil;
    }];
}

+ (void)export {
    NSMutableArray *layerInfos = [@[] mutableCopy];
    NSMutableArray<MSLayer *> *layers = [@[] mutableCopy];
    
    MSDocument *document = _context[@"document"];
    NSWindowController *documentWindowController = [document.windowControllers firstObject];
    
    NSArray<MSPage *> *pages = document.pages;
    
    for (MSPage *page in pages) {
        [layers addObjectsFromArray:page.children];
    }
    
    for (MSLayer *layer in layers) {
        if ([layer.className isEqualToString:@"MSSymbolInstance"] && [layer.name hasPrefix:@"_"] && [layer.name hasSuffix:@"_"]) {
            MSSymbolInstance *instance = (MSSymbolInstance *)layer;
            MSSymbolMaster *master = instance.symbolMaster;
            NSDictionary *overrides = instance.overrides;
            
            NSArray *masterChildren = master.children;
            
            for (MSLayer *layer in masterChildren) {
                if (overrides && [layer.className isEqualToString:@"MSTextLayer"] && [layer.name hasPrefix:@"*"] && [layer.name hasSuffix:@"_"]) {
                    NSString *textOverride = overrides[@0][layer.objectID];
                    
                    if (textOverride) {
                        GPOverridedLayerInfo *info = [[GPOverridedLayerInfo alloc] init];
                        info.symbolInstance = instance;
                        info.layer = (MSTextLayer *)layer;
                        info.text = textOverride;
                        
                        [layerInfos addObject:info];
                    }
                }
            }
        }
    }
    
    NSMutableArray *stringInfos = [@[] mutableCopy];
    
    for (GPOverridedLayerInfo *info in layerInfos) {
        NSMutableDictionary *dictionary = [info dictionaryRepresentation];
        dictionary[@"seq_num"] = @([layerInfos indexOfObject:info]);
        [stringInfos addObject:dictionary];
    }
    
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    savePanel.allowedFileTypes = @[@"json"];
    savePanel.directoryURL = [NSURL fileURLWithPath:@"~/Documents/"];
    
    [documentWindowController.window beginSheet:savePanel completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSModalResponseOK) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:stringInfos options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            [jsonString writeToURL:savePanel.URL atomically:true encoding:NSUTF8StringEncoding error:nil];
        }
    }];
}

@end
