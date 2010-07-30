//
//  UIDevice-Helper.h
//  FirstUniversal
//
//  Created by Matthias Tretter on 26.07.10.
//  Copyright (c) 2010 m.yellow. All rights reserved.
//


#import <Foundation/Foundation.h>

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Category for extending UIDevice Information
///////////////////////////////////////////////////////////////////////////////////////////////////////

@interface UIDevice (Helper)
    - (BOOL)isJailbroken;
    - (BOOL)isIPad;
	- (BOOL)isPhone;

    - (BOOL)isMultitaskingAvailable;
    - (BOOL)isHardwareEncryptionAvailable;
    - (BOOL)isNetworkAvailable;
    - (BOOL)isStillCameraAvailable;
    - (BOOL)isVideoCameraAvailable;
    - (BOOL)isAudioInputAvailable;
    - (BOOL)isProximitySensorAvailable;
    - (BOOL)isScreenLockingActivated;
    - (BOOL)isClassAvailable:(NSString *) className;
    - (BOOL)isExternalScreenAttached;

    - (void)activateScreenLocking;
    - (void)deactivateScreenLocking;
@end