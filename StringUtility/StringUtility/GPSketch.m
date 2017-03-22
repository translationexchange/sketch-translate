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
static GPService *_currentService;

@implementation GPSketch

+ (void)setPluginContextDictionary:(NSDictionary *)context {
    _context = [context copy];
}

+ (void)presentImport {
    _currentService = [[GPStandardImportService alloc] initWithContext:_context];
    [_currentService run];
}

+ (void)presentExport {
    _currentService = [[GPTranslationExchangeExportService alloc] initWithContext:_context];
    [_currentService run];
}

@end
