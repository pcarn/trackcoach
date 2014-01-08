//
//  TestTimerViewController.h
//  TestTimer
//
//  Created by Peter Carnesciali on 10/12/13.
//  Copyright (c) 2013 Peter Carnesciali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VolumeButtons.h"

@interface TrackCoachViewController : UIViewController <UITableViewDataSource, UIAlertViewDelegate>

//@property (nonatomic) BOOL timerRunning;
//@property (nonatomic) NSTimeInterval lapStartTime;
//@property (nonatomic) NSTimeInterval elapsedTime;
//@property (nonatomic) NSTimeInterval secondsAlreadyRun; //If != 0, timer not reset
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *lapTimerLabel;
@property (strong, nonatomic) VolumeButtons *volumeButtons;
@property (weak, nonatomic) IBOutlet UIButton *startStopButton;
@property (weak, nonatomic) IBOutlet UIButton *lapResetButton;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSMutableArray *lapTimes;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign) BOOL alertIsDisplayed;

- (IBAction)lapResetButtonAction:(id)sender;
- (IBAction)startStopButtonAction:(UIButton *)sender;
- (void)updateTime;
- (NSString *)timeToString:(NSTimeInterval)elapsed;
- (NSTimeInterval)totalOfLaps;

@end
