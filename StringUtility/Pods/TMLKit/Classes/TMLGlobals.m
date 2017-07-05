//
//  TMLGlobals.m
//  Demo
//
//  Created by Pasha on 11/7/15.
//  Copyright © 2015 TmlHub Inc. All rights reserved.
//

#import "TMLGlobals.h"

NSString * const TMLAbstractInvocationException = @"TMLAbstractInvocation";

void TMLAbstractInvocation(SEL selector,id object) {
    [NSException raise:TMLAbstractInvocationException
                format:@"[%@ %@] forwards to an abstract invocation",
     NSStringFromClass([object class]),
     NSStringFromSelector(selector)
     ];
}

NSString * const TMLNotYetImplementedException = @"TMLNotYetImplemented";

void TMLNotYetImplemented(SEL selector, id object) {
    [NSException raise:TMLNotYetImplementedException
                format:@"[%@ %@] Is not yet implemented",
     NSStringFromClass([object class]),
     NSStringFromSelector(selector)];
}

NSString * const TMLAlternativeInstantiationException = @"TMLAlternativeInstantiation";
void TMLUseAlternativeInstantiationMethod(SEL selector, id object) {
    [NSException raise:TMLAlternativeInstantiationException
                format:@"Use -[%@ %@] instantiation method",
     [object class],
     NSStringFromSelector(selector)
     ];
}


#pragma mark - Notification Constants
NSString * const TMLLanguageChangedNotification = @"TMLLanguageChangedNotification";
NSString * const TMLLocalizationDataChangedNotification = @"TMLLocalizationDataChangedNotification";
NSString * const TMLDidStartSyncNotification = @"TMLDidStartSyncNotification";
NSString * const TMLDidFinishSyncNotification = @"TMLDidFinishSyncNotification";
NSString * const TMLLocalizationUpdatesInstalledNotification = @"TMLLocalizationUpdatesInstalledNotification";
NSString * const TMLLocalizationUpdatesFailedNotification = @"TMLLocalizationUpdatesFailedNotification";

#pragma mark - UserInfo Constants
NSString * const TMLPreviousLocaleUserInfoKey = @"TMLPreviousLocaleUserInfoKey";
NSString * const TMLTokensInfoKey = @"tokens";
NSString * const TMLOptionsInfoKey = @"options";
NSString * const TMLTranslationKeyInfoKey = @"translationKey";
NSString * const TMLSourceInfoKey = @"source";
NSString * const TMLLocalizedStringInfoKey = @"localizedString";

#pragma mark - Options
NSString * const TMLSourceOptionName = @"source";
NSString * const TMLLocaleOptionName = @"locale";
NSString * const TMLLevelOptionName = @"level";
NSString * const TMLTokenFormatOptionName = @"tokenFormat";
NSString * const TMLReuseIdentifierOptionName = @"reuseIdentifier";
NSString * const TMLSenderOptionName = @"sender";

#pragma mark - Tokens
NSString * const TMLViewingUserTokenName = @"viewing_user";

NSString * const TMLDataTokenTypeString = @"data";
NSString * const TMLDecorationTokenTypeString = @"decoration";
NSString * const TMLHTMLTokenFormatString = @"html";
NSString * const TMLAttributedTokenFormatString = @"attributed";

NSString * NSStringFromTokenType(TMLTokenType type) {
    if (type == TMLDecorationTokenType) {
        return TMLDecorationTokenTypeString;
    }
    return TMLDataTokenTypeString;
}

NSString * NSStringFromTokenFormat(TMLTokenFormat format) {
    if (format == TMLAttributedTokenFormat) {
        return TMLAttributedTokenFormatString;
    }
    return TMLHTMLTokenFormatString;
}
