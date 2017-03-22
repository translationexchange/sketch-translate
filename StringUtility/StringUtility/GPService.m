//
//  GPService.m
//  StringUtility
//
//  Created by Konstantin Kabanov on 22/03/2017.
//  Copyright © 2017 GoPro Inc. All rights reserved.
//

#import "GPService.h"

@implementation GPService

- (instancetype)initWithContext:(NSDictionary *)context {
    self = [super init];
    if (self) {
        self.context = context;
    }
    return self;
}

- (void)run {
    
}

@end
