//
//  MZFreeModel.h
//  MZFreeLayoutDemo
//
//  Created by ZhangLe on 2020/6/8.
//  Copyright © 2020 zhangle. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZFreeModel : NSObject

@property (nonatomic, assign) NSInteger x;
@property (nonatomic, assign) NSInteger y;

+ (MZFreeModel *)initWithX:(NSInteger)x Y:(NSInteger)y;

@end

NS_ASSUME_NONNULL_END
