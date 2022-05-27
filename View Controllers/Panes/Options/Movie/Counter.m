//
//  Counter.m
//  avbody
//
//  Created by lan1 on 2017/3/28.
//  Copyright © 2017年 com.eznewlife. All rights reserved.
//

#import "Counter.h"

@implementation Counter

+(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;   //返回的就是已经改变的图片
}

@end
