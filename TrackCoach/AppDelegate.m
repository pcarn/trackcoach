//
//  AppDelegate.m
//  TrackCoach
//
//  Created by Peter Carnesciali on 10/16/13.
//  Copyright (c) 2017 Peter Carnesciali. All rights reserved.
//

#import "AppDelegate.h"
#import "TrackCoachUI.h"

#import "JVFloatingDrawerViewController.h"
#import "JVFloatingDrawerSpringAnimator.h"

static NSString * const kJVStoryboardName = @"Main";

static NSString * const kJVLeftDrawerStoryboardID = @"JVLeftDrawerViewControllerStoryboardID";
static NSString * const trackCoachViewControllerStoryboardID = @"TrackCoachViewControllerStoryboardID";
static NSString * const settingsViewControllerStoryboardID = @"SettingsViewControllerStoryboardID";

@interface AppDelegate ()

@property (nonatomic, strong, readonly) UIStoryboard *storyboard;

@end

@implementation AppDelegate

@synthesize storyboard = _storyboard;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSURL *defaultPrefsFile = [[NSBundle mainBundle] URLForResource:@"DefaultPreferences" withExtension:@"plist"];
    NSDictionary *defaultPrefs = [NSDictionary dictionaryWithContentsOfURL:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];

    UIColor *myOrange = [UIColor colorWithRed:(255.0/255.0) green:(122.0/255.0) blue:(28.0/255.0) alpha:1.0];
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.backgroundColor = myOrange;

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.drawerViewController;
    [self configureDrawerViewController];
    [self.window makeKeyAndVisible];

    return YES;
}

#pragma mark - Drawer View Controllers

- (JVFloatingDrawerViewController *)drawerViewController {
    if (!_drawerViewController) {
        _drawerViewController = [[JVFloatingDrawerViewController alloc] init];
    }

    return _drawerViewController;
}

#pragma mark Sides

- (UITableViewController *)leftDrawerViewController {
    if (!_leftDrawerViewController) {
        _leftDrawerViewController = [self.storyboard instantiateViewControllerWithIdentifier:kJVLeftDrawerStoryboardID];
    }

    return _leftDrawerViewController;
}

#pragma mark Center

- (UIViewController *)trackCoachViewController {
    if (!_trackCoachViewController) {
        _trackCoachViewController = [self.storyboard instantiateViewControllerWithIdentifier:trackCoachViewControllerStoryboardID];
    }

    return _trackCoachViewController;
}

- (UIViewController *)settingsViewController {
    if (!_settingsViewController) {
        _settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:settingsViewControllerStoryboardID];
    }

    return _settingsViewController;
}

- (JVFloatingDrawerSpringAnimator *)drawerAnimator {
    if (!_drawerAnimator) {
        _drawerAnimator = [[JVFloatingDrawerSpringAnimator alloc] init];
    }
    
    return _drawerAnimator;
}

- (UIStoryboard *)storyboard {
    if(!_storyboard) {
        _storyboard = [UIStoryboard storyboardWithName:kJVStoryboardName bundle:nil];
    }
    
    return _storyboard;
}

- (void)configureDrawerViewController {
    self.drawerViewController.leftViewController = self.leftDrawerViewController;
    self.drawerViewController.centerViewController = self.trackCoachViewController;
    
    self.drawerViewController.animator = self.drawerAnimator;
    
    self.drawerViewController.backgroundImage = [UIImage imageNamed:@"track"];

    self.drawerAnimator.animationDuration = 0.5;
    self.drawerAnimator.animationDelay = 0.0;
    self.drawerAnimator.initialSpringVelocity = 9.0;
    self.drawerAnimator.springDamping = 1.0;
}

#pragma mark - Global Access Helper

+ (AppDelegate *)globalDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)toggleLeftDrawer:(id)sender animated:(BOOL)animated {
    [self.drawerViewController toggleDrawerWithSide:JVFloatingDrawerSideLeft animated:animated completion:nil];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

    [self stopNSTimerIfRunning];
    [self saveSettings];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    [self stopNSTimerIfRunning];
    [self saveSettings];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

    [self startNSTimerIfSuspended];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    [self startNSTimerIfSuspended];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

    [self stopNSTimerIfRunning];
    [self saveSettings];
}

- (void)startNSTimerIfSuspended {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startNSTimerIfSuspended" object:self];
}

- (void)stopNSTimerIfRunning {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopNSTimerIfRunning" object:self];
}

- (void)saveSettings {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"saveSettings" object:self];
}

@end
