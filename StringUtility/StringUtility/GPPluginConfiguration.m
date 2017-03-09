//
//  GPPluginConfiguration.m
//  StringUtility
//
//  Created by Konstantin Kabanov on 09/03/2017.
//  Copyright © 2017 GoPro Inc. All rights reserved.
//

#import "GPPluginConfiguration.h"

NSString * const GPPluginConfigurationBundleName = @"com.gopro.sketch.stringutility";

NSString * const GPPluginConfigurationLocaleIdentifiersKey = @"GPPluginConfigurationLocaleIdentifiersKey";
NSString * const GPPluginConfigurationFindStringsInOptionKey = @"GPPluginConfigurationFindStringsInOptionKey";
NSString * const GPPluginConfigurationIsMaxCharacterCountEnabledKey = @"GPPluginConfigurationIsMaxCharacterCountEnabledKey";
NSString * const GPPluginConfigurationIsMaxLineCountEnabledKey = @"GPPluginConfigurationIsMaxLineCountEnabledKey";
NSString * const GPPluginConfigurationIsFontTypeEnabledKey = @"GPPluginConfigurationIsFontTypeEnabledKey";
NSString * const GPPluginConfigurationIsFontSizeEnabledKey = @"GPPluginConfigurationIsFontSizeEnabledKey";
NSString * const GPPluginConfigurationIsTextAlignmentEnabledKey = @"GPPluginConfigurationIsTextAlignmentEnabledKey";
NSString * const GPPluginConfigurationIsTextFieldDimensionsEnabledKey = @"GPPluginConfigurationIsTextFieldDimensionsEnabledKey";

@interface GPPluginConfiguration ()

@property (readonly, nonatomic) NSMutableDictionary *pluginUserDefaults;

@end

@implementation GPPluginConfiguration {
    NSMutableDictionary *_pluginUserDefaults;
}

+ (instancetype)sharedConfiguration {
    static GPPluginConfiguration *sharedConfiguration = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedConfiguration = [[GPPluginConfiguration alloc] init];
    });
    return sharedConfiguration;
}

- (NSMutableDictionary *)pluginUserDefaults {
    if (!_pluginUserDefaults) {
        _pluginUserDefaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:GPPluginConfigurationBundleName] mutableCopy];
        
        if (!_pluginUserDefaults) {
            _pluginUserDefaults = [@{} mutableCopy];
        }
    }
    
    return _pluginUserDefaults;
}

- (void)save {
    [[NSUserDefaults standardUserDefaults] setObject:self.pluginUserDefaults forKey:GPPluginConfigurationBundleName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//

- (NSArray *)localeIdentifiers {
    return self.pluginUserDefaults[GPPluginConfigurationLocaleIdentifiersKey];
}

- (void)setLocaleIdentifiers:(NSArray *)localeIdentifiers {
    self.pluginUserDefaults[GPPluginConfigurationLocaleIdentifiersKey] = localeIdentifiers;
}

//

- (NSInteger)findStringsInOption {
    return [self.pluginUserDefaults[GPPluginConfigurationFindStringsInOptionKey] integerValue];
}

- (void)setFindStringsInOption:(NSInteger)findStringsInOption {
    self.pluginUserDefaults[GPPluginConfigurationFindStringsInOptionKey] = @(findStringsInOption);
}

//

- (BOOL)isMaxCharacterCountEnabled {
    return [self.pluginUserDefaults[GPPluginConfigurationIsMaxCharacterCountEnabledKey] boolValue];
}

- (void)setIsMaxCharacterCountEnabled:(BOOL)isMaxCharacterCountEnabled {
    self.pluginUserDefaults[GPPluginConfigurationIsMaxCharacterCountEnabledKey] = @(isMaxCharacterCountEnabled);
}

//

- (BOOL)isMaxLineCountEnabled {
    return [self.pluginUserDefaults[GPPluginConfigurationIsMaxLineCountEnabledKey] boolValue];
}

- (void)setIsMaxLineCountEnabled:(BOOL)isMaxLineCountEnabled {
    self.pluginUserDefaults[GPPluginConfigurationIsMaxLineCountEnabledKey] = @(isMaxLineCountEnabled);
}

//

- (BOOL)isFontTypeEnabled {
    return [self.pluginUserDefaults[GPPluginConfigurationIsFontTypeEnabledKey] boolValue];
}

- (void)setIsFontTypeEnabled:(BOOL)isFontTypeEnabled {
    self.pluginUserDefaults[GPPluginConfigurationIsFontTypeEnabledKey] = @(isFontTypeEnabled);
}

//

- (BOOL)isFontSizeEnabled {
    return [self.pluginUserDefaults[GPPluginConfigurationIsFontSizeEnabledKey] boolValue];
}

- (void)setIsFontSizeEnabled:(BOOL)isFontSizeEnabled {
    self.pluginUserDefaults[GPPluginConfigurationIsFontSizeEnabledKey] = @(isFontSizeEnabled);
}

//

- (BOOL)isTextAlignmentEnabled {
    return [self.pluginUserDefaults[GPPluginConfigurationIsTextAlignmentEnabledKey] boolValue];
}

- (void)setIsTextAlignmentEnabled:(BOOL)isTextAlignmentEnabled {
    self.pluginUserDefaults[GPPluginConfigurationIsTextAlignmentEnabledKey] = @(isTextAlignmentEnabled);
}

//

- (BOOL)isTextFieldDimensionsEnabled {
    return [self.pluginUserDefaults[GPPluginConfigurationIsTextFieldDimensionsEnabledKey] boolValue];
}

- (void)setIsTextFieldDimensionsEnabled:(BOOL)isTextFieldDimensionsEnabled {
    self.pluginUserDefaults[GPPluginConfigurationIsTextFieldDimensionsEnabledKey] = @(isTextFieldDimensionsEnabled);
}

@end
