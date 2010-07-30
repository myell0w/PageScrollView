//
//  MBDataRequestDelegate.h
//  HTTPTransfer
//
//  Created by Michael Schwarz on 28.07.10.
//  Copyright 2010 Karl-Franzens Uni Graz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBDataRequest;

@protocol MBDataRequestDelegate <NSObject>

- (void)requestFinished:(MBDataRequest *)request;
- (void)requestFailed:(MBDataRequest *)request;

@optional

- (void)requestStarted:(MBDataRequest *)request;
- (void)requestReceivedResponseHeaders:(MBDataRequest *)request;


@end
