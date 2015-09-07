//
//  AppDelegate.m
//  F3X
//
//  Created by Guilherme Rambo on 05/09/15.
//  Copyright (c) 2015 Canyon Produções. All rights reserved.
//

#import "AppDelegate.h"

#import "F3InformativeWindowController.h"

@import Updater;
@import F3UI;

@interface AppDelegate ()

@property (unsafe_unretained) NSWindow *mainWindow;
@property (unsafe_unretained) F3InformativeWindowController *infoWC;
@property (nonatomic, assign, getter=isInDownloadingUpdateMode) BOOL downloadingUpdateMode;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.mainWindow = [NSApplication sharedApplication].windows.lastObject;
    
    [[UDUpdater sharedUpdater] addObserver:self forKeyPath:@"isDownloadingUpdate" options:NSKeyValueObservingOptionNew context:nil];
    
    [self checkForUpdates:nil];
}

- (IBAction)checkForUpdates:(id)sender
{
    [UDUpdater sharedUpdater].updateAutomatically = YES;
    
    [[UDUpdater sharedUpdater] checkForUpdatesWithCompletionHandler:^(UDRelease *latestRelease) {
        if (!sender) return;
        
        NSAlert *alert = [[NSAlert alloc] init];
        
        if (latestRelease) {
            alert.messageText = NSLocalizedString(@"New version available", @"New version available");
            alert.informativeText = NSLocalizedString(@"A new version is available, relaunch the app to update", @"A new version is available, relaunch the app to update");
        } else {
            alert.messageText = NSLocalizedString(@"You're up to date!", @"You're up to date!");
            alert.informativeText = NSLocalizedString(@"You have the latest version", @"You have the latest version");
        }
        
        [alert addButtonWithTitle:@"Ok"];
        [alert runModal];
    }];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
    [self.mainWindow makeKeyAndOrderFront:nil];
    
    return YES;
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender
{
    [self.mainWindow makeKeyAndOrderFront:nil];
    
    return YES;
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    if ([UDUpdater sharedUpdater].isDownloadingUpdate) {
        [self _enterDownloadingUpdateMode];
        return NSTerminateLater;
    } else {
        return NSTerminateNow;
    }
}

- (void)_enterDownloadingUpdateMode
{
    NSStoryboard *storyboard = [[self.mainWindow windowController] storyboard];
    self.infoWC = [storyboard instantiateControllerWithIdentifier:@"informativeWC"];
    self.infoWC.informativeTitle = NSLocalizedString(@"Installing update", @"Installing update");
    self.infoWC.informativeText = NSLocalizedString(@"Please wait while the latest version is downloaded and installed.", @"Please wait while the latest version is downloaded and installed.");
    [self.mainWindow beginCriticalSheet:self.infoWC.window completionHandler:nil];
    
    self.downloadingUpdateMode = YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"isDownloadingUpdate"]) {
        if (self.isInDownloadingUpdateMode && ![UDUpdater sharedUpdater].isDownloadingUpdate) {
            self.downloadingUpdateMode = NO;
            [self.mainWindow endSheet:self.infoWC.window];
            [[NSApplication sharedApplication] replyToApplicationShouldTerminate:YES];
        }
    } else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc
{
    [[UDUpdater sharedUpdater] removeObserver:self forKeyPath:@"isDownloadingUpdates"];
}

@end
