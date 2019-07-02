//
//  ZYAlertViewController.m
//  ZYAlertViewController
//
//  Created by iDev01 on 2019/6/11.
//  Copyright © 2019 iDev01. All rights reserved.
//

#import "ZYAlertViewController.h"
#import <Masonry/Masonry.h>

@interface PresentAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic) PresentDirection presentDirection;
@property (strong, nonatomic) UIViewController *toViewController;

@end

@interface DismissAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic) PresentDirection presentDirection;

@end

@interface ZYAlertViewController ()<UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) PresentAnimator *presentAnimator;
@property (strong, nonatomic) DismissAnimator *dismissAnimator;

@end

@implementation ZYAlertViewController

- (instancetype)initWithView:(UIView *)view presentDirection:(PresentDirection)presentDirection {
    if (self = [super init]) {
        self.view = view;
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
        self.presentAnimator = [PresentAnimator new];
        self.presentAnimator.presentDirection = presentDirection;
        self.dismissAnimator = [DismissAnimator new];
        self.dismissAnimator.presentDirection = presentDirection;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.dismissAnimator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self.presentAnimator;
}

@end

@implementation PresentAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = [UIColor clearColor];
    [transitionContext.containerView addSubview:bgView];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [bgView addGestureRecognizer:tapGR];
    self.toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    CGRect storeFrame = toView.frame;
    CGRect frame = toView.frame;
    switch (self.presentDirection) {
        case PresentDirectionCoverVertical:
            frame.origin.y = [UIScreen mainScreen].bounds.size.height;
            toView.frame = frame;
            break;
        case PresentDirectionCrossDissolve:
            toView.alpha = 0;
            break;
        default:
            break;
    }
    [transitionContext.containerView addSubview:toView];
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
                         toView.frame = storeFrame;
                         toView.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:finished];
                     }];
}

- (void)tap:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self.toViewController dismissViewControllerAnimated:YES completion:nil];
}

@end

@implementation DismissAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *bgView = transitionContext.containerView.subviews[0];
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         CGRect frame = fromView.frame;
                         switch (self.presentDirection) {
                             case PresentDirectionCoverVertical:
                                 frame.origin.y = [UIScreen mainScreen].bounds.size.height;
                                 fromView.frame = frame;
                                 break;
                             case PresentDirectionCrossDissolve:
                                 fromView.alpha = 0;
                                 break;
                             default:
                                 break;
                         }
                         bgView.backgroundColor = [UIColor clearColor];
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:finished];
                     }];
}

@end
