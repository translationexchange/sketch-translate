//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "NSObject.h"

@class MSImmutableDocumentData;

@interface MSManifestMaker : NSObject
{
    BOOL _selectiveExport;
    BOOL _usePageIfMissingArtboard;
    MSImmutableDocumentData *_doc;
    CDUnknownBlockType _imageProviderBlock;
}

+ (BOOL)isArtboardEqual:(id)arg1 toArtboard:(id)arg2;
+ (BOOL)isPageEqual:(id)arg1 toPage:(id)arg2;
+ (BOOL)wouldManifestChangeBetweenOldDoc:(id)arg1 andNewDoc:(id)arg2;
+ (id)manifestForDocument:(id)arg1 withName:(id)arg2 selectiveExport:(BOOL)arg3 usePageIfMissingArtboard:(BOOL)arg4 imageProviderBlock:(CDUnknownBlockType)arg5;
@property(nonatomic) BOOL usePageIfMissingArtboard; // @synthesize usePageIfMissingArtboard=_usePageIfMissingArtboard;
@property(nonatomic) BOOL selectiveExport; // @synthesize selectiveExport=_selectiveExport;
@property(copy, nonatomic) CDUnknownBlockType imageProviderBlock; // @synthesize imageProviderBlock=_imageProviderBlock;
@property(retain, nonatomic) MSImmutableDocumentData *doc; // @synthesize doc=_doc;
- (void).cxx_destruct;
- (id)fileMetadataForRoot:(id)arg1 onPage:(id)arg2 id:(id)arg3 exportScale:(double)arg4 manifestScale:(double)arg5;
- (id)filesMetadataForRootLayer:(id)arg1 onPage:(id)arg2 id:(id)arg3 scale:(double)arg4;
- (id)metadataAndExportForRootLayer:(id)arg1 onPage:(id)arg2 earlierSlugs:(id)arg3;
- (BOOL)shouldExportLayerGroup:(id)arg1;
- (id)metadataAndExportForArtboardsOnPage:(id)arg1;
- (id)metadataAndExportForPage:(id)arg1 earlierSlugs:(id)arg2;
- (id)metadataAndExportForPages:(id)arg1;
- (id)manifestWithName:(id)arg1;

@end

