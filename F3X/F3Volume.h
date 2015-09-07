//
//  F3Card.h
//  F3X
//
//  Created by Guilherme Rambo on 05/09/15.
//  Copyright (c) 2015 Canyon Produções. All rights reserved.
//

@import Cocoa;

@class F3TestResults;

@interface F3Volume : NSObject <NSCopying>

+ (F3Volume *)volumeWithMountPoint:(NSURL *)mountPoint;

@property (nonatomic, copy) NSURL *mountPoint;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSImage *icon;
@property (nonatomic, readonly, getter=isUsable) BOOL usable;
@property (nonatomic, readonly) NSString *volumeIdentifier;
@property (nonatomic, readonly) NSString *size;
@property (nonatomic, readonly) NSString *freespace;

@property (nonatomic, copy) F3TestResults *testResults;

@end
