//
//  ViewController.m
//  F3X
//
//  Created by Guilherme Rambo on 05/09/15.
//  Copyright (c) 2015 Canyon Produções. All rights reserved.
//

#import "F3CardsViewController.h"
#import "F3VolumeDataSource.h"
#import "F3Volume.h"

#import "F3CardCellView.h"

@import F3UI;

@interface F3CardsViewController () <NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic, strong) F3VolumeDataSource *dataSource;
@property (weak) IBOutlet NSButton *startTestButton;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSButton *showResultsButton;
@property (weak) IBOutlet NSLayoutConstraint *buttonsCenterConstraint;

@end

@implementation F3CardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [F3Appearance appearance].tableBackgroundColor;
    
    self.dataSource = [F3VolumeDataSource dataSource];
}

- (void)viewWillAppear
{
    [super viewWillAppear];
    
    [self.dataSource addObserver:self forKeyPath:@"volumes" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
}

- (void)viewWillDisappear
{
    [super viewWillDisappear];
    
    [self.dataSource removeObserver:self forKeyPath:@"volumes"];
}

- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"runtest"] ||
        [segue.identifier isEqualToString:@"showResults"]) {
        [segue.destinationController setRepresentedObject:self.dataSource.volumes[self.tableView.selectedRow]];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.dataSource && [keyPath isEqualToString:@"volumes"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self _reactToTableViewSelectionChange];
        });
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)_unhideShowResultsButton
{
    if (!self.showResultsButton.hidden) return;
    
    self.showResultsButton.hidden = NO;
    self.buttonsCenterConstraint.constant += NSWidth(self.showResultsButton.bounds)/2.0;
}

- (void)_hideShowResultsButton
{
    if (self.showResultsButton.hidden) return;
    
    self.showResultsButton.hidden = YES;
    self.buttonsCenterConstraint.constant -= NSWidth(self.showResultsButton.bounds)/2.0;
}

#pragma mark Table View

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.dataSource.volumes.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    F3CardCellView *cellView = [tableView makeViewWithIdentifier:@"card" owner:tableView];
    
    cellView.card = self.dataSource.volumes[row];
    
    return cellView;
}

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row
{
    return [[F3TableRowView alloc] initWithFrame:NSZeroRect];
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    F3Volume *volume = self.dataSource.volumes[row];
    
    return volume.isUsable;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    [self _reactToTableViewSelectionChange];
}

- (void)_reactToTableViewSelectionChange
{
    F3Volume *volume;
    
    if (self.tableView.selectedRow >= 0) volume = self.dataSource.volumes[self.tableView.selectedRow];
    
    self.startTestButton.enabled = volume.isUsable;
    
    if (volume.testResults) {
        [self _unhideShowResultsButton];
    } else {
        [self _hideShowResultsButton];
    }
}

@end
