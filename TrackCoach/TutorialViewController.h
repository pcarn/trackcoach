//
//  TutorialViewController.h
//  TrackCoach
//
//  Created by Peter Carnesciali on 3/3/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialViewController : UIViewController

@property NSUInteger pageIndex;
@property (weak, nonatomic) IBOutlet UITextView *mainTextView;

@end
