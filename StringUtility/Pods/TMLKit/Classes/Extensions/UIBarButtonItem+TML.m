//
//  UIBarButtonItem+TML.m
//  TMLKit
//
//  Created by Pasha on 12/15/15.
//  Copyright © 2015 Translation Exchange. All rights reserved.
//

#if TARGET_OS_IOS || TARGET_OS_TV

#import "UIBarButtonItem+TML.h"
#import "NSObject+TML.h"

@implementation UIBarButtonItem (TML)

- (NSSet *)tmlLocalizableKeyPaths {
    NSMutableSet *keys = [[super tmlLocalizableKeyPaths] mutableCopy];
    if (keys == nil) {
        keys = [NSMutableSet set];
    }
    [keys addObjectsFromArray:@[@"possibleTitles"]];
    return [keys copy];
}

@end

#endif
