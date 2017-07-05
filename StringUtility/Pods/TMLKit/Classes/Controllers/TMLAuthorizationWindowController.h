//
//  TMLAuthorizationWindowController.h
//  Pods
//
//  Created by Konstantin Kabanov on 20/03/2017.
//
//

#import <AppKit/AppKit.h>
#import "TMLAuthorizationController.h"
#import "TMLWebWindowController.h"

extern NSString * const TMLAuthorizationAccessTokenKey;
extern NSString * const TMLAuthorizationUserKey;
extern NSString * const TMLAuthorizationErrorDomain;

typedef NS_ENUM(NSInteger, TMLAuthorizationErrorCode) {
    TMLAuthorizationUnknownError = 0,
    TMLAuthorizationUnexpectedResponseError
};

@protocol TMLAuthorizationWindowControllerDelegate;

@interface TMLAuthorizationWindowController : TMLWebWindowController

@property (weak, nonatomic) id <TMLAuthorizationWindowControllerDelegate> delegate;

- (void)authorize;
- (void)deauthorize;

@end

@protocol TMLAuthorizationWindowControllerDelegate <NSObject>

@optional

- (void) authorizationWindowController:(TMLAuthorizationWindowController *)controller
               didGrantAuthorization:(NSDictionary *)userInfo;
- (void) authorizationWindowController:(TMLAuthorizationWindowController *)controller
                  didFailToAuthorize:(NSError *)error;
- (void) authorizationWindowControllerDidRevokeAuthorization:(TMLAuthorizationWindowController *)controller;

@end
