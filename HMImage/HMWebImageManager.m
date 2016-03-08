//
//  HMWebImageManager.m
//  01-HMImage(框架)
//
//  Created by yan on 15/12/7.
//  Copyright © 2015年 yan. All rights reserved.
//

#import "HMWebImageManager.h"
#import "HMNSOperation.h"

@implementation HMWebImageManager

//懒加载
-(NSOperationQueue *)queue{

    if (!_queue) {
        _queue = [[NSOperationQueue alloc]init];
    }
    return _queue;
}
-(NSMutableDictionary *)images{

    if (!_images) {
        _images = [NSMutableDictionary dictionary];
    }
    return _images;
}
-(NSMutableDictionary *)operations{

    if (!_operations) {
        _operations = [NSMutableDictionary dictionary];
    }
    return _operations;
}

//用这个类来管理下载的来管理下载的
//向外提供一个创建单例类的方法 创建单例的方法
+(instancetype)shareManager{

    static id _instance;
    static dispatch_once_t onceToken;
    //要用一次性代码
    dispatch_once(&onceToken, ^{
        
        _instance = [[self alloc]init];
        
    });
    return _instance;
    
}

//应该提供一个下载图片的方法
-(void)downloadImageWithUrlString:(NSString *)urlString showImageBlock:(showImageBlock)showBlock{
    
    //要有图片缓存和操作缓存
    //先要判断操作缓存中是否有操作
    HMNSOperation *op = self.operations[urlString];
    if (op) {
        //证明存在  说明正在下载  不需要重建等待下载完成即可
        NSLog(@"图片正在下载中....");
    }else{

    //下载图片 要用操作 下载图片要在子线程执行 加载到非主操作队列
    HMNSOperation *op = [[HMNSOperation alloc]init];
    //将操作添加到操作缓存中
    [self.operations setObject:op forKey:urlString];
        
    //告诉图片要下载哪一张图片
    op.urlString = urlString;
    
    //来给block赋值  确定block要执行什么操作  就是图片下载完成以后的回调
    [op setUpBlock:^(HMNSOperation *op) {
        //在这里面确定block要做的操作
        //在这显示图片显示图片
        if (op.image) {
            
            if (showBlock) {
                //在这显示图片 需要外界将block的具体操作传进来
                showBlock(op.image);
            }
            //图片下载完成以后  要加入到缓存中
            [self.images setObject:op.image forKey:urlString];
        }
        
        //当下载完成以后将操作缓存清除掉
        [self.operations removeObjectForKey:urlString];
    }];
    
    //创建非主操作队列 用懒加载 懒加载效率比较高 加载到操作队列中以后 操作才会被执行
    
    [self.queue addOperation:op];
        
    }
}

-(void)cancelOperationWith:(NSString *)urlString{
    
    //从操作缓存中获取到对应的操作
    HMNSOperation *op = self.operations[urlString];
    
    //取消该操作
    [op cancel];
    
    //操作取消了  但是还在缓存中存放着 浪费资源 删除掉
    [self.operations removeObjectForKey:urlString];
}


@end
