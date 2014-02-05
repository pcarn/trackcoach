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
    } else {
        NSLog(@"Super did not init");
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
    NSLog(@"Lap");
    if (!self.timerIsRunning) {
        [NSException raise:@"Tried to lap while timer not running"
                    format:nil];
    }
    [self.raceTime addNewLap];
}

- (void)undoStop {
    if (self.timerIsRunning) {
        [NSException raise:@"Tried to undo stop, when already started" format:nil];
    }
    
    [self.raceTime removeMostRecentLap];
    self.timerIsRunning = YES;
    
}

- (void)reset {
    if (self.timerIsRunning) {
        [NSException raise:@"Tried to reset while timer running"
                    format:nil];
    }
    NSLog(@"Reset");
    self.raceTime = [[RaceTime alloc] init];
}

- (BOOL)lapsIsEmpty {
    return ([self.raceTime.lapTimes count] == 0);
}


@end
