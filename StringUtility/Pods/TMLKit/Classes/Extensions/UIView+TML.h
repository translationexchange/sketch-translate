//
//  UIView+TML.h
//  TMLKit
//
//  Created by Pasha on 12/7/15.
//  Copyright © 2015 Translation Exchange. All rights reserved.
//

#if TARGET_OS_IOS || TARGET_OS_TV

#import <UIKit/UIKit.h>

@interface UIView (TML)

- (void)tmlIterateSubviewsWithBlock:(void(^)(UIView *view, BOOL *skip, BOOL *stop))block;

@end

#endif
