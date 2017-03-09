//
//  AppDelegate.m
//  StringUtility
//
//  Created by Konstantin Kabanov on 07/03/2017.
//  Copyright © 2017 GoPro Inc. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    [[self bundledWindowController] showWindow:self];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (NSWindowController *)bundledWindowController
{
    // Assume _bundledWindowController is a private instance variable
    // of type id or NSWindowController *.
    if(!_bundledWindowController)
    {
        NSString *bundlePath = [[[NSBundle mainBundle] builtInPlugInsPath]
                                stringByAppendingPathComponent:@"StringUtilityPlugin.bundle"];
        NSBundle *windowBundle = [NSBundle bundleWithPath:bundlePath];
        
        if(windowBundle)
        {
            Class windowControllerClass = [windowBundle principalClass];
            if(windowControllerClass)
            {
                _bundledWindowController = [[windowControllerClass
                                             alloc] init];
            }
        }
    }
    
    return _bundledWindowController;
}


@end
