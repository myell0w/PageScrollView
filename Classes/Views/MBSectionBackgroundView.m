//
//  MBSectionView.m
//  Mercedes
//
//  Created by Matthias Tretter on 29.07.10.
//  Copyright 2010 YellowSoft. All rights reserved.
//

#import "MBSectionBackgroundView.h"


@implementation MBSectionBackgroundView

@synthesize imageName = imageName_;
@synthesize image = image_;
@synthesize imageLandscape = imageLandscape_;


- (id)initWithFrame:(CGRect)frame imageName:(NSString *)imageName {
	if ((self = [super initWithFrame:frame])) {
		imageName_ = [imageName copy];
		image_ = imageLandscape_ = nil;
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.contentMode = UIViewContentModeRedraw; //UIViewContentModeScaleToFill;
	}
	
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	return [self initWithFrame:frame imageName:nil];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	
	if (UIInterfaceOrientationIsPortrait(orientation)) {
		if (self.image == nil) {
			self.image = MBImageNamed(self.imageName);
		}
		
		[self.image drawInRect:rect];
	} else {
		if (self.imageLandscape == nil) {
			self.imageLandscape = MBImageNamedForOrientation(self.imageName, UIInterfaceOrientationLandscapeLeft);
		}
		
		[self.imageLandscape drawInRect:rect];
	}
}


- (void)dealloc {
	RELEASE(imageName_);
	RELEASE(imageLandscape_);
	RELEASE(image_);
	
	[super dealloc];
}


@end