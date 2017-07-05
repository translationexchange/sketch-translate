//
//  UITableView+TML.m
//  TMLKit
//
//  Created by Pasha on 12/7/15.
//  Copyright © 2015 Translation Exchange. All rights reserved.
//

#if TARGET_OS_IOS || TARGET_OS_TV

#import "NSObject+TML.h"
#import "TML.h"
#import "TMLConfiguration.h"
#import "UITableView+TML.h"

@implementation UITableView (TML)

- (void)updateReusableTMLStrings {
    [super updateReusableTMLStrings];
    if ([[[TML sharedInstance] configuration] automaticallyReloadDataBackedViews] == YES) {
        [self reloadData];
    }
}

@end

#endif
