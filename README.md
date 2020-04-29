# MZFreeLayout

## Abstract
MZFreeLayout的[Swift版本](https://github.com/MachelleZhang/MZTableLayout)<br>
自定义UICollectionView的Layout，实现类似Excel的功能。<br>
![Multi_Headers.gif](/Pictures/multi_header.gif)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS 8.0+

## Installation

MZMultiHeadersSheet is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MZFreeLayout', '~> 0.1.0'
```

## Usage<br>
e.g.<br>
![free_layout.png](/Pictures/free_layout.png)<br>
在已知表格样式的前提下，按从左到右，从上到下，依次添加索引，已编号的掠过，参考上图的索引规则<br>

1.引入头文件

```Objective-C
#import "MZFreeLayout.h"
```

2.设置代理

```Objective-C
MZFreeLayout *freeLayout = [[MZFreeLayout alloc] init];
freeLayout.delegate = self;
```

3.需要实现的主要代理方法

```Objective-C
#pragma mark - MZFreeLayoutDelegate
/**
 *  表格的基本宽度，1个单位长度实际的像素值，格式(float, float)，例：(50, 50)
 */
- (CGSize)baseSizeOfCollectionView:(UICollectionView *)collectionView {
    return CGSizeMake(100, 200);
}

/**
 *  表格的规模大小，格式(int, int)，例：(4, 5)，表示表格总体宽4个单位，高5个单位
 */
- (CGSize)scaleOfCollectionView:(UICollectionView *)collectionView {
    return CGSizeMake(5, 5);
}

/**
 *  每个cell的大小，用单位个数表示，格式(int, int)，例：(2, 1)，表示当前索引的元素宽2个单位，高1个单位
 */
- (CGSize)mzCollectionView:(UICollectionView *)collectionView cellSizeOfIndex:(NSInteger)index {
    NSArray *cellSize = self.datas[index];
    NSInteger width = ((NSNumber *)cellSize[0]).integerValue;
    NSInteger height = ((NSNumber *)cellSize[1]).integerValue;
    return CGSizeMake(width, height);
}

/**
 *  需要冻结的行列，格式(int, int)，例：(1,0)，表示第1列被冻结，可参照Excel的冻结规则
 */
- (CGSize)frozenUnitOfCollection:(UICollectionView *)collectionView {
    return CGSizeMake(1, 0);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}
```

## Update History
版本号|版本描述
---|---
0.1.0|从MZMultiHeadersSheet库分离出来

## Author

MachelleZhang, 407916482@qq.com

## License

MZFreeLayout is available under the MIT license. See the LICENSE file for more info.
