//
//  ZQSlider.m
//  day4-ui
//
//  Created by qianfeng on 15/12/2.
//  Copyright (c) 2015年 TooWalker. All rights reserved.
//

#import "ZQSlider.h"

@implementation ZQSlider

//- (CGRect)minimumValueImageRectForBounds:(CGRect)bounds{
//    
//}
//- (CGRect)maximumValueImageRectForBounds:(CGRect)bounds{
//    
//}

-(void)layoutSubviews
{
    [super layoutSubviews];
    for (UIImageView* imageView in self.subviews)
    {
        if (imageView.frame.origin.x < self.center.x)
        {

            imageView.contentMode = UIViewContentModeLeft;
        }
    }
}

@end
