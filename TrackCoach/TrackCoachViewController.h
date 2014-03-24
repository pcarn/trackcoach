//
//  TestTimerViewController.h
//  TestTimer
//
//  Created by Peter Carnesciali on 10/12/13.
//  Copyright (c) 2013 Peter Carnesciali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackCoachBrain.h"
#import "AppInfoViewController.h"
#import "TutorialViewController.h"
#import "Tutorial1ViewController.h"
#import "Tutorial2ViewController.h"

#define iOS_7_or_later SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface TrackCoachViewController : UIViewController <UITableViewDataSource, UIAlertViewDelegate, AppInfoViewControllerDelegate, UIPageViewControllerDataSource>

@property (assign) BOOL alertIsDisplayed;
@property (assign) BOOL tutorialIsDisplayed;
@property (strong, nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIButton *lapResetButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *startStopButton;
@property (weak, nonatomic) IBOutlet UILabel *lapTimerLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) TrackCoachBrain *trackCoachBrain;
@property (strong, nonatomic) VolumeButtons *volumeButtons;
@property (strong, nonatomic) UIPageViewController *pageViewController;

- (IBAction)lapResetButtonAction:(id)sender;
- (IBAction)startStopButtonAction:(id)sender;
- (IBAction)shareButtonAction:(id)sender;
- (void)updateUI;

+ (NSString *)timeToString:(NSTimeInterval)time;
@end
