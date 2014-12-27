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

- (void)testTableView {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"confirmReset"];
    viewController.trackCoachBrain.raceTime.lapTimes = nil;
    viewController.trackCoachBrain.timerIsRunning = NO;
    [viewController.trackCoachBrain.raceTime.lapTimes insertObject:@60 atIndex:0];
    [viewController.trackCoachBrain.raceTime.lapTimes insertObject:@90 atIndex:0];
    [viewController.trackCoachBrain.raceTime.lapTimes insertObject:@120 atIndex:0];
    [viewController.tableView reloadData];
    XCTAssertEqual(3, [viewController.tableView numberOfRowsInSection:0]);
    
    [viewController reset];
    [viewController.tableView reloadData];
    XCTAssertEqual(0, [viewController.tableView numberOfRowsInSection:0]);
}

- (void)testViewDidLoad {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"confirmReset"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    viewController = [storyboard instantiateViewControllerWithIdentifier:@"TrackCoachViewController"];
    [viewController view];
    XCTAssertTrue([defaults boolForKey:@"confirmReset"]);
}

- (void)testShareButtonAction {
    // Nothing possible to test, manually test regularly
    [viewController.trackCoachBrain.raceTime.lapTimes insertObject:@60 atIndex:0];
    [viewController shareButtonAction:nil];
}

- (void)testStartStopButtonAction {
    viewController.trackCoachBrain.timerIsRunning = NO;
    [viewController reset];
    [viewController startStopButtonAction:nil];
    XCTAssertTrue(viewController.trackCoachBrain.timerIsRunning);
}

- (void)testLapResetButtonAction {
    viewController.trackCoachBrain.timerIsRunning = YES;
    [viewController setupForTimerRunning];
    [viewController lapResetButtonAction:nil];
    XCTAssertEqual(1, [viewController.trackCoachBrain.raceTime.lapTimes count]);
    XCTAssertTrue(viewController.trackCoachBrain.timerIsRunning);
    viewController.trackCoachBrain.timerIsRunning = NO;
    [viewController setupForTimerStopped];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"confirmReset"];
    [viewController lapResetButtonAction:nil];
    XCTAssertTrue(viewController.alertIsDisplayed);
}

- (void)testSetupForTimerRunning {
    viewController.trackCoachBrain.timerIsRunning = YES;
    [viewController setupForTimerRunning];
    
    XCTAssertEqualObjects(@"Stop", viewController.startStopButton.currentTitle);
    XCTAssertEqualObjects([UIColor redColor], viewController.startStopButton.backgroundColor);
    XCTAssertEqualObjects(@"Lap", viewController.lapResetButton.currentTitle);
    XCTAssertEqualObjects([UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1] , viewController.lapResetButton.backgroundColor);
    XCTAssertTrue([[UIApplication sharedApplication] isIdleTimerDisabled]);
    XCTAssertFalse(viewController.shareButton.enabled);
    XCTAssertEqualWithAccuracy(0.2, viewController.shareButton.alpha, 0.01);
}


- (void)testSetupForTimerStopped {
    viewController.trackCoachBrain.timerIsRunning = NO;
    [viewController setupForTimerStopped];
    XCTAssertEqualObjects([TrackCoachUI timeToString:[viewController.trackCoachBrain.raceTime totalOfAllLaps]], viewController.timerLabel.text);
    XCTAssertEqualObjects([TrackCoachUI timeToString:[viewController.trackCoachBrain.raceTime mostRecentLapTime]], viewController.lapTimerLabel.text);
    XCTAssertEqualObjects(@"Undo Stop", viewController.startStopButton.currentTitle);
    XCTAssertEqualObjects([UIColor colorWithRed:255.0/255.0 green:122.0/255.0 blue:28.0/255.0 alpha:1.0], viewController.startStopButton.backgroundColor);
    XCTAssertEqualObjects(@"Reset", viewController.lapResetButton.currentTitle);
    XCTAssertEqualObjects([UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1] , viewController.lapResetButton.backgroundColor);
    XCTAssertFalse([[UIApplication sharedApplication] isIdleTimerDisabled]);
    XCTAssertTrue(viewController.shareButton.enabled);
    XCTAssertEqual(1.0, viewController.shareButton.alpha);
}


- (void)testReset {
    viewController.trackCoachBrain.timerIsRunning = NO;
    [viewController setupForTimerStopped];
    [viewController reset];
    XCTAssertEqualObjects(@"0:00.00", viewController.timerLabel.text);
    XCTAssertEqualObjects(@"0:00.00", viewController.lapTimerLabel.text);
    XCTAssertFalse([viewController.shareButton isEnabled]);
    XCTAssertEqualObjects(@"Start", viewController.startStopButton.currentTitle);
    XCTAssertEqualObjects([UIColor greenColor], viewController.startStopButton.backgroundColor);
    XCTAssertEqualObjects(@"Reset", viewController.lapResetButton.currentTitle);
    XCTAssertEqualObjects([UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1] , viewController.lapResetButton.backgroundColor);
}

- (void)testUndoStop {
    viewController.trackCoachBrain.timerIsRunning = NO;
    [viewController.trackCoachBrain.raceTime.lapTimes insertObject:@60 atIndex:0];
    [viewController undoStop];
    XCTAssertTrue(viewController.trackCoachBrain.timerIsRunning);
}

@end
