//
//  TransitionAnimation.h
//  SpringTransition
//
//  Created by David on 2018/4/8.
//  Copyright © 2018年 David. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransitionAnimation : NSObject <UIViewControllerAnimatedTransitioning>

+ (instancetype)transitionWithType:(UINavigationControllerOperation)type;

@end
