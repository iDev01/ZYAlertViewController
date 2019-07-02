//
//  ViewController.m
//  Example
//
//  Created by Ma Hao on 2019/7/2.
//  Copyright © 2019 idev01. All rights reserved.
//

#import "ViewController.h"
#import "ZYAlertViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 90, 40)];
    [button setTitle:@"点我弹Alert" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)clicked:(id)sender {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    view.backgroundColor = [UIColor brownColor];
    ZYAlertViewController *alertVC = [[ZYAlertViewController alloc] initWithView:view presentDirection:PresentDirectionCoverVertical];
    [self presentViewController:alertVC animated:YES completion:nil];
}


@end
