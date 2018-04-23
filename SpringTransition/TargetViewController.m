//
//  TargetViewController.m
//  SpringTransition
//
//  Created by David on 2018/3/15.
//  Copyright © 2018年 David. All rights reserved.
//

#import "TargetViewController.h"
#import "TransitionAnimation.h"

@interface TargetViewController ()

@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation TargetViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.topImageView];
    self.topImageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 440);
    
    [self.view addSubview:self.closeButton];
    UIImage *closeImage = [UIImage imageNamed:@"machineClose"];
    self.closeButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 20 - closeImage.size.width, 20, closeImage.size.width, closeImage.size.height);
    [self.closeButton addTarget:self action:@selector(closeButtonDidClose:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)closeButtonDidClose:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)setShowImage:(UIImage *)showImage {
    _showImage = showImage;
    self.topImageView.image = showImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    //分pop和push两种情况分别返回动画过渡代理相应不同的动画操作
    return [TransitionAnimation transitionWithType:operation];
}

//- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
//    //手势开始的时候才需要传入手势过渡代理，如果直接点击pop，应该传入空，否者无法通过点击正常pop
//    return _interactiveTransition.interation ? _interactiveTransition : nil;
//}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setImage:[UIImage imageNamed:@"machineClose"] forState:UIControlStateNormal];
    }
    return _closeButton;
}

- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] init];
    }
    return _topImageView;
}

@end
