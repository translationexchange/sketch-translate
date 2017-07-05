//
//  UITableViewRowAction+TML.m
//  TMLKit
//
//  Created by Pasha on 12/15/15.
//  Copyright © 2015 Translation Exchange. All rights reserved.
//

#if TARGET_OS_IOS || TARGET_OS_TV

#import "UITableViewRowAction+TML.h"
#import "NSObject+TML.h"

@implementation UITableViewRowAction (TML)

- (NSSet *)tmlLocalizableKeyPaths {
    NSMutableSet *keys = [[super tmlLocalizableKeyPaths] mutableCopy];
    if (keys == nil) {
        keys = [NSMutableSet set];
    }
    [keys addObject:@"title"];
    return [keys copy];
}

@end

#endif
