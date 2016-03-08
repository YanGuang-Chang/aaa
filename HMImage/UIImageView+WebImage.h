//
//  UIImageView+WebImage.h
//  01-HMImage(框架)
//
//  Created by yan on 15/12/7.
//  Copyright © 2015年 yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (WebImage)

//每个imageview都有一张自己的图片
//oc中没有提供在分类中增加属性的方法 要用运行时语言添加属性
@property(nonatomic,copy)NSString *urlString;

//用这个分类来下载图片  首先要对外提供一个借口 供用户使用

//需要有下载图片的urlString 和 占位图片
-(void)setUpImageWithUrlString:(NSString *)urlString placedImageString:(NSString *)placed;

@end
