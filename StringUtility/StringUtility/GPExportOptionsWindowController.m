//
//  GPExportOptionsWindowController.m
//  StringUtility
//
//  Created by Konstantin Kabanov on 09/03/2017.
//  Copyright © 2017 GoPro Inc. All rights reserved.
//

#import "GPExportOptionsWindowController.h"

#import "GPSketch.h"
#import "GPPluginConfiguration.h"

@interface GPExportOptionsWindowController () <NSTableViewDelegate, NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSMatrix *findStringsInMatrix;

@property (strong) IBOutlet NSTableCellView *tableViewCell1;
@property (strong) IBOutlet NSTableCellView *tableViewCell2;
@property (strong) IBOutlet NSTableCellView *tableViewCell3;
@property (strong) IBOutlet NSTableCellView *tableViewCell4;
@property (strong) IBOutlet NSTableCellView *tableViewCell5;
@property (strong) IBOutlet NSTableCellView *tableViewCell6;
@property (strong, nonatomic) NSArray *cells;

@property (weak) IBOutlet NSButton *maxCharacterCountButton;
@property (weak) IBOutlet NSButton *maxLineCountButton;
@property (weak) IBOutlet NSButton *fontTypeButton;
@property (weak) IBOutlet NSButton *fontSizeButton;
@property (weak) IBOutlet NSButton *textAlignmentButton;
@property (weak) IBOutlet NSButton *textFieldDimensionsButton;

@end

@implementation GPExportOptionsWindowController

- (NSString *)windowNibName {
    return [self className];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    [self.findStringsInMatrix selectCellAtRow:0 column:[GPPluginConfiguration sharedConfiguration].findStringsInOption];
    self.maxCharacterCountButton.state = [GPPluginConfiguration sharedConfiguration].isMaxCharacterCountEnabled;
    self.maxLineCountButton.state = [GPPluginConfiguration sharedConfiguration].isMaxLineCountEnabled;
    self.fontTypeButton.state = [GPPluginConfiguration sharedConfiguration].isFontTypeEnabled;
    self.fontSizeButton.state = [GPPluginConfiguration sharedConfiguration].isFontSizeEnabled;
    self.textAlignmentButton.state = [GPPluginConfiguration sharedConfiguration].isTextAlignmentEnabled;
    self.textFieldDimensionsButton.state = [GPPluginConfiguration sharedConfiguration].isTextFieldDimensionsEnabled;
    
    self.cells = @[self.tableViewCell1, self.tableViewCell2, self.tableViewCell3, self.tableViewCell4, self.tableViewCell5, self.tableViewCell6];
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.cells count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    return self.cells[row];
}

- (IBAction)cancelButtonAction:(id)sender {
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseCancel];
}

- (IBAction)exportButtonAction:(id)sender {
    [GPPluginConfiguration sharedConfiguration].findStringsInOption = self.findStringsInMatrix.selectedColumn;
    [GPPluginConfiguration sharedConfiguration].isMaxCharacterCountEnabled = (BOOL)self.maxCharacterCountButton.state;
    [GPPluginConfiguration sharedConfiguration].isMaxLineCountEnabled = (BOOL)self.maxLineCountButton.state;
    [GPPluginConfiguration sharedConfiguration].isFontTypeEnabled = (BOOL)self.fontTypeButton.state;
    [GPPluginConfiguration sharedConfiguration].isFontSizeEnabled = (BOOL)self.fontSizeButton.state;
    [GPPluginConfiguration sharedConfiguration].isTextAlignmentEnabled = (BOOL)self.textAlignmentButton.state;
    [GPPluginConfiguration sharedConfiguration].isTextFieldDimensionsEnabled = (BOOL)self.textFieldDimensionsButton.state;
    
    [[GPPluginConfiguration sharedConfiguration] save];
    
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseOK];
}

@end
