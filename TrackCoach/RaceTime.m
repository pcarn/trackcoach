//
//  RaceTime.m
//  TrackCoach
//
//  Created by Peter Carnesciali on 2/4/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#import "RaceTime.h"

@implementation RaceTime

#pragma mark init
- (id)initWithCoder:(NSCoder *)decoder {
//    self = [super initWithCoder:decoder];
    self = [super init];
    if (self) {
        _startDate = [decoder decodeObjectForKey:@"startDate"];
        _lapTimes = [decoder decodeObjectForKey:@"lapTimes"];
    }
    return self;
}

- (NSMutableArray *)lapTimes {
    if (!_lapTimes) {
        _lapTimes = [[NSMutableArray alloc] init];
    }
    return _lapTimes;
}

- (NSTimeInterval)mostRecentLapTime {
    return [[self.lapTimes firstObject] doubleValue];
}

- (void)removeMostRecentLap {
    [self.lapTimes removeObjectAtIndex:0];
}

- (void)addNewLap {
    [self.lapTimes insertObject:@([self elapsed] - [self totalOfAllLaps]) atIndex:0];
}

- (NSTimeInterval)elapsed {
    if (self.startDate == nil) {
        return 0;
    }
    return [[NSDate date] timeIntervalSinceDate:self.startDate];
}

- (NSTimeInterval)totalOfAllLaps {
    NSTimeInterval total = 0;
    for (NSNumber *lap in self.lapTimes) {
        total += [lap doubleValue];
    }
    return total;
}

- (NSTimeInterval)totalOfLapAndBelow:(NSInteger)count {
    NSTimeInterval total = 0;
    NSUInteger numberOfLaps = self.lapTimes.count;
    if (count > numberOfLaps) {
        [NSException raise:@"Tried to total more laps than were present" format:nil];
    }
    for (NSInteger i=count; i<numberOfLaps; i++) {
        total += [self.lapTimes[i] doubleValue];
    }
    return total;
}

#pragma mark coder
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.startDate forKey:@"startDate"];
    [encoder encodeObject:self.lapTimes forKey:@"lapTimes"];
}

@end
