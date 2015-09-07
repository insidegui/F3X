//
//  F3Window.m
//  F3X
//
//  Created by Guilherme Rambo on 05/09/15.
//  Copyright (c) 2015 Canyon Produções. All rights reserved.
//

#import "F3Window.h"

#import "F3Appearance.h"

@import QuartzCore;

@interface NSWindow (Private)

- (NSRect)startRectForSheet:(NSWindow *)sheet;

@end

@interface NSThemeFrame : NSView

- (instancetype)initWithFrame:(NSRect)frameRect styleMask:(NSUInteger)aStyle owner:(NSWindow *)owner;
- (NSRect)titlebarRectAssumingVisible;
- (void)_updateBackgroundLayer;
- (NSTextField *)_titleTextField;

@end

@interface F3WindowFrameView : NSThemeFrame
@end

@implementation F3Window

- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    if (!(self = [super initWithContentRect:contentRect styleMask:aStyle|NSFullSizeContentViewWindowMask backing:bufferingType defer:flag])) return nil;
    
    self.backgroundColor = [F3Appearance appearance].windowBackgroundColor;
    self.titlebarAppearsTransparent = YES;
    
    return self;
}

+ (Class)frameViewClassForStyleMask:(NSUInteger)styleMask
{
    return [F3WindowFrameView class];
}

- (BOOL)_usesCustomDrawing
{
    return NO;
}

- (void)setContentView:(id)contentView
{
    [contentView setWantsLayer:YES];
    
    [super setContentView:contentView];
}

- (NSRect)startRectForSheet:(NSWindow *)sheet
{
    NSRect rect = [super startRectForSheet:sheet];
    rect.origin.y -= 22;
    return rect;
}

@end

@implementation F3WindowFrameView
{
    CAGradientLayer *_titlebgLayer;
    CALayer *_titlespLayer;
}

- (void)viewDidMoveToWindow
{
    [super viewDidMoveToWindow];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_updateBackgroundLayer) name:NSWindowDidBecomeKeyNotification object:self.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_updateBackgroundLayer) name:NSWindowDidResignKeyNotification object:self.window];
}

- (void)_updateBackgroundLayer
{
    [super _updateBackgroundLayer];
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:0];
    
    if (!_titlebgLayer) {
        _titlespLayer = [CALayer layer];
        
        _titlebgLayer = [CAGradientLayer layer];
        _titlebgLayer.autoresizingMask = kCALayerWidthSizable|kCALayerMinYMargin;
        [_titlebgLayer addSublayer:_titlespLayer];
        
        [self.layer insertSublayer:_titlebgLayer above:self.layer.sublayers[1]];
    }
    
    if (self.window.isKeyWindow && [NSApplication sharedApplication].isActive) {
        _titlebgLayer.colors = [F3Appearance appearance].titlebarGradientColors;
        _titlebgLayer.locations = [F3Appearance appearance].titlebarGradientLocations;
        _titlespLayer.backgroundColor = [F3Appearance appearance].titlebarSeparatorColor.CGColor;
    } else {
        _titlebgLayer.colors = [F3Appearance appearance].titlebarGradientColorsInactive;
        _titlebgLayer.locations = [F3Appearance appearance].titlebarGradientLocations;
        _titlespLayer.backgroundColor = [F3Appearance appearance].titlebarSeparatorColorInactive.CGColor;
    }
    
    _titlebgLayer.frame = [self titlebarRectAssumingVisible];
    _titlespLayer.frame = NSMakeRect(0, 0, NSWidth(_titlebgLayer.frame), 1.0);
    
    [CATransaction commit];
}

- (NSColor *)_currentTitleColor
{
    return (self.window.isKeyWindow && [NSApplication sharedApplication].isActive) ? [F3Appearance appearance].titlebarTextColor : [F3Appearance appearance].titlebarTextColorInactive;
}

- (NSFont *)titleFont
{
    return [F3Appearance appearance].titlebarFont;
}

- (NSTextField *)_titleTextField
{
    NSTextField *ttf = [super _titleTextField];
    [[ttf cell] setBackgroundStyle:[F3Appearance appearance].titlebarBackgroundStyle];
    
    return ttf;
}

@end