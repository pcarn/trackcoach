//
//  AppInfoViewControllerTests.m
//  TrackCoach
//
//  Created by Peter Carnesciali on 12/28/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "AppInfoViewController.h"
#import "TrackCoachUI.h"
#import "TrackCoachViewController.h"

@interface AppInfoViewController (Testing)

- (void)setConfirmResetState:(id)sender;

@end

@interface AppInfoViewControllerTests : XCTestCase

@end

@implementation AppInfoViewControllerTests {
    AppInfoViewController *viewController;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    viewController = [[AppInfoViewController alloc] init];
}

- (void)setUpInterface {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    viewController = [storyboard instantiateViewControllerWithIdentifier:@"AppInfoViewController"];
    [viewController view];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testViewDidLoad_webTextStringsExist {
    id uiMock = OCMClassMock([TrackCoachUI class]);
    NSString *mockString = @"test";
    NSArray *mockArray = [NSArray arrayWithObject:mockString];
    OCMStub([uiMock getStringsFromSite:[OCMArg any]]).andReturn(mockArray);
    [self setUpInterface];
    XCTAssertEqualObjects(mockString, viewController.topTextView.text);
    OCMVerify([uiMock getStringsFromSite:[OCMArg any]]);
}

- (void)testViewDidLoad_stringsChangeForiPad {
    id deviceMock = OCMPartialMock([UIDevice currentDevice]);
    OCMStub([deviceMock userInterfaceIdiom]).andReturn(UIUserInterfaceIdiomPad);
    [self setUpInterface];
    XCTAssertTrue([viewController.topTextView.text containsString:@"iPad"]);
    OCMVerify([deviceMock userInterfaceIdiom]);
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

- (void)testContactButtonAction {
    id mockcontroller = OCMPartialMock(viewController);
    [viewController contactButtonAction:nil];
    OCMVerify([mockcontroller presentViewController:[OCMArg any] animated:YES completion:nil]);
}

- (void)testMailComposeController_dismisses {
    id mockcontroller = OCMPartialMock(viewController);
    [viewController mailComposeController:nil didFinishWithResult:MFMailComposeResultSent error:nil];
    OCMVerify([mockcontroller dismissViewControllerAnimated:YES completion:nil]);
}

- (void)testBack {
    id mockDelegate = OCMClassMock([TrackCoachViewController class]);
    viewController.delegate = mockDelegate;
    [viewController back:nil];
    OCMVerify([mockDelegate appInfoViewControllerDidCancel:viewController]);
}

- (void)testOthers {
    [viewController viewDidAppear:NO];
    [viewController didReceiveMemoryWarning];
    XCTAssertEqual(UIStatusBarStyleLightContent, [viewController preferredStatusBarStyle]);
}

@end
