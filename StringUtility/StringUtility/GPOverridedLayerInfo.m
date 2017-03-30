//
//  GPOverridedLayerInfo.m
//  StringUtility
//
//  Created by Konstantin Kabanov on 09/03/2017.
//  Copyright © 2017 GoPro Inc. All rights reserved.
//

#import "GPOverridedLayerInfo.h"

#import "GPPluginConfiguration.h"

#import "MSKit.h"

NSString * const GPSketchBundleName = @"com.gopro.sketch.stringutility";
NSString * const GPSketchLastExportOverridesKey = @"GPSketchLastExportOverridesKey";

@interface GPOverridedLayerInfo ()

@property (readonly, nonatomic) NSMutableDictionary *pluginUserInfo;

@end

@implementation GPOverridedLayerInfo

- (NSMutableDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dictionary = [@{} mutableCopy];
    
    dictionary[@"seq_num"] = @0;
    dictionary[@"identifier"] = self.identifier;
    
    NSMutableDictionary *infoDict = [@{} mutableCopy];
    infoDict[@"english"] = self.text;
    
    for (NSString *localeIdentifier in [GPPluginConfiguration sharedConfiguration].localeIdentifiers) {
        infoDict[localeIdentifier] = @"";
    }
    
    dictionary[@"info"] = infoDict;
    
    NSMutableDictionary *noteDict = [@{} mutableCopy];
    
    NSString *currentTextOverride = self.symbolInstance.overrides[@0][self.layer.objectID];
    NSString *previousTextOverride = self.lastExportOverrides[@0][self.layer.objectID];
    
    noteDict[@"updated"] = @(![currentTextOverride isEqualToString:previousTextOverride]);
    
    noteDict[@"pageName"] = self.symbolInstance.parentPage.name;
    noteDict[@"artboardName"] = self.symbolInstance.parentArtboard.name;
    
    if ([GPPluginConfiguration sharedConfiguration].isFontTypeEnabled) {
        noteDict[@"fontName"] = self.layer.font.displayName;
    }
    
    if ([GPPluginConfiguration sharedConfiguration].isFontSizeEnabled) {
        noteDict[@"fontSize"] = @(self.layer.fontSize);
    }
    
    if ([GPPluginConfiguration sharedConfiguration].isTextAlignmentEnabled) {
        noteDict[@"textAlignment"] = @(self.layer.textAlignment);
    }
    
    if ([GPPluginConfiguration sharedConfiguration].isMaxCharacterCountEnabled) {
        noteDict[@"maxChar"] = @(self.maxCharCount);
    }
    
    if ([GPPluginConfiguration sharedConfiguration].isMaxLineCountEnabled) {
        noteDict[@"maxLine"] = @(self.maxLineCount);
    }
    
    if ([GPPluginConfiguration sharedConfiguration].isTextFieldDimensionsEnabled) {
        NSMutableDictionary *sizeDict = [@{} mutableCopy];
        sizeDict[@"width"] = @(self.layer.rect.size.width);
        sizeDict[@"height"] = @(self.layer.rect.size.height);
        
        noteDict[@"size"] = sizeDict;
    }
    
    dictionary[@"note"] = noteDict;
    
    return dictionary;
}

- (NSString *)identifier {
    NSMutableArray *identifierComponents = [@[] mutableCopy];
    
    [identifierComponents addObject:self.symbolInstance.name];
    [identifierComponents addObject:self.layer.name];
    [identifierComponents addObject:[self.text substringToIndex:2]];
    [identifierComponents addObject:[NSString stringWithFormat:@"%li", self.text.length]];
    [identifierComponents addObject:[self.text substringFromIndex:self.text.length - 2]];
    
    return [identifierComponents componentsJoinedByString:@"-"];
}

- (double)lineHeight {
    double lineHeight = self.layer.lineHeight;
    
    if (lineHeight == 0.0) {
        lineHeight = [self.layer defaultLineHeight:[self.layer createLayoutManager]];
    }
    
    return lineHeight;
}

- (NSInteger)maxCharCount {
    NSString *sampleString = @"x";
    NSSize sampleSize = [sampleString sizeWithAttributes:@{NSFontAttributeName: self.layer.font}];
    
    return (NSInteger)floorf((self.layer.rect.size.width * self.layer.rect.size.height) / (sampleSize.width * self.lineHeight));
}

- (NSInteger)maxLineCount {
    return (NSInteger)floorf(self.layer.rect.size.height / self.lineHeight);
}

- (NSMutableDictionary *)pluginUserInfo {
    NSMutableDictionary *pluginUserInfo = [self.symbolInstance.userInfo[GPSketchBundleName] mutableCopy];
    
    if (!pluginUserInfo) {
        pluginUserInfo = [@{} mutableCopy];
    }
    
    return pluginUserInfo;
}

- (NSDictionary *)lastExportOverrides {
    return self.pluginUserInfo[GPSketchLastExportOverridesKey];
}

- (void)setLastExportOverrides:(NSDictionary *)lastExportOverrides {
    NSMutableDictionary *pluginUserInfo = self.pluginUserInfo;
    
    pluginUserInfo[GPSketchLastExportOverridesKey] = lastExportOverrides;
    
    NSMutableDictionary *mutableUserInfo = [self.symbolInstance.userInfo mutableCopy];
    
    mutableUserInfo[GPSketchBundleName] = pluginUserInfo;
    
    self.symbolInstance.userInfo = mutableUserInfo;
}

@end
