//
//  F3Runner.h
//  F3
//
//  Created by Guilherme Rambo on 05/09/15.
//  Copyright (c) 2015 Canyon Produções. All rights reserved.
//

@import Foundation;

@class F3TestResults, F3Runner;

typedef NS_ENUM(NSUInteger, F3RunnerState) {
    F3RunnerStateWaiting,
    F3RunnerStateWriting,
    F3RunnerStateReading,
    F3RunnerStateFailed,
    F3RunnerStateCancelled,
    F3RunnerStateCompleted
};

typedef void (^F3RunnerProgressHandler)(F3Runner *runner);

@interface F3Runner : NSObject

@property (nonatomic, copy) NSURL *volumeURL;
@property (nonatomic, copy) NSString *volumeID;

@property (nonatomic, assign) F3RunnerState state;
@property (nonatomic, assign) double progress;
@property (nonatomic, copy) NSDictionary *info;

@property (nonatomic, strong) F3TestResults *results;
@property (nonatomic, copy) F3RunnerProgressHandler progressHandler;

+ (F3Runner *)runnerWithVolumeAtURL:(NSURL *)url progressHandler:(F3RunnerProgressHandler)handler;

- (void)run;
- (void)cancel;

@end
