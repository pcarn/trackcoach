//
//  TrackCoachBrain.m
//  TrackCoach
//
//  Created by Peter Carnesciali on 2/4/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#import "TrackCoachBrain.h"

@implementation TrackCoachBrain

- (id)init {
    self = [super init];
    if (self) {
        self.timerIsRunning = NO;
    }
    return self;
}

- (RaceTime *)raceTime {
    if (!_raceTime) {
        _raceTime = [[RaceTime alloc] init];
    }
    return _raceTime;
}

#pragma mark Timer
- (void)start {
    self.raceTime.startDate = [NSDate date];
    self.timerIsRunning = YES;
}

- (void)stop {
    [self lap];
    self.timerIsRunning = NO;
}

- (void)lap {
    if (!self.timerIsRunning) {
        [NSException raise:@"InvalidMethodException"
                    format:@"Tried to lap while timer not running"];
    }
    [self.raceTime addNewLapAtCurrentTime];
}

- (void)undoStop {
    if (self.timerIsRunning) {
        [NSException raise:@"InvalidMethodException" format:@"Tried to undo stop, when already started"];
    }

    [self.raceTime removeMostRecentLap];
    self.timerIsRunning = YES;
}

- (void)reset {
    if (self.timerIsRunning) {
        [NSException raise:@"InvalidMethodException"
                    format:@"Tried to reset while timer running"];
    }
    self.raceTime = nil;
}

- (BOOL)lapsIsEmpty {
    return ([self.raceTime.lapTimes count] == 0);
}

@end
