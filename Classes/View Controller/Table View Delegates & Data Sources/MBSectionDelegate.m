//
//  MBTableViewDelegate.m
//  Mercedes
//
//  Created by Matthias Tretter on 29.07.10.
//  Copyright 2010 YellowSoft. All rights reserved.
//

#import "MBSectionDelegate.h"


#define TAG_LEFT_BUTTON  1
#define TAG_RIGHT_BUTTON 2

#define MARGIN_RIGHT_IPAD   72
#define MARGIN_RIGHT_IPHONE 30

@implementation MBSectionDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Synthesized Properties
///////////////////////////////////////////////////////////////////////////////////////////////////////

@synthesize cellTitles = cellTitles_;
@synthesize viewController = viewController_;

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
///////////////////////////////////////////////////////////////////////////////////////////////////////

- (id)initWithViewController:(UIViewController *)viewController cellTitles:(NSArray *)cellTitles; {
	if (self = [super init]) {
		viewController_ = [viewController retain];
		cellTitles_ = [cellTitles mutableCopy];
		accessoryType_ = UITableViewCellAccessoryNone;
		marginRight_  = [[UIDevice currentDevice] isIPad] ? MARGIN_RIGHT_IPAD : MARGIN_RIGHT_IPHONE;
		
		[self p_loadFooterImages];
	}
	
	return self;
}

- (void)dealloc {
	RELEASE(cellTitles_);
	RELEASE(viewController_);
	
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 
#pragma mark Table view data source
///////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)numberOfRows {
	return self.cellTitles.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self numberOfRows];
}

// change the colors of the footer-cell
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self p_isFooterCellAtIndexPath:indexPath]) {
		[cell.textLabel setTextAlignment:UITextAlignmentCenter];
		[cell.textLabel setTextColor:[UIColor whiteColor]];
		[cell setBackgroundColor:[UIColor colorWithRed:0.51 green:0.54 blue:0.576 alpha:1.0]];
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIDFooter = @"CellIDFooter";
	static NSString *cellID = @"CellIDSection";
	
	
	BOOL isFooterCell = [self p_isFooterCellAtIndexPath:indexPath];
	UITableViewCell *cell = nil;
	
	// step 1: is there a reusable cell?
	if (isFooterCell) {
		cell = [tableView dequeueReusableCellWithIdentifier:cellIDFooter];
	} else {
		cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	}

	
	// step 2: no? -> create new cell
	if (cell == nil) {
		if (isFooterCell) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIDFooter] autorelease];
			
			if (leftFooterImage_ != nil) {
				// create custom button
				UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
				// set tag
				left.tag = TAG_LEFT_BUTTON;
				// set frame
				left.frame = CGRectMake(10.0, cell.bounds.size.height / 2 - leftFooterImage_.size.height / 2, 
										leftFooterImage_.size.width, leftFooterImage_.size.height);
				// target-action
				[left addTarget:self action:@selector(p_didClickOnLeftFooterButton) forControlEvents:UIControlEventTouchUpInside];
				// add to cell
				[cell.contentView addSubview:left];
			}
			
			if (rightFooterImage_ != nil) {
				// create custom button
				UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
				// set tag
				right.tag = TAG_RIGHT_BUTTON;
				
				NSLog(@"width: %f",tableView.frame.size.width);
				// set frame
				right.frame = CGRectMake(tableView.frame.size.width - rightFooterImage_.size.width - marginRight_, cell.bounds.size.height / 2 - rightFooterImage_.size.height / 2,
										 rightFooterImage_.size.width, rightFooterImage_.size.height);
				// target-action
				[right addTarget:self action:@selector(p_didClickOnRightFooterButton) forControlEvents:UIControlEventTouchUpInside];
				// add to cell
				[cell.contentView addSubview:right];
			}
		} else {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
			cell.accessoryType = accessoryType_;
		}
	}
	
	// step 3: set up cell values
	if (isFooterCell) {
		[self p_setUpFooterCell:cell];
	} else {
		[self p_setUpCell:cell atIndexPath:indexPath];	
	}
	
    return cell;
}


 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	 return NO;
 }


///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Table view delegate
///////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// footer cell is not selectable
	if ([self p_isFooterCellAtIndexPath:indexPath]) {
		return nil;
	}
	
	return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// disables the scrollview so that is looks like if there is a new ViewController
	MBApplicationDelegate.scrollEnabled = NO;
}


///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private Methods
///////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)p_isFooterCellAtIndexPath:(NSIndexPath *)indexPath {
	return indexPath.row == self.numberOfRows - 1;
}

- (void)p_setUpFooterCell:(UITableViewCell *)cell {
	cell.textLabel.text = [NSString stringWithFormat:@"%d/%d", [MBApplicationDelegate currentPage], [MBApplicationDelegate numberOfPages]];
	
	if (leftFooterImage_ != nil) {
		UIButton *left = (UIButton *) [cell viewWithTag:TAG_LEFT_BUTTON];
		[left setImage:leftFooterImage_ forState:UIControlStateNormal];
	}
	
	if (rightFooterImage_ != nil) {
		UIButton *right = (UIButton *) [cell viewWithTag:TAG_RIGHT_BUTTON];
		[right setImage:rightFooterImage_ forState:UIControlStateNormal];
	}
}

- (void)p_setUpCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	cell.textLabel.text = [self.cellTitles objectAtIndex:indexPath.row];
}

- (void)p_loadFooterImages {
	[self doesNotRecognizeSelector:_cmd];
}

- (void)p_didClickOnLeftFooterButton {
	// scroll to specific page
	[MBApplicationDelegate loadPage:MBApplicationDelegate.currentPage-1 animated:YES];
}

- (void)p_didClickOnRightFooterButton {
	// scroll to specific page
	[MBApplicationDelegate loadPage:MBApplicationDelegate.currentPage+1 animated:YES];
}

@end
