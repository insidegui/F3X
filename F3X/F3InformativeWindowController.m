//
//  F3InformativeWindowController.m
//  F3X
//
//  Created by Guilherme Rambo on 07/09/15.
//  Copyright (c) 2015 Canyon Produções. All rights reserved.
//

#import "F3InformativeWindowController.h"

#import "F3InformativeViewController.h"

@interface F3InformativeWindowController ()

@property (nonatomic, readonly) F3InformativeViewController *infoVC;

@end

@implementation F3InformativeWindowController

- (void)setInformativeTitle:(NSString *)informativeTitle
{
    _informativeTitle = [informativeTitle copy];
    
    self.infoVC.informativeTitle = _informativeTitle;
}

- (void)setInformativeText:(NSString *)informativeText
{
    _informativeText = [informativeText copy];
    
    self.infoVC.informativeText = _informativeText;
}

- (F3InformativeViewController *)infoVC
{
    return (F3InformativeViewController *)self.contentViewController;
}

- (void)windowDidLoad
{
    self.infoVC.informativeTitle = _informativeTitle;
    self.infoVC.informativeText = _informativeText;
}

@end
