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
        _startTime = [decoder decodeInt64ForKey:@"startTime"];
        _lapTimes = [decoder decodeObjectForKey:@"lapTimes"];
    } else {
        [NSException raise:@"ClassInitException" format: @"RaceTime super init failed"];
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
    uint64_t end = mach_absolute_time();
    if (self.startTime == 0) {
        return 0;
    }
    mach_timebase_info_data_t info;
    if (mach_timebase_info(&info) != KERN_SUCCESS) {
        [NSException raise:@"TimeException" format: @"mach_timebase_info failed"];
    }
    return (end-self.startTime) * info.numer / info.denom / 1000000000.0;
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
        [NSException raise:@"OutOfRangeException" format:@"Tried to total more laps than were present"];
    }
    for (NSInteger i=count; i<numberOfLaps; i++) {
        total += [self.lapTimes[i] doubleValue];
    }
    return total;
}

#pragma mark coder
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt64:self.startTime forKey:@"startTime"];
    [encoder encodeObject:self.lapTimes forKey:@"lapTimes"];
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
        return ((self.startTime == otherTime.startTime )
                && ([self.lapTimes isEqualToArray:otherTime.lapTimes] || (!self.lapTimes && !otherTime.lapTimes)));
    }
}

@end
