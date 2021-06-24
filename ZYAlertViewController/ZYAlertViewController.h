//
//  ZYAlertViewController.h
//  ZYAlertViewController
//
//  Created by iDev01 on 2019/6/11.
//  Copyright © 2019 iDev01. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PresentDirection) {
    PresentDirectionCoverVertical,
    PresentDirectionCrossDissolve
};

@interface ZYAlertViewController : UIViewController

- (instancetype)initWithView:(UIView *)view presentDirection:(PresentDirection)presentDirection tapDismiss:(BOOL)tapDismiss;

@end

NS_ASSUME_NONNULL_END
