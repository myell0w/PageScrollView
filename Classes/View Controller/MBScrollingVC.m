    //
//  MBScrollingVC.m
//  Mercedes
//
//  Created by Matthias Tretter on 28.07.10.
//  Copyright 2010 YellowSoft. All rights reserved.
//

#import "MBScrollingVC.h"


@implementation MBScrollingVC

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Synthesized Properties
///////////////////////////////////////////////////////////////////////////////////////////////////////

@synthesize scrollView  = scrollView_;
@synthesize pageControl = pageControl_;
@synthesize viewControllers = viewControllers_;


///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark View Controller Lifecycle
///////////////////////////////////////////////////////////////////////////////////////////////////////

// the designated initializer
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil viewControllerProvider:(id)provider {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		delegate_ = provider;
		applicationFrame = [[UIScreen mainScreen] applicationFrame];
		
		// view controllers are created lazily
		// in the meantime, load the array with placeholders which will be replaced on demand
		NSMutableArray *controllers = [NSMutableArray arrayWithCapacity:[delegate_ numberOfControllers]];
		
		for (NSUInteger i = 0; i<[delegate_ numberOfControllers]; i++) {
			[controllers addObject:[NSNull null]];
		}
		
		self.viewControllers = controllers;
		
		[self p_initScrollView];
    }
	
    return self;
}

 // The designated initializer of the base class, therefore it is overridden
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil viewControllerProvider:nil];
}

- (void)dealloc {
	RELEASE(viewControllers_);
    RELEASE(scrollView_);
    RELEASE(pageControl_);
	
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.viewControllers = nil;
	self.scrollView = nil;
	self.pageControl = nil;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // support all orientations on iPad, Portrait on iPhone
    return ROTATE_ON_IPAD;
}



///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Action Methods
///////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)loadPage:(NSUInteger)page animated:(BOOL)animated {
	//TODO: implement loading of a specific page with animation
	CGRect frame = self.scrollView.frame;
	frame.origin.x = frame.size.width * page;
	frame.origin.y = 0;
	[self.scrollView scrollRectToVisible:frame animated:animated];
}

- (IBAction)changePage:(id)sender {
	NSLog(@"change page");
    int page = self.pageControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self p_loadScrollViewWithPage:page - 1];
    [self p_loadScrollViewWithPage:page];
    [self p_loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}


///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark ScrollViewDelegate Methods
///////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
	// Switch the indicator when more than 50% of the previous/next page is visible
	CGFloat pageWidth = self.scrollView.frame.size.width;
	int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
    self.pageControl.currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self p_loadScrollViewWithPage:page - 1];
    [self p_loadScrollViewWithPage:page];
    [self p_loadScrollViewWithPage:page + 1];
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}


///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private Methods
///////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)p_deviceDidRotate:(NSNotification *)notification {
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	
	// save the page and restore it after the rotation
	pageBeforeRotation = self.pageControl.currentPage;
	
	[self p_resizeScrollViewForOrientation:orientation];
}

- (CGRect)p_framePosition:(CGRect)frame forPage:(int)page {
	// Calculate frame position
	frame.origin.x = frame.size.width * page;
	frame.origin.y = 0;
	
	return frame;
}

- (void)p_resizeScrollViewForOrientation:(UIInterfaceOrientation)orientation {
	// only resize Scrollview for Landscape on iPad
	if ([[UIDevice currentDevice] isIPad] && UIInterfaceOrientationIsLandscape(orientation)) {
		[self p_resizeScrollViewForLandscape];
	} else {
		[self p_resizeScrollViewForPortrait];
	}
}

- (void)p_resizeScrollViewForPortrait {
	self.scrollView.frame = CGRectMake(applicationFrame.origin.x, applicationFrame.origin.y,
									   applicationFrame.size.width, applicationFrame.size.height);
	
	self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.viewControllers.count,
                                             self.scrollView.frame.size.height);
	
	[self p_repositionSubViews];
}

- (void)p_resizeScrollViewForLandscape {
	self.scrollView.frame = CGRectMake(applicationFrame.origin.y, applicationFrame.origin.x,
									   applicationFrame.size.height, applicationFrame.size.width);
	
	self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.viewControllers.count,
											 self.scrollView.frame.size.height);
	
	[self p_repositionSubViews];
}

- (void)p_repositionSubViews {
	self.pageControl.center = CGPointMake(applicationFrame.size.width / 2, 30.0);
	
	// Reposition all loaded frames
	for (int i = 0; i < [self.viewControllers count]; i++) {
		UIViewController* vc = [self.viewControllers objectAtIndex:i];
		
        if((NSNull *)vc != [NSNull null]) {
			// Calculate the position of the frame depending on orientation
			vc.view.frame = [self p_framePosition:vc.view.frame forPage:i];
		}
    }
	
	// Move the scrollview viewport to the location the user was on before the resize
	//if(pageBeforeRotation >= 0) {
//		if([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft) {
//			self.scrollView.contentOffset = CGPointMake(0, (6-pageBeforeRotation)*self.scrollView.frame.size.height);
//		} else if([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight) {
//			self.scrollView.contentOffset = CGPointMake(0, pageBeforeRotation*self.scrollView.frame.size.height);
//		} else {
			self.scrollView.contentOffset = CGPointMake(pageBeforeRotation*self.scrollView.frame.size.width, 0);
//		}
//	}
}

- (void)p_initScrollView {
    // init scrollview
	self.scrollView = [[[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
    self.scrollView.pagingEnabled = YES;
	[self p_resizeScrollViewForOrientation:[[UIDevice currentDevice] orientation]];
	
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
	self.scrollView.backgroundColor = [UIColor blueColor];
	[self.view addSubview:self.scrollView];
    
    // init pageControl
	self.pageControl = [[[UIPageControl alloc] initWithFrame:CGRectZero] autorelease];
	self.pageControl.center = CGPointMake(self.scrollView.frame.size.width / 2, 30.0);
	self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	self.pageControl.contentMode = UIViewContentModeScaleToFill;
    self.pageControl.numberOfPages = self.viewControllers.count;
    self.pageControl.currentPage = 0;
	[self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:self.pageControl];
	
    
    // load the visible page - pages are created on demand
    [self p_loadScrollViewWithPage:0];
    // load the page on either side to avoid flashes when the user starts scrolling
    [self p_loadScrollViewWithPage:1];
}

- (void)p_loadScrollViewWithPage:(int)page {
    if (page < 0 || page >= self.viewControllers.count) {
        return;
    }
    
    // replace the placeholder if necessary
    UIViewController *controller = [self.viewControllers objectAtIndex:page];
    
    if ((NSNull *)controller == [NSNull null]) {
		controller = [delegate_ viewControllerForPage:page];
        [self.viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil) {
		// Position the new frame depending on the interface orientation
		controller.view.frame = [self p_framePosition:self.scrollView.frame forPage:page];
        
        [self.scrollView addSubview:controller.view];
    }
}


@end
