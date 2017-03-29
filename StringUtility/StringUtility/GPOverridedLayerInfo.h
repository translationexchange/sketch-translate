//
//  GPOverridedLayerInfo.h
//  StringUtility
//
//  Created by Konstantin Kabanov on 09/03/2017.
//  Copyright © 2017 GoPro Inc. All rights reserved.
//

#import "MSSymbolInstance.h"
#import "MSTextLayer.h"

@interface GPOverridedLayerInfo : NSObject

@property (strong, nonatomic) MSSymbolInstance *symbolInstance;
@property (strong, nonatomic) MSTextLayer *layer;
@property (copy, nonatomic) NSString *text;
@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) double lineHeight;
@property (nonatomic, readonly) NSInteger maxCharCount;
@property (nonatomic, readonly) NSInteger maxLineCount;

- (NSMutableDictionary *)dictionaryRepresentation;

@end
