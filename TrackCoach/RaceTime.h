//
//  RaceTime.h
//  TrackCoach
//
//  Created by Peter Carnesciali on 2/4/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RaceTime : NSObject <NSCoding>

@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSMutableArray *lapTimes;
@property BOOL timerIsRunning;

- (NSTimeInterval)mostRecentLapTime;
- (void)removeMostRecentLap;
- (void)addNewLapAtCurrentTime;
- (NSTimeInterval)elapsed;
- (NSTimeInterval)totalOfAllLaps;
- (NSTimeInterval)totalOfLapAndBelow:(NSInteger)count;
- (BOOL)isEqualToRaceTime:(RaceTime *)otherTime;

@end
