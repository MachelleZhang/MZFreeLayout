//
//  MZFreeLayout.m
//  MZFreeLayout
//
//  Created by zhangle on 16/4/6.
//  Copyright © 2018年 Machelle. All rights reserved.
//

#import "MZFreeLayout.h"

@interface MZFreeLayout ()

@property(strong, nonatomic) NSMutableArray *itemAttributes;
@property(nonatomic, assign) CGSize contentSize;

@end

@implementation MZFreeLayout

/**
 *  自定义布局
 */
- (void)prepareLayout {
    // 有无数据都需要初始化，因为有复用
    self.itemAttributes = [NSMutableArray array];
    //没有元素，直接返回
    if ([self.collectionView numberOfItemsInSection:0] == 0) {
        return;
    }
    
    if (self.delegate == nil) {
        return;
    }
    
    //获取需要冻结的行列坐标
    MZFreeModel *frozenUnit = [MZFreeModel initWithX:0 Y:0];
    if ([self.delegate respondsToSelector:@selector(frozenUnitOfCollection:)]) {
        frozenUnit = [self.delegate frozenUnitOfCollection:self.collectionView];
    }
    
    MZFreeModel *scale = [self scaleOfCollectionView:self.collectionView];
    
//    CGSize baseSize = [self baseSizeOfCollectionView:self.collectionView];
    
    CGFloat cellWidth = 0;
    for (int i=0; i<scale.x; i++) {
        CGFloat curCellWidth  = [self baseWidthOfCollectionView:self.collectionView cellWidthOf:i];
        cellWidth += curCellWidth;
    }
    
    CGFloat cellHeight = 0;
    for (int i=0; i<scale.y; i++) {
        CGFloat curCellHeight = [self baseHeightOfCollectionView:self.collectionView cellHeightOf:i];
        cellHeight += curCellHeight;
    }

    //根据规模和每行每列的宽高，可以确定content size的大小
    self.contentSize = CGSizeMake(cellWidth + (scale.x - 1) * self.itemSpacing + 2 * self.itemMargin,
                                  cellHeight + (scale.y - 1) * self.itemSpacing + 2 * self.itemMargin);
    //根据规模生成占位数组,例如 3 * 3 的规模
    //  [ [1, 1, 1],
    //    [1, 1, 1],
    //    [1, 1, 1] ]
    NSMutableArray *seatArray = [NSMutableArray array];
    for (int i=0; i<scale.y; i++) {
        NSMutableArray *rowArray = [NSMutableArray array];
        for (int j=0; j<scale.x; j++) {
            [rowArray addObject:@(1)];
        }
        [seatArray addObject:rowArray];
    }

    //初始化
    NSInteger xOffset = 0;       //元素的x坐标(单位坐标系)
    NSInteger yOffset = 0;       //元素的y坐标
    
    NSInteger endFlag = 0; //结束标志，0=未结束；1=全部插入，正常结束；2=空间不足，异常退出
    for (int index=0; index<[self.collectionView numberOfItemsInSection:0]; index++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        MZFreeModel *curItemScale = [self mzCollectionView:self.collectionView cellSizeOfIndex:index];
        BOOL isFind = NO; //当前索引的元素是否正确插入
        NSInteger tempX_single = xOffset; //单次寻位的坐标
        NSInteger tempY_single = yOffset;
        while (!isFind && endFlag == 0) {
            BOOL isFind_single = [self findTheRightPlaceWithScale:curItemScale seatArray:seatArray startX:tempX_single startY:tempY_single];
            if (!isFind_single) {
                //移向下一个检查起点
                tempX_single += 1;
                if (tempX_single >= scale.x) {
                    tempX_single = 0;
                    tempY_single += 1;
                }
                if (tempY_single >= scale.y) {
                    //超出范围，结束
                    endFlag = 1;
                }
            } else {
                isFind = YES;
                //生成位置属性，保存
                CGFloat atWidthPerCell = 0;
                for (int i=0; i<tempX_single; i++) {
                    CGFloat curCellWidth = [self baseWidthOfCollectionView:self.collectionView cellWidthOf:i];
                    atWidthPerCell += curCellWidth;
                }
                CGFloat atWidth = atWidthPerCell + tempX_single * self.itemSpacing + self.itemMargin;
                
                CGFloat atHeightPerCell = 0;
                for (int i=0; i<tempY_single; i++) {
                    CGFloat curCellHeight = [self baseHeightOfCollectionView:self.collectionView cellHeightOf:i];
                    atHeightPerCell += curCellHeight;
                }
                CGFloat atHeight = atHeightPerCell + tempY_single * self.itemSpacing + self.itemMargin;
                
                //冻结行列的坐标偏移
                if (frozenUnit.x != 0 || frozenUnit.y != 0) {
                    if (tempX_single < frozenUnit.x && tempY_single < frozenUnit.y) {
                        atWidth += self.collectionView.contentOffset.x;
                        atHeight += self.collectionView.contentOffset.y;
                        attributes.zIndex = 1024;
                    } else if (tempX_single < frozenUnit.x) {
                        atWidth += self.collectionView.contentOffset.x;
                        attributes.zIndex = 1023;
                    } else if (tempY_single < frozenUnit.y) {
                        atHeight += self.collectionView.contentOffset.y;
                        attributes.zIndex = 1023;
                    }
                }
                
                CGFloat itemWidth = 0;
                for (NSInteger i=tempX_single; i<(tempX_single + curItemScale.x); i++) {
                    CGFloat curCellWidth = [self baseWidthOfCollectionView:self.collectionView cellWidthOf:i];
                    itemWidth += curCellWidth;
                }
                itemWidth += (curItemScale.x - 1) * self.itemSpacing;
        
                CGFloat itemHeight = 0;
                for (NSInteger i=tempY_single; i<(tempY_single + curItemScale.y); i++) {
                    CGFloat curCellHeight = [self baseHeightOfCollectionView:self.collectionView cellHeightOf:i];
                    itemHeight += curCellHeight;
                }
                itemHeight += (curItemScale.y - 1)* self.itemSpacing;
                
                attributes.frame = CGRectMake(atWidth,
                                              atHeight,
                                              itemWidth,
                                              itemHeight);
                [self.itemAttributes addObject:attributes];
                
                //移向下一个元素位置
                xOffset = tempX_single + curItemScale.x;
                yOffset = tempY_single;
                if (xOffset >= scale.x) {
                    xOffset = 0;
                    yOffset += 1;
                }
                if (yOffset >= scale.y && index+1 != [self.collectionView numberOfItemsInSection:0]) {
                    endFlag = 2;
                }
            }
        } // while-end
        if (endFlag == 2) {
            break;
        }
    }// for-end
    
    if (endFlag == 2) {
        //异常退出时，所有布局显示为空
        [self.itemAttributes removeAllObjects];
        for (int i=0; i<[self.collectionView numberOfItemsInSection:0]; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame = CGRectZero;
            [self.itemAttributes addObject:attributes];
        }
    }
}

