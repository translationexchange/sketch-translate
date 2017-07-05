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

#import "TML.h"
#import "TMLAPIResponse.h"
#import "TMLSource.h"

NSString * const TMLSourceDefaultKey = @"TML";

@implementation TMLSource

+ (instancetype)defaultSource {
    static TMLSource *source;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        source = [[TMLSource alloc] init];
        source.key = TMLSourceDefaultKey;
    });
    return source;
}

- (id)copyWithZone:(NSZone *)zone {
    TMLSource *aCopy = [[TMLSource alloc] init];
    aCopy.translations = [self.translations copyWithZone:zone];
    aCopy.sourceID = self.sourceID;
    aCopy.key = [self.key copyWithZone:zone];
    aCopy.created = [self.created copyWithZone:zone];
    aCopy.updated = [self.updated copyWithZone:zone];
    aCopy.displayName = [self.displayName copyWithZone:zone];
    aCopy.sourceName = [self.sourceName copyWithZone:zone];
    aCopy.type = [self.type copyWithZone:zone];
    aCopy.state = [self.state copyWithZone:zone];
    return aCopy;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if ([object isKindOfClass:[self class]] == NO) {
        return NO;
    }
    
    return [self isEqualToSource:(TMLSource *)object];
}

- (BOOL)isEqualToSource:(TMLSource *)source {
    return (self.sourceID == source.sourceID
            && (self.key == source.key
                || [self.key isEqualToString:source.key] == YES)
            && (self.created == source.created
                || [self.created isEqualToDate:source.created] == YES)
            && (self.updated == source.updated
                || [self.updated isEqualToDate:source.updated] == YES)
            && (self.displayName == source.displayName
                || [self.displayName isEqualToString:source.displayName] == YES)
            && (self.sourceName == source.sourceName
                || [self.sourceName isEqualToString:source.sourceName] == YES)
            && (self.type == source.type
                || [self.type isEqualToString:source.type] == YES)
            && (self.state == source.state
                || [self.state isEqualToString:source.state] == YES));
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.sourceID forKey:@"id"];
    [aCoder encodeObject:self.key forKey:@"key"];
    [aCoder encodeObject:self.created forKey:@"created_at"];
    [aCoder encodeObject:self.updated forKey:@"updated_at"];
    [aCoder encodeObject:self.displayName forKey:@"display_name"];
    [aCoder encodeObject:self.sourceName forKey:@"source"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.state forKey:@"state"];
}

- (void)decodeWithCoder:(NSCoder *)aDecoder {
    self.sourceID = [aDecoder decodeIntegerForKey:@"id"];
    self.key = [aDecoder decodeObjectForKey:@"key"];
    self.created = [aDecoder decodeObjectForKey:@"created_at"];
    self.updated = [aDecoder decodeObjectForKey:@"updated_at"];
    self.displayName = [aDecoder decodeObjectForKey:@"display_name"];
    self.sourceName = [aDecoder decodeObjectForKey:@"source"];
    self.type = [aDecoder decodeObjectForKey:@"type"];
    self.state = [aDecoder decodeObjectForKey:@"state"];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %@>", NSStringFromClass([self class]), self.key];
}

- (NSUInteger)hash {
    return [self.key hash];
}

- (void) updateTranslations:(NSDictionary *)translationInfo forLocale:(NSString *)locale {
    NSMutableDictionary *newTranslations = [self.translations mutableCopy];
    newTranslations[locale]=translationInfo;
    self.translations = (NSDictionary *)newTranslations;
}

- (NSArray *) translationsForKey:(NSString *) translationKey inLanguage: (NSString *) locale {
    if (!self.translations && ![self.translations objectForKey:locale]) return nil;
    return [[self.translations objectForKey:locale] objectForKey:translationKey];
}

@end
