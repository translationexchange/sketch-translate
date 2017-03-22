//
//  GPService.h
//  StringUtility
//
//  Created by Konstantin Kabanov on 22/03/2017.
//  Copyright © 2017 GoPro Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPService : NSObject

@property(nonatomic, strong) NSDictionary *context;

- (instancetype)initWithContext:(NSDictionary *)context;

- (void)run;

@end

