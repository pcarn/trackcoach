//
//  Tutorial1ViewController.h
//  TrackCoach
//
//  Created by Peter Carnesciali on 2/25/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"
#import "TrackCoachUI.h"
#import "TutorialViewController.h"

@interface Tutorial1ViewController : TutorialViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aboveButtonIndicatorsSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *differenceBetweenButtonIndicatorsSpaceConstraint;
@property (weak, nonatomic) IBOutlet UILabel *mainTextTitle;
@property (weak, nonatomic) IBOutlet UITextView *mainTextView;
@property (weak, nonatomic) IBOutlet UILabel *startStopLabel;
@property (weak, nonatomic) IBOutlet UILabel *lapResetLabel;

@end
