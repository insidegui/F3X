//
//  F3Button.m
//  F3X
//
//  Created by Guilherme Rambo on 06/09/15.
//  Copyright (c) 2015 Canyon Produções. All rights reserved.
//

#import "F3Button.h"

#import "F3Appearance.h"

@implementation F3Button
@end

@implementation F3ButtonCell
{
    BOOL _drawAsDefault;
}

- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    
    _drawAsDefault = [self.keyEquivalent isEqualToString:@"\r"];
    
    return self;
}

- (void)setKeyEquivalent:(NSString *)keyEquivalent
{
    [super setKeyEquivalent:keyEquivalent];
    
    _drawAsDefault = [keyEquivalent isEqualToString:@"\r"];
}

- (void)drawBezelWithFrame:(NSRect)frame inView:(NSView *)controlView
{
    BOOL doDrawAsDefault = (_drawAsDefault && self.enabled && controlView.window.isKeyWindow);
    NSGradient *gradient = doDrawAsDefault ? [F3Appearance appearance].buttonBorderGradientDefault : [F3Appearance appearance].buttonBorderGradient;
    NSColor *bgColor = doDrawAsDefault ? [F3Appearance appearance].buttonBackgroundColorDefault : [F3Appearance appearance].buttonBackgroundColor;
    
    NSRect outerRect = controlView.bounds;
    outerRect.origin.y -= 1;
    outerRect.origin.x -= 1;
    outerRect = NSInsetRect(outerRect, 8, 6);
    NSBezierPath *bezel = [NSBezierPath bezierPathWithRoundedRect:outerRect xRadius:3.0 yRadius:3.0];
    
    [gradient drawInBezierPath:bezel angle:90.0];
    
    NSRect innerRect = NSInsetRect(outerRect, 0, 1);
    NSBezierPath *innerBezel = [NSBezierPath bezierPathWithRoundedRect:innerRect xRadius:3.0 yRadius:3.0];
    [bgColor setFill];
    [innerBezel fill];

    if (self->_cFlags.highlighted) {
        [[NSColor colorWithCalibratedWhite:0 alpha:0.1] setFill];
        [innerBezel fill];
    }
}

@end