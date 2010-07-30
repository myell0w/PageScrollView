//
//  UICheckBox.m
//  Less2Do
//
//  Created by Matthias Tretter on 26.11.09.
//  Copyright 2009 BIAC. All rights reserved.
//

#import "UICheckBox.h"

#define DEFAULT_ON_IMAGE	@"task_on.png"
#define DEFAULT_OFF_IMAGE	@"task_off.png"

@implementation UICheckBox

@synthesize backgroundImage;
@synthesize imageNameOn;
@synthesize imageNameOff;


- (id)initWithFrame:(CGRect)frame 
		 andOnImage:(NSString *)imageOn 
		andOffImage:(NSString *)imageOff {
	if (self = [super initWithFrame:frame]) {
		on = NO;
		
		self.imageNameOn = imageOn;
		self.imageNameOff = imageOff;
		self.backgroundColor = [UIColor clearColor];
		self.clipsToBounds = YES;
		self.autoresizesSubviews = NO;
		self.autoresizingMask = 0;
		self.opaque = YES;
		
		[self setupUserInterface];
    }
	
    return self;
}

- (id)initWithFrame:(CGRect)frame {
	return [self initWithFrame:frame andOnImage:DEFAULT_ON_IMAGE andOffImage:DEFAULT_OFF_IMAGE];
}

- (void)dealloc {
	[backgroundImage release];
	[imageNameOn release];
	[imageNameOff release];
	
	[super dealloc];
}

// Setup the user interface
- (void)setupUserInterface {
	// Background image
	UIImage *image = [UIImage imageNamed:imageNameOff];
	UIImageView* imageView = [[UIImageView alloc] 
							  initWithFrame:CGRectMake(0,0,image.size.width,image.size.height)];
	
	imageView.image = image;
	imageView.backgroundColor = [UIColor clearColor];
	imageView.contentMode = UIViewContentModeLeft;
	self.backgroundImage = imageView;
	
	[imageView release];
	
	
	// Check for user input
	[self addTarget:self 
			 action:@selector(toggle) 
   forControlEvents:UIControlEventTouchUpInside];
	// add image-view
	[self addSubview:self.backgroundImage];
}

- (void)setOn:(BOOL)isOn {
	on = isOn;
	
	if (on)	{
		self.backgroundImage.image = [UIImage imageNamed:imageNameOn];
	} else {
		self.backgroundImage.image = [UIImage imageNamed:imageNameOff];
	}
}

- (BOOL)isOn {
	return on;
}

// Toggle state
- (void)toggle {
	[self setOn:!on];
}

@end