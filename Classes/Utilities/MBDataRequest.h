//
//  MBDataRequest.h
//  HTTPTransfer
//
//  Created by Michael Schwarz on 28.07.10.
//  Copyright 2010 Karl-Franzens Uni Graz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBDataRequestDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"

typedef enum MBDataContentCategory {
	MBClubsCategory,
	MBNewsCategory,
	MBMuseumCategory,
	MBEventsCategory,
	MBClubEventsCategory,
	MBClassicsCategory,
	MBYoungClassicsCategory,
	MBMuseumShopCategory,
	MBStoryCategory,
	MBExhibitionCategory,
} MBDataContentCategory;


@interface MBDataRequest : NSObject <ASIHTTPRequestDelegate>{
  
  //Defines, which content category the request delivers.
  MBDataContentCategory contentCategory_;
  
  //Delegate, implementing the MBDataRequestDelegate Protocol
  id <MBDataRequestDelegate> delegate_; 
  
  //Data-Array consisting the requestet content
  NSMutableArray *contentData_;
  
  //String consisting the XML file to parse
  NSString *xmlString_;
  
  
  
  
}
#pragma mark Properties
@property(retain, nonatomic) id <MBDataRequestDelegate> delegate;


+(void) shouldUseLocalMemory:(BOOL)shouldUse;

#pragma mark init / dealloc

// Init Methods
- (id)initWithMBContentCategory:(MBDataContentCategory)contentCategory;

// Convenience constructor
+ (id)requestWithMBContentCategory:(MBDataContentCategory)contentCategory;


// Run a request in the background
- (void)start;

- (NSArray *)requestData;

@end
