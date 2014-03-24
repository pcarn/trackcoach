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

#pragma mark Button Actions
- (IBAction)shareButtonAction:(id)sender {
    NSMutableString *textToShare = [NSMutableString stringWithFormat:@"Total Time: %@", self.timerLabel.text];
    NSArray *laps = [[[self.trackCoachBrain.raceTime.lapTimes copy] reverseObjectEnumerator] allObjects];
    if (laps.count > 0) {
        [textToShare appendString:@"\n"];
    }
    for (NSNumber *lap in laps) {
        [textToShare appendString:[NSString stringWithFormat:@"\nLap %lu: %@", (unsigned long)[laps indexOfObject:lap]+1, [TrackCoachViewController timeToString:[lap doubleValue]]]];
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


#pragma mark UI Setup for Timer
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
    self.timerLabel.text = [TrackCoachViewController timeToString:[self.trackCoachBrain.raceTime totalOfAllLaps]];
    self.lapTimerLabel.text = [TrackCoachViewController timeToString:[self.trackCoachBrain.raceTime mostRecentLapTime]];
    [self.startStopButton setTitle:@"Undo Stop" forState:UIControlStateNormal];
    [self.startStopButton setBackgroundColor:[UIColor colorWithRed:(255.0/255.0) green:(122.0/255.0) blue:(28.0/255.0) alpha:1.0]];
    [self.lapResetButton setTitle:@"Reset" forState:UIControlStateNormal];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [self.shareButton setEnabled:YES];
    [self.shareButton setAlpha:1.0];
}

- (void)updateUI {
    if (self.trackCoachBrain.timerIsRunning) {
        NSTimeInterval totalElapsed = [self.trackCoachBrain.raceTime elapsed];
        self.timerLabel.text = [TrackCoachViewController timeToString:totalElapsed];
        NSTimeInterval currentLapTime = totalElapsed - [self.trackCoachBrain.raceTime totalOfAllLaps];
        self.lapTimerLabel.text = [TrackCoachViewController timeToString:currentLapTime];
    } else {
        NSTimeInterval totalOfLaps = [self.trackCoachBrain.raceTime totalOfAllLaps];
        self.timerLabel.text = [TrackCoachViewController timeToString:totalOfLaps];
        self.lapTimerLabel.text = [TrackCoachViewController timeToString:[self.trackCoachBrain.raceTime mostRecentLapTime]];
    }
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
    cell.detailTextLabel.text = [TrackCoachViewController timeToString:[lapTime doubleValue]];
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
        NSLog(@"Other alert clicked.");
    }
    self.alertIsDisplayed = NO;
    [self saveSettings];
}

#pragma mark UserDefaults
- (void)saveSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedRaceTime = [NSKeyedArchiver archivedDataWithRootObject:self.trackCoachBrain.raceTime];
    
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
    }
}

#pragma mark AppInfoViewControllerDelegate
- (void)appInfoViewControllerDidCancel:(AppInfoViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Tutorial
- (TutorialViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = ((TutorialViewController *) viewController).pageIndex;
    return nil;
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = ((TutorialViewController *) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    return [self viewControllerAtIndex:index];
}

- (TutorialViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (index == 0) {
        TutorialViewController *tutorial1ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Tutorial1ViewController"];
        tutorial1ViewController.pageIndex = index;
        return tutorial1ViewController;
    } else if (index == 1) {
        TutorialViewController *tutorial2ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Tutorial2ViewController"];
        tutorial2ViewController.pageIndex = index;
        return tutorial2ViewController;
    } else if (index == 2) {
        TutorialViewController *tutorialEnd = [self.storyboard instantiateViewControllerWithIdentifier:@"Tutorial3ViewController"];
        tutorialEnd.pageIndex = index;
        return tutorialEnd;
    } else {
        [UIView animateWithDuration:0.4
                         animations:^{self.pageViewController.view.alpha = 0.2;}
                         completion:^(BOOL finished){[self.pageViewController.view removeFromSuperview];
                                    [self.pageViewController removeFromParentViewController];}];

        self.tutorialIsDisplayed = NO;
        NSLog(@"tried to dismiss");
        return nil;
    }
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return 3;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

#pragma mark Other/Utility methods
+ (NSString *)timeToString:(NSTimeInterval)time {
    int mins = (int)(time / 60.0);
    time -= mins * 60;
    int secs = (int)(time);
    time -= secs;
    int dec = time * 100.0;
    
    return [NSString stringWithFormat:@"%u:%02u.%02u", mins, secs, dec];
}

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
            if (blocksafeSelf.tutorialIsDisplayed) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Start/Stop"
                                                                message:@"This button starts or stops the timer!"
                                                               delegate:blocksafeSelf
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                blocksafeSelf.alertIsDisplayed = YES;
            } else {
                [blocksafeSelf startStopButtonAction:nil];
            }
        }
    };
    self.volumeButtons.volumeDownBlock = ^{
        NSLog(@"Volume Down");
        if (!blocksafeSelf.alertIsDisplayed) {
            if (blocksafeSelf.tutorialIsDisplayed) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lap/Reset"
                                                                message:@"This button laps or resets the timer!"
                                                               delegate:blocksafeSelf
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                blocksafeSelf.alertIsDisplayed = YES;
            } else {
                [blocksafeSelf lapResetButtonAction:nil];
            }
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
        self.tutorialIsDisplayed = YES;
        self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                                  navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                                options:nil];
        self.pageViewController.dataSource = self;
        TutorialViewController *startingViewController = [self viewControllerAtIndex:0];
        [self.pageViewController setViewControllers:@[startingViewController]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO completion:nil];
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self addChildViewController:self.pageViewController];
        [self.view addSubview:self.pageViewController.view];
        [self.pageViewController didMoveToParentViewController:self];
    }
    
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

- (void)dealloc {
    self.volumeButtons = nil;
}





@end
