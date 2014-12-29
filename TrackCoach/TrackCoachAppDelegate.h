//
//  TrackCoachAppDelegate.h
//  TrackCoach
//
//  Created by Peter Carnesciali on 10/16/13.
//  Copyright (c) 2013 Peter Carnesciali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackCoachViewController.h"

@interface TrackCoachAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) IBOutlet TrackCoachViewController *viewController;

@end
