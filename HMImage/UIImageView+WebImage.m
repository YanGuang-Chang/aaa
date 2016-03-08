//
//  UIImageView+WebImage.m
//  01-HMImage(框架)
//
//  Created by yan on 15/12/7.
//  Copyright © 2015年 yan. All rights reserved.
//

#import "UIImageView+WebImage.h"
#import <objc/runtime.h>
#import "HMWebImageManager.h"
#import "HMReadAndWriteToSandBox.h"
//@interface UIImageView (WebImage)
////每个imageview都有一张自己的图片
////oc中没有提供在分类中增加属性的方法 要用运行时语言添加属性
//@property(nonatomic,copy)NSString *urlString;
//
//@end


@implementation UIImageView (WebImage)

const void* urlStringkey = @"urlStringkey";
//实现set和get方法
-(void)setUrlString:(NSString *)urlString{

    //用运行时语言
    objc_setAssociatedObject(self, urlStringkey, urlString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString *)urlString{

    return objc_getAssociatedObject(self, urlStringkey);
}


-(void)setUpImageWithUrlString:(NSString *)urlString placedImageString:(NSString *)placed{

    //外面调用这个方法的时候  里面会自动将这个图片下载完成 加到缓存 和加到沙河中的一些操作
    //在这个方法里面下载图片
    //创建一个单例的对象
    
    HMWebImageManager *manager = [HMWebImageManager shareManager];
    //下面就要进行判断 缓存中是否存在图片
    UIImage *image = manager.images[urlString];
    if (image) {
        self.image = image;
        return;
    }
    //如果缓存中没有  在看看沙盒中是否有图片
    HMReadAndWriteToSandBox *sandBox = [HMReadAndWriteToSandBox shareSandBox];
    UIImage *sandImage = [sandBox readImageFromSandBox:urlString];
    //如果沙盒中存在图片
    if (sandImage) {
        //显示图片
        self.image = sandImage;
        //将图片放入内存缓存中  避免过多的去进行I/O操作
        [manager.images setObject:sandImage forKey:urlString];
        return;
    }
    //如果缓存中和沙盒中都没有图片 就加载占位图片
    self.image = [UIImage imageNamed:placed];
    //当网络较慢的时候和cell重用的时候 会出现图片错位的现象  因为当前下载的传入过来的需要下载的图片 不是一张  这时取消这个操作 并且将这个操作删除
    //当一样的时候
    if (self.urlString && [self.urlString isEqualToString:urlString]) {
        NSLog(@"图片正在下载....");
        return;
    }
    //当图片不一样的时候 要取消这个操作 并且将操作删除
    if (self.urlString && ![self.urlString isEqualToString:urlString]) {
        
        //取消对应的操作缓存
        [manager cancelOperationWith:self.urlString];
        //开始新的下载
        self.urlString = urlString;
        
        //下载图片
        [manager downloadImageWithUrlString:urlString showImageBlock:^(UIImage *image) {
            self.image = image;
        }];
    }
    
    if (!self.urlString) {
        
        self.urlString = urlString;
        
        //下载图片
        [manager downloadImageWithUrlString:urlString showImageBlock:^(UIImage *image) {
            self.image = image;
        }];
    }
    
    
}

@end
