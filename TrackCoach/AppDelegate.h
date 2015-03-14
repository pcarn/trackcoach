//
//  AppDelegate.h
//  TrackCoach
//
//  Created by Peter Carnesciali on 10/16/13.
//  Copyright (c) 2013 Peter Carnesciali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VolumeButtons.h"

@class JVFloatingDrawerViewController;
@class JVFloatingDrawerSpringAnimator;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) JVFloatingDrawerViewController *drawerViewController;
@property (nonatomic, strong) JVFloatingDrawerSpringAnimator *drawerAnimator;
@property (nonatomic, strong) UITableViewController *leftDrawerViewController;
@property (nonatomic, strong) UIViewController *trackCoachViewController;
@property (nonatomic, strong) UIViewController *settingsViewController;

@property (strong, nonatomic) VolumeButtons *volumeButtons;

@property BOOL hideVolumeButtons;

+ (AppDelegate *)globalDelegate;

- (void)toggleLeftDrawer:(id)sender animated:(BOOL)animated;

@end
