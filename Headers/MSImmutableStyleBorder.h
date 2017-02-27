//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "_MSImmutableStyleBorder.h"

#import "MSStyleBorder.h"

@class NSObject<NSCopying><NSCoding>, NSString;

@interface MSImmutableStyleBorder : _MSImmutableStyleBorder <MSStyleBorder>
{
}

+ (id)defaultName;
- (void)updateColorCounter:(id)arg1;
- (void)drawGradientBorder:(id)arg1 advancedOptions:(id)arg2 originalPath:(id)arg3 isArtistic:(BOOL)arg4 frame:(struct CGRect)arg5 context:(id)arg6;
- (void)drawBorder:(id)arg1 advancedOptions:(id)arg2 context:(id)arg3;
- (void)addSVGAttributes:(id)arg1 exporter:(id)arg2;
- (void)addOuterMaskToAttributes:(id)arg1 withExporter:(id)arg2;
- (void)addInnerMaskToAttributes:(id)arg1 withExporter:(id)arg2;
- (id)addMaskElementToAttributes:(id)arg1 withExporter:(id)arg2;

// Remaining properties
@property(readonly, nonatomic) id <MSColor> colorGeneric;
@property(readonly, nonatomic) id <MSGraphicsContextSettings> contextSettingsGeneric;
@property(readonly, copy) NSString *debugDescription;
@property(readonly, copy) NSString *description;
@property(readonly, nonatomic) unsigned long long fillType;
@property(readonly, nonatomic) id <MSGradient> gradientGeneric;
@property(readonly) unsigned long long hash;
@property(readonly, nonatomic) BOOL isEnabled;
@property(readonly, copy, nonatomic) NSObject<NSCopying><NSCoding> *objectID;
@property(readonly, nonatomic) long long position;
@property(readonly) Class superclass;
@property(readonly, nonatomic) double thickness;

@end

