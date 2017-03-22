//
//  GPAuthorizationWindowController.m
//  StringUtility
//
//  Created by Konstantin Kabanov on 21/03/2017.
//  Copyright © 2017 GoPro Inc. All rights reserved.
//

#import "GPAuthorizationWindowController.h"
#import <TMLAuthorizationController.h>

@interface GPAuthorizationWindowController ()

@property (strong, nonatomic) NSURL *authorizationURL;
@property (strong, nonatomic) NSURL *deauthorizationURL;

@property (strong, nonatomic) TMLAPIClient *apiClient;

@end

@implementation GPAuthorizationWindowController

- (instancetype)initWithConfiguration:(TMLConfiguration *)configuration {
    if (self = [super init]) {
        self.configuration = configuration;
        self.apiClient = [[TMLAPIClient alloc] initWithBaseURL:configuration.apiBaseURL applicationKey:configuration.applicationKey accessToken:configuration.accessToken];
        
        NSURL *url = [configuration.gatewayBaseURL copy];
        NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
        self.authorizationURL = components.URL;
        
        url = [configuration.gatewayBaseURL URLByAppendingPathComponent:@"logout"];
        components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
        self.deauthorizationURL = components.URL;
    }
    return self;
}

#pragma mark - Authorizing

- (void)authorize {
    NSURLRequest *request = [NSURLRequest requestWithURL:self.authorizationURL];
    [self.webView loadRequest:request];
}

- (void) setAccessToken:(NSString *)accessToken forUser:(TMLBasicUser *)user {
    [[TMLAuthorizationController sharedAuthorizationController] setAccessToken:accessToken
                                                                    forAccount:user.username];
    [self notifyDelegateWithGrantedAccessToken:accessToken user:user];
}

- (void) failAuthorizationWithError:(NSError *)error {
    [self notifyDelegateAuthorizationFailed:error];
}

#pragma mark - Deauthorizing

- (void)deauthorize {
    NSURLRequest *request = [NSURLRequest requestWithURL:self.deauthorizationURL];
    [self.webView loadRequest:request];
}

#pragma mark - Notifying Delegate

- (void)notifyDelegateWithGrantedAccessToken:(NSString *)accessToken user:(TMLBasicUser *)user {
    id <GPAuthorizationWindowControllerDelegate>delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(authorizationWindowController:didGrantAuthorization:)] == YES) {
        NSDictionary *authInfo = @{
                                   TMLAuthorizationAccessTokenKey: accessToken,
                                   TMLAuthorizationUserKey: user
                                   };
        [delegate authorizationWindowController:self didGrantAuthorization:authInfo];
    }
}

- (void)notifyDelegateWithRevokedAccess {
    id<GPAuthorizationWindowControllerDelegate>delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(authorizationWindowControllerDidRevokeAuthorization:)] == YES) {
        [delegate authorizationWindowControllerDidRevokeAuthorization:self];
    }
}

- (void)notifyDelegateAuthorizationFailed:(NSError *)error {
    id<GPAuthorizationWindowControllerDelegate>delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(authorizationWindowController:didFailToAuthorize:)] == YES) {
        [delegate authorizationWindowController:self didFailToAuthorize:error];
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [super webView:webView didFinishNavigation:navigation];
    NSURL *url = webView.URL;
    if ([url isEqual:self.deauthorizationURL] == YES) {
        [self notifyDelegateWithRevokedAccess];
    }
}

- (void)postedUserInfo:(NSDictionary *)userInfo {
    [super postedUserInfo:userInfo];
    if ([@"unauthorized" isEqualToString:userInfo[@"status"]] == YES) {
        NSURL *authURL = [NSURL URLWithString:userInfo[@"url"]];
        if (authURL == nil) {
            TMLWarn(@"Unauthorized and don't know what to do...");
            return;
        }
        [self.webView loadRequest:[NSURLRequest requestWithURL:authURL]];
    }
    else if ([@"authorized" isEqualToString:userInfo[@"status"]] == YES) {
        NSString *accessToken = userInfo[@"access_token"];
        
        self.configuration.accessToken = accessToken;
        self.apiClient.accessToken = accessToken;
        
        NSError *error = nil;
        if (accessToken == nil) {
            TMLWarn(@"No authentication token found in posted message");
            error = [NSError errorWithDomain:TMLAuthorizationErrorDomain
                                        code:TMLAuthorizationUnexpectedResponseError
                                    userInfo:@{NSLocalizedDescriptionKey : @"No authentication token found in authorization response"}];
        }
        else {
            [self.apiClient getUserInfo:^(TMLUser *user, TMLAPIResponse *response, NSError *error) {
                if (user == nil || [[NSNull null] isEqual:user] == YES) {
                    TMLError(@"No translator indicated in auth response");
                    user = nil;
                    error = [NSError errorWithDomain:TMLAuthorizationErrorDomain
                                                code:TMLAuthorizationUnexpectedResponseError
                                            userInfo:@{NSLocalizedDescriptionKey : @"No translator description found in authorization response"}];
                }
                if (user != nil) {
                    [self setAccessToken:accessToken forUser:user];
                }
                else {
                    if (error == nil) {
                        error = [NSError errorWithDomain:TMLAuthorizationErrorDomain
                                                    code:TMLAuthorizationUnknownError
                                                userInfo:nil];
                    }
                    [self notifyDelegateAuthorizationFailed:error];
                }
            }];
        }
    }
    else {
        TMLWarn(@"Unrecognized message posted");
    }
}

@end
