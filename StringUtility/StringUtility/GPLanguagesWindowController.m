//
//  GPLanguagesWindowController.m
//  StringUtility
//
//  Created by Konstantin Kabanov on 07/03/2017.
//  Copyright © 2017 GoPro Inc. All rights reserved.
//

#import "GPLanguagesWindowController.h"

#import "GPPluginConfiguration.h"

@interface GPLanguagesWindowController () <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSTableView *tableView;
@property (strong) NSMutableArray *selectedLocaleIdentifiers;
@property (strong) NSArray *languages;
@property (strong) NSArray *filteredLanguages;
@property (weak) IBOutlet NSSearchField *searchField;

@end

@implementation GPLanguagesWindowController

- (NSString *)windowNibName {
    return [self className];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.selectedLocaleIdentifiers = [[GPPluginConfiguration sharedConfiguration].localeIdentifiers mutableCopy];
    
    if (!self.selectedLocaleIdentifiers) {
        self.selectedLocaleIdentifiers = [@[] mutableCopy];
    }
    
    NSMutableArray *temp = [@[] mutableCopy];
    
    for (NSString *localeIdentifier in [NSLocale availableLocaleIdentifiers]) {
        NSString *displayName = [[NSLocale currentLocale] displayNameForKey:NSLocaleIdentifier value:localeIdentifier];
        
        NSDictionary *language = @{@"localeIdentifier": localeIdentifier, @"displayName": displayName};

        [temp addObject:language];
    }
    
    [temp sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES]]];
    
    self.languages = temp;
    self.filteredLanguages = self.languages;
    
    [self.tableView reloadData];
}

- (IBAction)resetButtonAction:(id)sender {
    [self.selectedLocaleIdentifiers removeAllObjects];
    
    [self.tableView reloadData];
}

- (IBAction)cancelButtonAction:(id)sender {
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseCancel];
}

- (IBAction)saveButtonAction:(id)sender {
    [GPPluginConfiguration sharedConfiguration].localeIdentifiers = self.selectedLocaleIdentifiers;
    [[GPPluginConfiguration sharedConfiguration] save];
    
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseOK];
}

- (IBAction)searchFieldDidChangeValue:(id)sender {
    NSString *searchText = self.searchField.stringValue;
    
    if ([searchText length] > 0) {
        self.filteredLanguages = [self.languages filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"displayName CONTAINS[cd] %@", searchText]];
    } else {
        self.filteredLanguages = self.languages;
    }
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.filteredLanguages count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSButtonCell *buttonCell = [tableColumn dataCell];
    
    return buttonCell;
}

- (NSCell *)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSButtonCell *buttonCell = [tableColumn dataCell];
    
    [buttonCell setState:[self.selectedLocaleIdentifiers containsObject:self.filteredLanguages[row][@"localeIdentifier"]]];
    [buttonCell setTitle:self.filteredLanguages[row][@"displayName"]];
    
    return buttonCell;
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSNumber *newValue = object;
    
    NSDictionary *language = self.filteredLanguages[row];
    
    if ([newValue boolValue]) {
        [self.selectedLocaleIdentifiers addObject:language[@"localeIdentifier"]];
    } else {
        [self.selectedLocaleIdentifiers removeObject:language[@"localeIdentifier"]];
    }
}

@end

