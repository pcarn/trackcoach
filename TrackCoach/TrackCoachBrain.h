//
//  TrackCoachBrain.h
//  TrackCoach
//
//  Created by Peter Carnesciali on 2/4/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RaceTime.h"
#import "Defines.h"

@interface TrackCoachBrain : NSObject

@property (assign) BOOL timerIsRunning;
@property (strong, nonatomic) RaceTime *raceTime;

- (void)lap;
- (BOOL)lapsIsEmpty;
- (void)reset;
- (void)start;
- (void)stop;
- (void)undoStop;

@end
