//
//  ZYAlertViewController.m
//  ZYAlertViewController
//
//  Created by iDev01 on 2019/6/11.
//  Copyright © 2019 iDev01. All rights reserved.
//

#import "ZYAlertViewController.h"
#import <sys/utsname.h>

@interface PresentAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic) PresentDirection presentDirection;
@property (strong, nonatomic) UIViewController *toViewController;
@property (assign, nonatomic) BOOL dismissWhenTap;

@end

@interface DismissAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic) PresentDirection presentDirection;

@end

@interface ZYAlertViewController ()<UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) PresentAnimator *presentAnimator;
@property (strong, nonatomic) DismissAnimator *dismissAnimator;
@property (assign, nonatomic) PresentDirection presentDirection;
@property (strong, nonatomic) UIView *contentView;
@property (assign, nonatomic) BOOL dismissWhenTap;

@end

@implementation ZYAlertViewController

- (instancetype)initWithView:(UIView *)view presentDirection:(PresentDirection)presentDirection dismissWhenTap:(BOOL)dismissWhenTap {
    if (self = [super init]) {
        self.contentView = view;
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
        self.presentDirection = presentDirection;
        self.presentAnimator = [PresentAnimator new];
        self.presentAnimator.presentDirection = presentDirection;
        self.dismissAnimator = [DismissAnimator new];
        self.dismissAnimator.presentDirection = presentDirection;
        self.dismissWhenTap = dismissWhenTap;
        self.presentAnimator.dismissWhenTap = dismissWhenTap;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.contentView];
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *widthGreaterThanOrEqualLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.view
                                                                                               attribute:NSLayoutAttributeWidth
                                                                                               relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                                                  toItem:self.contentView
                                                                                               attribute:NSLayoutAttributeWidth
                                                                                              multiplier:1
                                                                                                constant:0];
    NSLayoutConstraint *widthEqualLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.view
                                                                                  attribute:NSLayoutAttributeWidth
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:self.contentView
                                                                                  attribute:NSLayoutAttributeWidth
                                                                                 multiplier:1
                                                                                   constant:0];
    widthEqualLayoutConstraint.priority = 49;
    NSLayoutConstraint *heightLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.view
                                                                              attribute:NSLayoutAttributeHeight
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.contentView
                                                                              attribute:NSLayoutAttributeHeight
                                                                             multiplier:1
                                                                               constant:0];
    NSLayoutConstraint *centerXGreaterThanOrEqualLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                                               attribute:NSLayoutAttributeCenterX
                                                                                               relatedBy:NSLayoutRelationEqual
                                                                                                  toItem:self.view
                                                                                               attribute:NSLayoutAttributeCenterX
                                                                                              multiplier:1
                                                                                                constant:0];
    NSLayoutConstraint *centerYGreaterThanOrEqualLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                                               attribute:NSLayoutAttributeCenterY
                                                                                               relatedBy:NSLayoutRelationEqual
                                                                                                  toItem:self.view
                                                                                               attribute:NSLayoutAttributeCenterY
                                                                                              multiplier:1
                                                                                                constant:0];
    [self.view addConstraints:@[widthGreaterThanOrEqualLayoutConstraint,
                                widthEqualLayoutConstraint,
                                heightLayoutConstraint,
                                centerXGreaterThanOrEqualLayoutConstraint,
                                centerYGreaterThanOrEqualLayoutConstraint]];
    
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
    if (self.dismissWhenTap) {
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [bgView addGestureRecognizer:tapGR];
    }
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
    struct utsname systemInfo;

    uname(&systemInfo);

    BOOL isX = [self isNotchScreen];
    NSLayoutConstraint *topGreaterThanOrEqualLayoutConstraint = [NSLayoutConstraint constraintWithItem:toView
                                                                                             attribute:NSLayoutAttributeTop
                                                                                             relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                                                toItem:transitionContext.containerView
                                                                                             attribute:NSLayoutAttributeTop
                                                                                            multiplier:1
                                                                                              constant:isX ? 47 : 20];
    NSLayoutConstraint *bottomGreaterThanOrEqualLayoutConstraint;
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:toView
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:transitionContext.containerView
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1
                                                                constant:0];
    NSLayoutConstraint *bottomEqualLayoutConstraint;
    switch (self.presentDirection) {
        case PresentDirectionCoverVertical:
            bottomEqualLayoutConstraint = [NSLayoutConstraint constraintWithItem:toView
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:transitionContext.containerView
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1
                                                                        constant:isX ? -34 : -8];
            bottomGreaterThanOrEqualLayoutConstraint = [NSLayoutConstraint constraintWithItem:toView
                                                                                    attribute:NSLayoutAttributeBottom
                                                                                    relatedBy:NSLayoutRelationLessThanOrEqual
                                                                                       toItem:transitionContext.containerView
                                                                                    attribute:NSLayoutAttributeBottom
                                                                                   multiplier:1
                                                                                     constant:isX ? -34 : -8];
            break;
        case PresentDirectionCrossDissolve:
            bottomEqualLayoutConstraint = [NSLayoutConstraint constraintWithItem:toView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:transitionContext.containerView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
            bottomGreaterThanOrEqualLayoutConstraint = [NSLayoutConstraint constraintWithItem:toView
                                                                                    attribute:NSLayoutAttributeBottom
                                                                                    relatedBy:NSLayoutRelationLessThanOrEqual
                                                                                       toItem:transitionContext.containerView
                                                                                    attribute:NSLayoutAttributeBottom
                                                                                   multiplier:1
                                                                                     constant:isX ? -47 : -8];
            break;
    }

    [transitionContext.containerView addConstraints:@[
        topGreaterThanOrEqualLayoutConstraint,
        bottomGreaterThanOrEqualLayoutConstraint,
        centerX,
        bottomEqualLayoutConstraint]];
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

- (BOOL)isNotchScreen {

    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return NO;
    }

    CGSize size = [UIScreen mainScreen].bounds.size;
    NSInteger notchValue = size.width / size.height * 100;

    if (216 == notchValue || 46 == notchValue) {
        return YES;
    }

    return NO;
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
