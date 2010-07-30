//
//  MBOverviewSectionDelegate.m
//  Mercedes
//
//  Created by Matthias Tretter on 29.07.10.
//  Copyright 2010 YellowSoft. All rights reserved.
//

#import "MBOverviewSectionDelegate.h"
#import "MyViewController.h"


@implementation MBOverviewSectionDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Initialization
///////////////////////////////////////////////////////////////////////////////////////////////////////

- (id)initWithViewController:(UIViewController *)viewController cellTitles:(NSArray *)cellTitles {
	if (self = [super initWithViewController:viewController cellTitles:cellTitles]) {
		accessoryType_ = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Table view delegate
///////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (![self p_isFooterCellAtIndexPath:indexPath]) {
		MBApplicationDelegate.scrollEnabled = NO;
		MyViewController *vc = [[[MyViewController alloc] initWithPageNumber:10] autorelease];
		[self.viewController.navigationController pushViewController:vc animated:YES];
//		
		// scroll to specific page
		//[MBApplicationDelegate loadPage:indexPath.row+1 animated:YES];
	} 

	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private Methods
///////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)p_setUpFooterCell:(UITableViewCell *)cell {
	[super p_setUpFooterCell:cell];
	cell.textLabel.text = @"";
}

- (void)p_loadFooterImages {
	leftFooterImage_ = nil;
	rightFooterImage_ = nil;
}

- (void)p_didClickOnLeftFooterButton {
	// TODO: show impressum
	NSLog(@"left");
}

- (void)p_didClickOnRightFooterButton {
	// do nothing
	NSLog(@"right");
}


@end
