//
//  AppDelegate.h
//  ball-jail-break
//
//  Created by  on 12-7-8.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@property (nonatomic, retain) NSNumber *timeRemains;
@property (nonatomic, retain) NSNumber *currentLevel;

@end
