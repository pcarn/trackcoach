//
//  StoryboardTrackCoachTableViewCellTests.m
//  TrackCoach
//
//  Created by Peter Carnesciali on 1/15/15.
//  Copyright (c) 2015 Peter Carnesciali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TrackCoachViewController.h"
#import "TrackCoachTableViewCell.h"

@interface StoryboardTrackCoachTableViewCellTests : XCTestCase

@end

@implementation StoryboardTrackCoachTableViewCellTests {
    TrackCoachViewController *viewController;
    TrackCoachTableViewCell *cell;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    viewController = [storyboard instantiateViewControllerWithIdentifier:@"TrackCoachViewController"];
    [viewController view];
    cell = [viewController.tableView dequeueReusableCellWithIdentifier:@"LapCell"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCellExists {
    XCTAssertNotNil(cell);
}

- (void)testOutletConnections {
    XCTAssertNotNil([cell titleLabel]);
    XCTAssertNotNil([cell splitLabel]);
    XCTAssertNotNil([cell totalLabel]);
}

@end
