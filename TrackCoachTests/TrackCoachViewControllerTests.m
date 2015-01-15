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
    OCMStub([mockBrain timerIsRunning]).andReturn(NO);
    viewController.trackCoachBrain = mockBrain;
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
    OCMStub([mockBrain timerIsRunning]).andReturn(YES);
    viewController.trackCoachBrain = mockBrain;
    [viewController startStopButtonAction:nil];
    OCMVerify([mockBrain stop]);
}

@end
