//
//  F3Appearance.h
//  F3X
//
//  Created by Guilherme Rambo on 05/09/15.
//  Copyright (c) 2015 Canyon Produções. All rights reserved.
//

@import Cocoa;

@class CAGradientLayer;

@interface F3Appearance : NSObject

+ (instancetype)appearance;

+ (NSAppearance *)defaultSystemAppearance;

@property (nonatomic, readonly) NSColor *windowBackgroundColor;
@property (nonatomic, readonly) NSColor *titlebarSeparatorColor;
@property (nonatomic, readonly) NSColor *titlebarSeparatorColorInactive;
@property (nonatomic, readonly) NSArray *titlebarGradientColors;
@property (nonatomic, readonly) NSArray *titlebarGradientColorsInactive;
@property (nonatomic, readonly) NSArray *titlebarGradientLocations;
@property (nonatomic, readonly) NSFont *titlebarFont;
@property (nonatomic, readonly) NSColor *titlebarTextColor;
@property (nonatomic, readonly) NSColor *titlebarTextColorInactive;
@property (nonatomic, readonly) NSBackgroundStyle titlebarBackgroundStyle;

@property (nonatomic, readonly) NSColor *invalidVolumeTextColor;
@property (nonatomic, readonly) NSColor *okColor;
@property (nonatomic, readonly) NSColor *notOkColor;

@property (nonatomic, readonly) NSColor *tableBackgroundColor;
@property (nonatomic, readonly) NSColor *tableTextColor;
@property (nonatomic, readonly) NSColor *tableTextColorSelected;
@property (nonatomic, readonly) NSColor *tableSelectionColor;
@property (nonatomic, readonly) NSColor *tableSelectionBorderColor;
@property (nonatomic, readonly) NSColor *tableSelectionColorSecondary;

@property (nonatomic, readonly) NSColor *buttonBackgroundColor;
@property (nonatomic, readonly) NSGradient *buttonBorderGradient;
@property (nonatomic, readonly) NSColor *buttonBackgroundColorDefault;
@property (nonatomic, readonly) NSGradient *buttonBorderGradientDefault;

@end
