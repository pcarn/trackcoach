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
    brain.raceTime.timerIsRunning = NO;
    [brain start];
    XCTAssertTrue(brain.raceTime.timerIsRunning);
}

- (void)testStop {
    brain.raceTime.timerIsRunning = YES;
    [brain stop];
    XCTAssertFalse(brain.raceTime.timerIsRunning);
}

- (void)testLap {
    id mockRaceTime = OCMClassMock([RaceTime class]);
    
    OCMStub([mockRaceTime timerIsRunning]).andReturn(YES);
    brain.raceTime = mockRaceTime;
    [brain lap];
    OCMVerify([mockRaceTime addNewLapAtCurrentTime]);
}

- (void)testLap_whenStopped {
    brain.raceTime.timerIsRunning = NO;
    XCTAssertThrows([brain lap]);
}

- (void)testUndoStop {
    [brain start];
    [brain stop];
    [brain undoStop];
    XCTAssertTrue([brain lapsIsEmpty]);
    XCTAssertTrue(brain.raceTime.timerIsRunning);
}

- (void)testUndoStop_whenRunning {
    brain.raceTime.timerIsRunning = YES;
    XCTAssertThrows([brain undoStop]);
}

- (void)testReset {
    RaceTime *temp = [[RaceTime alloc] init];
    brain.raceTime = temp;
    [brain reset];
    XCTAssertNotEqual(temp, brain.raceTime);
    //Because of lazy initialization, cannot check if nil.
}

- (void)testReset_whileRunning {
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

- (void)testOthers {
    [TrackCoachBrain alloc];
    // This is here to get coverage of the @implementation line
}

@end
