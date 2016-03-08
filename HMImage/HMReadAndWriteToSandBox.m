//
//  HMReadAndWriteToSandBox.m
//  01-HMImage(框架)
//
//  Created by yan on 15/12/7.
//  Copyright © 2015年 yan. All rights reserved.
//

#import "HMReadAndWriteToSandBox.h"

@implementation HMReadAndWriteToSandBox

-(void)writeToSandBoxWithImage:(UIImage *)image ToSand:(NSString *)imageName{

    //现将图片转化为二进制以后才能存入沙盒
    NSData *data = UIImagePNGRepresentation(image);
    //找到沙盒路径
    NSString *path = [self getImagePathFromWithImageName:imageName];
    //存入沙盒
    [data writeToFile:path atomically:YES];
}

-(UIImage *)readImageFromSandBox:(NSString *)imageName{

    NSString *path = [self getImagePathFromWithImageName:imageName];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}

-(NSString *)getImagePathFromWithImageName:(NSString *)imageName{

    //获取路径
    NSString *cache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    
    //拼接路径
    cache = [cache stringByAppendingString:imageName.lastPathComponent];
    return cache;
}

+(instancetype)shareSandBox{

    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[HMReadAndWriteToSandBox alloc]init];
    });
    return _instance;
}

@end
