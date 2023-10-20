//
//
//  UIViewController+ParallelViewControllerItem.h
//
//  Create by wesleyxiao on 2021/11/12
//  Copyright © 2021 xiaoxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParallelViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ParallelViewControllerItem)
@property(nonatomic, readonly, strong) UINavigationItem* parallelNavigationItem;
@property(nullable, nonatomic, readwrite, strong) ParallelViewController* parallelViewController;
@end

NS_ASSUME_NONNULL_END
