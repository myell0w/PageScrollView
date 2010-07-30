//
//  MBScrollingVC.h
//  Mercedes
//
//  Created by Matthias Tretter on 28.07.10.
//  Copyright 2010 YellowSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBScrollingDelegate.h"


@interface MBScrollingVC : UIViewController<UIScrollViewDelegate> {
	id<MBScrollingDelegate> delegate_;
	
	UIScrollView *scrollView_;
	UIPageControl *pageControl_;
    NSMutableArray *viewControllers_;
	
    // To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed;
	// page Number before Rotation starts
	NSInteger pageBeforeRotation;
	// frame of the application (whole display size)
	CGRect applicationFrame;
}

// Properties
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *viewControllers;

// Initializer
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil viewControllerProvider:(id)provider;

// Methods
- (void)loadPage:(NSUInteger)page animated:(BOOL)animated;

// Action Methods
- (IBAction)changePage:(id)sender;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Class Extension for Private Methods
///////////////////////////////////////////////////////////////////////////////////////////////////////

@interface MBScrollingVC ()
- (void)p_deviceDidRotate:(NSNotification *)notification;
- (CGRect)p_framePosition:(CGRect)frame forPage:(int)page;

- (void)p_resizeScrollViewForOrientation:(UIInterfaceOrientation)orientation;
- (void)p_resizeScrollViewForPortrait;
- (void)p_resizeScrollViewForLandscape;
- (void)p_repositionSubViews;
- (void)p_initScrollView;

- (void)p_loadScrollViewWithPage:(int)page;
@end