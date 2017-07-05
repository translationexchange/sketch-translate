//
//  TMLWebViewController.h
//  TMLKit
//
//  Created by Pasha on 8/16/16.
//  Copyright © 2016 Translation Exchange. All rights reserved.
//

#import "TMLViewController.h"

#if TARGET_OS_IOS || TARGET_OS_TV

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface TMLWebViewController : UIViewController <WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, readonly) WKWebView *webView;

- (void)postedErrorMessage:(NSString *)message;
- (void)postedUserInfo:(NSDictionary *)userInfo;

@end

#endif
