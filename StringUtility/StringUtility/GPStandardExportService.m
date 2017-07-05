//
//  GPStandardExportService.m
//  StringUtility
//
//  Created by Konstantin Kabanov on 22/03/2017.
//  Copyright © 2017 GoPro Inc. All rights reserved.
//

#import "GPStandardExportService.h"

#import "MSKit.h"

#import "GPOverridedLayerInfo.h"
#import "GPPluginConfiguration.h"
#import "GPExportOptionsWindowController.h"
#import "GPLanguagesWindowController.h"

@implementation GPStandardExportService {
    NSWindowController *_currentWindowController;
}

- (void)run {
    MSDocument *document = self.context[@"document"];
    NSWindowController *documentWindowController = [document.windowControllers firstObject];

    GPExportOptionsWindowController *windowController = [[GPExportOptionsWindowController alloc] init];
    _currentWindowController = windowController;

    [documentWindowController.window beginSheet:windowController.window completionHandler:^(NSModalResponse returnCode) {
        _currentWindowController = nil;

        if (returnCode == NSModalResponseOK) {
            GPLanguagesWindowController *windowController = [[GPLanguagesWindowController alloc] init];
            _currentWindowController = windowController;

            [documentWindowController.window beginSheet:windowController.window completionHandler:^(NSModalResponse returnCode) {
                [windowController.window orderOut:nil];

                _currentWindowController = nil;

                if (returnCode == NSModalResponseOK) {
                    [self export];
                }
            }];
        }
    }];
}

- (void)export {
    NSMutableArray *layerInfos = [@[] mutableCopy];
    NSMutableArray<MSLayer *> *layers = [@[] mutableCopy];
    
    MSDocument *document = self.context[@"document"];
    NSWindowController *documentWindowController = [document.windowControllers firstObject];
    
    NSArray<MSPage *> *pages = document.pages;
    
    if ([GPPluginConfiguration sharedConfiguration].findStringsInOption == 1) {
        pages = [document valueForKeyPath:@"sidebarController.pageListViewController.dataController.delegate.selectedPages"];
        
        if (!pages) {
            pages = @[document.currentPage];
        }
    }
    
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
                    NSString *textOverride = overrides[layer.objectID];
                    
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
    
    for (GPOverridedLayerInfo *info in layerInfos) {
        info.lastExportOverrides = info.symbolInstance.overrides;
    }
    
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    savePanel.allowedFileTypes = @[@"json"];
    savePanel.directoryURL = [NSURL fileURLWithPath:@"~/Documents/"];
    
    [savePanel beginSheetModalForWindow:documentWindowController.window completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:stringInfos options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            [jsonString writeToURL:savePanel.URL atomically:true encoding:NSUTF8StringEncoding error:nil];
        }
    }];
}

@end
