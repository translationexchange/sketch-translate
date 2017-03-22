//
//  GPSketch.m
//  StringUtility
//
//  Created by Konstantin Kabanov on 09/03/2017.
//  Copyright © 2017 GoPro Inc. All rights reserved.
//

#import "GPSketch.h"

#import "GPStandardImportService.h"
#import "GPStandardExportService.h"
#import "GPTranslationExchangeImportService.h"
#import "GPTranslationExchangeExportService.h"

static NSDictionary *_context;

@implementation GPSketch

+ (void)setPluginContextDictionary:(NSDictionary *)context {
    _context = [context copy];
}

+ (void)presentImport {
    GPService *service = [[GPStandardImportService alloc] initWithContext:_context];
    [service run];
}

+ (void)presentExport {
    GPService *service = [[GPStandardExportService alloc] initWithContext:_context];
    [service run];
}

@end
