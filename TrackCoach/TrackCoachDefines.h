//
//  TrackCoachDefines.h
//  TrackCoach
//
//  Created by Peter Carnesciali on 4/12/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#define IS_IPAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

#define IS_IPHONE_5_SIZE ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define IOS_7_OR_LATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

enum raceEvents {m100, m200, m400, m800, m1500, m1600, m3200, m5000, m10000,
                 m100hurdles, m110hurdles, m300hurdles, m400hurdles, steepleChase, other};

#define TUTORIAL_RUN_STRING @"1_0_3_TutorialRun"
