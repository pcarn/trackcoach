//
//  TrackCoachBrain.m
//  TrackCoach
//
//  Created by Peter Carnesciali on 2/4/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#import "TrackCoachBrain.h"

@implementation TrackCoachBrain

- (RaceTime *)raceTime {
    if (!_raceTime) {
        _raceTime = [[RaceTime alloc] init];
    }
    return _raceTime;
}

#pragma mark Timer
- (void)start {
    self.raceTime.startDate = [NSDate date];
    self.raceTime.timerIsRunning = YES;
}

- (void)stop {
    [self lap];
    self.raceTime.timerIsRunning = NO;
}

- (void)lap {
    NSLog(@"Lap");
    if (!self.raceTime.timerIsRunning) {
        [NSException raise:@"Tried to lap while timer not running"
                    format:nil];
    }
    [self.raceTime addNewLapAtCurrentTime];
}

- (void)undoStop {
    if (self.raceTime.timerIsRunning) {
        [NSException raise:@"Tried to undo stop, when already started" format:nil];
    }

    [self.raceTime removeMostRecentLap];
    self.raceTime.timerIsRunning = YES;
}

- (void)reset {
    if (self.raceTime.timerIsRunning) {
        [NSException raise:@"Tried to reset while timer running"
                    format:nil];
    }
    NSLog(@"Reset");
    self.raceTime = nil;
}

- (BOOL)lapsIsEmpty {
    return ([self.raceTime.lapTimes count] == 0);
}

@end
