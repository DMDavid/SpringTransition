//
//  TransitionAnimation.m
//  SpringTransition
//
//  Created by David on 2018/4/8.
//  Copyright © 2018年 David. All rights reserved.
//

#import "TransitionAnimation.h"

#import "ViewController.h"
#import "TargetViewController.h"
#import "PopTableViewCell.h"

@interface TransitionAnimation ()

@property (nonatomic, assign) UINavigationControllerOperation operation;

@end

@implementation TransitionAnimation

+ (instancetype)transitionWithType:(UINavigationControllerOperation)type {
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(UINavigationControllerOperation)type {
    self = [super init];
    if (self) {
        _operation = type;
    }
    return self;
}

//动画时长
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.7;
}

//所有的过渡动画事务都在这个方法里面完成
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    if (_operation == UINavigationControllerOperationPush) {
        [self pushAnimation:transitionContext];
        
    } else if (_operation == UINavigationControllerOperationPop) {
        [self popAnimation:transitionContext];
    }
    
}

- (void)pushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    ViewController *fromVC = (ViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    TargetViewController *toVC = (TargetViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //拿到当前点击的cell的imageView
    PopTableViewCell *cell = (PopTableViewCell *)[fromVC.tableView cellForRowAtIndexPath:fromVC.currentIndexPath];
    UIView *containerView = [transitionContext containerView];
    
    //snapshotViewAfterScreenUpdates 对cell的imageView截图保存成另一个视图用于过渡，并将视图转换到当前控制器的坐标
    UIView *tempView = [cell.cellContentView snapshotViewAfterScreenUpdates:YES];
    tempView.frame = [cell.cellContentView convertRect:cell.cellContentView.bounds toView: containerView];
    //设置动画前的各个控件的状态
    cell.imageView.hidden = YES;
    toVC.view.alpha = 0;
    toVC.topImageView.hidden = YES;
    //tempView 添加到containerView中，要保证在最前方，所以后添加
    [containerView addSubview:toVC.view];
    [containerView addSubview:tempView];
    //开始做动画
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:6.5f options:0 animations:^{
        tempView.frame = [toVC.topImageView convertRect:toVC.topImageView.bounds toView:containerView];
        toVC.view.alpha = 1;
    } completion:^(BOOL finished) {
        tempView.hidden = YES;
        toVC.topImageView.hidden = NO;
        //如果动画过渡取消了就标记不完成，否则才完成，这里可以直接写YES，如果有手势过渡才需要判断，必须标记，否则系统不会中动画完成的部署，会出现无法交互之类的bug
        [transitionContext completeTransition:YES];
    }];
}

- (void)popAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    TargetViewController *fromVC = (TargetViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    ViewController *toVC = (ViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    PopTableViewCell *cell = (PopTableViewCell *)[toVC.tableView cellForRowAtIndexPath:toVC.currentIndexPath];
    UIView *containerView = [transitionContext containerView];
    //这里的lastView就是push时候初始化的那个tempView
    UIView *tempView = containerView.subviews.lastObject;
    //设置初始状态
    cell.cellContentView.hidden = YES;
    fromVC.topImageView.hidden = YES;
    tempView.hidden = NO;
    [containerView insertSubview:toVC.view atIndex:0];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:1.5 initialSpringVelocity:1 / 0.3 options:0 animations:^{
        tempView.frame = [cell.cellContentView convertRect:cell.cellContentView.bounds toView:containerView];
        fromVC.view.alpha = 0;
    } completion:^(BOOL finished) {
        //由于加入了手势必须判断
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if ([transitionContext transitionWasCancelled]) {//手势取消了，原来隐藏的imageView要显示出来
            //失败了隐藏tempView，显示fromVC.imageView
            tempView.hidden = YES;
            cell.cellContentView.hidden = NO;
//            fromVC.imageView.hidden = NO;
        }else{//手势成功，cell的imageView也要显示出来
            //成功了移除tempView，下一次pop的时候又要创建，然后显示cell的imageView
            cell.imageView.hidden = NO;
            cell.cellContentView.hidden = NO;
            [tempView removeFromSuperview];
        }
    }];
}


@end
