//
//  MBSectionTVC.h
//  Mercedes
//
//  Created by Matthias Tretter on 28.07.10.
//  Copyright (c) 2010 m.yellow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBSectionBackgroundView.h"


@class MBSectionDelegate;

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Base Class for all View Controllers that represent a Section
///////////////////////////////////////////////////////////////////////////////////////////////////////

@interface MBSectionVC : UIViewController {
    // view for managing the background
	MBSectionBackgroundView *backgroundView_;
	// table view for displaying sections
	UITableView *tableView_;
	
	// table-view delegate and dataSource
	MBSectionDelegate *delegate_;
}

// Properties
@property (nonatomic, retain) IBOutlet UIView *backgroundView;
@property (nonatomic, assign) MBSectionDelegate *delegate;

// initalizer
- (id)initWithNibName:(NSString *)nibNameOrNil 
			   bundle:(NSBundle *)nibBundleOrNil 
  backgroundImageName:(NSString *)imageName;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Class Extension for Private Methods
///////////////////////////////////////////////////////////////////////////////////////////////////////

@interface MBSectionVC ()
- (CGRect)p_tableViewFrameForCurrentDevice;
@end