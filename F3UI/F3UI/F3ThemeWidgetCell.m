//
//  F3ThemeWidgetCell.m
//  F3X
//
//  Created by Guilherme Rambo on 07/09/15.
//  Copyright (c) 2015 Canyon Produções. All rights reserved.
//

#import "F3ThemeWidgetCell.h"

#import "F3Appearance.h"

#import <objc/runtime.h>

@interface _NSThemeWidgetCell (Private)

- (void)coreUIDrawWithFrame:(NSRect)frameRect inView:(id)controlView;

@end

@interface F3ThemeWidgetCell ()

- (void)ns_coreUIDrawWithFrame:(NSRect)frameRect inView:(id)controlView;

@end

@implementation F3ThemeWidgetCell

+ (void)load
{
    Method m = class_getInstanceMethod([_NSThemeWidgetCell class], @selector(coreUIDrawWithFrame:inView:));
    Method mNew = class_getInstanceMethod([self class], @selector(f3_coreUIDrawWithFrame:inView:));
    class_addMethod([_NSThemeWidgetCell class], @selector(ns_coreUIDrawWithFrame:inView:), method_getImplementation(m), method_getTypeEncoding(m));
    method_exchangeImplementations(m, mNew);
}

- (void)f3_coreUIDrawWithFrame:(NSRect)frameRect inView:(id)controlView
{
    [controlView setAppearance:[F3Appearance defaultSystemAppearance]];
    
    [self ns_coreUIDrawWithFrame:frameRect inView:controlView];
}

- (void)ns_coreUIDrawWithFrame:(NSRect)frameRect inView:(id)controlView
{
    // will be filled in at runtime...
}

@end