//
//  MBScrollingVC.h
//  Mercedes
//
//  Created by Matthias Tretter on 28.07.10.
//  Copyright 2010 YellowSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBPageScrollView.h"


@interface MBPageScrollVC : UIViewController<UIScrollViewDelegate> {
	MBPageScrollView *pageScrollView_;
}

// Properties
@property (nonatomic, retain) IBOutlet MBPageScrollView *pageScrollView;

// Methods
- (void)loadPage:(NSUInteger)page animated:(BOOL)animated;

@end