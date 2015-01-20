//
//  TrackCoachViewControllerTests.m
//  TrackCoach
//
//  Created by Peter Carnesciali on 12/28/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "TrackCoachViewController.h"

@interface TrackCoachViewController (Testing)

- (void)setupForTimerRunning;
- (void)setupForTimerStopped;
- (void)reset;
- (void)undoStop;
- (TutorialViewController *)viewControllerAtIndex:(NSUInteger)index;
- (void)runTutorialIfNeeded;
- (void)setupEncodedRaceTime;
- (void)setupVolumeButtons;

@end

@interface TrackCoachViewControllerTests : XCTestCase

@end

@implementation TrackCoachViewControllerTests {
    TrackCoachViewController *viewController;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    viewController = [[TrackCoachViewController alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    viewController = nil;
}

- (void)testViewDidLoad_setsConfirmReset {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"confirmReset"];
    [viewController viewDidLoad];
    XCTAssertTrue([defaults boolForKey:@"confirmReset"]);
}

- (void)testShareButtonAction {
    id mock = OCMPartialMock(viewController);
    [viewController.trackCoachBrain.raceTime.lapTimes insertObject:@60 atIndex:0];
    [viewController shareButtonAction:nil];
    OCMVerify([mock presentViewController:[OCMArg any] animated:YES completion:nil]);
}

- (void)testStartStopButtonAction_start {
    id mockBrain = OCMClassMock([TrackCoachBrain class]);
    viewController.trackCoachBrain = mockBrain;
    OCMStub([mockBrain timerIsRunning]).andReturn(NO);
    [viewController startStopButtonAction:nil];
    OCMVerify([(TrackCoachBrain *)mockBrain start]);
}

- (void)testStartStopButtonAction_undoStop {
    viewController.trackCoachBrain.timerIsRunning = NO;
    viewController.trackCoachBrain.raceTime.lapTimes = [NSMutableArray arrayWithObject:@5];
    [viewController startStopButtonAction:nil];
    XCTAssertTrue(viewController.alertIsDisplayed);
}

- (void)testStartStopButtonAction_stop {
    id mockBrain = OCMClassMock([TrackCoachBrain class]);
    viewController.trackCoachBrain = mockBrain;
    OCMStub([mockBrain timerIsRunning]).andReturn(YES);
    [viewController startStopButtonAction:nil];
    OCMVerify([mockBrain stop]);
}

- (void)testLapResetButtonAction_lap {
    id mockBrain = OCMClassMock([TrackCoachBrain class]);
    viewController.trackCoachBrain = mockBrain;
    OCMStub([mockBrain timerIsRunning]).andReturn(YES);
    [viewController lapResetButtonAction:nil];
    OCMVerify([mockBrain lap]);
}

- (void)testLapResetButtonAction_showResetAlert {
    viewController.trackCoachBrain.raceTime.lapTimes = [NSMutableArray arrayWithObject:@5];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"confirmReset"];
    [viewController lapResetButtonAction:nil];
    XCTAssertTrue(viewController.alertIsDisplayed);
}

- (void)testLapResetButtonAction_reset {
    id mock = OCMPartialMock(viewController);
    viewController.trackCoachBrain.raceTime.lapTimes = [NSMutableArray arrayWithObject:@5];
    [[NSUserDefaults standardUserDefaults]
     setBool:NO forKey:@"confirmReset"];
    [viewController lapResetButtonAction:nil];
    OCMVerify([mock reset]);
}

- (void)testSetupForTimerRunning {
    id mock = OCMPartialMock(viewController);
    [viewController setupForTimerRunning];
    OCMVerify([mock startNSTimer]);
}

- (void)testSetupForTimerStopped {
    id mock = OCMPartialMock(viewController);
    [viewController setupForTimerStopped];
    OCMVerify([mock stopNSTimer]);
}

- (void)testReset {
    id mockBrain = OCMClassMock([TrackCoachBrain class]);
    viewController.trackCoachBrain = mockBrain;
    [viewController reset];
    OCMVerify([mockBrain reset]);
}

- (void)testUndoStop {
    id mockBrain = OCMClassMock([TrackCoachBrain class]);
    viewController.trackCoachBrain = mockBrain;
    [viewController undoStop];
    OCMVerify([mockBrain undoStop]);
}

- (void)testUpdateUI {
    id mockBrain = OCMClassMock([TrackCoachBrain class]);
    viewController.trackCoachBrain = mockBrain;
    OCMStub([mockBrain timerIsRunning]).andReturn(YES);
    [viewController updateUI];

    OCMStub([mockBrain timerIsRunning]).andReturn(NO);
    [viewController updateUI];
    // Nothing easy to test here
}

- (void)testAlertView_reset {
    id mock = OCMPartialMock(viewController);
    UIAlertView *testAlert = [[UIAlertView alloc] init];
    testAlert.tag = RESET_ALERT;
    viewController.trackCoachBrain.timerIsRunning = NO;
    viewController.trackCoachBrain.raceTime.lapTimes = [NSMutableArray arrayWithObject:@5];
    [viewController alertView:testAlert clickedButtonAtIndex:1];
    OCMVerify([mock reset]);
}

