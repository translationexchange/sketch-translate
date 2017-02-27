//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "MSModelObject.h"

@class NSString;

@interface _MSExportFormat : MSModelObject
{
    double _absoluteSize;
    NSString *_fileFormat;
    NSString *_name;
    long long _namingScheme;
    double _scale;
    long long _visibleScaleType;
}

+ (BOOL)allowsFaulting;
+ (Class)immutableClass;
- (void).cxx_destruct;
- (void)syncPropertiesFromObject:(id)arg1;
- (BOOL)propertiesAreEqual:(id)arg1;
- (void)copyPropertiesToObject:(id)arg1 options:(unsigned long long)arg2;
- (void)setAsParentOnChildren;
- (void)initializeUnsetObjectPropertiesWithDefaults;
- (BOOL)hasDefaultValues;
- (void)performInitEmptyObject;
@property(nonatomic) long long visibleScaleType; // @synthesize visibleScaleType=_visibleScaleType;
@property(nonatomic) double scale; // @synthesize scale=_scale;
@property(nonatomic) long long namingScheme; // @synthesize namingScheme=_namingScheme;
@property(retain, nonatomic) NSString *name; // @synthesize name=_name;
@property(retain, nonatomic) NSString *fileFormat; // @synthesize fileFormat=_fileFormat;
@property(nonatomic) double absoluteSize; // @synthesize absoluteSize=_absoluteSize;
- (void)performInitWithImmutableModelObject:(id)arg1;
- (void)enumerateChildProperties:(CDUnknownBlockType)arg1;
- (void)enumerateProperties:(CDUnknownBlockType)arg1;

@end

