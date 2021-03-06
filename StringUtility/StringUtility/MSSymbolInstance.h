//
//  MSSymbolInstance.h
//  StringUtility
//
//  Created by Konstantin Kabanov on 09/03/2017.
//  Copyright © 2017 GoPro Inc. All rights reserved.
//

#import "MSStyledLayer.h"
#import "MSSymbolMaster.h"

@interface MSSymbolInstance : MSStyledLayer

@property(retain, nonatomic) NSDictionary *overrides;

- (MSSymbolMaster *)symbolMaster;

@end
