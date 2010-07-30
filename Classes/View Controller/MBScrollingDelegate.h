//
//  MBScrollingProvider.h
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

@protocol MBScrollingDelegate
// the number of view controllers
- (NSUInteger)numberOfControllers;
// specific view controller for a given page
- (UIViewController *)viewControllerForPage:(NSUInteger)page;
@end
