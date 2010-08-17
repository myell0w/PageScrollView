//
//  MBPageScrollView.m
//  Mercedes
//
//  Created by Matthias Tretter on 28.07.10.
//  Copyright 2010 YellowSoft. All rights reserved.
//

#import "MBPageScrollView.h"
#import "AppDelegate.h"


@implementation MBPageScrollView

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Synthesized Properties
///////////////////////////////////////////////////////////////////////////////////////////////////////

@synthesize scrollView  = scrollView_;
@synthesize pageControl = pageControl_;
@synthesize viewControllers = viewControllers_;


///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark View Lifecycle
///////////////////////////////////////////////////////////////////////////////////////////////////////

- (id)initWithFrame:(CGRect)frame dataSource:(id<MBPageScrollViewDataSource>)dataSource delegate:(id<MBPageScrollViewDelegate>)delegate {
	if ((self = [super initWithFrame:frame])) {
        dataSource_ = dataSource;
		delegate_ = delegate;
		viewFrame_ = frame;
		isRotating_ = pageControlUsed_ = NO;
		
		// view controllers are created lazily
		// in the meantime, load the array with placeholders which will be replaced on demand
		viewControllers_ = [[NSMutableArray alloc] initWithCapacity:[dataSource_ numberOfPages]];
		
		for (NSUInteger i = 0; i<[dataSource_ numberOfPages]; i++) {
			[viewControllers_ addObject:[NSNull null]];
		}
		
		[self p_initScrollView];
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.contentMode = UIViewContentModeScaleToFill;
    }
	
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame dataSource:MBApplicationDelegate delegate:MBApplicationDelegate];
}

- (void)releaseCachedController {
	// Calculate the current page in scroll view
	int currentPage = self.pageControl.currentPage;
	
	// unload the pages which are no longer visible
	for (int i = 0; i < [self.viewControllers count]; i++) {
		UIViewController *viewController = [self.viewControllers objectAtIndex:i];
		
		if((NSNull *)viewController != [NSNull null]) {
			if(i < currentPage-1 || i > currentPage+1) {
				[viewController.view removeFromSuperview];
				[self.viewControllers replaceObjectAtIndex:i withObject:[NSNull null]];
			}
		}
	}
}

- (void)dealloc {
	RELEASE(viewControllers_);
    RELEASE(scrollView_);
    RELEASE(pageControl_);
	
    [super dealloc];
}
///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Action Methods
///////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)loadPage:(NSUInteger)page animated:(BOOL)animated {
	CGRect frame = self.scrollView.frame;
	frame.origin.x = frame.size.width * page;
	frame.origin.y = 0;
	
	[self.scrollView scrollRectToVisible:frame animated:animated];
}

- (IBAction)changePage:(id)sender {
    int page = self.pageControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self p_loadScrollViewWithPage:page - 1];
    [self p_loadScrollViewWithPage:page];
    [self p_loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    [self loadPage:page animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed_ = YES;
	// inform the delegate
	[delegate_ didScrollToPage:page];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	isRotating_ = YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	
	isRotating_ = NO;
	
	// save the page and restore it after the rotation
	pageBeforeRotation_ = self.pageControl.currentPage;
	
	[self p_resizeScrollViewForOrientation:orientation];
	[self p_loadScrollViewWithPage:pageBeforeRotation_];
	
	//LogRect(@"self.frame", self.frame);
	//LogRect(@"self.scrollView.frame", self.scrollView.frame);
}

- (UIViewController *)currentController {
	return [self.viewControllers objectAtIndex:self.pageControl.currentPage];
}


///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark ScrollViewDelegate Methods
///////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed_ || isRotating_) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
	// Switch the indicator when more than 50% of the previous/next page is visible
	CGFloat pageWidth = self.scrollView.frame.size.width;
	int oldpage = self.pageControl.currentPage;
	int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
    self.pageControl.currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self p_loadScrollViewWithPage:page - 1];
    [self p_loadScrollViewWithPage:page];
    [self p_loadScrollViewWithPage:page + 1];
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
	
	// inform the delegate if page changed 
	if (page != oldpage) {
		[delegate_ didScrollToPage:page];
	}
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlUsed_ = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed_ = NO;
}


///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private Methods
///////////////////////////////////////////////////////////////////////////////////////////////////////

- (CGRect)p_framePosition:(CGRect)frame forPage:(int)page {
	// Calculate frame position
	frame.origin.x = frame.size.width * page;
	frame.origin.y = 0;
	
	//LogRect(@"vc.frame", frame);
	
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
	self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.viewControllers.count,
                                             self.scrollView.frame.size.height);
	
	[self p_repositionSubViews];
}

- (void)p_resizeScrollViewForLandscape {
	self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.viewControllers.count,
											 self.scrollView.frame.size.height);
	
	[self p_repositionSubViews];
}

- (void)p_repositionSubViews {
	// Reposition all loaded frames
	for (int i = 0; i < [self.viewControllers count]; i++) {
		UIViewController* vc = [self.viewControllers objectAtIndex:i];
		
        if((NSNull *)vc != [NSNull null]) {
			// Calculate the position of the frame depending on orientation
			vc.view.frame = [self p_framePosition:vc.view.frame forPage:i];
		}
    }
	
	// display same page after rotation than before
	self.scrollView.contentOffset = CGPointMake(pageBeforeRotation_*self.scrollView.frame.size.width, 0);
}

- (void)p_initScrollView {
    // init scrollview
	//TODO: Startup BUG - Landscape - 
	//Fix works only for iPad - for iPhone replace CGRect with MBRectMake
	//self.scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0.,0.,768.,1024.)] autorelease];
	self.scrollView = [[[UIScrollView alloc] initWithFrame:MBApplicationFrame()] autorelease];
    self.scrollView.pagingEnabled = YES;
	[self p_resizeScrollViewForOrientation:[[UIDevice currentDevice]orientation]];
	
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
	// TODO:
	self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.scrollView.contentMode = UIViewContentModeScaleToFill;
	[self addSubview:self.scrollView];
    
    // init pageControl
	self.pageControl = [[[UIPageControl alloc] initWithFrame:CGRectMake(0,0,viewFrame_.size.width, 30)] autorelease];
	self.pageControl.center = CGPointMake(self.scrollView.frame.size.width / 2, 30.0);
	self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	self.pageControl.contentMode = UIViewContentModeScaleToFill;
    self.pageControl.numberOfPages = self.viewControllers.count;
    self.pageControl.currentPage = 0;
	[self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
	[self addSubview:self.pageControl];
	
    
	// lazy loading - commented out
    // load the visible page - pages are created on demand
    //[self p_loadScrollViewWithPage:0];
    // load the page on either side to avoid flashes when the user starts scrolling
    //[self p_loadScrollViewWithPage:1];
	
	// load all pages on startup
	for (int i=0;i<[dataSource_ numberOfPages];i++) {
		[self p_loadScrollViewWithPage:i];
	}
}

- (void)p_loadScrollViewWithPage:(int)page {
    if (page < 0 || page >= self.viewControllers.count) {
        return;
    }
    
    // replace the placeholder if necessary
    UIViewController *controller = [self.viewControllers objectAtIndex:page];
    
    if ((NSNull *)controller == [NSNull null]) {
		controller = [dataSource_ viewControllerForPage:page];
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
