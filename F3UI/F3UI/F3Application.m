//
//  F3Application.m
//  F3UI
//
//  Created by Guilherme Rambo on 07/09/15.
//  Copyright (c) 2015 Canyon Produções. All rights reserved.
//

#import "F3Application.h"

@implementation F3Application

- (instancetype)init
{
    if (!(self = [super init])) return nil;
    
    [F3Application installGraphiteOverride];
    
    return self;
}

+ (void)installGraphiteOverride
{
    [[NSUserDefaults standardUserDefaults] setVolatileDomain:@{@"AppleAquaColorVariant": @6} forName:NSArgumentDomain];
}

@end
