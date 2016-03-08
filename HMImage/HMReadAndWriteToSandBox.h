//
//  HMReadAndWriteToSandBox.h
//  01-HMImage(框架)
//
//  Created by yan on 15/12/7.
//  Copyright © 2015年 yan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HMReadAndWriteToSandBox : NSObject

//首先有一个将图片存入沙盒的方法
//要给它一张图片  和图片唯一的标识符
-(void)writeToSandBoxWithImage:(UIImage *)image ToSand:(NSString *)imageName;
//读取沙盒中的图片
//给它一个取图片的标识符 和 返回一张图片
-(UIImage *)readImageFromSandBox:(NSString *)imageName;

//还要有一个获取沙盒路径的方法
-(NSString *)getImagePathFromWithImageName:(NSString *)imageName;

//还要有一个工具类  用这个类来管理这些方法 一个单例类
+(instancetype)shareSandBox;

@end
