//
//  TutorialTests.m
//  TrackCoach
//
//  Created by Peter Carnesciali on 1/25/15.
//  Copyright (c) 2015 Peter Carnesciali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "Tutorial.h"
#import "TutorialViewController.h"
#import "Defines.h"

@interface Tutorial (Testing)

- (TutorialViewController *)viewControllerAtIndex:(NSUInteger)index;

@end

@interface TutorialTests : XCTestCase

@end

@implementation TutorialTests {
    Tutorial *tutorial;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    tutorial = [[Tutorial alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

@end
