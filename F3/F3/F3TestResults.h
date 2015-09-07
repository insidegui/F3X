//
//  F3TestResults.h
//  F3
//
//  Created by Guilherme Rambo on 05/09/15.
//  Copyright (c) 2015 Canyon Produções. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface F3TestResults : NSObject <NSCoding, NSCopying>

+ (F3TestResults *)latestTestResultsForVolumeWithID:(NSString *)volumeID;
+ (F3TestResults *)testResultsWithRawWritingData:(NSString *)writingData readingData:(NSString *)readingData;

@property (nonatomic, copy) NSString *volumeID;
@property (nonatomic, readonly) NSDate *createdAt;

@property (nonatomic, copy) NSString *rawWritingData;
@property (nonatomic, copy) NSString *rawReadingData;

@property (nonatomic, copy) NSString *data;
@property (nonatomic, copy) NSString *dataLoss;
@property (nonatomic, copy) NSString *corrupted;
@property (nonatomic, copy) NSString *slightlyChanged;
@property (nonatomic, copy) NSString *overwritten;
@property (nonatomic, copy) NSString *avgWritingSpeed;
@property (nonatomic, copy) NSString *avgReadingSpeed;

@property (nonatomic, readonly) BOOL approved;

- (void)save;

@end
