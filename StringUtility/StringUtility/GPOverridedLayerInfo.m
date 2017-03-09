//
//  GPOverridedLayerInfo.m
//  StringUtility
//
//  Created by Konstantin Kabanov on 09/03/2017.
//  Copyright © 2017 GoPro Inc. All rights reserved.
//

#import "GPOverridedLayerInfo.h"

@implementation GPOverridedLayerInfo

- (NSMutableDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dictionary = [@{} mutableCopy];
    
    NSMutableArray *identifierComponents = [@[] mutableCopy];
    
    [identifierComponents addObject:self.symbolInstance.name];
    [identifierComponents addObject:self.layer.name];
    [identifierComponents addObject:[self.text substringToIndex:2]];
    [identifierComponents addObject:[NSString stringWithFormat:@"%li", self.text.length]];
    [identifierComponents addObject:[self.text substringFromIndex:self.text.length - 2]];
    
    NSString *sampleString = @"x";
    NSSize sampleSize = [sampleString sizeWithAttributes:@{NSFontAttributeName: self.layer.font}];
    
    double lineHeight = self.layer.lineHeight;
    
    if (lineHeight == 0.0) {
        lineHeight = [self.layer defaultLineHeight:[self.layer createLayoutManager]];
    }
    
    NSInteger maxCharCount = (NSInteger)floorf((self.layer.rect.size.width * self.layer.rect.size.height) / (sampleSize.width * lineHeight));
    
    NSInteger maxLineCount = (NSInteger)floorf(self.layer.rect.size.height / lineHeight);
    
    dictionary[@"seq_num"] = @0;
    dictionary[@"identifier"] = [identifierComponents componentsJoinedByString:@"/"];
    
    NSMutableDictionary *infoDict = [@{} mutableCopy];
    infoDict[@"english"] = self.text;
    
    dictionary[@"info"] = infoDict;
    
    NSMutableDictionary *noteDict = [@{} mutableCopy];
    noteDict[@"fontName"] = self.layer.font.displayName;
    noteDict[@"fontSize"] = @(self.layer.fontSize);
    noteDict[@"textAlignment"] = @(self.layer.textAlignment);
    noteDict[@"lineHeight"] = @(lineHeight);
    noteDict[@"maxChar"] = @(maxCharCount);
    noteDict[@"maxLine"] = @(maxLineCount);
    
    NSMutableDictionary *sizeDict = [@{} mutableCopy];
    sizeDict[@"width"] = @(self.layer.rect.size.width);
    sizeDict[@"height"] = @(self.layer.rect.size.height);
    
    noteDict[@"size"] = sizeDict;
    
    dictionary[@"note"] = noteDict;
    
    return dictionary;
}

@end