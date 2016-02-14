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
- (void)runTutorialIfNeeded;
- (void)setupEncodedRaceTime;
- (void)startNSTimer;
- (void)stopNSTimer;
- (void)updateUI;
- (void)saveSettings;
- (void)startNSTimerIfSuspended;
- (void)stopNSTimerIfRunning;

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
    OCMVerify([mock presentViewController:[OCMArg any] animated:YES completion:[OCMArg any]]);
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
    testAlert.tag = resetAlert;
    viewController.trackCoachBrain.timerIsRunning = NO;
    viewController.trackCoachBrain.raceTime.lapTimes = [NSMutableArray arrayWithObject:@5];
    [viewController alertView:testAlert clickedButtonAtIndex:1];
    OCMVerify([mock reset]);
}

- (void)testAlertView_undoStop {
    id mock = OCMPartialMock(viewController);
    UIAlertView *testAlert = [[UIAlertView alloc] init];
    testAlert.tag = undoStopAlert;
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

- (void)testTutorialIfNeeded {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:TUTORIAL_RUN_STRING];
    [viewController runTutorialIfNeeded];
    XCTAssertNotNil(viewController.tutorial);
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
    viewController.trackCoachBrain.raceTime.startTime = mach_absolute_time();
    [viewController saveSettings];
    [viewController setupEncodedRaceTime];
    OCMVerify([mock setupForTimerStopped]);
}

- (void)testSetupVolumeButtons {
    viewController.alertIsDisplayed = NO;
    viewController.tutorial = [[Tutorial alloc] init];
    //TODO: What's the test here
}

- (void)testStartNSTimerIfSuspended {
    id mock = OCMPartialMock(viewController);
    viewController.timerSuspended = YES;
    [viewController startNSTimerIfSuspended];
    XCTAssertFalse(viewController.timerSuspended);
    OCMVerify([mock startNSTimer]);
}

- (void)testStopNSTimerIfRunning {
    id mock = OCMPartialMock(viewController);
    [viewController startNSTimer];
    [viewController stopNSTimerIfRunning];
    XCTAssertTrue(viewController.timerSuspended);
    OCMVerify([mock stopNSTimer]);
}

@end
