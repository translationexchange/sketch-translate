//
//  GPAuthorizationWindowController.h
//  StringUtility
//
//  Created by Konstantin Kabanov on 21/03/2017.
//  Copyright © 2017 GoPro Inc. All rights reserved.
//

#import <TMLKit/TMLKit.h>
#import <TMLAuthorizationWindowController.h>

@protocol GPAuthorizationWindowControllerDelegate;

@interface GPAuthorizationWindowController : TMLWebWindowController

@property (weak, nonatomic) id <GPAuthorizationWindowControllerDelegate> delegate;

@property (strong, nonatomic) TMLConfiguration *configuration;

- (instancetype)initWithConfiguration:(TMLConfiguration *)configuration;

- (void)authorize;
- (void)deauthorize;

@end

@protocol GPAuthorizationWindowControllerDelegate <NSObject>

@optional

- (void) authorizationWindowController:(GPAuthorizationWindowController *)controller
                 didGrantAuthorization:(NSDictionary *)userInfo;
- (void) authorizationWindowController:(GPAuthorizationWindowController *)controller
                    didFailToAuthorize:(NSError *)error;
- (void) authorizationWindowControllerDidRevokeAuthorization:(GPAuthorizationWindowController *)controller;

@end
