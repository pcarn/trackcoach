//
//  RaceTimeTests.m
//  TrackCoach
//
//  Created by Peter Carnesciali on 12/26/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
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
}

- (void)testAddNewLapAtCurrentTime {
    time = [[RaceTime alloc] init]; // New RaceTime
    time.startDate = [[NSDate date] dateByAddingTimeInterval:-30];
    [time addNewLapAtCurrentTime];
    XCTAssertEqualWithAccuracy(30, [time mostRecentLapTime], 0.001);
}

- (void)testElapsed {
    time.startDate = nil;
    XCTAssertEqual(0, [time elapsed]);
    
    time.startDate = [[NSDate date] dateByAddingTimeInterval:-5];
    XCTAssertEqualWithAccuracy(5, [time elapsed], 0.001);
}

- (void)testTotalOfAllLaps {
    XCTAssertEqual(270, [time totalOfAllLaps]);
}

- (void)testTotalOfLapAndBelow {
    XCTAssertThrows([time totalOfLapAndBelow:7]);
    XCTAssertEqual(150, [time totalOfLapAndBelow:1]);
}

@end
