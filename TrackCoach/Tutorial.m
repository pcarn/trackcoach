//
//  Tutorial.m
//  TrackCoach
//
//  Created by Peter Carnesciali on 1/25/15.
//  Copyright (c) 2015 Peter Carnesciali. All rights reserved.
//

#import "Tutorial.h"
#import "TutorialViewController.h"
#import "Defines.h"

@implementation Tutorial


- (UIPageViewController *)runTutorialIfNeeded {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:TUTORIAL_RUN_STRING] || ![defaults boolForKey:TUTORIAL_RUN_STRING]) {
        // Doesn't exist, or false
        NSLog(@"Running tutorial");
        UIPageViewController *pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                                                   navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                                                 options:nil];
        pageViewController.dataSource = self;
        TutorialViewController *startingViewController = [self viewControllerAtIndex:0];
        [pageViewController setViewControllers:@[startingViewController]
                                     direction:UIPageViewControllerNavigationDirectionForward
                                      animated:NO completion:nil];
        return pageViewController;
    } else {
        return nil;
    }
}

- (TutorialViewController *)pageViewController:(UIPageViewController *)pageViewController
            viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = ((TutorialViewController *) viewController).pageIndex;
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    } else {
        index--;
        return [self viewControllerAtIndex:index];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = ((TutorialViewController *) viewController).pageIndex;

    if (index == NSNotFound) {
        return nil;
    } else {
        index++;
        return [self viewControllerAtIndex:index];
    }
}

- (TutorialViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (index == 0) {
        TutorialViewController *tutorial1ViewController = [[TutorialViewController alloc] initWithNibName:@"Tutorial1" bundle:nil];
        tutorial1ViewController.pageIndex = index;
        return tutorial1ViewController;
    } else if (index == 1) {
        TutorialViewController *tutorial2ViewController = [[TutorialViewController alloc] initWithNibName:@"Tutorial2" bundle:nil];
        tutorial2ViewController.pageIndex = index;
        return tutorial2ViewController;
    } else if (index == 2) {
        TutorialViewController *tutorial3ViewController = [[TutorialViewController alloc] initWithNibName:@"Tutorial3" bundle:nil];
        tutorial3ViewController.pageIndex = index;
        return tutorial3ViewController;
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:TUTORIAL_RUN_STRING];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"Dismissed tutorial");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissTutorial" object:nil];
        return nil;
    }
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return 3;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

@end
