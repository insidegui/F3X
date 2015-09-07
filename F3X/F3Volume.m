//
//  F3Card.m
//  F3X
//
//  Created by Guilherme Rambo on 05/09/15.
//  Copyright (c) 2015 Canyon Produções. All rights reserved.
//

#import "F3Volume.h"

@import F3;
@import DiskArbitration;

@implementation F3Volume
{
    BOOL _usable;
    NSDictionary *_attributes;
    NSString *_volumeIdentifier;
    F3TestResults *_testResults;
}

+ (F3Volume *)volumeWithMountPoint:(NSURL *)mountPoint
{
    F3Volume *volume = [[F3Volume alloc] init];
    volume.mountPoint = mountPoint;
    
    return volume;
}

- (NSString *)name
{
    return self.mountPoint.lastPathComponent;
}

- (NSImage *)icon
{
    return [[NSWorkspace sharedWorkspace] iconForFile:self.mountPoint.path];
}

- (NSString *)description
{
    NSString *usabilityString = self.isUsable ? @"Valid" : @"Invalid";
    return [NSString stringWithFormat:@"F3Volume <%@ ID:%@> (%@)", self.name, self.volumeIdentifier, usabilityString];
}

- (BOOL)isUsable
{
    return _usable;
}

- (NSString *)size
{
    if (!_attributes) [self _fetchAttributes];
    
    NSByteCountFormatter *formatter = [[NSByteCountFormatter alloc] init];
    return [formatter stringFromByteCount:[_attributes[NSFileSystemSize] longLongValue]];
}

- (NSString *)freespace
{
    if (!_attributes) [self _fetchAttributes];
    
    NSByteCountFormatter *formatter = [[NSByteCountFormatter alloc] init];
    return [formatter stringFromByteCount:[_attributes[NSFileSystemFreeSize] longLongValue]];
}

- (NSString *)volumeIdentifier
{
    if (!_volumeIdentifier) [self _fetchVolumeIdentifier];
    
    return _volumeIdentifier;
}

- (void)setTestResults:(F3TestResults *)testResults
{
    _testResults = [testResults copy];
    [_testResults save];
}

- (F3TestResults *)testResults
{
    if (!_testResults) _testResults = [F3TestResults latestTestResultsForVolumeWithID:self.volumeIdentifier];
    
    return _testResults;
}

#pragma mark Private methods

- (void)setUsable:(BOOL)usable
{
    _usable = usable;
}

- (void)setVolumeIdentifier:(NSString *)volumeIdentifier
{
    _volumeIdentifier = [volumeIdentifier copy];
}

- (void)_fetchAttributes
{
    NSError *error;
    _attributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:self.mountPoint.path error:&error];
    
    if (error) NSLog(@"Warning: unable to fetch file system attributes for path %@", self.mountPoint.path);
}

- (void)_fetchVolumeIdentifier
{
    DASessionRef sess = DASessionCreate(kCFAllocatorDefault);
    DADiskRef disk = DADiskCreateFromVolumePath(kCFAllocatorDefault, sess, (__bridge CFURLRef)self.mountPoint);
    NSDictionary *diskInfo = (__bridge NSDictionary *)DADiskCopyDescription(disk);
    NSString *volumeUUIDKey = (__bridge NSString *)kDADiskDescriptionVolumeUUIDKey;
    
    if (!diskInfo || !diskInfo[volumeUUIDKey]) {
        _volumeIdentifier = @"";
        NSLog(@"Warning: unable to fetch disk arbitration info for path %@", self.mountPoint.path);
        return;
    }

    CFUUIDRef diskID = (__bridge CFUUIDRef)diskInfo[volumeUUIDKey];
    _volumeIdentifier = (__bridge NSString *)CFUUIDCreateString(kCFAllocatorDefault, diskID);
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    F3Volume *copy = [[F3Volume alloc] init];
    
    [copy setVolumeIdentifier:_volumeIdentifier];
    [copy setMountPoint:_mountPoint];
    [copy setUsable:_usable];
    
    return copy;
}

@end
