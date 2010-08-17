//
//  MBSectionTVC.m
//  Mercedes
//
//  Created by Matthias Tretter on 28.07.10.
//  Copyright (c) 2010 m.yellow. All rights reserved.
//

#import "MBSectionVC.h"
#import "MBSectionDelegate.h"

#define CELL_HEIGHT			 44.0
#define CELL_WIDTH_IPAD		 500.0

#define MARGIN_BOTTOM_IPHONE 22.0
#define MARGIN_BOTTOM_IPAD   55.0
#define MARGIN_LEFT_IPAD     20.0

#define degreesToRadian(x) (M_PI * (x) / 180.0)


@implementation MBSectionVC


///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Synthesized Properties
///////////////////////////////////////////////////////////////////////////////////////////////////////

@synthesize backgroundView = backgroundView_;
@synthesize delegate = delegate_;

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark View Lifecycle
///////////////////////////////////////////////////////////////////////////////////////////////////////

// the designated initializer
- (id)initWithNibName:(NSString *)nibNameOrNil 
			   bundle:(NSBundle *)nibBundleOrNil 
  backgroundImageName:(NSString *)imageName {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		// load background view
		backgroundView_ = [[MBSectionBackgroundView alloc] initWithFrame:MBApplicationFrame()
															   imageName:imageName];
	}
    
	return self;
}

// the designated initializer of the superclass => overloaded
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil backgroundImageName:nil];
}

- (void)dealloc {
	RELEASE(backgroundView_);
	RELEASE(tableView_);
	
    [super dealloc];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	UIView *v = [[[UIView alloc] initWithFrame:MBApplicationFrame()] autorelease];
	// set own view
	self.view = v;
	
	// add background-view
	[self.view addSubview:self.backgroundView];
	
	// add table-View
	if (self.delegate != nil) {
		tableView_ = [[UITableView alloc] initWithFrame:[self p_tableViewFrameForCurrentDevice] 
												  style:UITableViewStyleGrouped];
		
		tableView_.dataSource = self.delegate;
		tableView_.delegate = self.delegate;
		tableView_.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		tableView_.contentMode = UIViewContentModeLeft | UIViewContentModeBottom;
		tableView_.scrollEnabled = NO;
		// make table view-background transparent
		tableView_.backgroundColor = [UIColor clearColor];
		tableView_.opaque = NO;
		tableView_.backgroundView = nil;
		[tableView_ reloadData];
		
		[self.view addSubview:tableView_];
	}
	
	self.view.backgroundColor = [UIColor colorWithRed:164/255.f green:172/255.f blue:179/255.f alpha:1.0f];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.view.contentMode = UIViewContentModeScaleToFill;
}

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

- (void)viewDidUnload {
	[super viewDidUnload];
	
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    self.backgroundView = nil;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	tableView_.alpha = 1.0;
	tableView_.frame = [self p_tableViewFrameForCurrentDevice];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Rotation
///////////////////////////////////////////////////////////////////////////////////////////////////////

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return ROTATE_ON_IPAD;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	// clip to bounds during orientation to prevent one page from appearing on the next one during orientation
	//self.view.clipsToBounds = YES;
	
	[UIView beginAnimations:@"MoveTable" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:0.1];
	// fade out
	tableView_.alpha = 0.0;
	[UIView commitAnimations];
	
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	// stop clipping to bounds after orientation
	//self.view.clipsToBounds = NO;
	
	[UIView beginAnimations:@"MoveTable" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	// compute new position of tableView
	tableView_.frame = [self p_tableViewFrameForCurrentDevice];
	tableView_.alpha = 1.0;
	[UIView commitAnimations];
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private Methods
///////////////////////////////////////////////////////////////////////////////////////////////////////

- (CGRect)p_tableViewFrameForCurrentDevice {
	int numberOfRows = [delegate_ numberOfRows];
	CGFloat marginLeft = 0.;
	CGFloat marginBottom = MARGIN_BOTTOM_IPHONE;
	CGFloat width = self.view.frame.size.width;
	CGFloat height = -1;
	
	if ([[UIDevice currentDevice] isIPad]) {
		marginLeft = MARGIN_LEFT_IPAD;
		width = CELL_WIDTH_IPAD;
		marginBottom = MARGIN_BOTTOM_IPAD;
	} 
	
	height = numberOfRows * CELL_HEIGHT + marginBottom;
	
	return CGRectMake(self.view.frame.origin.x + marginLeft, self.view.frame.size.height - height, width, height);
}

@end

