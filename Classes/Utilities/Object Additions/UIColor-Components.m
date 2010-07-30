//
//  UIColor-Components.m
//  CocoaSnippets
//
//  Created by Matthias Tretter on 26.07.10.
//  Copyright (c) 2010 m.yellow. All rights reserved.
//

#import "UIColor-Components.h"


@implementation UIColor (Components)
- (NSNumber *)redColorComponent {
	CGColorRef color = [self CGColor];
	
	int numComponents = CGColorGetNumberOfComponents(color);
	
	if (numComponents == 4)
	{
		const CGFloat *components = CGColorGetComponents(color);
		CGFloat floatcolor = components[0];
		return [[[NSNumber alloc] initWithFloat:floatcolor] autorelease];
	}
	
	return nil;
}

- (NSNumber *)greenColorComponent {
	CGColorRef color = [self CGColor];
	
	int numComponents = CGColorGetNumberOfComponents(color);
	
	if (numComponents == 4)
	{
		const CGFloat *components = CGColorGetComponents(color);
		CGFloat floatcolor = components[1];
		return [[[NSNumber alloc] initWithFloat:floatcolor] autorelease];
	}
	
	return nil;
}


- (NSNumber *)blueColorComponent {
	CGColorRef color = [self CGColor];
	
	int numComponents = CGColorGetNumberOfComponents(color);
	
	if (numComponents == 4)
	{
		const CGFloat *components = CGColorGetComponents(color);
		CGFloat floatcolor = components[2];
		return [[[NSNumber alloc] initWithFloat:floatcolor] autorelease];
	}
	
	return nil;
}
@end
