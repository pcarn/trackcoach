//
//  SettingsViewControllerTests.m
//  TrackCoach
//
//  Created by Peter Carnesciali on 12/28/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "SettingsViewController.h"
#import "TrackCoachUI.h"
#import "TrackCoachViewController.h"

@interface SettingsViewController (Testing)

- (void)setConfirmResetState:(id)sender;

@end

@interface SettingsViewControllerTests : XCTestCase

@end

@implementation SettingsViewControllerTests {
    SettingsViewController *viewController;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    viewController = [[SettingsViewController alloc] init];
}

- (void)setUpInterface {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    viewController = [storyboard instantiateViewControllerWithIdentifier:@"SettingsViewControllerStoryboardID"];
    [viewController view];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSetConfirmResetState {
    id mockSwitch = OCMClassMock([UISwitch class]);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"confirmReset"];
    OCMStub([mockSwitch isOn]).andReturn(YES);
    [viewController setConfirmResetState:mockSwitch];
    XCTAssertTrue([defaults boolForKey:@"confirmReset"]);
    OCMVerify([mockSwitch isOn]);
}

- (void)testOthers {
    [viewController viewDidAppear:NO];
    [viewController didReceiveMemoryWarning];
}

@end
