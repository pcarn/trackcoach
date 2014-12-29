//
//  TrackCoachDefines.h
//  TrackCoach
//
//  Created by Peter Carnesciali on 4/12/14.
//  Copyright (c) 2014 Peter Carnesciali. All rights reserved.
//

#define IS_IPAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

#define IS_3_5_INCH_SIZE ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )

#define IS_4_INCH_SIZE ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define IS_4_7_INCH_SIZE ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )667 ) < DBL_EPSILON )

#define IS_5_5_INCH_SIZE ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )736 ) < DBL_EPSILON )

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define UNDO_STOP_ALERT 7
#define RESET_ALERT 8

#define TUTORIAL_RUN_STRING @"1_0_3_TutorialRun"
