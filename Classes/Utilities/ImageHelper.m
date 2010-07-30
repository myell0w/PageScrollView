//
//  ImageHelper.m
//  Mercedes
//
//  Created by Matthias Tretter on 29.07.10.
//  Copyright 2010 YellowSoft. All rights reserved.
//

#import "ImageHelper.h"


NSString* MBDeviceSpecificImageName(NSString *imageName) {
	// seperate extension from imageName
	NSArray *parts = [imageName componentsSeparatedByString:@"."];
	// when on iPad, append "-iPad"
	NSString *iPadAppendix = [[UIDevice currentDevice] isIPad] ? @"-iPad" : @"";
	
	if (parts.count == 2) {
		return [NSString stringWithFormat:@"%@%@.%@", [parts objectAtIndex:0], iPadAppendix, [parts objectAtIndex:1]];
	} else if (parts.count == 1) {
		// append .png per default
		return [NSString stringWithFormat:@"%@%@.png", [parts objectAtIndex:0], iPadAppendix];
	} 
	
	return nil;
}

NSString* MBDeviceSpecificImageNameForOrientation(NSString *imageName, UIInterfaceOrientation orientation) {
	// seperate extension from imageName
	NSArray *parts = [imageName componentsSeparatedByString:@"."];
	// when on iPad, append "-iPad"
	NSString *iPadAppendix = [[UIDevice currentDevice] isIPad] ? @"-iPad" : @"";
	// when on iPad and orientation is Landscape, append "-iPad-L"
	NSString *orientationAppendix = [[UIDevice currentDevice] isIPad] && UIInterfaceOrientationIsLandscape(orientation) ? @"-L" : @"";
	
	if (parts.count == 2) {
		return [NSString stringWithFormat:@"%@%@%@.%@", [parts objectAtIndex:0], iPadAppendix, orientationAppendix, [parts objectAtIndex:1]];
	} else if (parts.count == 1) {
		// append .png per default
		return [NSString stringWithFormat:@"%@%@%@.png", [parts objectAtIndex:0], iPadAppendix, orientationAppendix];
	} 
	
	return nil;
}