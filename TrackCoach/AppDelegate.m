//
//  AppDelegate.m
//  TrackCoach
//
//  Created by Peter Carnesciali on 10/16/13.
//  Copyright (c) 2013 Peter Carnesciali. All rights reserved.
//

#import "AppDelegate.h"
#import "TrackCoachUI.h"
#import <Parse/Parse.h>
#import <ParseCrashReporting/ParseCrashReporting.h>

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
    [ParseCrashReporting enable];
    [Parse setApplicationId:@"XvKgdBAVEUAlxwyVXQ4qXv6K99jnurNcuwI9Zdho"
                  clientKey:@"guxvJO4V9seJJR4m9okkC5il8p8n69GOeFBvLGPS"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    UIColor *myOrange = [UIColor colorWithRed:(255.0/255.0) green:(122.0/255.0) blue:(28.0/255.0) alpha:1.0];
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.backgroundColor = myOrange;

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.drawerViewController;
    [self configureDrawerViewController];
    [self.window makeKeyAndVisible];

    // Having an MPVolumeView hides the volume overlay appwide.
    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(-100, -100, 0, 0)];
    [[[UIApplication sharedApplication] windows][0] addSubview:volumeView];

    [self performSelectorInBackground:@selector(setupVolumeButtonsIfNotHidden) withObject:nil];

    return YES;
}

- (void)setupVolumeButtonsIfNotHidden {
    NSArray *hide = [TrackCoachUI getStringsFromSite:@"hide"];
    if (!hide) {
        [self setupVolumeButtons];
    }
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

#pragma mark - Volume Buttons

- (void)setupVolumeButtons {
    self.volumeButtons = [[VolumeButtons alloc] init];
    self.volumeButtons.volumeDownBlock = ^{
        NSLog(@"Volume Down");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"volumeDown"
                                                            object:nil];
    };
    self.volumeButtons.volumeUpBlock = ^{
        NSLog(@"Volume Up");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"volumeUp"
                                                            object:nil];
    };
    [self.volumeButtons startUsingVolumeButtons];
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

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.pcarn.CoreData" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }

    // Create the coordinator and store

    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreData.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
