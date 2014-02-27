//
//  FirstTimeViewController.h
//  TrackCoach
//
//  Created by Peter Carnesciali on 2/25/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#import <UIKit/UIKit.h>
#define IS_IPHONE_5_SIZE ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


@interface FirstTimeViewController : UIViewController

@property NSUInteger pageIndex;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aboveStartSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *differenceSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTopSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerTitleConstraint;
@end
