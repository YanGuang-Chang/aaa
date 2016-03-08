//
//  HMNSOperation.m
//  01-HMImage(框架)
//
//  Created by yan on 15/12/7.
//  Copyright © 2015年 yan. All rights reserved.
//

#import "HMNSOperation.h"
#import "HMReadAndWriteToSandBox.h"

@implementation HMNSOperation

-(void)main{

    @autoreleasepool {
        //下载图片
        self.image = [self downloadImageWithUrlString:self.urlString];
        
        //显示图片 用block将图片传送出去 要在主线程去执行
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.myBlock) {
                //执行block
                self.myBlock(self);
            }
        });
    }
}

-(UIImage *)downloadImageWithUrlString:(NSString *)urlString{
    
    if (self.cancelled) {
        return nil;
    }

    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    if (self.cancelled) {
        return nil;
    }

    
    UIImage *image = [UIImage imageWithData:data];
    //在这图片下载好了  加入到缓存中
    HMReadAndWriteToSandBox *sandBox = [HMReadAndWriteToSandBox shareSandBox];
    
    if (self.cancelled) {
        return nil;
    }

    NSString *path = [sandBox getImagePathFromWithImageName:urlString];
    //将图片的二进制存入沙盒
    [data writeToFile:path atomically:YES];
    
    return image;
}

-(void)setUpBlock:(setUpImageBlock)blk{

    if (blk) {
        //给myBlock赋值
        self.myBlock = blk;
    }
}

@end
