//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "MSDocumentAction.h"

@interface MSCreateSymbolAction : MSDocumentAction
{
}

- (BOOL)shouldUseImageForTouchBarItem;
- (BOOL)dynamicTitle;
- (id)historyMomentTitle;
- (id)label;
- (id)imageName;
- (void)createSymbolFromLayers:(id)arg1;
- (void)doCreateSymbolsFromArtboardsAndInsertInstances:(id)arg1;
- (void)createSymbolsFromArtboards:(id)arg1;
- (void)doPerformAction:(id)arg1;
- (BOOL)canCreateSymbolsFromArtboards:(id)arg1;
- (BOOL)validate;
- (void)createSymbolAction:(id)arg1;

@end
