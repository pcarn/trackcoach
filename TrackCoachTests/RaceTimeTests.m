//
//  RaceTimeTests.m
//  TrackCoach
//
//  Created by Peter Carnesciali on 12/26/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "RaceTime.h"

@interface RaceTimeTests : XCTestCase

@end

@implementation RaceTimeTests {
    RaceTime *time;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    time = [[RaceTime alloc] init];
    [time.lapTimes insertObject:@60 atIndex:0];
    [time.lapTimes insertObject:@90 atIndex:0];
    [time.lapTimes insertObject:@120 atIndex:0];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMostRecentLapTime {
    XCTAssertEqual(120, [time mostRecentLapTime]);
}

- (void)testRemoveMostRecentLap {
    [time removeMostRecentLap];
    XCTAssertEqual(90, [time mostRecentLapTime]);
    XCTAssertEqual(2, [time.lapTimes count]);
}

- (void)testAddNewLapAtCurrentTime {
    time.startDate = [[NSDate date] dateByAddingTimeInterval:-30];
    time.lapTimes = nil;
    time.timerIsRunning = YES;
    [time addNewLapAtCurrentTime];
    XCTAssertEqualWithAccuracy(30, [time mostRecentLapTime], 0.01);
    XCTAssertEqual(1, [time.lapTimes count]);
}

- (void)testElapsed {
    time.startDate = nil;
    time.timerIsRunning = NO;
//    XCTAssertEqual(0, [time elapsed]);

    time.startDate = [[NSDate date] dateByAddingTimeInterval:-5];
//    XCTAssertEqualWithAccuracy(5, [time elapsed], 0.01);
}

- (void)testTotalOfAllLaps {
    XCTAssertEqual(270, [time totalOfAllLaps]);
}

- (void)testTotalOfLapAndBelow {
    XCTAssertThrows([time totalOfLapAndBelow:7]);
    XCTAssertEqual(150, [time totalOfLapAndBelow:1]);
}

- (void)testCoder {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:time];
    RaceTime *decoded = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    XCTAssertEqualObjects(decoded, time);
    // If more properties are added, coder method must be updated
}

- (void)testIsEqual_sameObject {
    XCTAssertTrue([time isEqual:time]);
}


- (void)testIsEqual_nilObject {
    XCTAssertFalse([time isEqual:nil]);
}

- (void)testIsEqual_equalObject {
    id mock = OCMPartialMock(time);
    RaceTime *other = [[RaceTime alloc] init];
    [other.lapTimes insertObject:@60 atIndex:0];
    [other.lapTimes insertObject:@90 atIndex:0];
    [other.lapTimes insertObject:@120 atIndex:0];
    other.startDate = time.startDate = [NSDate date];
    [time isEqualToRaceTime:other];
    OCMVerify([mock isEqualToRaceTime:other]);
}

- (void)testIsEqualToRaceTime_sameObject {
    XCTAssertTrue([time isEqualToRaceTime:time]);
}

- (void)testIsEqualToRaceTime_nilObject {
    XCTAssertFalse([time isEqualToRaceTime:nil]);
}

- (void)testIsEqualToRaceTime_equalObject {
    RaceTime *other = [[RaceTime alloc] init];
    [other.lapTimes insertObject:@60 atIndex:0];
    [other.lapTimes insertObject:@90 atIndex:0];
    [other.lapTimes insertObject:@120 atIndex:0];
    other.startDate = time.startDate = [NSDate date];
    XCTAssertTrue([time isEqualToRaceTime:other]);
}

@end
