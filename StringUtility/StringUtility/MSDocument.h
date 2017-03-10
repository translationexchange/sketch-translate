//
//  MSDocument.h
//  StringUtility
//
//  Created by Konstantin Kabanov on 09/03/2017.
//  Copyright © 2017 GoPro Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MSPage.h"

@interface MSDocument : NSDocument

- (NSArray<MSPage *> *)pages;

- (MSPage *)currentPage;

@end
