//
//  GPTranslationExchangeImportService.m
//  StringUtility
//
//  Created by Konstantin Kabanov on 22/03/2017.
//  Copyright © 2017 GoPro Inc. All rights reserved.
//

#import "GPTranslationExchangeImportService.h"
#import "GPAuthorizationWindowController.h"
#import "GPProjectsWindowController.h"

#import "MSKit.h"
#import <TMLKit.h>

#import "GPOverridedLayerInfo.h"
#import "GPPluginConfiguration.h"

@interface GPTranslationExchangeImportService () <GPAuthorizationWindowControllerDelegate, GPProjectsWindowControllerDelegate>

@end

@implementation GPTranslationExchangeImportService {
    NSWindowController *_currentWindowController;
}

- (void)run {
    if (TMLSharedConfiguration() == nil) {
        TMLConfiguration *configuration = [[TMLConfiguration alloc] init];
        [TML sharedInstanceWithConfiguration:configuration];
    }
    
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
    
    [[TMLBundleManager defaultManager] apiBundleForApplicationKey:TMLApplicationKey()].syncAllLocales = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(importStrings) name:TMLDidFinishSyncNotification object:nil];
}

- (void)importStrings {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TMLDidFinishSyncNotification object:nil];
    
    TMLLanguage *defaultLanguage = [TML sharedInstance].application.defaultLanguage;
    
    for (TMLLanguage *language in [TML sharedInstance].currentBundle.languages) {
        for (TMLTranslationKey *translationKey in [TML sharedInstance].currentBundle.translationKeys.allValues) {
            NSString *originalText = [defaultLanguage translateKey:translationKey source:nil tokens:nil options:nil];
            NSString *text = [language translateKey:translationKey source:nil tokens:nil options:nil];
            
            NSArray *pages = [self pagesForLanguage:language.locale];
            NSArray *layers = [self layersForPages:pages];
            GPOverridedLayerInfo *info = [self findOverridedLayerInfoWithText:originalText inLayers:layers];
            
            if (info) {
                NSMutableDictionary *mutableOverrides = [info.symbolInstance.overrides mutableCopy];
                NSMutableDictionary *mutableValuesDict = [mutableOverrides[@0] mutableCopy];
                mutableValuesDict[info.layer.objectID] = text;
                mutableOverrides[@0] = mutableValuesDict;
                
                info.symbolInstance.overrides = mutableOverrides;
            }
        }
    }
}

- (NSArray *)pagesForLanguage:(NSString *)language {
    MSDocument *document = self.context[@"document"];
    NSArray *pages = document.pages;
    
    NSArray *originPages = [pages filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT (name CONTAINS[cd] %@) AND (name != %@)", @": ", @"Symbols"]];
    
    if ([language isEqualToString:[TML sharedInstance].application.defaultLanguage.locale]) {
        return originPages;
    }
    
    NSMutableArray *pagesForLanguage = [[pages filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name ENDSWITH %@", [NSString stringWithFormat:@": %@", language]]] mutableCopy];
    
    for (MSPage *originPage in originPages) {
        NSString *pageName = [NSString stringWithFormat:@"%@: %@", originPage.name, language];
        
        if ([[pagesForLanguage filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", pageName]] count] == 0) {
            MSPage *pageForLanguage = [originPage copy];
            pageForLanguage.name = pageName;
            
            id documentData = [document valueForKeyPath:@"documentData"];
            [documentData performSelector:@selector(addPage:) withObject:pageForLanguage];
            
            [pagesForLanguage addObject:pageForLanguage];
        }
    }
    
    document.currentPage = document.currentPage;
    
    return pagesForLanguage;
}

- (NSArray *)layersForPages:(NSArray *)pages {
    NSMutableArray *layers = [@[] mutableCopy];
    
    for (MSPage *page in pages) {
        [layers addObjectsFromArray:page.children];
    }
    
    return layers;
}

- (GPOverridedLayerInfo *)findOverridedLayerInfoWithText:(NSString *)text inLayers:(NSArray *)layers {
    for (MSLayer *layer in layers) {
        if ([layer.className isEqualToString:@"MSSymbolInstance"]) {
            MSSymbolInstance *instance = (MSSymbolInstance *)layer;
            MSSymbolMaster *master = instance.symbolMaster;
            NSDictionary *overrides = instance.overrides;
            
            NSArray *masterChildren = master.children;
            
            for (MSTextLayer *layer in masterChildren) {
                if ([layer.className isEqualToString:@"MSTextLayer"]) {
                    NSString *textOverride = overrides[@0][layer.objectID];
                    
                    if ([textOverride isEqualToString:text]) {
                        GPOverridedLayerInfo *info = [[GPOverridedLayerInfo alloc] init];
                        info.symbolInstance = instance;
                        info.layer = layer;
                        
                        return info;
                    }
                }
            }
        }
    }
    
    return nil;
}

@end