- (void)testAlertView_undoStop {
    id mock = OCMPartialMock(viewController);
    UIAlertView *testAlert = [[UIAlertView alloc] init];
    testAlert.tag = UNDO_STOP_ALERT;
    viewController.trackCoachBrain.timerIsRunning = NO;
    viewController.trackCoachBrain.raceTime.lapTimes = [NSMutableArray arrayWithObject:@5];
    [viewController alertView:testAlert clickedButtonAtIndex:1];
    OCMVerify([mock undoStop]);
}

- (void)testAlertView_other {
    UIAlertView *testAlert = [[UIAlertView alloc] init];
    testAlert.tag = 429;
    viewController.trackCoachBrain.timerIsRunning = NO;
    viewController.trackCoachBrain.raceTime.lapTimes = [NSMutableArray arrayWithObject:@5];
    [viewController alertView:testAlert clickedButtonAtIndex:1];
}

- (void)testSaveSettings_notRunning {
    id mockBrain = OCMClassMock([TrackCoachBrain class]);
    viewController.trackCoachBrain = mockBrain;
    OCMStub([mockBrain timerIsRunning]).andReturn(NO);
    [viewController saveSettings];
    XCTAssertEqual([[NSUserDefaults standardUserDefaults] boolForKey:@"timerIsRunning"], NO);
}

- (void)testSaveSettings_running {
    id mockBrain = OCMClassMock([TrackCoachBrain class]);
    viewController.trackCoachBrain = mockBrain;
    OCMStub([mockBrain timerIsRunning]).andReturn(YES);
    [viewController saveSettings];
    XCTAssertEqual([[NSUserDefaults standardUserDefaults] boolForKey:@"timerIsRunning"], YES);
}

- (void)testTutorialOthers {
    [viewController pageViewController:nil viewControllerAfterViewController:nil];

    id mockVC = OCMClassMock([TutorialViewController class]);
    OCMStub([mockVC pageIndex]).andReturn(NSNotFound);
    [viewController pageViewController:nil viewControllerAfterViewController:mockVC];

    [viewController pageViewController:nil viewControllerBeforeViewController:nil];

    mockVC = OCMClassMock([TutorialViewController class]);
    OCMStub([mockVC pageIndex]).andReturn(429);
    [viewController pageViewController:nil viewControllerBeforeViewController:mockVC];

    TutorialViewController *tutorial;
    tutorial = [viewController viewControllerAtIndex:0];
    XCTAssertEqualObjects(tutorial.nibName, @"Tutorial1");

    tutorial = [viewController viewControllerAtIndex:1];
    XCTAssertEqualObjects(tutorial.nibName, @"Tutorial2");

    tutorial = [viewController viewControllerAtIndex:2];
    XCTAssertEqualObjects(tutorial.nibName, @"Tutorial3");

    tutorial = [viewController viewControllerAtIndex:3];
    XCTAssertFalse(viewController.tutorialIsDisplayed);
    XCTAssertTrue([[NSUserDefaults standardUserDefaults] boolForKey:TUTORIAL_RUN_STRING]);
    [viewController presentationCountForPageViewController:nil];
    [viewController presentationIndexForPageViewController:nil];
}

- (void)testTutorialIfNeeded {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:TUTORIAL_RUN_STRING];
    [viewController runTutorialIfNeeded];
    XCTAssertTrue(viewController.tutorialIsDisplayed);
}

- (void)testStartNSTimer {
    [viewController startNSTimer];
    XCTAssertNotNil(viewController.timer);
}

- (void)testStopNSTimer {
    [viewController startNSTimer];
    [viewController stopNSTimer];
    XCTAssertNil(viewController.timer);
}

- (void)testSetupEncodedRaceTime_running {
    id mock = OCMPartialMock(viewController);
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"timerIsRunning"];
    [viewController setupEncodedRaceTime];
    OCMVerify([mock setupForTimerRunning]);
}

- (void)testSetupEncodedRaceTime_stopped {
    id mock = OCMPartialMock(viewController);
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"timerIsRunning"];
    viewController.trackCoachBrain.raceTime.startDate = [NSDate date];
    [viewController saveSettings];
    [viewController setupEncodedRaceTime];
    OCMVerify([mock setupForTimerStopped]);
}

- (void)testSetupVolumeButtons {
    viewController.alertIsDisplayed = NO;
    viewController.tutorialIsDisplayed = YES;
    [viewController setupVolumeButtons];
}

- (void)testOthers {
    [viewController tableView:nil numberOfRowsInSection:0];
    [viewController numberOfSectionsInTableView:nil];
    viewController.trackCoachBrain.raceTime.lapTimes = [NSMutableArray arrayWithObject:@5];
    [viewController tableView:nil cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

    id mockSegue = OCMClassMock([UIStoryboardSegue class]);
    OCMStub([mockSegue identifier]).andReturn(@"AppInfo");
    [viewController prepareForSegue:mockSegue sender:nil];
}

@end
