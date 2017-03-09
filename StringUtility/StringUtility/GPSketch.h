//
//  GPSketch.h
//  StringUtility
//
//  Created by Konstantin Kabanov on 09/03/2017.
//  Copyright © 2017 GoPro Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPSketch : NSObject

+ (void)setPluginContextDictionary:(NSDictionary *)context;
+ (void)presentExportOptions;
+ (void)export;

@end
