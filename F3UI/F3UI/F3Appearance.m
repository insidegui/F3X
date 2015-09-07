//
//  F3Appearance.m
//  F3X
//
//  Created by Guilherme Rambo on 05/09/15.
//  Copyright (c) 2015 Canyon Produções. All rights reserved.
//

#import "F3Appearance.h"

@import QuartzCore;

@implementation F3Appearance

+ (instancetype)appearance
{
    static F3Appearance *_shared;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[F3Appearance alloc] init];
    });
    
    return _shared;
}

+ (NSAppearance *)defaultSystemAppearance
{
    return [[NSAppearance alloc] initWithAppearanceNamed:@"SystemAppearance" bundle:[NSBundle bundleWithIdentifier:@"com.apple.systemappearance"]];
}

- (NSColor *)windowBackgroundColor
{
    return [NSColor colorWithCalibratedRed:0.198 green:0.198 blue:0.198 alpha:1];
}

- (NSColor *)tableBackgroundColor
{
    return [NSColor colorWithCalibratedRed:0.124 green:0.124 blue:0.124 alpha:1];
}

- (NSColor *)titlebarTextColor
{
    return [NSColor colorWithCalibratedRed:0.009 green:0.009 blue:0.009 alpha:1];
}

- (NSColor *)titlebarTextColorInactive
{
    return [NSColor colorWithCalibratedRed:0.177 green:0.177 blue:0.177 alpha:1];
}

- (NSFont *)titlebarFont
{
    NSFont *font = [NSFont systemFontOfSize:13.0];
    
    return [[NSFontManager sharedFontManager] convertWeight:YES ofFont:font];
}

- (NSBackgroundStyle)titlebarBackgroundStyle
{
    return NSBackgroundStyleDark;
}

- (NSColor *)titlebarSeparatorColor
{
    return [NSColor colorWithCalibratedRed:0.049 green:0.049 blue:0.049 alpha:1];
}

- (NSColor *)titlebarSeparatorColorInactive
{
    return [NSColor colorWithCalibratedRed:0.089 green:0.089 blue:0.089 alpha:1];
}

- (NSArray *)titlebarGradientColors
{
    return @[(__bridge id)[NSColor colorWithCalibratedRed:0.403 green:0.403 blue:0.403 alpha:1].CGColor,
             (__bridge id)[NSColor colorWithCalibratedRed:0.533 green:0.533 blue:0.533 alpha:1].CGColor,
             (__bridge id)[NSColor colorWithCalibratedWhite:1.0 alpha:0.7].CGColor];
}

- (NSArray *)titlebarGradientColorsInactive
{
    return @[(__bridge id)[NSColor colorWithCalibratedRed:0.332 green:0.332 blue:0.332 alpha:1].CGColor,
             (__bridge id)[NSColor colorWithCalibratedRed:0.374 green:0.37 blue:0.374 alpha:1].CGColor,
             (__bridge id)[NSColor colorWithCalibratedWhite:1.0 alpha:0.6].CGColor];
}

- (NSArray *)titlebarGradientLocations
{
    return @[@0.0, @0.95, @1.0];
}

- (NSColor *)invalidVolumeTextColor
{
    return [NSColor colorWithCalibratedRed:0.206 green:0.197 blue:0.206 alpha:1];
}

- (NSColor *)okColor
{
    return [NSColor colorWithCalibratedRed:0.146 green:0.679 blue:0.374 alpha:1];
}

- (NSColor *)notOkColor
{
    return [NSColor colorWithCalibratedRed:0.934 green:0.274 blue:0.223 alpha:1];
}

- (NSColor *)tableTextColor
{
    return [NSColor colorWithCalibratedRed:0.814 green:0.814 blue:0.814 alpha:1];
}

- (NSColor *)tableTextColorSelected
{
    return [NSColor whiteColor];
}

- (NSColor *)tableSelectionColor
{
    return [NSColor colorWithCalibratedRed:0.189 green:0.352 blue:0.675 alpha:1];
}

- (NSColor *)tableSelectionBorderColor
{
    return [NSColor colorWithCalibratedRed:0.228 green:0.388 blue:0.696 alpha:1];
}

- (NSColor *)tableSelectionColorSecondary
{
    return [NSColor colorWithCalibratedRed:0.577 green:0.577 blue:0.577 alpha:1];
}

- (NSColor *)buttonBackgroundColor
{
    return [NSColor colorWithCalibratedRed:0.479 green:0.475 blue:0.479 alpha:1];
}

- (NSGradient *)buttonBorderGradient
{
    return [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:0.498 green:0.495 blue:0.498 alpha:1] endingColor:[NSColor colorWithCalibratedWhite:0 alpha:0.3]];
}

- (NSColor *)buttonBackgroundColorDefault
{
    return [NSColor colorWithCalibratedRed:0.189 green:0.352 blue:0.675 alpha:1];
}

- (NSGradient *)buttonBorderGradientDefault
{
    return [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedRed:0.228 green:0.388 blue:0.696 alpha:1] endingColor:[NSColor colorWithCalibratedRed:0.098 green:0.205 blue:0.434 alpha:1]];
}

@end
