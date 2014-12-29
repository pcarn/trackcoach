//
//  TrackCoachAppDelegateTests.m
//  TrackCoach
//
//  Created by Peter Carnesciali on 12/28/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TrackCoachAppDelegate.h"

@interface TrackCoachAppDelegateTests : XCTestCase

@end

@implementation TrackCoachAppDelegateTests {
    TrackCoachAppDelegate *delegate;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    delegate = [[TrackCoachAppDelegate alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testOthers {
    [delegate applicationWillResignActive:nil];
}


@end
