//
//  StoryboardSettingsViewControllerTests.m
//  TrackCoach
//
//  Created by Peter Carnesciali on 12/28/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "SettingsViewController.h"

@interface StoryboardSettingsViewControllerTests : XCTestCase

@end

@implementation StoryboardSettingsViewControllerTests {
    SettingsViewController *viewController;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    viewController = [storyboard instantiateViewControllerWithIdentifier:@"SettingsView"];
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
    XCTAssertNotNil([viewController mainTextView]);
    XCTAssertNotNil([viewController topTextView]);
    XCTAssertNotNil([viewController contactButton]);
    XCTAssertNotNil([viewController copyrightNoticeLabel]);
    XCTAssertNotNil([viewController versionLabel]);
    XCTAssertNotNil([viewController contentWidth]);
    XCTAssertNotNil([viewController confirmResetSwitch]);
}

- (void)testActionConnections {
    NSArray *actions  = [viewController.contactButton actionsForTarget:viewController forControlEvent:UIControlEventTouchUpInside];
    XCTAssertTrue([actions containsObject:@"contactButtonAction:"]);
}

@end
