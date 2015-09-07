//
//  GRBackgroundView.m
//  F3X
//
//  Created by Guilherme Rambo on 05/09/15.
//  Copyright (c) 2015 Canyon Produções. All rights reserved.
//

#import "GRBackgroundView.h"

@import F3UI;

@implementation GRBackgroundView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    if (self.backgroundColor) {
        [self.backgroundColor setFill];
    } else {
        if (self.window.backgroundColor) {
            [self.window.backgroundColor setFill];
        } else {
            [[F3Appearance appearance].windowBackgroundColor setFill];
        }
    }
    
    NSRectFill(dirtyRect);
}

- (void)setBackgroundColor:(NSColor *)backgroundColor
{
    [self willChangeValueForKey:@"backgroundColor"];
    _backgroundColor = [backgroundColor copy];
    [self didChangeValueForKey:@"backgroundColor"];
    
    [self setNeedsDisplay:YES];
}

@end
