//
//  GPStandardImportService.m
//  StringUtility
//
//  Created by Konstantin Kabanov on 22/03/2017.
//  Copyright © 2017 GoPro Inc. All rights reserved.
//

#import "GPStandardImportService.h"

#import "MSKit.h"

#import "GPOverridedLayerInfo.h"

@implementation GPStandardImportService

- (void)run {
    MSDocument *document = self.context[@"document"];
    NSWindowController *documentWindowController = [document.windowControllers firstObject];
    
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.allowedFileTypes = @[@"json"];
    openPanel.directoryURL = [NSURL fileURLWithPath:@"~/Documents/"];
    
    [openPanel beginSheetModalForWindow:documentWindowController.window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSFileHandlingPanelOKButton) {
            NSURL *url = [openPanel.URLs firstObject];
            
            NSString *jsonString = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
            NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            
            NSArray *stringInfos = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
            
            for (NSDictionary *overrideInfoDict in stringInfos) {
                NSDictionary *infoDict = (NSDictionary *)overrideInfoDict[@"info"];
                
                for (NSString *language in [infoDict allKeys]) {
                    NSString *text = infoDict[language];
                    
                    NSArray *pages = [self pagesForLanguage:language];
                    NSArray *layers = [self layersForPages:pages];
                    GPOverridedLayerInfo *info = [self findOverridedLayerInfoWithIdentifier:overrideInfoDict[@"identifier"] inLayers:layers];
                    
                    if (info) {
                        NSMutableDictionary *mutableOverrides = [info.symbolInstance.overrides mutableCopy];
                        NSMutableDictionary *mutableValuesDict = [mutableOverrides[@0] mutableCopy];
                        mutableValuesDict[info.layer.objectID] = text;
                        mutableOverrides[@0] = mutableValuesDict;
                        
                        info.symbolInstance.overrides = mutableOverrides;
                    }
                }
            }
        }
    }];
}

- (NSArray *)pagesForLanguage:(NSString *)language {
    MSDocument *document = self.context[@"document"];
    NSArray *pages = document.pages;
    
    NSArray *originPages = [pages filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT (name CONTAINS[cd] %@) AND (name != %@)", @": ", @"Symbols"]];
    
    if ([language isEqualToString:@"english"]) {
        return originPages;
    }
    
    NSMutableArray *pagesForLanguage = [[pages filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name ENDSWITH %@", [NSString stringWithFormat:@": %@", language]]] mutableCopy];
    
    for (MSPage *originPage in originPages) {
        NSString *pageName = [NSString stringWithFormat:@"%@: %@", originPage.name, language];
        
        if ([[pagesForLanguage filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", pageName]] count] == 0) {
            MSPage *pageForLanguage = [originPage copy];
            pageForLanguage.name = pageName;
            
            id documentData = [document valueForKeyPath:@"documentData"];
            [documentData performSelector:@selector(addPage:) withObject:pageForLanguage];
            
            [pagesForLanguage addObject:pageForLanguage];
        }
    }
    
    document.currentPage = document.currentPage;
    
    return pagesForLanguage;
}

- (NSArray *)layersForPages:(NSArray *)pages {
    NSMutableArray *layers = [@[] mutableCopy];
    
    for (MSPage *page in pages) {
        [layers addObjectsFromArray:page.children];
    }
    
    return layers;
}

- (GPOverridedLayerInfo *)findOverridedLayerInfoWithIdentifier:(NSString *)identifier inLayers:(NSArray *)layers {
    NSArray<NSString *> *identifierComponents = [identifier componentsSeparatedByString:@"-"];
    NSString *symbolName = identifierComponents[0];
    NSString *layerName = identifierComponents[1];
    NSString *first2Characters = identifierComponents[2];
    NSInteger textLength = [identifierComponents[3] integerValue];
    NSString *last2Characters = identifierComponents[4];
    
    for (MSLayer *layer in layers) {
        if ([layer.className isEqualToString:@"MSSymbolInstance"] && [layer.name isEqualToString:symbolName]) {
            MSSymbolInstance *instance = (MSSymbolInstance *)layer;
            MSSymbolMaster *master = instance.symbolMaster;
            NSDictionary *overrides = instance.overrides;
            
            NSArray *masterChildren = master.children;
            
            for (MSLayer *layer in masterChildren) {
                if ([layer.className isEqualToString:@"MSTextLayer"] && [layer.name isEqualToString:layerName]) {
                    MSTextLayer *textLayer = (MSTextLayer *)layer;
                    NSString *textOverride = overrides[@0][layer.objectID];
                    
                    if ([textOverride hasPrefix:first2Characters] && ([textOverride length] == textLength) && [textOverride hasSuffix:last2Characters]) {
                        GPOverridedLayerInfo *info = [[GPOverridedLayerInfo alloc] init];
                        info.symbolInstance = instance;
                        info.layer = textLayer;
                        
                        return info;
                    }
                }
            }
        }
    }
    
    return nil;
}

@end
