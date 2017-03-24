//
//  GPProjectsWindowController.h
//  StringUtility
//
//  Created by Konstantin Kabanov on 22/03/2017.
//  Copyright © 2017 GoPro Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <TMLKit.h>

@protocol GPProjectsWindowControllerDelegate;

@interface GPProjectsWindowController : NSWindowController

@property (weak, nonatomic) id<GPProjectsWindowControllerDelegate> delegate;

@end

@protocol GPProjectsWindowControllerDelegate <NSObject>

- (void)projectsWindowController:(GPProjectsWindowController *)controller didSelectProject:(TMLApplication *)project;

@end
