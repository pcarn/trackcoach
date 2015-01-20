//
//  TrackCoachTableViewCellTests.m
//  TrackCoach
//
//  Created by Peter Carnesciali on 1/15/15.
//  Copyright (c) 2015 Peter Carnesciali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TrackCoachTableViewCell.h"

@interface TrackCoachTableViewCellTests : XCTestCase

@end

@implementation TrackCoachTableViewCellTests {
    TrackCoachTableViewCell *cell;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testOthers {
    // All calls here, since nothing to test.
    cell = [[TrackCoachTableViewCell alloc] init];
    [TrackCoachTableViewCell alloc];
    [cell setSelected:YES];

}

@end
