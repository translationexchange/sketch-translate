//
//  TMLWebWindowController.h
//  Pods
//
//  Created by Konstantin Kabanov on 20/03/2017.
//
//

#import <AppKit/AppKit.h>
#import <WebKit/WebKit.h>

@interface TMLWebWindowController : NSWindowController <WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, readonly) WKWebView *webView;

- (void)postedErrorMessage:(NSString *)message;
- (void)postedUserInfo:(NSDictionary *)userInfo;

@end
