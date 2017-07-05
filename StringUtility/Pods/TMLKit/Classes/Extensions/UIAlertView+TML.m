//
//  UIAlertView+TML.m
//  TMLKit
//
//  Created by Pasha on 12/14/15.
//  Copyright © 2015 Translation Exchange. All rights reserved.
//

#if TARGET_OS_IOS || TARGET_OS_TV

#import "NSObject+TML.h"
#import "TML.h"
#import "UIAlertView+TML.h"

@implementation UIAlertView (TML)

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
