//
//  Tutorial1ViewController.m
//  TrackCoach
//
//  Created by Peter Carnesciali on 2/25/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#import "Tutorial1ViewController.h"

@interface Tutorial1ViewController ()

@end

@implementation Tutorial1ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.pageIndex = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.pageIndex = 1;
    if (!IS_IPHONE_5_SIZE) {
        NSLog(@"not iphone 5");
        self.aboveStartSpaceConstraint.constant = 5;
        self.differenceSpaceConstraint.constant = 35;
        self.titleTopSpaceConstraint.constant = 120;
        self.centerTitleConstraint.constant = 25;
        self.aboveLogoTopContraint.constant = -17;
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
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
