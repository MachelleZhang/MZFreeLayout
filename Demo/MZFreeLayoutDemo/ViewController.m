//
//  ViewController.m
//  MZFreeLayoutDemo
//
//  Created by ZhangLe on 2020/6/8.
//  Copyright © 2020 zhangle. All rights reserved.
//

#import "ViewController.h"
#import "MZFreeLayoutVC.h"
#import "MZFreeLayoutDemo2.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *datas;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Demos";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.datas = @[@"Demo1", @"Demo2"];
    
    [self.view addSubview:self.tableView];
}

//MARK: - Table view delegate and data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        MZFreeLayoutVC *demo1 = [[MZFreeLayoutVC alloc] init];
        [self.navigationController pushViewController:demo1 animated:YES];
    } else if (indexPath.row == 1) {
        MZFreeLayoutDemo2 *demo2 = [[MZFreeLayoutDemo2 alloc] init];
        [self.navigationController pushViewController:demo2 animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = self.datas[indexPath.row];
    return cell;
}

//MARK: - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = self.view.bounds;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    }
    return _tableView;
}


@end
