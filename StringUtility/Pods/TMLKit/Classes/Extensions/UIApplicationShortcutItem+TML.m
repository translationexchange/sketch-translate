//
//  UIApplicationShortcutItem+TML.m
//  TMLKit
//
//  Created by Pasha on 12/15/15.
//  Copyright © 2015 Translation Exchange. All rights reserved.
//

#if TARGET_OS_IOS || TARGET_OS_TV

#ifdef __IPHONE_9_0
#import "UIApplicationShortcutItem+TML.h"
#import "NSObject+TML.h"

@implementation UIApplicationShortcutItem (TML)

- (NSSet *)tmlLocalizableKeyPaths {
    NSMutableSet *keys = [[super tmlLocalizableKeyPaths] mutableCopy];
    if (keys == nil) {
        keys = [NSMutableSet set];
    }
    [keys addObjectsFromArray:@[@"localizedTitle", @"localizedSubtitle"]];
    return [keys copy];
}

@end
#endif

#endif
