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

- (NSTimeInterval)mostRecentLapTime;
- (void)removeMostRecentLap;
- (void)addNewLap;
- (NSTimeInterval)elapsed;
- (NSTimeInterval)totalOfLaps;

@end
