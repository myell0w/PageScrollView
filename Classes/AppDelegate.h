//
//  AppDelegate.h
//  Mercedes
//
//  Created by Matthias Tretter on 27.07.10.
//  Copyright (c) 2010 m.yellow. All rights reserved.
//


#define MBApplicationDelegate ((AppDelegate*)[[UIApplication sharedApplication] delegate])

CGRect MBApplicationFrame();

#import <UIKit/UIKit.h>
#import "MBPageScrollVC.h"
#import "MBPageScrollView.h"

@interface AppDelegate : NSObject <UIApplicationDelegate, MBPageScrollViewDataSource, MBPageScrollViewDelegate, UINavigationControllerDelegate> {
	// The Main Window
	UIWindow *window;
	// The Scrolling ViewController
	MBPageScrollVC *rootVC_;
	
	// The Delegates of the Sections
	NSMutableArray *sectionDelegates_;
}

// Properties
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MBPageScrollVC *rootVC;
@property (nonatomic, retain) NSMutableArray *sectionDelegates;

@property BOOL scrollEnabled;

// Methods
- (void)loadPage:(NSUInteger)page animated:(BOOL)animated;
- (NSUInteger)currentPage;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Class Extension for Private Methods
///////////////////////////////////////////////////////////////////////////////////////////////////////

@interface AppDelegate ()
@end