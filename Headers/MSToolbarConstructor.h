//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "NSObject.h"

#import "NSToolbarDelegate.h"

@class MSDocument, MSToolbar, NSString;

@interface MSToolbarConstructor : NSObject <NSToolbarDelegate>
{
    MSToolbar *toolbar;
    MSDocument *_doc;
}

+ (id)toolbarForDocument:(id)arg1;
@property(nonatomic) __weak MSDocument *doc; // @synthesize doc=_doc;
- (void).cxx_destruct;
- (void)dealloc;
- (id)toolbar:(id)arg1 itemForItemIdentifier:(id)arg2 willBeInsertedIntoToolbar:(BOOL)arg3;
- (id)toolbarDefaultItemIdentifiers:(id)arg1;
- (id)toolbarSelectableItemIdentifiers:(id)arg1;
- (id)toolbarAllowedItemIdentifiers:(id)arg1;
- (id)allActions;
- (id)standardToolbarIdentifiers;
- (void)constructToolbarForWindow:(id)arg1;
- (id)toolbar;
- (id)initWithDocument:(id)arg1;

// Remaining properties
@property(readonly, copy) NSString *debugDescription;
@property(readonly, copy) NSString *description;
@property(readonly) unsigned long long hash;
@property(readonly) Class superclass;

@end

