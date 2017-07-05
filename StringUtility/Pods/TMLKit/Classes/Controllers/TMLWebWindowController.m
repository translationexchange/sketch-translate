//
//  TMLWebWindowController.m
//  Pods
//
//  Created by Konstantin Kabanov on 20/03/2017.
//
//

#import "NSObject+TMLJSON.h"
#import "TML.h"
#import "TMLWebWindowController.h"

@interface TMLWebWindowController ()

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation TMLWebWindowController

- (instancetype)init {
    NSWindow *window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0.0f, 0.0f, 480.0f, 400.0f) styleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskClosable backing:NSBackingStoreRetained defer:YES];
    [window center];
    window.maxSize = window.frame.size;
    window.minSize = window.frame.size;
    window.title = @"Authorization";
    
    if (self = [super initWithWindow:window]) {
        WKUserContentController *webContentController = [[WKUserContentController alloc] init];
        [webContentController addScriptMessageHandler:self name:@"tmlMessageHandler"];
        
        WKUserScript *userScript = [[WKUserScript alloc] initWithSource:@"var tmlMessageHandler = window.webkit.messageHandlers.tmlMessageHandler;" injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        [webContentController addUserScript:userScript];
        
        WKWebViewConfiguration *webViewConfig = [[WKWebViewConfiguration alloc] init];
        webViewConfig.userContentController = webContentController;
        
        WKWebView *webView = [[WKWebView alloc] initWithFrame:NSMakeRect(0.0f, 0.0f, 480.0f, 400.0f) configuration:webViewConfig];
        webView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        webView.navigationDelegate = self;
        webView.UIDelegate = self;
        
        self.webView = webView;
        
        NSWindow *ourWindow = self.window;
        [ourWindow.contentView addSubview:webView];
    }
    return self;
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    completionHandler(YES);
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message
{
    if (message.body == nil) {
        TMLDebug(@"No body in posted message");
        return;
    }
    
    NSDictionary *result = nil;
    if ([message.body isKindOfClass:[NSDictionary class]] == YES) {
        result = message.body;
    }
    else {
        NSData *bodyData = [[NSData alloc] initWithBase64EncodedString:message.body options:0];
        NSString *body = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
        if (body != nil) {
            result = [body tmlJSONObject];
        }
    }
    
    if (result == nil) {
        TMLDebug(@"Didn't find anything relevant in posted message");
        return;
    }
    
    if ([@"error" isEqualToString:result[@"status"]] == YES) {
        NSString *message = result[@"message"];
        if (message == nil) {
            message = @"Unknown Error";
        }
        [self postedErrorMessage:message];
    }
    else {
        [self postedUserInfo:result];
    }
}

#pragma mark - Message post handling

- (void)postedErrorMessage:(NSString *)message {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setAlertStyle:NSCriticalAlertStyle];
    [alert addButtonWithTitle:@"OK"];
    alert.messageText = TMLLocalizedString(@"Error");
    alert.informativeText = message;
    
    [alert runModal];
}

- (void)postedUserInfo:(NSDictionary *)userInfo {
    TMLDebug(@"WebView posted message: %@", userInfo);
}

@end
