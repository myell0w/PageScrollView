//
//  UIDevice-Helper.m
//  FirstUniversal
//
//  Created by Matthias Tretter on 26.07.10.
//  Copyright (c) 2010 m.yellow. All rights reserved.
//

#import "UIDevice-Helper.h"


@implementation UIDevice (Helper)

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Checking Jailbreak Status
///////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)isJailbroken {
    BOOL jailbroken = NO;
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *aptPath = @"/private/var/lib/apt/";
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
        jailbroken = YES;
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
        jailbroken = YES;
    }
    
    return jailbroken;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Checking Device Type
///////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)isIPad {
    static BOOL hasCheckediPadStatus = NO;
	static BOOL isRunningOniPad = NO;
	
	if (!hasCheckediPadStatus) {
		if ([self respondsToSelector:@selector(userInterfaceIdiom)]) {
			if ([self userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
				isRunningOniPad = YES;
			}
		}
        
		hasCheckediPadStatus = YES;
	}
	
	return isRunningOniPad;
}

- (BOOL)isPhone {
	return [[self model] rangeOfString:@"iPhone" options:NSCaseInsensitiveSearch].location != NSNotFound;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Checking Hardware/Software Features
///////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)isMultitaskingAvailable {
    /*static BOOL hasCheckedMultitaskingStatus = NO;
    static BOOL multitaskingAvailable = NO;
    
    if (!hasCheckedMultitaskingStatus) {
        if ([self respondsToSelector:@selector(isMultitaskingSupported)]) {
            multitaskingAvailable = [self isMultitaskingSupported];
        }
        
        hasCheckedMultitaskingStatus = YES;
    }
    
    return multitaskingAvailable;*/
	return NO;
}

- (BOOL)isHardwareEncryptionAvailable {
    /* TODO: Get the value of the protectedDataAvailable property in the shared UIApplication object. */
    
    [self doesNotRecognizeSelector:_cmd];
    return NO;
}

- (BOOL)isNetworkAvailable {
    /* TODO: Use the reachability interfaces of the System Configuration framework to determine the current network connectivity.
     For an example of how to use the System Configuration framework, see Reachability. */
    
    [self doesNotRecognizeSelector:_cmd];
    return NO;
}

- (BOOL)isStillCameraAvailable {
    return [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)isVideoCameraAvailable {
    /*  TODO: 
     Use the isSourceTypeAvailable: method of the UIImagePicker- Controller class to determine if a camera is available and then use the availableMediaTypesForSourceType: method to request the types for the UIImagePickerControllerSourceTypeCamera source. If the returned array contains the kUTTypeMovie key, video capture is available. For more information, see Device Features Programming Guide. */
    
    [self doesNotRecognizeSelector:_cmd];
    return NO;
}

- (BOOL)isAudioInputAvailable {
    /* TODO: In iOS 3 and later, use the AVAudioSession class to determine if audio input is available. This class accounts for many different sources of audio input on iOS-based devices, including built-in microphones, headset jacks, and connected accessories. For more information, see AVAudioSession Class Reference. */

    [self doesNotRecognizeSelector:_cmd];
    return NO;
}

- (BOOL)isProximitySensorAvailable {
    return self.proximityMonitoringEnabled;
}

- (BOOL)isScreenLockingActivated {
    return ![UIApplication sharedApplication].idleTimerDisabled;
}

- (BOOL)isClassAvailable:(NSString *)className {
    return NSClassFromString(className) != nil;
}

- (BOOL)isExternalScreenAttached {
    return UIScreen.screens.count > 1;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Changing Device Values
///////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)activateScreenLocking {
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void)deactivateScreenLocking {
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}


@end

