//
//  HMWebImageManager.h
//  01-HMImage(框架)
//
//  Created by yan on 15/12/7.
//  Copyright © 2015年 yan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^showImageBlock)(UIImage *image);

@interface HMWebImageManager : NSObject

@property(nonatomic,strong)NSOperationQueue *queue;
@property(nonatomic,strong)NSMutableDictionary *images;
@property(nonatomic,strong)NSMutableDictionary *operations;


@property(nonatomic,copy)showImageBlock myBlock;

+(instancetype)shareManager;

-(void)downloadImageWithUrlString:(NSString *)urlString showImageBlock:(showImageBlock)blk;

-(void)cancelOperationWith:(NSString *)urlString;



@end
