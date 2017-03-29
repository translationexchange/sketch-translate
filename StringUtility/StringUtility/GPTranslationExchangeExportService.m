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

#import "GPOverridedLayerInfo.h"
#import "GPPluginConfiguration.h"

@interface GPTranslationExchangeExportService () <GPAuthorizationWindowControllerDelegate, GPProjectsWindowControllerDelegate>

@end

@implementation GPTranslationExchangeExportService {
    NSWindowController *_currentWindowController;
}

- (void)run {
    if (TMLSharedConfiguration() == nil) {
        TMLConfiguration *configuration = [[TMLConfiguration alloc] init];
        [TML sharedInstanceWithConfiguration:configuration];
    }
    
    [self acquireAccessToken];
    
//    if ([TML sharedInstance].configuration.accessToken.length == 0) {
//        [self acquireAccessToken];
//    } else {
//        [self showProjects];
//    }
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
    wc.delegate = self;
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

- (void)projectsWindowController:(GPProjectsWindowController *)controller didSelectProject:(TMLApplication *)project {
    NSString *accessToken = [TML sharedInstance].configuration.accessToken;
    
    [TML sharedInstanceWithApplicationKey:project.key];
    
    [TML sharedInstance].configuration.accessToken = accessToken;
    
    [TML sharedInstance].translationActive = YES;
    
    [self exportStrings];
}

- (void)exportStrings {
    NSMutableArray *layerInfos = [@[] mutableCopy];
    NSMutableArray<MSLayer *> *layers = [@[] mutableCopy];
    
    MSDocument *document = self.context[@"document"];
    NSWindowController *documentWindowController = [document.windowControllers firstObject];
    
    NSArray<MSPage *> *pages = document.pages;
    
    if ([GPPluginConfiguration sharedConfiguration].findStringsInOption == 1) {
        pages = [document valueForKeyPath:@"sidebarController.pageListViewController.dataController.delegate.selectedPages"];
        
        if (!pages) {
            pages = @[document.currentPage];
        }
    }
    
    for (MSPage *page in pages) {
        [layers addObjectsFromArray:page.children];
    }
    
    for (MSLayer *layer in layers) {
        if ([layer.className isEqualToString:@"MSSymbolInstance"] && [layer.name hasPrefix:@"_"] && [layer.name hasSuffix:@"_"]) {
            MSSymbolInstance *instance = (MSSymbolInstance *)layer;
            MSSymbolMaster *master = instance.symbolMaster;
            NSDictionary *overrides = instance.overrides;
            
            NSArray *masterChildren = master.children;
            
            for (MSLayer *layer in masterChildren) {
                if (overrides && [layer.className isEqualToString:@"MSTextLayer"] && [layer.name hasPrefix:@"*"] && [layer.name hasSuffix:@"_"]) {
                    NSString *textOverride = overrides[@0][layer.objectID];
                    
                    if (textOverride) {
                        GPOverridedLayerInfo *info = [[GPOverridedLayerInfo alloc] init];
                        info.symbolInstance = instance;
                        info.layer = (MSTextLayer *)layer;
                        info.text = textOverride;
                        
                        [layerInfos addObject:info];
                    }
                }
            }
        }
    }
    
    for (GPOverridedLayerInfo *info in layerInfos) {
        TMLTranslationKey *translationKey = [[TMLTranslationKey alloc] init];
        translationKey.label = info.text;
        translationKey.key = info.identifier;
        translationKey.locale = TMLDefaultLocale();
        
        TMLSource *source = [[TMLSource alloc] init];
        source.key = info.layer.parentPage.name;
        
        if (![[TML sharedInstance] isTranslationKeyRegistered:translationKey.key]) {
            [[TML sharedInstance] registerMissingTranslationKey:translationKey forSourceKey:source.key];
        }
    }
}

@end
