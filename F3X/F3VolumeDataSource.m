//
//  F3CardDataSource.m
//  F3X
//
//  Created by Guilherme Rambo on 05/09/15.
//  Copyright (c) 2015 Canyon Produções. All rights reserved.
//

#import "F3VolumeDataSource.h"

#import "F3Volume.h"

#define kVolumesPath @"/Volumes"

@import DiskArbitration;

@interface F3Volume (Private)

- (void)setUsable:(BOOL)usable;

@end

@implementation F3VolumeDataSource
{
    NSArray *_volumes;
    
    DASessionRef _diskObservationSession;
    dispatch_queue_t _diskObservationQ;
    
    BOOL _fetchInProgress;
}

+ (instancetype)dataSource
{
    return [[F3VolumeDataSource alloc] init];
}

- (instancetype)init
{
    if (!(self = [super init])) return nil;
    
    [self _startObservingDisks];
    
    return self;
}

- (NSArray *)volumes
{
    if (!_volumes) [self _fetchVolumes];
    
    return _volumes;
}

- (void)_fetchVolumes
{
    _fetchInProgress = YES;
    
    NSArray *volumeKeys = @[NSURLIsVolumeKey, NSURLIsWritableKey, NSURLVolumeIdentifierKey];
    NSDirectoryEnumerationOptions options = NSDirectoryEnumerationSkipsSubdirectoryDescendants | NSDirectoryEnumerationSkipsPackageDescendants | NSDirectoryEnumerationSkipsHiddenFiles;
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtURL:[self _volumesURL] includingPropertiesForKeys:volumeKeys options:options errorHandler:^BOOL(NSURL *url, NSError *error) {
        NSLog(@"Warning: unable to enumerate directory %@. %@", url, error);
        return YES;
    }];
    
    NSURL *url;
    NSMutableArray *volumes = [NSMutableArray new];
    while ((url = [enumerator nextObject])) {
        if (!url) continue;
        
        id isVolume;
        [url getResourceValue:&isVolume forKey:NSURLIsVolumeKey error:nil];
        
        id isWritable;
        [url getResourceValue:&isWritable forKey:NSURLIsWritableKey error:nil];
        
        BOOL usable = ([isVolume boolValue] && [isWritable boolValue]);
        
        F3Volume *volume = [F3Volume volumeWithMountPoint:url];
        [volume setUsable:usable];
        [volumes addObject:volume];
    }
    
    [self willChangeValueForKey:@"volumes"];
    _volumes = [volumes copy];
    [self didChangeValueForKey:@"volumes"];
    
    _fetchInProgress = NO;
}

- (NSURL *)_volumesURL
{
    return [NSURL fileURLWithPath:kVolumesPath];
}

static void availableVolumesChanged(DADiskRef disk, void *context)
{
    F3VolumeDataSource *self = (__bridge F3VolumeDataSource *)context;
    
#ifdef DEBUG
    NSLog(@"Available volumes changed");
#endif
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self _fetchVolumes];
    });
}

static void diskDescriptionChanged(DADiskRef disk, CFArrayRef keys, void *context)
{
    availableVolumesChanged(disk, context);
}

- (void)_startObservingDisks
{
    if (!_diskObservationQ || !_diskObservationSession) {
        _diskObservationQ = dispatch_queue_create("F3X Disk Observation", NULL);
        _diskObservationSession = DASessionCreate(kCFAllocatorDefault);
        DASessionSetDispatchQueue(_diskObservationSession, _diskObservationQ);
    }

    DARegisterDiskAppearedCallback(_diskObservationSession, NULL, availableVolumesChanged, (__bridge void *)self);
    DARegisterDiskDisappearedCallback(_diskObservationSession, NULL, availableVolumesChanged, (__bridge void *)self);

    NSArray *descriptionKeys = @[(__bridge NSString *)kDADiskDescriptionVolumeNameKey];
    DARegisterDiskDescriptionChangedCallback(_diskObservationSession, NULL, (__bridge CFArrayRef)descriptionKeys, diskDescriptionChanged, (__bridge void *)self);
}

@end
