//
//  TutorialViewController.m
//  TrackCoach
//
//  Created by Peter Carnesciali on 3/3/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#import "TutorialViewController.h"
#import "Defines.h"

@interface TutorialViewController ()

@end

@implementation TutorialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor colorWithRed:(255.0/255.0) green:(122.0/255.0) blue:(28.0/255.0) alpha:1.0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.mainTextView) {
        self.mainTextView.selectable = YES; // for formatting
        if (IS_IPAD) {
            self.mainTextView.text = [self.mainTextView.text stringByReplacingOccurrencesOfString:@"iPhone" withString:@"iPad"];
        }
        self.mainTextView.selectable = NO; // for formatting
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
