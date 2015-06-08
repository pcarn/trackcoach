//
//  AthleteViewController.m
//  TrackCoach
//
//  Created by Peter Carnesciali on 6/7/15.
//  Copyright (c) 2015 Peter Carnesciali. All rights reserved.
//

#import "AthleteViewController.h"
#import "AppDelegate.h"

@implementation AthleteViewController

- (IBAction)actionToggleLeftDrawer:(id)sender {
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}

@end
