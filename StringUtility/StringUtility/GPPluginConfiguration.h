//
//  GPPluginConfiguration.h
//  StringUtility
//
//  Created by Konstantin Kabanov on 09/03/2017.
//  Copyright © 2017 GoPro Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPPluginConfiguration : NSObject

+ (instancetype)sharedConfiguration;

- (void)save;

@property (strong, nonatomic) NSArray *localeIdentifiers;
@property (nonatomic) NSInteger findStringsInOption;
@property (nonatomic) BOOL isMaxCharacterCountEnabled;
@property (nonatomic) BOOL isMaxLineCountEnabled;
@property (nonatomic) BOOL isFontTypeEnabled;
@property (nonatomic) BOOL isFontSizeEnabled;
@property (nonatomic) BOOL isTextAlignmentEnabled;
@property (nonatomic) BOOL isTextFieldDimensionsEnabled;

@end
