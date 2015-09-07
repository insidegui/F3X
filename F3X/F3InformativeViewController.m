//
//  F3InformativeViewController.m
//  F3X
//
//  Created by Guilherme Rambo on 07/09/15.
//  Copyright (c) 2015 Canyon Produções. All rights reserved.
//

#import "F3InformativeViewController.h"

@interface F3InformativeViewController ()

@property (weak) IBOutlet NSTextField *titleLabel;
@property (weak) IBOutlet NSTextField *textLabel;

@end

@implementation F3InformativeViewController

- (void)setInformativeText:(NSString *)informativeText
{
    if (!informativeText) return;
    
    _informativeText = [informativeText copy];
    self.textLabel.stringValue = _informativeText;
}

- (void)setInformativeTitle:(NSString *)informativeTitle
{
    if (!informativeTitle) return;
    
    _informativeTitle = [informativeTitle copy];
    self.titleLabel.stringValue = _informativeTitle;
}

- (void)viewWillAppear {
    [super viewWillAppear];
    
    if (self.informativeText) self.textLabel.stringValue = self.informativeText;
    if (self.informativeTitle) self.titleLabel.stringValue = self.informativeTitle;
}

@end
