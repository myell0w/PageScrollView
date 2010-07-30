    //
//  MBScrollingVC.m
//  Mercedes
//
//  Created by Matthias Tretter on 28.07.10.
//  Copyright 2010 YellowSoft. All rights reserved.
//

#import "MBPageScrollVC.h"
#import "AppDelegate.h"


@implementation MBPageScrollVC

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Synthesized Properties
///////////////////////////////////////////////////////////////////////////////////////////////////////

@synthesize pageScrollView  = pageScrollView_;


///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark View Controller Lifecycle
///////////////////////////////////////////////////////////////////////////////////////////////////////

// the designated initializer
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		pageScrollView_ = [[MBPageScrollView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] 
													   dataSource:MBApplicationDelegate
														 delegate:MBApplicationDelegate];
		
		[self.view addSubview:self.pageScrollView];
    }
	
    return self;
}

- (void)dealloc {
	RELEASE(pageScrollView_);
	
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.pageScrollView = nil;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
	[self.pageScrollView releaseCachedController];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Rotation
///////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // support all orientations on iPad, Portrait on iPhone
    return ROTATE_ON_IPAD;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	// call willRotate for all created view controllers
	for (id vc in self.pageScrollView.viewControllers) {
		if ((NSNull *)vc != [NSNull null]) {
			[vc willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
		}
	}
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	
	[self.pageScrollView deviceDidRotate];
	
	// call didRotate for all created view controllers
	for (id vc in self.pageScrollView.viewControllers) {
		if ((NSNull *)vc != [NSNull null]) {
			[vc didRotateFromInterfaceOrientation:fromInterfaceOrientation];
		}
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Action Methods
///////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)loadPage:(NSUInteger)page animated:(BOOL)animated {
	[self.pageScrollView loadPage:page animated:animated];
}

@end
