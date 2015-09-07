//
//  F3Runner.m
//  F3
//
//  Created by Guilherme Rambo on 05/09/15.
//  Copyright (c) 2015 Canyon Produções. All rights reserved.
//

#import "F3Runner.h"

#import "NTBTask.h"
#import "F3TestResults.h"

// uncomment to perform fake runs and test the UI
//#define USE_FAKE_RUNNER

@interface F3Runner ()

#ifdef USE_FAKE_RUNNER
@property (nonatomic, strong) NSTimer *fakeRunnerTimer;
#endif

@property (nonatomic, strong) NTBTask *writeTask;
@property (nonatomic, strong) NSMutableString *writeData;
@property (nonatomic, strong) NTBTask *readTask;
@property (nonatomic, strong) NSMutableString *readData;

@end

@implementation F3Runner

+ (F3Runner *)runnerWithVolumeAtURL:(NSURL *)url progressHandler:(F3RunnerProgressHandler)handler
{
    return [[F3Runner alloc] initWithVolumeAtURL:url progressHandler:handler];
}

- (void)run
{
#ifdef USE_FAKE_RUNNER
    _fakeRunnerTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(_fakeTimer:) userInfo:nil repeats:YES];
#else
#endif
    
    [self _runWriteTask];
    
    self.state = F3RunnerStateWriting;
}

- (void)cancel
{
#ifdef USE_FAKE_RUNNER
    [_fakeRunnerTimer invalidate];
    _fakeRunnerTimer = nil;
#else
    if (self.state == F3RunnerStateWriting) {
        [self.writeTask terminate];
    }
    if (self.state == F3RunnerStateReading) {
        [self.readTask terminate];
    }
#endif
    self.state = F3RunnerStateCancelled;
}

- (void)setState:(F3RunnerState)state
{
    _state = state;
    
    [self _callProgressHandlerOnMainThread];
}

- (void)setProgress:(double)progress
{
    _progress = progress;
    
    [self _callProgressHandlerOnMainThread];
}

#pragma mark Private Methods

- (instancetype)initWithVolumeAtURL:(NSURL *)url progressHandler:(F3RunnerProgressHandler)handler
{
    if (!(self = [super init])) return nil;
    
    self.state = F3RunnerStateWaiting;
    self.volumeURL = url;
    self.progressHandler = handler;
    
    return self;
}

- (void)_callProgressHandlerOnMainThread
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressHandler(self);
    });
}

#ifdef USE_FAKE_RUNNER
- (void)_fakeTimer:(NSTimer *)timer
{
    self.progress += 3;
    if (self.progress >= 100.0) {
        self.progress = 0;
        if (self.state == F3RunnerStateWriting) {
            self.state = F3RunnerStateReading;
        } else if (self.state == F3RunnerStateReading) {
            self.info = @{@"report": @"Your card appears to be genuine and in good shape (fake test)"};
            self.state = F3RunnerStateCompleted;
            [_fakeRunnerTimer invalidate];
            _fakeRunnerTimer = nil;
        }
    }
}
#endif

- (void)_runWriteTask
{
    self.writeTask = [[NTBTask alloc] initWithLaunchPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"f3write" ofType:@""]];
    self.writeTask.arguments = @[self.volumeURL.path];
    
    self.writeData = [NSMutableString new];
    
    __weak typeof(self) weakSelf = self;
    self.writeTask.outputHandler = ^(NSString *output){
        [weakSelf.writeData appendString:output];

        if ([output rangeOfString:@"Average writing speed:"].location != NSNotFound) [weakSelf _finishedWriting];
        
        [weakSelf _parseProgressOutput:output];
    };

    [self.writeTask launch];
}

- (void)_finishedWriting
{
    [self.writeData writeToFile:@"/Users/inside/Desktop/writedata.txt" atomically:YES encoding:NSUTF8StringEncoding error:nil];
    self.info = nil;
    self.progress = 0;
    self.state = F3RunnerStateReading;
    [self _runReadTask];
}

- (void)_runReadTask
{
    self.readTask = [[NTBTask alloc] initWithLaunchPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"f3read" ofType:@""]];
    self.readTask.arguments = @[self.volumeURL.path];
    
    self.readData = [NSMutableString new];
    
    __weak typeof(self) weakSelf = self;
    self.readTask.outputHandler = ^(NSString *output){
        [weakSelf.readData appendString:output];
        
        if ([output rangeOfString:@"Average reading speed:"].location != NSNotFound) [weakSelf _finishedReading];
    };
    
    [self.readTask launch];
}

- (void)_finishedReading
{
    self.results = [F3TestResults testResultsWithRawWritingData:self.writeData readingData:self.readData];
    self.results.volumeID = self.volumeID;
    self.progress = 100.0;
    self.state = F3RunnerStateCompleted;
}

- (void)_parseProgressOutput:(NSString *)output
{
    NSString *cleanOutput = [[output stringByReplacingOccurrencesOfString:@"\b" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *components = [cleanOutput componentsSeparatedByString:@"--"];
    
    BOOL isValidProgressLine = ([components[0] rangeOfString:@"%"].location != NSNotFound);
    
    if (!isValidProgressLine) return;
    
    NSMutableDictionary *info = [NSMutableDictionary new];
    if (components.count >= 2) [info setObject:components[1] forKey:@"speed"];
    if (components.count >= 3) [info setObject:components[2] forKey:@"eta"];
    self.info = info;
    
    self.progress = [components[0] doubleValue];
}

@end
