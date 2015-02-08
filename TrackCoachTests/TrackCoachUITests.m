//
//  TrackCoachUITests.m
//  TrackCoach
//
//  Created by Peter Carnesciali on 12/25/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TrackCoachUI.h"

@interface TrackCoachUITests : XCTestCase

@end

@implementation TrackCoachUITests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetStringsFromSite {
    XCTAssertThrows([TrackCoachUI getStringsFromSite:nil]);
}

- (void)testTimeToString {
    XCTAssertEqualObjects(@"0:00.00", [TrackCoachUI timeToString:0]);
    XCTAssertEqualObjects(@"0:01.00", [TrackCoachUI timeToString:1]);
    XCTAssertEqualObjects(@"1:00.00", [TrackCoachUI timeToString:60]);
    
    XCTAssertEqualObjects(@"9:59.99", [TrackCoachUI timeToString:(9*60 + 59 + 0.99)]);
    
    XCTAssertEqualObjects(@"10:00.00", [TrackCoachUI timeToString:(10*60)]);
    XCTAssertEqualObjects(@"1:00:00.00", [TrackCoachUI timeToString:3600]);
}


@end
