//
//  MBPageScrollView.h
//  Mercedes
//
//  Created by Matthias Tretter on 28.07.10.
//  Copyright 2010 YellowSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Protocol for Providing View Controllers for MBScrollingVC on demand
///////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol MBPageScrollViewDataSource
// the number of view controllers
- (NSUInteger)numberOfPages;
// specific view controller for a given page
- (UIViewController *)viewControllerForPage:(NSUInteger)page;
@end

@protocol MBPageScrollViewDelegate
// is called when the View Scrolls to a given page
- (void)didScrollToPage:(int)page;
@end

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Generic View for Scrolling through Pages
///////////////////////////////////////////////////////////////////////////////////////////////////////

@interface MBPageScrollView : UIView <UIScrollViewDelegate> {
	id<MBPageScrollViewDataSource> dataSource_;
	id<MBPageScrollViewDelegate> delegate_;
	
	UIScrollView *scrollView_;
	UIPageControl *pageControl_;
    NSMutableArray *viewControllers_;
	
	// To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed_;
	// page Number before Rotation starts
	NSInteger pageBeforeRotation_;
	// frame of the PageScrollView
	CGRect viewFrame_;	
}

// Properties
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *viewControllers;

// Initializer
- (id)initWithFrame:(CGRect)frame dataSource:(id<MBPageScrollViewDataSource>)dataSource delegate:(id<MBPageScrollViewDelegate>)delegate;
- (void)releaseCachedController;

// Methods
- (void)loadPage:(NSUInteger)page animated:(BOOL)animated;

// Action Methods
- (IBAction)changePage:(id)sender;
- (void)deviceDidRotate;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Class Extension for Private Methods
///////////////////////////////////////////////////////////////////////////////////////////////////////

@interface MBPageScrollView ()
- (CGRect)p_framePosition:(CGRect)frame forPage:(int)page;

- (void)p_resizeScrollViewForOrientation:(UIInterfaceOrientation)orientation;
- (void)p_resizeScrollViewForPortrait;
- (void)p_resizeScrollViewForLandscape;
- (void)p_repositionSubViews;
- (void)p_initScrollView;

- (void)p_loadScrollViewWithPage:(int)page;
@end