//
//  TrackCoachViewControllerTests.m
//  TrackCoach
//
//  Created by Peter Carnesciali on 12/28/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
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

@end
