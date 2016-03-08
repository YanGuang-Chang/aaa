//
//  HMNSOperation.h
//  01-HMImage(框架)
//
//  Created by yan on 15/12/7.
//  Copyright © 2015年 yan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class HMNSOperation;

typedef void(^setUpImageBlock)(HMNSOperation *op);

@interface HMNSOperation : NSOperation

@property(nonatomic,strong)UIImage *image;

@property(nonatomic,copy)NSString *urlString;

@property(nonatomic,copy)setUpImageBlock myBlock;

-(void)setUpBlock:(setUpImageBlock)blk;

@end
