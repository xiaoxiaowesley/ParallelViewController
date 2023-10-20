//
//
//  ContainerViewController.h
//  ios-multiply-viewcontroller-in-one-window
//
//  Created by 肖湘 on 2021/10/12.
//

#import <UIKit/UIKit.h>
#import "ParallelViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ParallelShoppingModeViewController : ParallelViewController

- (nullable UIViewController*)popViewControllerAnimated:
    (BOOL)animated;  // Returns the popped controller.

@end

NS_ASSUME_NONNULL_END
