//
//  MainStoryboardTest.m
//  TrackCoach
//
//  Created by Peter Carnesciali on 12/27/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TrackCoachViewController.h"

@interface MainStoryboardTest : XCTestCase

@end

@implementation MainStoryboardTest {
    TrackCoachViewController *viewController;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    viewController = [storyboard instantiateViewControllerWithIdentifier:@"TrackCoachViewController"];
    [viewController view];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testViewControllerExists {
    XCTAssertNotNil([viewController view]);
}

- (void)testOutletConnections {
    XCTAssertNotNil([viewController lapResetButton]);
    XCTAssertNotNil([viewController shareButton]);
    XCTAssertNotNil([viewController startStopButton]);
    XCTAssertNotNil([viewController lapTimerLabel]);
    XCTAssertNotNil([viewController timerLabel]);
    XCTAssertNotNil([viewController tableView]);
}

- (void)testActionConnections {
    NSArray *actions  = [viewController.lapResetButton actionsForTarget:viewController forControlEvent:UIControlEventTouchDown];
    XCTAssertTrue([actions containsObject:@"lapResetButtonAction:"]);
    actions = [viewController.startStopButton actionsForTarget:viewController forControlEvent:UIControlEventTouchDown];
    XCTAssertTrue([actions containsObject:@"startStopButtonAction:"]);
    actions = [viewController.shareButton actionsForTarget:viewController forControlEvent:UIControlEventTouchUpInside];
    XCTAssertTrue([actions containsObject:@"shareButtonAction:"]);
}

@end
