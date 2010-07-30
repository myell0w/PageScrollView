//
//  MBTableViewDelegate.h
//  Mercedes
//
//  Created by Matthias Tretter on 29.07.10.
//  Copyright 2010 YellowSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Base Class for all Delegates and DataSources for Sections
///////////////////////////////////////////////////////////////////////////////////////////////////////

@interface MBSectionDelegate : NSObject <UITableViewDelegate, UITableViewDataSource> {
	NSMutableArray *cellTitles_;
	UITableViewCellAccessoryType accessoryType_;
	UIViewController *viewController_;
	
	UIImage *leftFooterImage_;
	UIImage *rightFooterImage_;
	
	NSInteger marginRight_;
}

@property(nonatomic,readonly) NSInteger numberOfRows;
@property(nonatomic,retain) NSMutableArray *cellTitles;
@property(nonatomic,readonly) IBOutlet UIViewController *viewController;

- (id)initWithViewController:(UIViewController *)viewController cellTitles:(NSArray *)cellTitles;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Class Extension for Private Methods
///////////////////////////////////////////////////////////////////////////////////////////////////////

@interface MBSectionDelegate ()
- (BOOL)p_isFooterCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)p_setUpFooterCell:(UITableViewCell *)cell;
- (void)p_setUpCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

- (void)p_loadFooterImages;

- (void)p_didClickOnLeftFooterButton;
- (void)p_didClickOnRightFooterButton;
@end