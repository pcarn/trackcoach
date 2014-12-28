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
    id partialMock = OCMPartialMock([UIDevice currentDevice]);
    OCMStub([partialMock userInterfaceIdiom]).andReturn(UIUserInterfaceIdiomPad);
    [self setUpInterface];
    XCTAssertTrue([viewController.topTextView.text containsString:@"iPad"]);
    OCMVerify([partialMock userInterfaceIdiom]);
}

@end
