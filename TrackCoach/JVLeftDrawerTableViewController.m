//
//  JVLeftDrawerTableViewController.m
//  JVFloatingDrawer
//
//  Created by Julian Villella on 2015-01-15.
//  Copyright (c) 2015 JVillella. All rights reserved.
//

#import "JVLeftDrawerTableViewController.h"
#import "JVLeftDrawerTableViewCell.h"
#import "AppDelegate.h"
#import "JVFloatingDrawerViewController.h"

enum {
    trackCoachViewControllerIndex = 0,
    athleteIndex = 1,
    settingsIndex = 2,
    menuCount = 3
};

static const CGFloat kJVTableViewTopInset = 80.0;
static NSString * const kJVDrawerCellReuseIdentifier = @"JVDrawerCellReuseIdentifier";

@interface JVLeftDrawerTableViewController ()

@end

@implementation JVLeftDrawerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake(kJVTableViewTopInset, 0.0, 0.0, 0.0);
    self.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:trackCoachViewControllerIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return menuCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JVLeftDrawerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kJVDrawerCellReuseIdentifier forIndexPath:indexPath];
    
    if (indexPath.row == trackCoachViewControllerIndex) {
        cell.titleText = @"TrackCoach";
        cell.iconImage = [UIImage imageNamed:@"smallTransparent"];
    } else if (indexPath.row == athleteIndex) {
        cell.titleText = @"Athletes";
    } else {
        cell.titleText = @"Settings";
        cell.iconImage = [UIImage imageNamed:@"gear"];
    }
    [cell setBackgroundColor:[UIColor clearColor]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *destinationViewController = nil;

    if (indexPath.row == trackCoachViewControllerIndex) {
        destinationViewController = [[AppDelegate globalDelegate] trackCoachViewController];
    } else if (indexPath.row == athleteIndex) {
        destinationViewController = [[AppDelegate globalDelegate] athleteViewController];
    } else {
        destinationViewController = [[AppDelegate globalDelegate] settingsViewController];
    }
    
    [[[AppDelegate globalDelegate] drawerViewController] setCenterViewController:destinationViewController];
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
