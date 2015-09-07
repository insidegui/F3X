//
//  F3TestResults.m
//  F3
//
//  Created by Guilherme Rambo on 05/09/15.
//  Copyright (c) 2015 Canyon Produções. All rights reserved.
//

#import "F3TestResults.h"

#define kResultsDatabaseVersionKey @"F3TestResultsDatabaseVersion"
#define kResultsDatabaseCurrentVersion @1
#define kResultsDatabaseCompatibleVersions @[@1]

@implementation F3TestResults

+ (F3TestResults *)testResultsWithRawWritingData:(NSString *)writingData readingData:(NSString *)readingData
{
    F3TestResults *results = [[F3TestResults alloc] init];
    
    results.rawWritingData = writingData;
    results.rawReadingData = readingData;
    
    return results;
}

- (instancetype)init
{
    if (!(self = [super init])) return nil;
    
    _createdAt = [NSDate date];
    
    return self;
}

- (void)setRawWritingData:(NSString *)rawWritingData
{
    _rawWritingData = [rawWritingData copy];
    
    [self _parseWritingData];
}

- (void)setRawReadingData:(NSString *)rawReadingData
{
    _rawReadingData = [rawReadingData copy];
    
    [self _parseReadingData];
}

- (void)_parseWritingData
{
    self.avgWritingSpeed = [[self.rawWritingData componentsSeparatedByString:@"Average writing speed: "][1] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
}

- (void)_parseReadingData
{
    NSString *cleanReadingData = [[self.rawReadingData stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByReplacingOccurrencesOfString:@"\b" withString:@""];
    NSArray *components = [cleanReadingData componentsSeparatedByString:@"Data OK: "];
    
    NSArray *dataLines = [components[1] componentsSeparatedByString:@"\n"];
    
    self.data            =  [ dataLines[0] componentsSeparatedByString:@" "][0];
    self.dataLoss        =  [[dataLines[1] componentsSeparatedByString:@":"][1] substringFromIndex:1];
    self.corrupted       =  [[dataLines[2] componentsSeparatedByString:@":"][1] substringFromIndex:1];
    self.slightlyChanged =  [[dataLines[3] componentsSeparatedByString:@":"][1] substringFromIndex:1];
    self.overwritten     =  [[dataLines[4] componentsSeparatedByString:@":"][1] substringFromIndex:1];
    self.avgReadingSpeed =  [[dataLines[5] componentsSeparatedByString:@":"][1] substringFromIndex:1];
    
    return;
}

- (BOOL)approved
{
    double lost = [[self.dataLoss componentsSeparatedByString:@" "][0] doubleValue];
    double corrupted = [[self.corrupted componentsSeparatedByString:@" "][0] doubleValue];
    double changed = [[self.slightlyChanged componentsSeparatedByString:@" "][0] doubleValue];
    double overwritten = [[self.overwritten componentsSeparatedByString:@" "][0] doubleValue];
    
    return (lost == 0.0 && corrupted == 0.0 && changed == 0.0 && overwritten == 0.0);
}

- (void)save
{
    if (!self.volumeID || [self.volumeID isEqualToString:@""]) {
        NSLog(@"Warning: tried to save test results without an associated volume ID!");
        return;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:kResultsDatabaseCurrentVersion forKey:kResultsDatabaseVersionKey];
    
    NSMutableArray *existingResults = [[defaults arrayForKey:self.volumeID] mutableCopy];
    if (!existingResults) existingResults = [[NSMutableArray alloc] initWithCapacity:1];
    
    [existingResults addObject:[NSKeyedArchiver archivedDataWithRootObject:self]];
    
    [defaults setObject:[existingResults copy] forKey:self.volumeID];
    [defaults synchronize];
}

+ (F3TestResults *)latestTestResultsForVolumeWithID:(NSString *)volumeID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    
    NSData *testResultsData = [[defaults arrayForKey:volumeID] lastObject];
    if (!testResultsData) return nil;
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:testResultsData];
}

#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_rawWritingData forKey:@"rawWritingData"];
    [aCoder encodeObject:_rawReadingData forKey:@"rawReadingData"];
    [aCoder encodeObject:_volumeID forKey:@"volumeID"];
    [aCoder encodeObject:_createdAt forKey:@"createdAt"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    _rawWritingData = [aDecoder decodeObjectForKey:@"rawWritingData"];
    _rawReadingData = [aDecoder decodeObjectForKey:@"rawReadingData"];
    _volumeID = [aDecoder decodeObjectForKey:@"volumeID"];
    _createdAt = [aDecoder decodeObjectForKey:@"createdAt"];
    
    [self _parseWritingData];
    [self _parseReadingData];
    
    return self;
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    F3TestResults *copy = [F3TestResults testResultsWithRawWritingData:_rawWritingData readingData:_rawReadingData];
    copy.volumeID = _volumeID;
    
    return copy;
}

@end
