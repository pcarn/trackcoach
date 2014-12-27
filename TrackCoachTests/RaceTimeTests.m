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
    XCTAssertEqual(2, [time.lapTimes count]);
}

- (void)testAddNewLapAtCurrentTime {
    time.startDate = [[NSDate date] dateByAddingTimeInterval:-30];
    time.lapTimes = nil;
    [time addNewLapAtCurrentTime];
    XCTAssertEqualWithAccuracy(30, [time mostRecentLapTime], 0.01);
    XCTAssertEqual(1, [time.lapTimes count]);
}

- (void)testElapsed {
    time.startDate = nil;
    XCTAssertEqual(0, [time elapsed]);
    
    time.startDate = [[NSDate date] dateByAddingTimeInterval:-5];
    XCTAssertEqualWithAccuracy(5, [time elapsed], 0.01);
}

- (void)testTotalOfAllLaps {
    XCTAssertEqual(270, [time totalOfAllLaps]);
}

- (void)testTotalOfLapAndBelow {
    XCTAssertThrows([time totalOfLapAndBelow:7]);
    XCTAssertEqual(150, [time totalOfLapAndBelow:1]);
}

- (void)testEncodeWithCoder {
    [NSKeyedArchiver archivedDataWithRootObject:time];
    // Assuming this function works, no test
    // If more properties are added, this must be updated
}

@end
