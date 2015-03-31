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
    self = [super init];
    if (self) {
        _startDate = [decoder decodeObjectForKey:@"startDate"];
        _lapTimes = [decoder decodeObjectForKey:@"lapTimes"];
        _timerIsRunning = [decoder decodeBoolForKey:@"timerIsRunning"];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        self.timerIsRunning = NO;
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

- (void)addNewLapAtCurrentTime {
    [self.lapTimes insertObject:@([self elapsed] - [self totalOfAllLaps]) atIndex:0];
}

- (NSTimeInterval)elapsed {
    if (self.timerIsRunning) {
        if (self.startDate == nil) {
            return 0;
        } else {
            return [[NSDate date] timeIntervalSinceDate:self.startDate];
        }
    } else {
        return [self totalOfAllLaps];
    }
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
    [encoder encodeBool:self.timerIsRunning forKey:@"timerIsRunning"];
}

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    } else if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    } else {
        return [self isEqualToRaceTime:object];
    }
}

- (BOOL)isEqualToRaceTime:(RaceTime *)otherTime {
    if (otherTime == self) {
        return YES;
    } else if (!otherTime || ![otherTime isKindOfClass:[self class]]) {
        return NO;
    } else {
        return (([self.startDate isEqualToDate:otherTime.startDate] || (!self.startDate && !otherTime.startDate))
                && ([self.lapTimes isEqualToArray:otherTime.lapTimes] || (!self.lapTimes && !otherTime.lapTimes))
                && (self.timerIsRunning == otherTime.timerIsRunning));

    }
}

@end
