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

@implementation GPTranslationExchangeExportService

- (void)run {
    TMLConfiguration *configuration = [[TMLConfiguration alloc] init];
    [TML sharedInstanceWithConfiguration:configuration];
    
    if ([TML sharedInstance].configuration.accessToken.length == 0) {
        GPAuthorizationWindowController *authController = [[GPAuthorizationWindowController alloc] initWithConfiguration:configuration];
        
        authController.delegate = self;
        [authController authorize];
        
        MSDocument *document = self.context[@"document"];
        NSWindowController *documentWindowController = [document.windowControllers firstObject];
        
        [authController showWindow:nil];
    }
}

@end
