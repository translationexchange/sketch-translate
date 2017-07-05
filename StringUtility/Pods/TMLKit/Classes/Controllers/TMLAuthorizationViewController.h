//
//  TMLAuthorizationViewController.h
//  TMLKit
//
//  Created by Pasha on 2/19/16.
//  Copyright © 2016 Translation Exchange. All rights reserved.
//

#if TARGET_OS_IOS || TARGET_OS_TV

#import <UIKit/UIKit.h>
#import "TMLAuthorizationController.h"
#import "TMLWebViewController.h"

extern NSString * const TMLAuthorizationAccessTokenKey;
extern NSString * const TMLAuthorizationUserKey;
extern NSString * const TMLAuthorizationErrorDomain;

typedef NS_ENUM(NSInteger, TMLAuthorizationErrorCode) {
    TMLAuthorizationUnknownError = 0,
    TMLAuthorizationUnexpectedResponseError
};

@protocol TMLAuthorizationViewControllerDelegate;

@interface TMLAuthorizationViewController : TMLWebViewController
@property (weak, nonatomic) id<TMLAuthorizationViewControllerDelegate> delegate;
- (void)authorize;
- (void)deauthorize;
@end

@protocol TMLAuthorizationViewControllerDelegate <NSObject>
@optional
- (void) authorizationViewController:(TMLAuthorizationViewController *)controller
                        didGrantAuthorization:(NSDictionary *)userInfo;
- (void) authorizationViewController:(TMLAuthorizationViewController *)controller
                  didFailToAuthorize:(NSError *)error;
- (void) authorizationViewControllerDidRevokeAuthorization:(TMLAuthorizationViewController *)controller;
@end

#endif
