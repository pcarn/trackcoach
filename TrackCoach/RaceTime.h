//
//  RaceTime.h
//  TrackCoach
//
//  Created by Peter Carnesciali on 2/4/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <mach/mach_time.h>

@interface RaceTime : NSObject <NSCoding>

@property (assign) uint64_t startTime;
@property (strong, nonatomic) NSMutableArray *lapTimes;

- (NSTimeInterval)mostRecentLapTime;
- (void)removeMostRecentLap;
- (void)addNewLapAtCurrentTime;
- (NSTimeInterval)elapsed;
- (NSTimeInterval)totalOfAllLaps;
- (NSTimeInterval)totalOfLapAndBelow:(NSInteger)count;
- (BOOL)isEqualToRaceTime:(RaceTime *)otherTime;

@end
