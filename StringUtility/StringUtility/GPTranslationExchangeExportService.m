//
//  GPTranslationExchangeExportService.m
//  StringUtility
//
//  Created by Konstantin Kabanov on 22/03/2017.
//  Copyright © 2017 GoPro Inc. All rights reserved.
//

#import "GPTranslationExchangeExportService.h"
#import "GPAuthorizationWindowController.h"
#import "GPProjectsWindowController.h"

#import "MSKit.h"
#import <TMLKit.h>

@interface GPTranslationExchangeExportService () <GPAuthorizationWindowControllerDelegate>

@end

@implementation GPTranslationExchangeExportService {
    NSWindowController *_currentWindowController;
}

- (void)run {
    TMLConfiguration *configuration = [[TMLConfiguration alloc] init];
    [TML sharedInstanceWithConfiguration:configuration];
    
    if ([TML sharedInstance].configuration.accessToken.length == 0) {
        [self acquireAccessToken];
    } else {
        [self showProjects];
    }
}

- (void)acquireAccessToken {
    GPAuthorizationWindowController *authController = [[GPAuthorizationWindowController alloc] init];
    
    authController.delegate = self;
    [authController authorize];
    
    [authController showWindow:nil];
    _currentWindowController = authController;
}

- (void)showProjects {
    GPProjectsWindowController *wc = [[GPProjectsWindowController alloc] init];
    _currentWindowController = wc;
    
    [wc showWindow:nil];
}

- (void)authorizationWindowController:(GPAuthorizationWindowController *)controller didGrantAuthorization:(NSDictionary *)userInfo {
    NSString *accessToken = [userInfo valueForKey:TMLAuthorizationAccessTokenKey];
    if (accessToken.length == 0) {
        TMLWarn(@"Got empty access token from gateway!");
        return;
    }
    
    [TML sharedInstance].configuration.accessToken = accessToken;
    [TML sharedInstance].currentUser = userInfo[TMLAuthorizationUserKey];
    
    [controller close];
    
    [self showProjects];
}

- (void)authorizationWindowController:(GPAuthorizationWindowController *)controller didFailToAuthorize:(NSError *)error {
    [controller close];
}

- (void)authorizationWindowControllerDidRevokeAuthorization:(GPAuthorizationWindowController *)controller {
    [TML sharedInstance].configuration.accessToken = nil;
    [TML sharedInstance].currentUser = nil;
    
    [controller close];
}

@end