//单个元素寻位
- (BOOL)findTheRightPlaceWithScale:(MZFreeModel *)itemScale seatArray:(NSArray *)seatArray
                            startX:(NSInteger)startX startY:(NSInteger)startY {
    NSMutableArray *tempSeatArray = [NSMutableArray array];
    BOOL isAllSeatAvailable = YES;
    for (int m=0; m<itemScale.y; m++) {
        BOOL isRestart = NO; //外循环停止标志
        NSInteger tempY = startY + m;
        for (int n=0; n<itemScale.x; n++) {
            NSInteger tempX = startX + n;
            //超出数组范围，寻位失败
            if (tempY >= seatArray.count || tempX >= ((NSArray *)seatArray[0]).count) {
                isRestart = YES;
                isAllSeatAvailable = NO;
                break;
            }
            if (((NSNumber *)seatArray[tempY][tempX]).integerValue == 1) {
                NSValue *value = [NSValue valueWithCGSize:CGSizeMake(tempX, tempY)];
                [tempSeatArray addObject:value];
            } else {
                //停止内层循环，告知此次寻位失败
                isRestart = YES;
                isAllSeatAvailable = NO;
                break;
            }
        }
        //停止外层循环
        if (isRestart) {
            break;
        }
    }
    if (isAllSeatAvailable) {
        //找到正确位置，flag占位
        for (int i=0; i<tempSeatArray.count; i++) {
            NSValue *value = tempSeatArray[i];
            CGSize seatLocation = [value CGSizeValue];
            NSInteger x = seatLocation.width;
            NSInteger y = seatLocation.height;
            seatArray[y][x] = @(0);
        }
        return YES;
    } else {
        return NO;
    }
}

/**
 *  返回在指定rect内的布局属性
 *  这里是通过判断元素的frame和rect是否有交集来确定是否需要显示
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [NSMutableArray array];
    [attributes addObjectsFromArray:
     [self.itemAttributes filteredArrayUsingPredicate:
      [NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
        return CGRectIntersectsRect( rect, [evaluatedObject frame]);
    }]]];
    return attributes;
}

/**
 *  返回每个位置的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.itemAttributes[indexPath.row];
}

/**
 *  返回整个content size的大小
 */
- (CGSize)collectionViewContentSize {
    return self.contentSize;
}

/**
 *  当边界值改变时，是否刷新
 *  返回yes则会在每次滚动时调用prepareLayout
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

#pragma mark - Delegate
//- (CGSize)baseSizeOfCollectionView:(UICollectionView *)collectionView {
//    if ([self.delegate respondsToSelector:@selector(baseSizeOfCollectionView:)]) {
//        return [self.delegate baseSizeOfCollectionView:collectionView];
//    }
//    return CGSizeZero;
//}

- (CGFloat)baseWidthOfCollectionView:(UICollectionView *)collectionView cellWidthOf:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(baseWidthOfCollectionView:cellWidthOf:)]) {
        return [self.delegate baseWidthOfCollectionView:collectionView cellWidthOf:index];
    }
    return 0;
}


- (CGFloat)baseHeightOfCollectionView:(UICollectionView *)collectionView cellHeightOf:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(baseHeightOfCollectionView:cellHeightOf:)]) {
        return [self.delegate baseHeightOfCollectionView:collectionView cellHeightOf:index];
    }
    return 0;
}

- (MZFreeModel *)scaleOfCollectionView:(UICollectionView *)collectionView {
    if ([self.delegate respondsToSelector:@selector(scaleOfCollectionView:)]) {
        return [self.delegate scaleOfCollectionView:collectionView];
    }
    return [MZFreeModel initWithX:0 Y:0];
}

- (MZFreeModel *)mzCollectionView:(UICollectionView *)collectionView cellSizeOfIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(mzCollectionView:cellSizeOfIndex:)]) {
        return [self.delegate mzCollectionView:collectionView cellSizeOfIndex:index];
    }
    return [MZFreeModel initWithX:0 Y:0];
}

@end
