//
//  Macros.h
//  FirstUniversal
//
//  Created by Matthias Tretter on 25.07.10.
//  Copyright (c) 2010 m.yellow. All rights reserved.
//



///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Localization
///////////////////////////////////////////////////////////////////////////////////////////////////////

// Shortcut for localized string, without comment
#define MBLocalize(x) NSLocalizedString(x, nil)
// Shortcut for getting a device-specific autoreleased Image
#define MBImageNamed(x) ([UIImage imageNamed:MBDeviceSpecificImageName(x)])
// This Shortcut also takes Orientation on the iPad into account
#define MBImageNamedForOrientation(x,o) ([UIImage imageNamed:MBDeviceSpecificImageNameForOrientation(x,o)])

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Object Lifecycle
///////////////////////////////////////////////////////////////////////////////////////////////////////

// Releases an object an sets it to nil, for preventing memory errors when sending messages to deallocated objects
#define RELEASE(x) ({[x release]; x = nil; })


///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Version Numbers of iOS
///////////////////////////////////////////////////////////////////////////////////////////////////////

#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_2_0
#define kCFCoreFoundationVersionNumber_iPhoneOS_2_0 478.23
#endif

#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_2_1
#define kCFCoreFoundationVersionNumber_iPhoneOS_2_1 478.26
#endif

#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_2_2
#define kCFCoreFoundationVersionNumber_iPhoneOS_2_2 478.29
#endif

#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_3_0
#define kCFCoreFoundationVersionNumber_iPhoneOS_3_0 478.47
#endif

#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_3_1
#define kCFCoreFoundationVersionNumber_iPhoneOS_3_1 478.52
#endif

#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_3_2
#define kCFCoreFoundationVersionNumber_iPhoneOS_3_2 478.61
#endif

#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_4_0
#define kCFCoreFoundationVersionNumber_iPhoneOS_4_0 550.32
#endif


///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Macros for Checking iOS Versions
///////////////////////////////////////////////////////////////////////////////////////////////////////

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
#define IF_IOS4_OR_GREATER(...) \
if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iPhoneOS_4_0) \
{ \
__VA_ARGS__ \
}
#else
#define IF_IOS4_OR_GREATER(...)
#endif 


#define IF_PRE_IOS4(...) \
if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iPhoneOS_4_0) \
{ \
__VA_ARGS__ \
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
#define IF_IOS32_OR_GREATER(...) \
if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iPhoneOS_3_2) \
{ \
__VA_ARGS__ \
}
#else
#define IF_IOS32_OR_GREATER(...)
#endif 
