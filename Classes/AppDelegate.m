//
//  AppDelegate.m
//  Mercedes
//
//  Created by Matthias Tretter on 27.07.10.
//  Copyright (c) 2010 m.yellow. All rights reserved.
//

#import "AppDelegate.h"
#import "MyViewController.h"
#import "MBSectionVC.h"
#import "MBSectionDelegate.h"
#import "MBNavigationController.h"
#import "MBOverviewSectionDelegate.h"



///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Globals
///////////////////////////////////////////////////////////////////////////////////////////////////////

static NSUInteger kNumberOfPages = 5;



@implementation AppDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Synthesized Properties
///////////////////////////////////////////////////////////////////////////////////////////////////////

@synthesize window;
@synthesize rootVC = rootVC_;
@synthesize sectionDelegates = sectionDelegates_;


///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Application Lifecycle
///////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)dealloc {
    RELEASE(window);
	RELEASE(rootVC_);
	RELEASE(sectionDelegates_);
            
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	// init application delegates
	sectionDelegates_ = [[NSMutableArray alloc] init];
	// create scrolling ViewController
	self.rootVC = [[[MBPageScrollVC alloc] initWithNibName:nil bundle:nil] autorelease];
	
	// add scrolling view to window
	[window addSubview:self.rootVC.view];
	[window makeKeyAndVisible];
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Methods
///////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)loadPage:(NSUInteger)page animated:(BOOL)animated {
	[self.rootVC loadPage:page animated:animated];
}

- (NSUInteger)currentPage {
	return self.rootVC.pageScrollView.pageControl.currentPage;
}

- (void)setScrollEnabled:(BOOL)enabled {
	self.rootVC.pageScrollView.scrollView.scrollEnabled = enabled;
	self.rootVC.pageScrollView.pageControl.hidden = !enabled;
}

- (BOOL)scrollEnabled {
	return self.rootVC.pageScrollView.scrollView.scrollEnabled;
}


///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark MBPageScrollViewDataSource-Protocol Methods
///////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSUInteger)numberOfPages {
	return kNumberOfPages;
}

- (UIViewController *)viewControllerForPage:(NSUInteger)page {
	MBSectionVC *vc;
	MBSectionDelegate *delegate;
	
	switch (page) {
		case 0:
        case 1:
			vc = [[[MBSectionVC alloc] initWithNibName:nil bundle:nil backgroundImageName:@"Home"] autorelease];
			delegate = [[[MBOverviewSectionDelegate alloc] initWithViewController:vc 
																	   cellTitles:[NSArray arrayWithObjects:MBLocalize(@"Push1"), MBLocalize(@"Push2"), nil]] autorelease];
			vc.delegate = delegate;
			[self.sectionDelegates addObject:delegate];
			break;
																									
		default:
			vc = [[[MyViewController alloc] initWithPageNumber:page] autorelease];
			break;
	}
	
    
	//UINavigationController *nc = [[[MBNavigationController alloc] initWithRootViewController:vc] autorelease];
	//nc.delegate = self;
	//return nc;
    
    return vc;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark MBPageScrollViewDelegate-Protocol Methods
///////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)didScrollToPage:(int)page {
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UINavigationControllerDelegate-Protocol Methods
///////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)navigationController:(UINavigationController *)navigationController 
	  willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	// did it return to the first level?
	if ([viewController isKindOfClass:[MBSectionVC class]]) {
		self.scrollEnabled = YES;
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private Methods
///////////////////////////////////////////////////////////////////////////////////////////////////////



@end
