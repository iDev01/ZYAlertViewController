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
    vButton.frame = CGRectMake(50, 50, 200, 40);
    [vButton setTitle:@"下方弹出Alert" forState:UIControlStateNormal];
    [vButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [vButton addTarget:self action:@selector(vButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:vButton];
    UIButton *dButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dButton.frame = CGRectMake(50, 100, 200, 40);
    [dButton setTitle:@"溶解弹出Alert" forState:UIControlStateNormal];
    [dButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [dButton addTarget:self action:@selector(dButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dButton];
}

- (void)vButtonClicked:(id)sender {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(37.5, 500, 300, 200)];
    view.backgroundColor = [UIColor brownColor];
    ZYAlertViewController *alertVC = [[ZYAlertViewController alloc] initWithView:view presentDirection:PresentDirectionCoverVertical];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)dButtonClicked:(id)sender {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(37.5, 160, 300, 200)];
    view.backgroundColor = [UIColor brownColor];
    ZYAlertViewController *alertVC = [[ZYAlertViewController alloc] initWithView:view presentDirection:PresentDirectionCrossDissolve];
    [self presentViewController:alertVC animated:YES completion:nil];
}


@end
