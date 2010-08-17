//
//  MBSectionView.h
//  Mercedes
//
//  Created by Matthias Tretter on 29.07.10.
//  Copyright 2010 YellowSoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MBSectionBackgroundView : UIView {
    NSString *imageName_;
    UIImage *image_;
    UIImage *imageLandscape_;
}

// Properties
@property (nonatomic, retain) NSString *imageName;
@property (nonatomic, retain) IBOutlet UIImage *image;
@property (nonatomic, retain) IBOutlet UIImage *imageLandscape;

- (id)initWithFrame:(CGRect)frame imageName:(NSString *)imageName;

@end