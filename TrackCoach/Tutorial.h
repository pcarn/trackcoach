//
//  Tutorial.h
//  TrackCoach
//
//  Created by Peter Carnesciali on 1/25/15.
//  Copyright (c) 2015 Peter Carnesciali. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tutorial : NSObject <UIPageViewControllerDataSource>

- (UIPageViewController *)runTutorial;

@end
