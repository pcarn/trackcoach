//
//  Tutorial1ViewController.h
//  TrackCoach
//
//  Created by Peter Carnesciali on 2/25/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TutorialViewController.h"
#define IS_IPHONE_5_SIZE ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


@interface Tutorial1ViewController : TutorialViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aboveButtonIndicatorsSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *differenceBetweenButtonIndicatorsSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTopSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerSubtitleVerticalOffsetConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aboveLogoTopContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *betweenSubtitleAndMainTextSpaceConstraint;
@property (weak, nonatomic) IBOutlet UILabel *mainTextTitle;
@property (weak, nonatomic) IBOutlet UITextView *mainTextView;

@end
