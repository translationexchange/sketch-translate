//
//  GPProjectsWindowController.m
//  StringUtility
//
//  Created by Konstantin Kabanov on 22/03/2017.
//  Copyright © 2017 GoPro Inc. All rights reserved.
//

#import "GPProjectsWindowController.h"

#import <TMLKit.h>

@interface GPProjectsWindowController ()

@property (weak) IBOutlet NSComboBox *projectsComboBox;

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
        
        [self.projectsComboBox removeAllItems];
        
        for (TMLApplication *project in self.projects) {
            [self.projectsComboBox addItemWithObjectValue:project.name];
        }
    }];
}

- (IBAction)cancelButtonAction:(id)sender {
    [self close];
}

- (IBAction)okButtonAction:(id)sender {
    TMLApplication *selectedProject = self.projects[self.projectsComboBox.indexOfSelectedItem];
    
    NSLog(@"Selected projects: %@", selectedProject.name);
    
    [self close];
}

@end
