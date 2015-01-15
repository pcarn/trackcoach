//
//  TrackCoachBrainTests.m
//  TrackCoach
//
//  Created by Peter Carnesciali on 1/14/15.
//  Copyright (c) 2015 Peter Carnesciali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "TrackCoachBrain.h"

@interface TrackCoachBrainTests : XCTestCase

@end

@implementation TrackCoachBrainTests {
    TrackCoachBrain *brain;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    brain = [[TrackCoachBrain alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testStart {
    brain.timerIsRunning = NO;
    [brain start];
    XCTAssertTrue(brain.timerIsRunning);
}

- (void)testStop {
    brain.timerIsRunning = YES;
    [brain stop];
    XCTAssertFalse(brain.timerIsRunning);
}

- (void)testLap {
    id mockRaceTime = OCMClassMock([RaceTime class]);
    brain.raceTime = mockRaceTime;
    brain.timerIsRunning = YES;
    [brain lap];
    OCMVerify([mockRaceTime addNewLapAtCurrentTime]);
}

- (void)testLapWhenStopped {
    brain.timerIsRunning = NO;
    XCTAssertThrows([brain lap]);
}

- (void)testUndoStop {
    [brain start];
    [brain stop];
    [brain undoStop];
    XCTAssertTrue([brain lapsIsEmpty]);
    XCTAssertTrue(brain.timerIsRunning);
}

- (void)testUndoStopWhenRunning {
    brain.timerIsRunning = YES;
    XCTAssertThrows([brain undoStop]);
}

- (void)testReset {
    RaceTime *temp = [[RaceTime alloc] init];
    brain.raceTime = temp;
    [brain reset];
    XCTAssertNotEqual(temp, brain.raceTime);
    //Because of lazy initialization, cannot check if nil.
}

- (void)testResetWhileRunning {
    [brain start];
    XCTAssertThrows([brain reset]);
}

- (void)testLapsIsEmpty {
    [brain start];
    [brain lap];
    XCTAssertFalse([brain lapsIsEmpty]);
    [brain stop];
    [brain reset];
    XCTAssertTrue([brain lapsIsEmpty]);
}

- (void)testExtra {
    [TrackCoachBrain alloc];
    // This is here to get coverage of the @implementation line
}

@end
