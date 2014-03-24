//
//  TrackCoachViewController_iPad.m
//  TrackCoach
//
//  Created by Peter Carnesciali on 3/9/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#import "TrackCoachViewController_iPad.h"

@interface TrackCoachViewController_iPad ()

@end

@implementation TrackCoachViewController_iPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TrackCoachiPadTableViewCell *cell = (TrackCoachiPadTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"LapCell"];
    
    NSNumber *lapTime = self.trackCoachBrain.raceTime.lapTimes[indexPath.row];
    cell.splitLabel.text = [TrackCoachViewController timeToString:[lapTime doubleValue]];
    cell.textLabel.text = [NSString stringWithFormat:@"Lap %lu", (unsigned long)(self.trackCoachBrain.raceTime.lapTimes.count - indexPath.row)];
    cell.detailLabel.text = [TrackCoachViewController timeToString:[self.trackCoachBrain.raceTime totalOfLapAndBelow:indexPath.row]];
    return cell;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
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
