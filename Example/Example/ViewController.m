//
//  ViewController.m
//  Example
//
//  Created by Ma Hao on 2019/7/2.
//  Copyright © 2019 idev01. All rights reserved.
//

#import "ViewController.h"
#import <ZYAlertViewController/ZYAlertViewController.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UIButton *vButton = [UIButton buttonWithType:UIButtonTypeCustom];
    vButton.frame = CGRectMake(UIScreen.mainScreen.bounds.size.width / 2 - 100, 200, 200, 40);
    [vButton setTitle:@"下方弹出Alert" forState:UIControlStateNormal];
    [vButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [vButton addTarget:self action:@selector(vButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:vButton];
    UIButton *dButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dButton.frame = CGRectMake(UIScreen.mainScreen.bounds.size.width / 2 - 100, 300, 200, 40);
    [dButton setTitle:@"溶解弹出Alert" forState:UIControlStateNormal];
    [dButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [dButton addTarget:self action:@selector(dButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dButton];
}

- (void)vButtonClicked:(id)sender {
    UIView *view = [[UIView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.backgroundColor = [UIColor brownColor];
    NSLayoutConstraint *wlc = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:300];
    NSLayoutConstraint *ylc = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:150];
    [view addConstraints:@[wlc, ylc]];
    ZYAlertViewController *alertVC = [[ZYAlertViewController alloc] initWithView:view presentDirection:PresentDirectionCoverVertical];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)dButtonClicked:(id)sender {
    UIView *view = [[UIView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.backgroundColor = [UIColor brownColor];
    NSLayoutConstraint *wlc = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:300];
    NSLayoutConstraint *ylc = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:500];
    [view addConstraints:@[wlc, ylc]];
    ZYAlertViewController *alertVC = [[ZYAlertViewController alloc] initWithView:view presentDirection:PresentDirectionCrossDissolve];
    [self presentViewController:alertVC animated:YES completion:nil];
}


@end
