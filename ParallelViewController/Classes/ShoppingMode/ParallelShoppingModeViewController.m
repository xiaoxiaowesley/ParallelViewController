//
//
//  ContainerViewController.m
//  ios-multiply-viewcontroller-in-one-window
//
//  Created by 肖湘 on 2021/10/12.
//

#import "ParallelShoppingModeViewController.h"
#import <objc/runtime.h>
#import "ParallelChildViewControllerWrapperView.h"
#import "UIViewController+ParallelViewControllerItem.h"

@interface ParallelShoppingModeViewController () <ParallelChildViewContollerWrapperViewDelegate> {
    UIViewController* _leftRootViewController;
    UIViewController* _rightRootViewController;
}
@end

@implementation ParallelShoppingModeViewController

#pragma mark - Override ParallelViewController Event Methods
- (void)layoutInitLeftViewController:(UIViewController*)leftViewController
                 rightViewController:(UIViewController*)rightViewController
                         orientation:(MyDeviceOrientation)orientation {
    _leftRootViewController = leftViewController;
    _rightRootViewController = rightViewController;

    [self layoutLeftViewController:leftViewController
                          delegate:self
                  showNaigationBar:[self canShowNaigationBar:leftViewController]];

    [self layoutRightViewController:rightViewController
                           delegate:self
                   showNaigationBar:[self canShowNaigationBar:leftViewController]];

    [self updateViewControllers:self.view.bounds.size
                          orientation:orientation
        autoAdjustRightViewController:YES];
}

- (void)orientationDidChange:(CGSize)size
                      orientation:(MyDeviceOrientation)orientation
    autoAdjustRightViewController:(BOOL)autoAdjust {
    [self updateViewControllers:size
                          orientation:orientation
        autoAdjustRightViewController:autoAdjust];
}

- (nullable UIViewController*)popViewControllerAnimated:(BOOL)animated {
    if (self.viewControllers.count > 2) {
        if ([super currentOrientation] == MyDeviceOrientationPortrait) {
            return [self popFullScreenModeViewControllerAnimated:animated];
        } else {
            return [self popParallelModeViewControllerAnimated:animated];
        }
    } else {
        NSLog(@"can not pop");
        return nil;
    }
}

- (nullable UIViewController*)popFullScreenModeViewControllerAnimated:(BOOL)animated {
    UIViewController* lastViewController =
        [self.viewControllers objectAtIndex:self.viewControllers.count - 1];

    UIViewController* visibleViewController = nil;
    // When viewControllers.count == 3, index of 0 viewcontroller is on the top
    if (self.viewControllers.count == 3) {
        visibleViewController = [self.viewControllers objectAtIndex:0];
    } else {
        visibleViewController = [self.viewControllers objectAtIndex:self.viewControllers.count - 2];
    }

    UIView* lastWrapper = [super getWrapperViewByViewController:lastViewController];
    [lastViewController willMoveToParentViewController:nil];
    if (animated) {
        [lastViewController beginAppearanceTransition:NO animated:animated];
        [visibleViewController beginAppearanceTransition:YES animated:animated];

        [UIView animateWithDuration:0.35
            animations:^{
              lastWrapper.frame = [self fullScreenModeExitEndViewFrame];
            }
            completion:^(BOOL finished) {
              [lastWrapper removeFromSuperview];
              [lastViewController endAppearanceTransition];
              [lastViewController removeFromParentViewController];

              [visibleViewController endAppearanceTransition];
            }];
    } else {
        [lastWrapper removeFromSuperview];
        [lastViewController beginAppearanceTransition:NO animated:animated];
        [visibleViewController beginAppearanceTransition:YES animated:animated];

        [lastViewController endAppearanceTransition];
        [visibleViewController endAppearanceTransition];
        [lastViewController removeFromParentViewController];
    }

    [super popViewControllerAnimated:animated];
    return lastViewController;
}

