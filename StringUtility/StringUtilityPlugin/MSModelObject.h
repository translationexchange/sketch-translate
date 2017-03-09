//
//  MSModelObject.h
//  StringUtility
//
//  Created by Konstantin Kabanov on 09/03/2017.
//  Copyright © 2017 GoPro Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MSModelObject : NSObject

@property(copy, nonatomic) NSObject<NSCopying, NSCoding> *objectID;

@end
