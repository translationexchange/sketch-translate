//
//  MSLayer.h
//  StringUtility
//
//  Created by Konstantin Kabanov on 09/03/2017.
//  Copyright © 2017 GoPro Inc. All rights reserved.
//

#import "MSModelObject.h"

@class MSPage;

@interface MSLayer : MSModelObject

@property(nonatomic) CGPoint center;
@property(nonatomic) CGPoint origin;
@property(nonatomic) CGRect rect;
@property(copy, nonatomic) NSString *name;

- (MSPage *)parentPage;

@end
