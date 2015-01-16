//
//  VolumeButtonsTests.m
//  TrackCoach
//
//  Created by Peter Carnesciali on 1/16/15.
//  Copyright (c) 2015 Peter Carnesciali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "VolumeButtons.h"

@interface VolumeButtons (Testing)

@property (nonatomic) BOOL active;
@property (nonatomic) int lastChange;
@property (nonatomic) BOOL loweredVolume;
@property (nonatomic) BOOL raisedVolume;
- (void)initializeVolumeButtons;
- (void)volumeDown;
- (void)volumeUp;

@end

@interface VolumeButtonsTests : XCTestCase

@end

@implementation VolumeButtonsTests {
    VolumeButtons *volumeButtons;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    volumeButtons = [[VolumeButtons alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testVolumeDown {
    id mock = OCMPartialMock(volumeButtons);
    volumeButtons.lastChange = 0;
    [volumeButtons volumeDown];
    OCMVerify([mock volumeDownBlock]);
    XCTAssertEqual(volumeButtons.lastChange, VOLUME_DOWN);
}

- (void)testVolumeUp {
    id mock = OCMPartialMock(volumeButtons);
    volumeButtons.lastChange = 0;
    [volumeButtons volumeUp];
    OCMVerify([mock volumeUpBlock]);
    XCTAssertEqual(volumeButtons.lastChange, VOLUME_UP);
}


@end
