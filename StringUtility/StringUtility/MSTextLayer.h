//
//  MSTextLayer.h
//  StringUtility
//
//  Created by Konstantin Kabanov on 09/03/2017.
//  Copyright © 2017 GoPro Inc. All rights reserved.
//

#import "MSStyledLayer.h"

@interface MSTextLayer : MSStyledLayer

@property(readonly, nonatomic) NSFont *font;
@property(nonatomic) double fontSize;
@property(nonatomic) NSTextAlignment textAlignment;
@property(copy, nonatomic) NSString *stringValue;
@property(nonatomic) double lineHeight;
@property(nonatomic) double baseLineHeight;
@property(retain, nonatomic) NSNumber *defaultLineHeightValue;
@property(copy, nonatomic) NSAttributedString *attributedStringValue;

- (double)defaultLineHeight:(NSLayoutManager *)layoutManager;
- (NSLayoutManager *)createLayoutManager;
- (NSTextStorage *)createTextStorage;

@end
