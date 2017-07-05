//
//  UIAlertController+TML.m
//  TMLKit
//
//  Created by Pasha on 12/15/15.
//  Copyright © 2015 Translation Exchange. All rights reserved.
//

#if TARGET_OS_IOS || TARGET_OS_TV

#import "UIAlertController+TML.h"
#import "NSObject+TML.h"

@implementation UIAlertController (TML)

- (NSSet *)tmlLocalizableKeyPaths {
    NSMutableSet *paths = [[super tmlLocalizableKeyPaths] mutableCopy];
    if (paths == nil) {
        paths = [NSMutableSet set];
    }
    [paths addObjectsFromArray:@[@"title", @"message"]];
    return [paths copy];
}

@end

#endif
