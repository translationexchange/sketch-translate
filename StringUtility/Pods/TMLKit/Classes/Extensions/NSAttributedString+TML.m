//
//  NSAttributedString+TML.m
//  TMLKit
//
//  Created by Pasha on 12/6/15.
//  Copyright © 2015 Translation Exchange. All rights reserved.
//

#import "NSAttributedString+TML.h"
#import "TMLDecorationTokenizer.h"

NSString * const TMLAttributedStringStylePrefix = @"style";

@implementation NSAttributedString (TML)
- (NSString *)tmlAttributedString:(NSDictionary **)tokens {
    return [self tmlAttributedString:tokens implicit:YES];
}

- (NSString *)tmlAttributedString:(NSDictionary **)tokens implicit:(BOOL)implicit {
    NSString *ourString = [self string];
    NSMutableDictionary *parts = [NSMutableDictionary dictionary];
    NSCharacterSet *whiteSpaceCharSet = [NSCharacterSet whitespaceCharacterSet];
    NSMutableDictionary *styleTokens = [NSMutableDictionary dictionary];
    __block NSInteger count=0;
    
    [self enumerateAttributesInRange:NSMakeRange(0, self.length)
                             options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired
                          usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
                              if (attrs.count == 0) {
                                  return;
                              }
                              NSString *token = nil;
                              if (count == 0) {
                                  token = TMLAttributedStringStylePrefix;
                              }
                              else {
                                  token = [NSString stringWithFormat:@"%@%zd", TMLAttributedStringStylePrefix, count];
                              }
                              count++;
                              
                              NSString *substring = [ourString substringWithRange:range];
                              NSString *trimmedString = [substring stringByTrimmingCharactersInSet:whiteSpaceCharSet];
                              NSRange subRange = [substring rangeOfString:trimmedString];
                              subRange.location += range.location;
                              if (subRange.location == NSNotFound) {
                                  subRange = range;
                              }
                              
                              NSString *tokenizedString = [ourString substringWithRange:subRange];
                              if (implicit == NO
                                  || !(range.location == 0 && range.length == self.length)) {
                                  tokenizedString = [TMLDecorationTokenizer formatString:tokenizedString
                                                                               withToken:token];
                              }
                              NSValue *rangeValue = [NSValue valueWithRange:subRange];
                              parts[rangeValue] = tokenizedString;
                              styleTokens[token] = @{@"attributes": attrs};
                          }];
    
    if (count == 0) {
        return ourString;
    }
    
    NSMutableString *tmlString = [NSMutableString string];
    NSArray *sortedLocations = [[parts allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSValue *rangeA, NSValue *rangeB) {
        NSRange a = [rangeA rangeValue];
        NSRange b = [rangeB rangeValue];
        return [@(a.location) compare:@(b.location)];
    }];
    NSInteger tail = 0;
    for (NSValue *rangeValue in sortedLocations) {
        NSRange range = [rangeValue rangeValue];
        if (range.location > tail) {
            [tmlString appendString:[ourString substringWithRange:NSMakeRange(tail, range.location-tail)]];
        }
        NSString *tokenizedString = parts[rangeValue];
        [tmlString appendString:tokenizedString];
        tail = range.location + range.length;
    }
    if (tmlString.length < ourString.length) {
        [tmlString appendString:[ourString substringWithRange:NSMakeRange(tmlString.length, ourString.length - tmlString.length)]];
    }
    if (tokens != nil) {
        *tokens = styleTokens;
    }
    return tmlString;
}

@end
