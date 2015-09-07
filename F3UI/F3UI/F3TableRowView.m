//
//  F3TableRowView.m
//  F3X
//
//  Created by Guilherme Rambo on 06/09/15.
//  Copyright (c) 2015 Canyon Produções. All rights reserved.
//

#import "F3TableRowView.h"

#import "F3Appearance.h"

#define USE_ROUNDED_SELECTION

@interface NSTableCellView (F3UIPrivate)

- (BOOL)_hasCustomLabelColors;

@end

@implementation F3TableRowView
{
    NSMutableDictionary *_originalLabelColors;
}

- (instancetype)initWithFrame:(NSRect)frameRect
{
    if (!(self = [super initWithFrame:frameRect])) return nil;
    
    _originalLabelColors = [NSMutableDictionary new];
    
    return self;
}

#ifndef USE_ROUNDED_SELECTION
- (void)drawSelectionInRect:(NSRect)dirtyRect
{
    BOOL active = [self.window.firstResponder isEqualTo:self.superview] && [[NSApplication sharedApplication] isActive];
    
    if (active) {
        [[F3Appearance appearance].tableSelectionColor setFill];
    } else {
        [[F3Appearance appearance].tableSelectionColorSecondary setFill];
    }
    
    NSRectFill(dirtyRect);
    
    if (!active) return;
    
    NSRect bottomBorderRect = NSMakeRect(0, NSHeight(self.bounds)-1.0, NSWidth(self.bounds), 1.0);
    NSRect topBorderRect = NSMakeRect(0, 0, NSWidth(self.bounds), 1.0);
    [[F3Appearance appearance].tableSelectionBorderColor setFill];
    NSRectFill(topBorderRect);
    NSRectFill(bottomBorderRect);
}
#else
- (void)drawSelectionInRect:(NSRect)dirtyRect
{
    NSRect outerRect = NSInsetRect(self.bounds, 3, 3);
    NSRect innerRect = NSInsetRect(self.bounds, 4, 4);
    [[NSBezierPath bezierPathWithRoundedRect:outerRect xRadius:6 yRadius:6] addClip];
    
    BOOL active = [self.window.firstResponder isEqualTo:self.superview] && [[NSApplication sharedApplication] isActive];
    
    if (active) {
        [[F3Appearance appearance].tableSelectionBorderColor setFill];
        NSRectFill(dirtyRect);
        [[NSBezierPath bezierPathWithRoundedRect:innerRect xRadius:6 yRadius:6] addClip];
        [[F3Appearance appearance].tableSelectionColor setFill];
        NSRectFill(dirtyRect);
    } else {
        [[F3Appearance appearance].tableSelectionColorSecondary setFill];
        NSRectFill(dirtyRect);
    }
}
#endif

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    [self _updateLabelsForSelectionState:selected];
}

- (void)addSubview:(NSView *)aView
{
    [super addSubview:aView];
    
    [self _updateLabelsForSelectionState:self.selected];
}

- (void)_updateLabelsForSelectionState:(BOOL)selected
{
    if (!self.subviews.count) return;
    
    if ([self.subviews[0] respondsToSelector:@selector(_hasCustomLabelColors)]) {
        if ([self.subviews[0] _hasCustomLabelColors]) return;
    }
    
    for (NSTextField *field in [self.subviews[0] subviews]) {
        if (![field isKindOfClass:[NSTextField class]]) continue;

        if (([field.textColor isEqualTo:[F3Appearance appearance].okColor] ||
            [field.textColor isEqualTo:[F3Appearance appearance].notOkColor]) && !selected) continue;
        
        if (selected) {
            _originalLabelColors[@(field.hash)] = field.textColor;
            field.textColor = [F3Appearance appearance].tableTextColorSelected;
        } else {
            if (_originalLabelColors[@(field.hash)]) {
                field.textColor = _originalLabelColors[@(field.hash)];
            } else {
                field.textColor = [F3Appearance appearance].tableTextColor;
            }
        }
    }
}

@end
