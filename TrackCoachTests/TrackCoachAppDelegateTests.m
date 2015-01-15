//
//  TrackCoachAppDelegateTests.m
//  TrackCoach
//
//  Created by Peter Carnesciali on 12/28/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "TrackCoachAppDelegate.h"

@interface TrackCoachAppDelegateTests : XCTestCase

@end

@implementation TrackCoachAppDelegateTests {
    TrackCoachAppDelegate *delegate;
    id mockViewController;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    delegate = [[TrackCoachAppDelegate alloc] init];
    mockViewController = OCMClassMock([TrackCoachViewController class]);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testApplicationWillResignActive {
    delegate.viewController = mockViewController;
    [delegate applicationWillResignActive:nil];
    OCMVerify([mockViewController stopNSTimer]);
}

- (void)testApplicationDidEnterBackground {
    delegate.viewController = mockViewController;
    [delegate applicationDidEnterBackground:nil];
    OCMVerify([mockViewController stopNSTimer]);
}

- (void)testApplicationWillEnterForeground {
    delegate.viewController = mockViewController;
    [delegate applicationWillEnterForeground:nil];
    OCMVerify([mockViewController startNSTimer]);
}

- (void)testApplicationDidBecomeActive {
    delegate.viewController = mockViewController;
    [delegate applicationDidBecomeActive:nil];
    OCMVerify([mockViewController startNSTimer]);
}

- (void)testApplicationWillTerminate {
    delegate.viewController = mockViewController;
    [delegate applicationWillTerminate:nil];
    OCMVerify([mockViewController saveSettings]);
}

- (void)testExtra {
    [TrackCoachAppDelegate alloc];
    // This is here to get coverage of the @implementation line
}

@end