- (nullable UIViewController*)popParallelModeViewControllerAnimated:(BOOL)animated {
    UIViewController* secondToLastViewController =
        [self.viewControllers objectAtIndex:self.viewControllers.count - 2];
    UIViewController* lastViewController =
        [self.viewControllers objectAtIndex:self.viewControllers.count - 1];

    UIViewController* visibleViewController = nil;
    if (self.viewControllers.count == 4) {
        visibleViewController = [self.viewControllers objectAtIndex:0];
    } else {
        visibleViewController = [self.viewControllers objectAtIndex:self.viewControllers.count - 2];
    }

    UIView* secondToLastWrapper = [super getWrapperViewByViewController:secondToLastViewController];
    UIView* lastWrapper = [super getWrapperViewByViewController:lastViewController];

    [lastViewController willMoveToParentViewController:nil];

    [lastViewController beginAppearanceTransition:NO animated:animated];
    [visibleViewController beginAppearanceTransition:YES animated:animated];

    if (animated) {
        [UIView animateWithDuration:0.35
            animations:^{
              lastWrapper.frame = [self newViewStartFrame];
              secondToLastWrapper.frame = [self rightViewFrame];
            }
            completion:^(BOOL finished) {
              [lastWrapper removeFromSuperview];

              [lastViewController endAppearanceTransition];
              [visibleViewController endAppearanceTransition];

              [lastViewController removeFromParentViewController];
            }];
    } else {
        // WrapperView removeFromSuperView,ViewController remove from ParentView
        [lastWrapper removeFromSuperview];

        [lastViewController beginAppearanceTransition:NO animated:animated];
        [visibleViewController beginAppearanceTransition:YES animated:animated];

        [lastViewController endAppearanceTransition];
        [visibleViewController endAppearanceTransition];
        [lastViewController removeFromParentViewController];
        // Move to right side because Second to last ViewController become the last ViewController
        secondToLastWrapper.frame = [self rightViewFrame];
    }

    [super popViewControllerAnimated:animated];
    return lastViewController;
}

#pragma mark - Private Methods

