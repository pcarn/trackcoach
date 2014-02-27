//
//  TestTimerViewController.m
//  TestTimer
//
//  Created by Peter Carnesciali on 10/12/13.
//  Copyright (c) 2013 Peter Carnesciali. All rights reserved.
//

#import "TrackCoachViewController.h"
#import "AVFoundation/AVFoundation.h"
#import "MediaPlayer/MediaPlayer.h"


@interface TrackCoachViewController()
@end

@implementation TrackCoachViewController

- (TrackCoachBrain *)trackCoachBrain {
    if (!_trackCoachBrain) {
        _trackCoachBrain = [[TrackCoachBrain alloc] init];
    }
    return _trackCoachBrain;
}

- (IBAction)shareButtonAction:(id)sender {
    NSMutableString *textToShare = [NSMutableString stringWithFormat:@"Total Time: %@", self.timerLabel.text];
    NSArray *laps = [[[self.trackCoachBrain.raceTime.lapTimes copy] reverseObjectEnumerator] allObjects];
    if (laps.count > 0) {
        [textToShare appendString:@"\n"];
    }
    for (NSNumber *lap in laps) {
        [textToShare appendString:[NSString stringWithFormat:@"\nLap %lu: %@", (unsigned long)[laps indexOfObject:lap]+1, [self timeToString:[lap doubleValue]]]];
    }
    [textToShare appendString:[NSString stringWithFormat:@"\n\nTimed by TrackCoach for %@", ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? @"iPad" : @"iPhone")]];
//    [textToShare appendString:@"\nwww.trackcoachapp.com"];
    
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[textToShare] applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    if (iOS_7_or_later) {
        activityVC.excludedActivityTypes = [activityVC.excludedActivityTypes arrayByAddingObjectsFromArray:@[UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo, UIActivityTypeAirDrop]];
    }
    
    [self presentViewController:activityVC animated:YES completion:nil];
}

//sender is button either way
- (IBAction)startStopButtonAction:(id)sender {
    if (!self.trackCoachBrain.timerIsRunning) {
        if (self.trackCoachBrain.raceTime.lapTimes.count == 0) { // Start
            [self.trackCoachBrain start];
            [self setupForTimerRunning];
        } else { // Undo Stop
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Undo Stop?"
                                                            message:@"Are you sure you want to undo? The time will resume as though you did not stop."
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Undo Stop", nil];
            alert.tag = UNDO_STOP_ALERT;
            [alert show];
            self.alertIsDisplayed = YES;
        }
    } else { // Stop
        NSLog(@"%f",[self.trackCoachBrain.raceTime elapsed]);
        [self.trackCoachBrain stop];
        [self.timer invalidate];
        self.timer = nil;
        [self.tableView reloadData];
        [self setupForTimerStopped];
        
    }
    [self saveSettings];
}


//sender is nil if triggered by volume button
- (IBAction)lapResetButtonAction:(id)sender {
//    [self.trackCoachBrain lapResetButtonPressed];
    if (self.trackCoachBrain.timerIsRunning) { // Just lapped
        [self.trackCoachBrain lap];
    } else if (self.trackCoachBrain.raceTime.lapTimes.count > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reset"
                                                        message:@"Are you sure you want to reset?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Reset", nil];
        alert.tag = RESET_ALERT;
        [alert show];
        self.alertIsDisplayed = YES;
        
    }
    [self.tableView reloadData];
    [self saveSettings];
}

- (void)setupForTimerRunning {
    [self startNSTimer];
    [self.startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
    [self.startStopButton setBackgroundColor:[UIColor redColor]];
    [self.lapResetButton setTitle:@"Lap" forState:UIControlStateNormal];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [self.shareButton setEnabled:NO];
    [self.shareButton setAlpha:0.2];
}

- (void)setupForTimerStopped {
    self.timerLabel.text = [self timeToString:[self.trackCoachBrain.raceTime totalOfLaps]];
    self.lapTimerLabel.text = [self timeToString:[self.trackCoachBrain.raceTime mostRecentLapTime]];
    [self.startStopButton setTitle:@"Undo Stop" forState:UIControlStateNormal];
    [self.startStopButton setBackgroundColor:[UIColor colorWithRed:(255.0/255.0) green:(122.0/255.0) blue:(28.0/255.0) alpha:1.0]];
    [self.lapResetButton setTitle:@"Reset" forState:UIControlStateNormal];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [self.shareButton setEnabled:YES];
    [self.shareButton setAlpha:1.0];
}

- (void)updateUI {
//    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.trackCoachBrain.timerIsRunning) {
            NSTimeInterval totalElapsed = [self.trackCoachBrain.raceTime elapsed];
            self.timerLabel.text = [self timeToString:totalElapsed];
            NSTimeInterval currentLapTime = totalElapsed - [self.trackCoachBrain.raceTime totalOfLaps];
            self.lapTimerLabel.text = [self timeToString:currentLapTime];
        } else {
            NSTimeInterval totalOfLaps = [self.trackCoachBrain.raceTime totalOfLaps];
            self.timerLabel.text = [self timeToString:totalOfLaps];
            self.lapTimerLabel.text = [self timeToString:[self.trackCoachBrain.raceTime mostRecentLapTime]];
        }
//    });
}

#pragma mark Utility methods
- (NSString *)timeToString:(NSTimeInterval)time {
    int mins = (int)(time / 60.0);
    time -= mins * 60;
    int secs = (int)(time);
    time -= secs;
    int dec = time * 100.0;
    
    return [NSString stringWithFormat:@"%u:%02u.%02u", mins, secs, dec];
}

