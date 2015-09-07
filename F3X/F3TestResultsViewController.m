//
//  F3TestResultsViewController.m
//  F3X
//
//  Created by Guilherme Rambo on 05/09/15.
//  Copyright (c) 2015 Canyon Produções. All rights reserved.
//

#import "F3TestResultsViewController.h"

#import "F3Volume.h"
#import "F3TestProgressViewController.h"

@import F3;

@interface F3TestResultsViewController ()

@property (nonatomic, readonly) F3Volume *volume;
@property (weak) IBOutlet NSTextField *titleLabel;
@property (weak) IBOutlet NSTextField *resultLabel;
@property (weak) IBOutlet NSImageView *resultImageView;

@end

@implementation F3TestResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.volume.testResults.approved) {
        self.titleLabel.stringValue = NSLocalizedString(@"Success!", @"Success!");
        self.resultLabel.stringValue = NSLocalizedString(@"Your card is ok!", @"Your card is ok!");
        self.resultImageView.image = [NSImage imageNamed:@"ok"];
    } else {
        self.titleLabel.stringValue = NSLocalizedString(@"Woops!", @"Woops!");
        self.resultLabel.stringValue = NSLocalizedString(@"Your card is either not genuine or It's about to die!", @"Your card is either not genuine or It's about to die!");
        self.resultImageView.image = [NSImage imageNamed:@"nope"];
    }
}

- (F3Volume *)volume
{
    return (F3Volume *)self.representedObject;
}

- (IBAction)dismiss:(id)sender
{
    if ([self.presentingViewController isKindOfClass:[F3TestProgressViewController class]]) {
        F3TestProgressViewController *previousController = (F3TestProgressViewController *)self.presentingViewController;
        [previousController dismiss];
    }
    
    [self.presentingViewController dismissViewController:self];
}

@end
