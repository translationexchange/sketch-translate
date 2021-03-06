/*
 *  Copyright (c) 2015 Translation Exchange, Inc. All rights reserved.
 *
 *  _______                  _       _   _             ______          _
 * |__   __|                | |     | | (_)           |  ____|        | |
 *    | |_ __ __ _ _ __  ___| | __ _| |_ _  ___  _ __ | |__  __  _____| |__   __ _ _ __   __ _  ___
 *    | | '__/ _` | '_ \/ __| |/ _` | __| |/ _ \| '_ \|  __| \ \/ / __| '_ \ / _` | '_ \ / _` |/ _ \
 *    | | | | (_| | | | \__ \ | (_| | |_| | (_) | | | | |____ >  < (__| | | | (_| | | | | (_| |  __/
 *    |_|_|  \__,_|_| |_|___/_|\__,_|\__|_|\___/|_| |_|______/_/\_\___|_| |_|\__,_|_| |_|\__, |\___|
 *                                                                                        __/ |
 *                                                                                       |___/
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 */

#if TARGET_OS_IOS || TARGET_OS_TV

#import "NSObject+TML.h"
#import "TMLAnalytics.h"
#import "UIViewController+TML.h"
#import <objc/runtime.h>

@implementation UIViewController (TML)

+ (void)load {
    Method original = class_getInstanceMethod(self, @selector(didMoveToParentViewController:));
    Method ours = class_getInstanceMethod(self, @selector(tmlDidMoveToParentViewController:));
    method_exchangeImplementations(original, ours);
}

- (void)tmlDidMoveToParentViewController:(UIViewController *)parent {
    [self tmlDidMoveToParentViewController:parent];
    if (parent != nil) {
        [[TMLAnalytics sharedInstance] reportEvent:@{
                                                     TMLAnalyticsEventTypeKey: TMLAnalyticsPageViewEventName,
                                                     TMLAnalyticsEventDataKey: NSStringFromClass(self.class)
                                                     }];
    }
}

- (NSSet *)tmlLocalizableKeyPaths {
    NSMutableSet *keys = [[super tmlLocalizableKeyPaths] mutableCopy];
    if (keys == nil) {
        keys = [NSMutableSet set];
    }
    [keys addObject:@"title"];
    return [keys copy];
}

- (void)updateTMLLocalizedStringWithInfo:(NSDictionary *)info
                   forReuseIdentifier:(NSString *)reuseIdentifier
{
    if ([reuseIdentifier isEqualToString:@"title"] == YES) {
        NSString *newTitle = info[TMLLocalizedStringInfoKey];
        self.title = newTitle;
    }
    else {
        [super updateTMLLocalizedStringWithInfo:info
                             forReuseIdentifier:reuseIdentifier];
    }
}

@end

#endif
