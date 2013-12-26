//
//  TestTimerViewController.h
//  TestTimer
//
//  Created by Peter Carnesciali on 10/12/13.
//  Copyright (c) 2013 Peter Carnesciali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VolumeButtons.h"

@interface TimerAppViewController : UIViewController

//@property (nonatomic) BOOL timerRunning;
//@property (nonatomic) NSTimeInterval lapStartTime;
//@property (nonatomic) NSTimeInterval elapsedTime;
@property (nonatomic) NSTimeInterval secondsAlreadyRun; //If != 0, timer not reset
@property (strong, nonatomic) NSMutableArray *lapTimes;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *lapTimerLabel;
@property (strong, nonatomic) VolumeButtons *volumeButtons;
- (IBAction)startStopButtonAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *startStopButton;
- (IBAction)lapResetButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *lapResetButton;
- (void)updateTime;
- (NSString *)timeToString:(NSTimeInterval)elapsed;
- (NSTimeInterval)totalOfLaps;
@property (strong, nonatomic) NSDate *startDate;
//@property (strong, nonatomic) NSDate *currentLapStartDate;
@property (strong, nonatomic) NSTimer *timer;

@end
