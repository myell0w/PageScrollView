//
//  NSString-TruncateToWidth.h
//  Mercedes
//
//  Created by Matthias Tretter on 28.07.10.
//  Copyright (c) 2010 m.yellow. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (TruncateToWidth)

- (NSString*)stringByTruncatingToWidth:(CGFloat)width withFont:(UIFont *)font;

@end