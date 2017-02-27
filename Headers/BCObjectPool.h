//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "NSObject.h"

#import "NSDiscardableContent.h"

@class NSHashTable;

@interface BCObjectPool : NSObject <NSDiscardableContent>
{
    NSHashTable *_pool;
    unsigned long long _maximumPoolCount;
    CDUnknownBlockType _creatorBlock;
}

@property(readonly, copy, nonatomic) CDUnknownBlockType creatorBlock; // @synthesize creatorBlock=_creatorBlock;
- (void).cxx_destruct;
- (BOOL)isContentDiscarded;
- (void)discardContentIfPossible;
- (void)endContentAccess;
- (BOOL)beginContentAccess;
@property unsigned long long maximumPoolCount;
- (void)recycleObject:(id)arg1;
- (id)vendObject;
- (id)initWithObjectCreatorBlock:(CDUnknownBlockType)arg1;

@end

