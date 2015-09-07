//
//  F3ProgressIndicator.m
//  F3X
//
//  Created by Guilherme Rambo on 06/09/15.
//  Copyright (c) 2015 Canyon Produções. All rights reserved.
//

#import "F3ProgressIndicator.h"

@import QuartzCore;

@interface NSProgressIndicator (Private)

- (NSRect)_getGaugeFrame;
- (void)_drawBar:(BOOL)arg1;

@end

@implementation F3ProgressIndicator

- (void)_drawBar:(BOOL)arg1
{
    [super _drawBar:arg1];
    
    NSRect overlayRect = NSInsetRect([self _getGaugeFrame], -1, 5);
    [[NSBezierPath bezierPathWithRoundedRect:overlayRect xRadius:3.0 yRadius:3.0] addClip];
    [[NSColor colorWithCalibratedWhite:0 alpha:0.5] setFill];
    NSRectFillUsingOperation(overlayRect, NSCompositeOverlay);
    [[NSColor colorWithCalibratedWhite:0 alpha:0.2] setFill];
    NSRectFillUsingOperation(overlayRect, NSCompositeDarken);
}

@end
