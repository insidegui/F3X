//
//  F3CardCellView.m
//  F3X
//
//  Created by Guilherme Rambo on 05/09/15.
//  Copyright (c) 2015 Canyon Produções. All rights reserved.
//

#import "F3CardCellView.h"

#import "F3Volume.h"

@import F3UI;
@import F3;

@interface F3CardCellView ()

@property (weak) IBOutlet NSImageView *iconView;
@property (weak) IBOutlet NSTextField *nameLabel;
@property (weak) IBOutlet NSTextField *infoLabel;
@property (weak) IBOutlet NSTextField *lastTestInfoLabel;

@end

@implementation F3CardCellView

- (void)setCard:(F3Volume *)card
{
    _card = [card copy];
    
    [self _updateUI];
}

- (void)_updateUI
{
    NSColor *color = self.card.isUsable ? [F3Appearance appearance].tableTextColor : [F3Appearance appearance].invalidVolumeTextColor;
    
    self.nameLabel.textColor = color;
    self.infoLabel.textColor = color;
    
    self.iconView.image = self.card.icon;
    self.nameLabel.stringValue = self.card.name;
    self.infoLabel.stringValue = [NSString stringWithFormat:NSLocalizedString(@"Size: %@ | Free: %@", @"Size: | Free: "), self.card.size, self.card.freespace];
    
    if (self.card.testResults) {
        self.infoLabel.stringValue = [self.infoLabel.stringValue stringByAppendingFormat:NSLocalizedString(@" | Speed: %@", @"Speed:"), self.card.testResults.avgWritingSpeed];
        
        self.lastTestInfoLabel.hidden = NO;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterShortStyle;
        NSString *dateString = [formatter stringFromDate:self.card.testResults.createdAt];
        
        if (self.card.testResults.approved) {
            self.lastTestInfoLabel.textColor = [F3Appearance appearance].okColor;
            self.lastTestInfoLabel.stringValue = [NSString stringWithFormat:NSLocalizedString(@"Approved on %@", @"Approved on "), dateString];
        } else {
            self.lastTestInfoLabel.textColor = [F3Appearance appearance].notOkColor;
            self.lastTestInfoLabel.stringValue = [NSString stringWithFormat:NSLocalizedString(@"Disapproved on %@", @"Disapproved on "), dateString];
        }
    } else {
        self.lastTestInfoLabel.hidden = YES;
    }
}

- (BOOL)_hasCustomLabelColors
{
    return !self.card.isUsable;
}

@end
