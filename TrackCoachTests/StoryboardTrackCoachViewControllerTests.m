//
//  TrackCoachViewControllerTest.m
//  TrackCoach
//
//  Created by Peter Carnesciali on 12/27/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TrackCoachViewController.h"

@interface TrackCoachViewController (Testing)

- (void)setupForTimerRunning;
- (void)setupForTimerStopped;
- (void)reset;
- (void)undoStop;
- (void)setupEncodedRaceTime;
- (void)saveSettings;

@end

@interface TrackCoachViewControllerTest : XCTestCase

@end

@implementation TrackCoachViewControllerTest {
    TrackCoachViewController *viewController;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    viewController = [storyboard instantiateViewControllerWithIdentifier:@"TrackCoachView"];
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
    XCTAssertTrue([viewController respondsToSelector:[viewController.shareButton action]]);
}

- (void)testTableView_ForMultipleLaps {
    viewController.trackCoachBrain.raceTime.lapTimes = nil;
    [viewController.trackCoachBrain.raceTime.lapTimes insertObject:@60 atIndex:0];
    [viewController.trackCoachBrain.raceTime.lapTimes insertObject:@90 atIndex:0];
    [viewController.trackCoachBrain.raceTime.lapTimes insertObject:@120 atIndex:0];
    [viewController.tableView reloadData];
    XCTAssertEqual(3, [viewController.tableView numberOfRowsInSection:0]);
}

- (void)testTableView_ForNoLaps {
    viewController.trackCoachBrain.raceTime.lapTimes = nil;
    [viewController.tableView reloadData];
    XCTAssertEqual(0, [viewController.tableView numberOfRowsInSection:0]);
}

// From ViewController
- (void)testSetupEncodedRaceTime_clear {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"timerIsRunning"];
    viewController.trackCoachBrain.raceTime.startDate = nil;
    [viewController saveSettings];
    [viewController setupEncodedRaceTime];

    XCTAssertFalse(viewController.shareButton.enabled);
}

@end