#pragma mark TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.trackCoachBrain.raceTime.lapTimes count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LapCell"];
    
    NSNumber *lapTime = self.trackCoachBrain.raceTime.lapTimes[indexPath.row];
    cell.detailTextLabel.text = [self timeToString:[lapTime doubleValue]];
    cell.textLabel.text = [NSString stringWithFormat:@"Lap %lu", (unsigned long)(self.trackCoachBrain.raceTime.lapTimes.count - indexPath.row)];
    return cell;
}

#pragma mark AlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == RESET_ALERT) {
        if (buttonIndex == 1) {
            [self.trackCoachBrain reset];
            [self updateUI];
            [self.tableView reloadData];
            [self.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
            [self.startStopButton setBackgroundColor:[UIColor greenColor]];
            [self.shareButton setEnabled:NO];
            [self.shareButton setAlpha:0.2];
        }
    } else if (alertView.tag == UNDO_STOP_ALERT) {
        if (buttonIndex == 1) {
            [self.trackCoachBrain undoStop];
            [self setupForTimerRunning];
            [self.tableView reloadData];
        }
    } else {
        NSLog(@"Unknown alert clicked.");
    }
    self.alertIsDisplayed = NO;
    [self saveSettings];
}

#pragma mark other methods for file
- (void)startNSTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(1.0 / 100.0)
                                                  target:self
                                                selector:@selector(updateUI)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.timer = nil;
    self.tableView.dataSource = self;
    self.volumeButtons = [[VolumeButtons alloc] init];
    __block TrackCoachViewController *blocksafeSelf = self;
    self.volumeButtons.volumeUpBlock = ^{
        NSLog(@"Volume Up");
        if (!blocksafeSelf.alertIsDisplayed) {
            [blocksafeSelf startStopButtonAction:nil];
        }
    };
    self.volumeButtons.volumeDownBlock = ^{
        NSLog(@"Volume Down");
        if (!blocksafeSelf.alertIsDisplayed) {
            [blocksafeSelf lapResetButtonAction:nil];
        }
    };
    [self.volumeButtons startUsingVolumeButtons];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *bundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
//    NSString *appFirstStartOfVersionKey = [NSString stringWithFormat:@"first_start_%@", bundleVersion];
//    NSNumber *alreadyStartedOnVersion = [defaults objectForKey:appFirstStartOfVersionKey];
    
    if (![defaults boolForKey:@"TutorialRun"] || [defaults boolForKey:@"TutorialRun"] == NO) {
        NSLog(@"First time!");
        [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"TutorialRun"];
    }
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    FirstTimeViewController *startingViewController = [self viewControllerAtIndex:0];
    [self.pageViewController setViewControllers:@[startingViewController]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO completion:nil];
//    [self presentViewController:self.pageViewController animated:YES completion:nil];
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    
    
    
    self.trackCoachBrain.timerIsRunning = [defaults boolForKey:@"timerIsRunning"];
    NSData *encodedRaceTime = [defaults objectForKey:@"encodedRaceTime"];
    if (encodedRaceTime) {
        self.trackCoachBrain.raceTime = [NSKeyedUnarchiver unarchiveObjectWithData:encodedRaceTime];
    }
    if (self.trackCoachBrain.timerIsRunning) {
        [self setupForTimerRunning];
    } else if (self.trackCoachBrain.raceTime.startDate) {  // Stopped
        [self setupForTimerStopped];
    } else {    // Clear
        [self.shareButton setEnabled:NO];
        [self.shareButton setAlpha:0.2];
    }
    [self updateUI];
    [self.tableView reloadData];
}

//- (void)viewDidAppear:(BOOL)animated {
//    [self performSegueWithIdentifier:@"PageViewController" sender:self];
//}

- (void)dealloc {
    self.volumeButtons = nil;
}

#pragma mark UserDefaults
- (void)saveSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSData *raceTime = self.trackCoachBrain.raceTime;
    NSData *encodedRaceTime = [NSKeyedArchiver archivedDataWithRootObject:self.trackCoachBrain.raceTime];
    
//    [defaults setBool:NO forKey:@"timerIsRunning"];
    [defaults setBool:self.trackCoachBrain.timerIsRunning forKey:@"timerIsRunning"];
    [defaults setObject:encodedRaceTime forKey:@"encodedRaceTime"];
    [defaults synchronize];
    NSLog(@"Data saved");
}


#pragma mark Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AppInfo"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        AppInfoViewController *appInfoVC = [navigationController viewControllers][0];
        appInfoVC.delegate = self;
//        AppInfoViewController *appInfoViewController = segue.destinationViewController;
//        appInfoViewController.delegate = self;
//    } else if ([segue.identifier isEqualToString:@"FirstTime"]) {
//        UINavigationController *navigationController = segue.destinationViewController;
//        FirstTimeViewController *firstTimeVC = [navigationController viewControllers][0];
    }
}

#pragma mark AppInfoViewControllerDelegate

- (void)appInfoViewControllerDidCancel:(AppInfoViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Tutorial

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = ((FirstTimeViewController *) viewController).pageIndex;
    return nil;
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = ((FirstTimeViewController *) viewController).pageIndex;
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    return [self viewControllerAtIndex:index];
}

- (FirstTimeViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (index == 1) {
        FirstTimeViewController *firstTime = [[FirstTimeViewController alloc] init];
        firstTime.view.backgroundColor = [UIColor colorWithRed:(255.0/255.0) green:(122.0/255.0) blue:(28.0/255.0) alpha:1.0];
        firstTime.pageIndex = index;
        return firstTime;
    }
    if (index == 2) {
        [self.pageViewController.view removeFromSuperview];
        [self.pageViewController removeFromParentViewController];
        NSLog(@"tried to dismiss");
    }
    FirstTimeViewController *firstTimeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FirstTimeViewController"];
    firstTimeViewController.pageIndex = index;
    return firstTimeViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return 1;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}



@end
