//
//  GPProjectsWindowController.m
//  StringUtility
//
//  Created by Konstantin Kabanov on 22/03/2017.
//  Copyright © 2017 GoPro Inc. All rights reserved.
//

#import "GPProjectsWindowController.h"

@interface GPProjectsWindowController ()

@property (weak) IBOutlet NSPopUpButton *popUpButton;

@property (strong, nonatomic) NSArray *projects;

@end

@implementation GPProjectsWindowController

- (NSString *)windowNibName {
    return [self className];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    [self fetchProjects];
}

- (void)fetchProjects {
    [[TML sharedInstance].apiClient getProjects:^(NSArray *projects, TMLAPIResponse *response, NSError *error) {
        self.projects = projects;
        
        [self.popUpButton removeAllItems];
        
        for (TMLApplication *project in self.projects) {
            [self.popUpButton addItemWithTitle:project.name];
        }
    }];
}

- (IBAction)cancelButtonAction:(id)sender {
    [self close];
}

- (IBAction)okButtonAction:(id)sender {
    TMLApplication *selectedProject = self.projects[self.popUpButton.indexOfSelectedItem];
    
    [self.delegate projectsWindowController:self didSelectProject:selectedProject];
    
    [self close];
}

@end
