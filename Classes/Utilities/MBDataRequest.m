//
//  MBDataRequest.m
//  HTTPTransfer
//
//  Created by Michael Schwarz on 28.07.10.
//  Copyright 2010 Karl-Franzens Uni Graz. All rights reserved.
//

#import "MBDataRequest.h"
#import "TBXML.h"



//Set true, if downloaded and parsed array data is saved locally.
static BOOL localMemoryUsed=YES;


// Private stuff
@interface MBDataRequest ()
//Delivers a locally saved Category Array if ttl is OK, if ttl is not ok, or array not saved -> return nil
-(NSMutableArray *)deliverSavedArrayForFilename:(NSString *)localFilename ConsideringTTL:(NSTimeInterval)ttl ;

- (NSString *)documentsDirectory;

- (void)parseXMLString;
@end


@implementation MBDataRequest

@synthesize delegate=delegate_;

+(void) shouldUseLocalMemory:(BOOL)shouldUse
{
  localMemoryUsed = shouldUse;
}

- (id)initWithMBContentCategory:(MBDataContentCategory)contentCategory
{
  self = [super init];
	if (self != nil) {
  	contentData_=nil;
  	xmlString_=nil;
  	contentCategory_=contentCategory;
  	}
  return self;
}



+ (id)requestWithMBContentCategory:(MBDataContentCategory)contentCategory
{
  return [[[self alloc] initWithMBContentCategory:contentCategory] autorelease];
}


- (void)start
{
  
  NSTimeInterval ttl=TTL_ETERNAL;	//Time To Live 
  NSString *localMBFilename=nil;
  NSString *remoteXMLFilename=nil;
  
  
  switch (contentCategory_) {
    case MBClubsCategory:
      localMBFilename = MBFILE_CLUBS;
      remoteXMLFilename = XML_REMOTE_CLUBS;
      ttl = TTL_CLUBS;
      break;
    case MBNewsCategory:
      localMBFilename = MBFILE_NEWS;
      remoteXMLFilename = XML_REMOTE_NEWS;
      ttl = TTL_NEWS;
      break;
    case MBMuseumCategory:  //Special Category - XML instead of remote, included in the bundle
      localMBFilename = MBFILE_MUSEUM;	
      xmlString_ = [[NSString alloc] initWithContentsOfFile:XML_LOCAL_MUSEUM encoding:NSUTF8StringEncoding error:nil ];
      ttl = TTL_ETERNAL;
      break;
    case MBEventsCategory:
      localMBFilename = MBFILE_EVENTS;
      remoteXMLFilename = XML_REMOTE_EVENTS;
      ttl = TTL_EVENTS;
      break;
    case MBClubEventsCategory:
      localMBFilename = MBFILE_CLUB_EVENTS;
      remoteXMLFilename = XML_REMOTE_CLUB_EVENTS;
      ttl = TTL_EVENTS;
      break;
    case MBClassicsCategory:
      localMBFilename = MBFILE_CLASSICS;
      remoteXMLFilename = XML_REMOTE_CLASSICS;
      ttl = TTL_CLASSICS;
      break;
    case MBYoungClassicsCategory:
      localMBFilename = MBFILE_YOUNGCLASSICS;
      remoteXMLFilename = XML_REMOTE_YOUNGCLASSICS;
      ttl = TTL_CLASSICS;
      break;
    case MBMuseumShopCategory:
      localMBFilename = MBFILE_MUSEUMSHOP;
      remoteXMLFilename = XML_REMOTE_MUSEUMSHOP;
      ttl = TTL_MUSEUMSHOP;
      break;
    case MBStoryCategory:
      localMBFilename = MBFILE_CLUB_STORIES;
      remoteXMLFilename = XML_REMOTE_CLUB_STORIES;
      ttl = TTL_CLUB_STORIES;
      break;
    case MBExhibitionCategory:
      localMBFilename = MBFILE_EXHIBITIONS;
      remoteXMLFilename = XML_REMOTE_EXHIBITIONS;
      ttl = TTL_EXHIBITIONS;
      break;
      
    default:
      NSLog(@"MBDataRequest/start: Unknown contentCategory");
      break;
  }
  
  if(localMemoryUsed)
  	contentData_=[self deliverSavedArrayForFilename:localMBFilename ConsideringTTL:ttl];
  
  if (contentData_ != nil) {		//Finished - deliver Request
    if(delegate_ && [delegate_ respondsToSelector:@selector(requestFinished:)])
      [delegate_ requestFinished:self];
  }
  
  
  if (xmlString_ == nil) { //if not museum categorie - load the xml file
    NSURL *url=[NSURL URLWithString:remoteXMLFilename];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
    NSLog(@"MBDataRequest/start: StartedXMLTransfer");
  }else{
    NSThread *parserThread = [[[NSThread alloc] initWithTarget:self selector:@selector(parseXMLString) object:nil] autorelease];
    [parserThread start];
  }
  

  
}


#pragma mark ASIHTTPRequestDelegate Implementations
- (void)requestFinished:(ASIHTTPRequest *)request
{
  // Use when fetching text data
  NSLog(@"MBDataRequest/requestFinished: XML-File transferred");
  xmlString_ = [[request responseString]retain];
  
  NSThread *parserThread = [[[NSThread alloc] initWithTarget:self selector:@selector(parseXMLString) object:nil] autorelease];

  [parserThread start];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
  NSError *error = [request error];
  NSLog(@"ERROR, %@",[error localizedDescription]);
}


- (void)parseXMLString{
  NSLog(@"MBDataRequest/parseXMLString: Start with parsing ");
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];	//New Pool for the thread
  
//  TBXML * tbxml = [TBXML tbxmlWithXMLString:xmlString_] ;
//	TBXMLElement * rootXMLElement = tbxml.rootXMLElement;

 // NSString *elementName = [NSString stringWithUTF8String:rootXMLElement->name];
//  NSLog(elementName);

  
  //NSData *xmlData = [xmlString_ dataUsingEncoding:NSUTF8StringEncoding];
  
   // NSLog(xmlString_);
  
  //NSLog(@"%d",  [xmlString_ length]);
  
  //NGDOMDocument *doc = [[NGDOMDocument alloc] initWithData:xmlData];
  
  
//  NSLog(@"MBDataRequest/parseXMLString: End  parsing ");
  [pool release];
  
  if(delegate_ && [delegate_ respondsToSelector:@selector(requestFinished:)])
    [delegate_ requestFinished:self];
  
   
 
}


-(NSMutableArray *)deliverSavedArrayForFilename:(NSString *)localFilename ConsideringTTL:(NSTimeInterval)ttl
{
  NSString *fullPathName;
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSDate *fileLastModified;
  
   NSLog(@"MBDataRequest/deliverSavedArrayForFilename: Search for saved Array! ");
  
  fullPathName = [[self documentsDirectory] stringByAppendingPathComponent:localFilename];
  
  if ([fileManager fileExistsAtPath:fullPathName]) {		//if file does not exist
    return(nil);
  }
  
  fileLastModified = [[fileManager fileAttributesAtPath:localFilename traverseLink:YES] objectForKey:NSFileModificationDate];
  int interval = (int)[fileLastModified timeIntervalSinceNow];
  
  if (abs(interval) > ttl && ttl != TTL_ETERNAL) {		//if time intervall from last download is > (Time To Live)
    return(nil);
  }
  
  NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:fullPathName];
  
  return [array autorelease];
}


- (NSArray *)requestData
{  
  return (NSArray *)contentData_;
}

- (NSString *)documentsDirectory {
	return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

@end
