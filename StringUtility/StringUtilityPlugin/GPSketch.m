//
//  GPSketch.m
//  StringUtility
//
//  Created by Konstantin Kabanov on 09/03/2017.
//  Copyright © 2017 GoPro Inc. All rights reserved.
//

#import "GPSketch.h"
#import "MSDocument.h"
#import "MSPage.h"

#import "GPExportOptionsWindowController.h"

static NSDictionary *_context;
static NSWindowController *_wc;

@implementation GPSketch

+ (void)setPluginContextDictionary:(NSDictionary *)context {
    _context = context;
    
    MSDocument *document = context[@"document"];
    NSArray<MSPage *> *pages = [document pages];
    
    for (MSPage *page in pages) {
        NSLog(@"%@", page.name);
    }
}

+ (void)exportOptions {
    GPExportOptionsWindowController *wc = [[GPExportOptionsWindowController alloc] init];
    _wc = wc;
    [wc showWindow:nil];
}

@end
