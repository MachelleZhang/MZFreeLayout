//
//  MZFreeModel.m
//  MZFreeLayoutDemo
//
//  Created by ZhangLe on 2020/6/8.
//  Copyright © 2020 zhangle. All rights reserved.
//

#import "MZFreeModel.h"

@implementation MZFreeModel

+ (MZFreeModel *)initWithX:(NSInteger)x Y:(NSInteger)y {
    MZFreeModel *model = [[MZFreeModel alloc] init];
    model.x = x;
    model.y = y;
    return model;
}

@end
