//
//  MZFreeLayoutDemo2.m
//  MZFreeLayoutDemo
//
//  Created by ZhangLe on 2020/6/8.
//  Copyright © 2020 zhangle. All rights reserved.
//

#import "MZFreeLayoutDemo2.h"
#import "MZFreeLayout.h"
#import "MZCollectionViewCell.h"

static NSString *cellIdentifier_demo2 = @"MZCollectionViewCell";

@interface MZFreeLayoutDemo2 () <MZFreeLayoutDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation MZFreeLayoutDemo2

#pragma mark - Init
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initForView];
}

- (void)initForView {
    self.title = @"Demo2";
    self.view.backgroundColor = [UIColor whiteColor];
    
    MZFreeLayout *freeLayout = [[MZFreeLayout alloc] init];
    freeLayout.delegate = self;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height - 140) collectionViewLayout:freeLayout];
    [self.collectionView registerNib:[UINib nibWithNibName:cellIdentifier_demo2 bundle:nil] forCellWithReuseIdentifier:cellIdentifier_demo2];
    self.collectionView.layer.borderWidth = 1;
    self.collectionView.layer.borderColor = [UIColor grayColor].CGColor;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.bounces = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.directionalLockEnabled = YES;
    [self.view addSubview:self.collectionView];
}

#pragma mark - MZFreeSheetLayoutDelegate
/**
 *  单元格的基本宽度
 */
- (CGFloat)baseWidthOfCollectionView:(UICollectionView *)collectionView cellWidthOf:(NSInteger)index {
    return 40;
}

/**
 *  单元格的基本高度
 */
- (CGFloat)baseHeightOfCollectionView:(UICollectionView *)collectionView cellHeightOf:(NSInteger)index {
    return 50;
}

/**
 *  表格的规模大小，格式(int, int)，例：(4, 5)，表示表格总体宽4个单位，高5个单位
 */
- (MZFreeModel *)scaleOfCollectionView:(UICollectionView *)collectionView {
    return [MZFreeModel initWithX:20 Y:20];
}

/**
 *  每个cell的大小，用单位个数表示，格式(int, int)，例：(2, 1)，表示当前索引的元素宽2个单位，高1个单位
 */
- (MZFreeModel *)mzCollectionView:(UICollectionView *)collectionView cellSizeOfIndex:(NSInteger)index {
    return [MZFreeModel initWithX:1 Y:1];
}

- (MZFreeModel *)frozenUnitOfCollection:(UICollectionView *)collectionView {
    return [MZFreeModel initWithX:0 Y:1];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 400;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MZCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier_demo2 forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.layer.borderWidth = 0.5;
    cell.title.text = [NSString stringWithFormat:@"%@", @(indexPath.row)];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSLog(@"%@", @(indexPath.row));
}

@end

