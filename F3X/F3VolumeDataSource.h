//
//  F3CardDataSource.h
//  F3X
//
//  Created by Guilherme Rambo on 05/09/15.
//  Copyright (c) 2015 Canyon Produções. All rights reserved.
//

@import Cocoa;

@interface F3VolumeDataSource : NSObject

+ (instancetype)dataSource;

@property (nonatomic, readonly) NSArray *volumes;

@end