- (void)updateViewControllers:(CGSize)size
                      orientation:(MyDeviceOrientation)orientation
    autoAdjustRightViewController:(BOOL)autoAdjust {
    NSAssert(self.viewControllers.count >= 2, @"self.viewControllers count can't less than 2");

    CGFloat halfWidth = (size.width - [super hingeWidth]) / 2.0;
    CGRect leftViewFrame = CGRectMake(0, 0, halfWidth, size.height);
    CGRect rightViewFrame =
        CGRectMake(halfWidth + [super hingeWidth], 0, size.width / 2.0, size.height);

    if (orientation == MyDeviceOrientationPortrait) {
        // From landscape to portrait mean the viewcontroller in index of count-1 will invisible.
        if ([super lastOrientation] == MyDeviceOrientationLandscape) {
            // re-trigger invisible viewcontroller's life cycle
            UIViewController* invisibleViewController = nil;
            if (self.viewControllers.count == 2) {
                // viewControllers.count == 2 mean the right root viewcontroller will invisible.
                invisibleViewController = [self.viewControllers objectAtIndex:1];
            } else {
                // viewControllers.count > 2 mean the second to last viewcontroller will invisible.
                invisibleViewController =
                    [self.viewControllers objectAtIndex:self.viewControllers.count - 1];
            }
            [invisibleViewController beginAppearanceTransition:NO animated:NO];
            [invisibleViewController endAppearanceTransition];
        }
        for (int i = 0; i < self.viewControllers.count; i++) {
            UIViewController* vc = [self.viewControllers objectAtIndex:i];
            ParallelChildViewControllerWrapperView* wrapper =
                [self getWrapperViewByViewController:vc];
            if (i == RIGHT_VIEWCONTROLLER_INDEX && autoAdjust == YES) {
                wrapper.frame = CGRectMake(size.width, size.height, size.width, size.height);
            } else {
                wrapper.frame = CGRectMake(0, 0, size.width, size.height);
                [self.view bringSubviewToFront:wrapper];
            }
            // hidden right side
            if (i == RIGHT_VIEWCONTROLLER_INDEX) {
                vc.view.layer.opacity = 0.0;
            }
        }
    } else if (orientation == MyDeviceOrientationLandscape) {
        // From portrait to landscape mean the viewcontroller in index of count-1 will visible
        // again.
        if ([super lastOrientation] == MyDeviceOrientationPortrait) {
            // re-trigger invisible viewcontroller's life cycle
            UIViewController* visibleViewController = nil;
            if (self.viewControllers.count == 2) {
                // viewControllers.count == 2 mean the right root viewcontroller will visible again.
                visibleViewController = [self.viewControllers objectAtIndex:1];
            } else {
                // viewControllers.count > 2 mean the second to last viewcontroller will visible
                // again.
                visibleViewController =
                    [self.viewControllers objectAtIndex:self.viewControllers.count - 1];
            }
            [visibleViewController beginAppearanceTransition:YES animated:NO];
            [visibleViewController endAppearanceTransition];
        }
        for (int i = 0; i < self.viewControllers.count; i++) {
            UIViewController* vc = [self.viewControllers objectAtIndex:i];
            ParallelChildViewControllerWrapperView* wrapper =
                [self getWrapperViewByViewController:vc];
            //┌┈┈┈┈┈┈┈┈┈┈┈┈┬┈┈┈┈┈┈┈┈┈┈┈┐
            //|            |   layout  |
            //| page count |┈┈┈┈┈┬┈┈┈┈┈┤
            //|            |left |right|
            //├┈┈┈┈┈┈┈┈┈┈┈┈|┈┈┈┈┈┴┈┈┈┈┈┤
            //|     2      | [0]   [1] |
            //├┈┈┈┈┈┈┈┈┈┈┈┈|┈┈┈┈┈┈┈┈┈┈┈┤
            //|     3      | [0]   [1] |
            //|            |       [2] |
            //├┈┈┈┈┈┈┈┈┈┈┈┈|┈┈┈┈┈┈┈┈┈┈┈┤
            //|     4      | [0]   [1] |
            //|            | [3]   [2] |
            //├┈┈┈┈┈┈┈┈┈┈┈┈|┈┈┈┈┈┈┈┈┈┈┈┤
            //|     n      | [0]   [1] |
            //|            | [3]   [2] |
            //|            |[..]   [..]|
            //|            |[n-2] [n-1]|
            //└┈┈┈┈┈┈┈┈┈┈┈┈┴┈┈┈┈┈┈┈┈┈┈┈┘
            /// -first and second  are fixed on left and on the right
            /// -the last second is on the left
            /// -others are on the right
            if (i == LEFT_VIEWCONTROLLER_INDEX) {
                wrapper.frame = leftViewFrame;
            } else if (i == RIGHT_VIEWCONTROLLER_INDEX) {
                wrapper.frame = rightViewFrame;
            } else if (i == (self.viewControllers.count - 2)) {
                wrapper.frame = leftViewFrame;
            } else {
                wrapper.frame = rightViewFrame;
            }
            // show right side
            if (i == RIGHT_VIEWCONTROLLER_INDEX) {
                vc.view.layer.opacity = 1.0;
            }
            [self.view bringSubviewToFront:wrapper];
        }
    } else {
        NSAssert(false, @"undefined DeviceOrientation");
    }
}

