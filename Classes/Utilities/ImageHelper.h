//
//  ImageHelper.h
//  Mercedes
//
//  Created by Matthias Tretter on 29.07.10.
//  Copyright 2010 YellowSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Functions for managing device-specific images on iPhone/iPad
///////////////////////////////////////////////////////////////////////////////////////////////////////

// returns the image name depending on the current device by appending "-iPad" when on iPad
NSString* MBDeviceSpecificImageName(NSString *imageName);
// takes the current orientation on iPad into account by appending "-iPad-L" when in Landscape-Mode, otherwise "-iPad"
NSString* MBDeviceSpecificImageNameForOrientation(NSString *imageName, UIInterfaceOrientation orientation);