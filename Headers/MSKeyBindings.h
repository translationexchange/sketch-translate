//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "CHSingletonObject.h"

@class NSMutableDictionary;

@interface MSKeyBindings : CHSingletonObject
{
    NSMutableDictionary *_shortcutMap;
    NSMutableDictionary *_keyComboToActionMap;
}

+ (void)registerActionNames:(id)arg1;
+ (id)actionNameForCharacter:(unsigned short)arg1;
+ (BOOL)keyComboIsPressed:(unsigned long long)arg1 withCharacter:(unsigned short)arg2;
+ (unsigned long long)keyComboForCharacter:(unsigned short)arg1;
@property(retain, nonatomic) NSMutableDictionary *keyComboToActionMap; // @synthesize keyComboToActionMap=_keyComboToActionMap;
@property(retain, nonatomic) NSMutableDictionary *shortcutMap; // @synthesize shortcutMap=_shortcutMap;
- (void).cxx_destruct;
- (id)defaultKeyComboNames;
- (id)defaultKeyBindingsPath;
- (id)userKeyBindingsPath;
- (void)registerActionNames:(id)arg1;
- (id)actionNameForCharacter:(unsigned short)arg1;
- (unsigned long long)keyComboForCharacter:(unsigned short)arg1;
- (id)shortcutToComboMapFromDefaultsAtPath:(id)arg1 actionNames:(id)arg2;
- (id)init;

@end

