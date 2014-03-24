//
//  TrackCoachBrain.h
//  TrackCoach
//
//  Created by Peter Carnesciali on 2/4/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VolumeButtons.h"
#import "RaceTime.h"
#define UNDO_STOP_ALERT 7
#define RESET_ALERT 8

@interface TrackCoachBrain : NSObject

@property (assign) BOOL timerIsRunning;
@property (strong, nonatomic) RaceTime *raceTime;

- (void)lap;
- (void)reset;
- (void)start;
- (void)stop;
- (void)undoStop;
- (BOOL)lapsIsEmpty;

@end
