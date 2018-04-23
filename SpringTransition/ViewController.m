//
//  ViewController.m
//  SpringTransition
//
//  Created by David on 2018/3/13.
//  Copyright © 2018年 David. All rights reserved.
//

#import "ViewController.h"
#import "PopTableViewCell.h"

#import "TargetViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation ViewController

static NSString *identifier = @"cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:@"PopTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    
    self.tableView = tableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 440;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.showImageView.image = self.datas[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击");
    
    self.currentIndexPath = indexPath;
    
    TargetViewController *vc = [[TargetViewController alloc] init];
    
    vc.showImage = self.datas[indexPath.row];
    //设置导航控制器的代理为推出的控制器，可以达到自定义不同控制器的退出效果的目的
    self.navigationController.delegate = vc;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [[NSMutableArray alloc] init];
        [_datas addObject:[UIImage imageNamed:@"image1.jpg"]];
        [_datas addObject:[UIImage imageNamed:@"image2.jpg"]];
        [_datas addObject:[UIImage imageNamed:@"image3.jpg"]];
    }
    return _datas;
}

@end
