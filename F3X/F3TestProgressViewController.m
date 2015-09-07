//
//  F3TestProgressViewController.m
//  F3X
//
//  Created by Guilherme Rambo on 05/09/15.
//  Copyright (c) 2015 Canyon Produções. All rights reserved.
//

#import "F3TestProgressViewController.h"

#import "F3Volume.h"

@import F3UI;

@import F3;

@interface F3TestProgressViewController ()

@property (nonatomic, readonly) F3Volume *volume;
@property (nonatomic, strong) F3Runner *runner;

@property (weak) IBOutlet NSTextField *titleLabel;
@property (weak) IBOutlet NSTextField *infoLabel;
@property (weak) IBOutlet F3ProgressIndicator *progressIndicator;
@property (weak) IBOutlet NSButton *cancelButton;
@property (weak) IBOutlet NSTextField *statsLabel;

@end

@implementation F3TestProgressViewController
{
    BOOL _dismissed;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.stringValue = [NSString stringWithFormat:NSLocalizedString(@"Testing \"%@\"...", @"Title when testing the card"), self.volume.name];
    
    self.runner = [F3Runner runnerWithVolumeAtURL:self.volume.mountPoint progressHandler:^(F3Runner *runner) {
        switch (runner.state) {
            case F3RunnerStateWaiting:
                [self _handleRunnerStateWaiting];
                break;
            case F3RunnerStateWriting:
                [self _handleRunnerStateWriting];
                break;
            case F3RunnerStateReading:
                [self _handleRunnerStateReading];
                break;
            case F3RunnerStateCancelled:
                [self _handleRunnerStateCancelled];
                break;
            case F3RunnerStateCompleted:
                [self _handleRunnerStateCompleted];
                break;
            case F3RunnerStateFailed:
                [self _handleRunnerStateFailed];
                break;
        }
    }];
    self.runner.volumeID = self.volume.volumeIdentifier;
    
    [self.runner run];
}

- (void)viewWillAppear
{
    [super viewWillAppear];
    
    [self.progressIndicator startAnimation:nil];
}

- (F3Volume *)volume
{
    return (F3Volume *)self.representedObject;
}

- (IBAction)cancel:(id)sender {
    [self.runner cancel];
    
    [self dismissViewController:self];
}

- (void)dismiss
{
    _dismissed = YES;
    [self dismissViewController:self];
}

- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"results"]) {
        self.volume.testResults = self.runner.results;
        [segue.destinationController setRepresentedObject:self.volume];
    }
}

#pragma State

- (void)_handleRunnerStateWaiting
{
    self.progressIndicator.indeterminate = YES;
    [self.progressIndicator startAnimation:nil];
}

- (void)_handleRunnerStateWriting
{
    self.infoLabel.stringValue = NSLocalizedString(@"Writing test files", @"Writing test files");
    [self _commonProgressUpdate];
}

- (void)_handleRunnerStateReading
{
    [self.progressIndicator stopAnimation:nil];
    self.progressIndicator.doubleValue = 100.0;
    self.progressIndicator.indeterminate = YES;
    [self.progressIndicator startAnimation:nil];
    
    self.statsLabel.stringValue = NSLocalizedString(@"This can take several minutes", @"This can take several minutes");
    self.infoLabel.stringValue = NSLocalizedString(@"Reading test files", @"Reading test files");
}

- (void)_commonProgressUpdate
{
    if (self.progressIndicator.indeterminate) {
        self.progressIndicator.indeterminate = NO;
        [self.progressIndicator startAnimation:nil];
    }
    self.progressIndicator.doubleValue = self.runner.progress;
    
    NSString *stats = @"";
    if (self.runner.info[@"speed"]) {
        stats = [stats stringByAppendingFormat:NSLocalizedString(@"Speed: %@", @"Speed: "), self.runner.info[@"speed"]];
        if (self.runner.info[@"eta"]) {
            stats = [stats stringByAppendingFormat:NSLocalizedString(@" | Time remaining: %@", @"Time remaining: "), self.runner.info[@"eta"]];
        }
    }

    self.statsLabel.hidden = [stats isEqualToString:@""];
    self.statsLabel.stringValue = stats;
}

- (void)_handleRunnerStateCancelled
{
    self.infoLabel.stringValue = NSLocalizedString(@"Test cancelled", @"Test cancelled");
    [self.progressIndicator stopAnimation:nil];
}

- (void)_handleRunnerStateCompleted
{
    self.infoLabel.stringValue = NSLocalizedString(@"Test completed", @"Test completed");
    [self.progressIndicator stopAnimation:nil];
    [self performSegueWithIdentifier:@"results" sender:nil];
}

- (void)_handleRunnerStateFailed
{
    self.infoLabel.stringValue = NSLocalizedString(@"Test failed", @"Test failed");
    [[NSAlert alertWithError:self.runner.info[@"error"]] runModal];
    [self.progressIndicator stopAnimation:nil];
}

@end
