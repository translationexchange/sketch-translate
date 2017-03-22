//
//  GPTranslationExchangeExportService.m
//  StringUtility
//
//  Created by Konstantin Kabanov on 22/03/2017.
//  Copyright © 2017 GoPro Inc. All rights reserved.
//

#import "GPTranslationExchangeExportService.h"

#import "MSDocument.h"
#import "MSPage.h"
#import "MSSymbolInstance.h"
#import "MSTextLayer.h"
#import "GPOverridedLayerInfo.h"

#import <TMLKit.h>
#import "GPAuthorizationWindowController.h"

@interface GPTranslationExchangeExportService () <GPAuthorizationWindowControllerDelegate>

@end

@implementation GPTranslationExchangeExportService {
    NSWindowController *_currentWindowController;
}

- (void)run {
    TMLConfiguration *configuration = [[TMLConfiguration alloc] init];
    [TML sharedInstanceWithConfiguration:configuration];
    
    if ([TML sharedInstance].configuration.accessToken.length == 0) {
        GPAuthorizationWindowController *authController = [[GPAuthorizationWindowController alloc] initWithConfiguration:configuration];
        
        authController.delegate = self;
        [authController authorize];
        
        [authController showWindow:nil];
        _currentWindowController = authController;
    }
}

- (void)authorizationWindowController:(GPAuthorizationWindowController *)controller didGrantAuthorization:(NSDictionary *)userInfo {
    NSString *accessToken = [userInfo valueForKey:TMLAuthorizationAccessTokenKey];
    if (accessToken.length == 0) {
        TMLWarn(@"Got empty access token from gateway!");
        return;
    }
    
    [TML sharedInstance].configuration.accessToken = accessToken;
    [TML sharedInstance].currentUser = userInfo[TMLAuthorizationUserKey];
    
    [controller.window close];
}

- (void)authorizationWindowController:(GPAuthorizationWindowController *)controller didFailToAuthorize:(NSError *)error {
    [controller.window close];
}

- (void)authorizationWindowControllerDidRevokeAuthorization:(GPAuthorizationWindowController *)controller {
    [TML sharedInstance].configuration.accessToken = nil;
    [TML sharedInstance].currentUser = nil;
    
    [controller.window close];
}

@end