- (void)pushFullScreenModeChangeWithOldViewController:(UIViewController*)oldVC
                                    newViewController:(UIViewController*)newVC
                                             animated:(BOOL)animated {
    ParallelChildViewControllerWrapperView* oldWrapperView =
        [self getWrapperViewByViewController:oldVC];
    NSAssert(oldWrapperView != nil, @"can not find wrapperview by id");

    if (!animated) {
        [oldVC beginAppearanceTransition:NO animated:animated];
        [oldVC endAppearanceTransition];
        ParallelChildViewControllerWrapperView* newWrapperView =
            [self appendWrapperViewWithViewController:newVC
                                         wrapperFrame:[self fullScreenNewViewEndFrame]
                                               toView:self.view
                                             animated:animated];
        newVC.view.frame = [self fullScreenModeChildViewFrame];
        newWrapperView.delegate = self;
        [newWrapperView showNavigationBar:[self canShowNaigationBar:newVC]];
        [self addChildViewController:newVC];
        [newVC didMoveToParentViewController:self];

    } else {
        [oldVC beginAppearanceTransition:NO animated:animated];
        ParallelChildViewControllerWrapperView* newWrapperView =
            [self appendWrapperViewWithViewController:newVC
                                         wrapperFrame:[self fullScreenModeNewViewStartFrame]
                                               toView:self.view
                                             animated:animated];
        newVC.view.frame = [self fullScreenModeChildViewFrame];
        newWrapperView.delegate = self;
        [newWrapperView showNavigationBar:[self canShowNaigationBar:newVC]];
        [self addChildViewController:newVC];

        [UIView animateWithDuration:0.35
            animations:^{
              newWrapperView.frame = [self fullScreenNewViewEndFrame];
            }
            completion:^(BOOL finished) {
              [oldVC endAppearanceTransition];
              [newVC didMoveToParentViewController:self];
            }];
    }
}

- (void)pushParallelModeChangeFromOldViewController:(UIViewController*)oldVC
                                  newViewController:(UIViewController*)newVC
                                           animated:(BOOL)animated {
    ParallelChildViewControllerWrapperView* oldWrapperView =
        [self getWrapperViewByViewController:oldVC];
    NSAssert(oldWrapperView != nil, @"can not find wrapperview by id");

    BOOL moveOldVC = oldVC != _rightRootViewController;

    if (!animated) {
        if (moveOldVC && oldVC) {
            oldWrapperView.frame = [self leftViewFrame];
        }

        [oldVC beginAppearanceTransition:NO animated:animated];
        [oldVC endAppearanceTransition];
        [self addRightView:newVC];
    } else {
        UIViewController* invisibleViewController = nil;
        // Untill push the second viewcontroller(self.viewControllers.count = 3)
        // than the index of 0 viewcontoller will disappear.
        if (self.viewControllers.count == 3) {
            invisibleViewController = [self.viewControllers objectAtIndex:0];
        } else {
            invisibleViewController =
                [self.viewControllers objectAtIndex:self.viewControllers.count - 1];
        }
        [invisibleViewController beginAppearanceTransition:NO animated:animated];

        ParallelChildViewControllerWrapperView* newWrapperView =
            [self appendWrapperViewWithViewController:newVC
                                         wrapperFrame:[self newViewStartFrame]
                                               toView:self.view
                                             animated:animated];
        // Will not move the _rightRootViewController.
        if (moveOldVC) {
            oldWrapperView.frame = [self oldViewStartFrame];
        }
        newVC.view.frame = [self childViewFrame];
        newWrapperView.delegate = self;
        [newWrapperView showNavigationBar:[self canShowNaigationBar:newVC]];
        [self addChildViewController:newVC];

        [UIView animateWithDuration:0.35
            animations:^{
              newWrapperView.frame = [self newViewEndFrame];
              if (moveOldVC) {
                  oldWrapperView.frame = [self leftViewFrame];
              }
            }
            completion:^(BOOL finished) {
              [invisibleViewController endAppearanceTransition];
              [newVC didMoveToParentViewController:self];
            }];
    }
}

#pragma mark ParallelChildViewContollerWrapperViewDelegate
- (void)onClickBack:(ParallelChildViewControllerWrapperView*)wrapperView
     viewController:(UIViewController*)viewController {
    [self popViewControllerAnimated:YES];
}
@end
