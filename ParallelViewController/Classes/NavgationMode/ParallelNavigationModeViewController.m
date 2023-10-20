//
//
//  ParallelNavigationModeViewController.m
//  ios-multiply-viewcontroller-in-one-window
//
//  Created by 肖湘 on 2021/10/18.
//

#import "ParallelNavigationModeViewController.h"
#import <objc/runtime.h>
#import "ParallelChildViewControllerWrapperView.h"
#import "UIViewController+ParallelViewControllerItem.h"

@interface ParallelNavigationModeViewController () <ParallelChildViewContollerWrapperViewDelegate>

@end

@implementation ParallelNavigationModeViewController

#pragma mark - Override ParallelViewController Event Methods
- (void)layoutInitLeftViewController:(UIViewController*)leftViewController
                 rightViewController:(UIViewController*)rightViewController
                         orientation:(MyDeviceOrientation)orientation {
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

#pragma mark - Override Super Methods (NavigationController-liked Methods)

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

    UIView* secondToLastWrapper = [super getWrapperViewByViewController:secondToLastViewController];
    UIView* lastWrapper = [super getWrapperViewByViewController:lastViewController];

    [lastViewController willMoveToParentViewController:nil];
    if (animated) {
        [lastViewController beginAppearanceTransition:NO animated:animated];
        [secondToLastViewController beginAppearanceTransition:YES animated:animated];

        [UIView animateWithDuration:0.35
            animations:^{
              lastWrapper.frame = [self newViewStartFrame];
              secondToLastWrapper.frame = [self rightViewFrame];
            }
            completion:^(BOOL finished) {
              [lastWrapper removeFromSuperview];
              [lastViewController endAppearanceTransition];
              [lastViewController removeFromParentViewController];

              // second to last viewcontroller bring to visible
              [secondToLastViewController endAppearanceTransition];
            }];
    } else {
        // WrapperView removeFromSuperView,ViewController remove from ParentView
        [lastWrapper removeFromSuperview];
        [lastViewController beginAppearanceTransition:NO animated:animated];
        [secondToLastViewController beginAppearanceTransition:YES animated:animated];

        [lastViewController endAppearanceTransition];
        [lastViewController removeFromParentViewController];

        // Move to right side because Second to last ViewController become the last ViewController
        [secondToLastViewController beginAppearanceTransition:YES animated:animated];
        [secondToLastViewController endAppearanceTransition];
        secondToLastWrapper.frame = [self rightViewFrame];
        // second to last viewcontroller bring to visible
        [secondToLastViewController endAppearanceTransition];
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
        // From landscape to portrait trigger the invisible viewcontroller's life cycle.
        if ([super lastOrientation] == MyDeviceOrientationLandscape) {
            // re-trigger invisible viewcontroller's life cycle
            UIViewController* invisibleViewController = nil;
            if (self.viewControllers.count == 2) {
                // viewControllers.count == 2 mean the right root viewcontroller will invisible.
                invisibleViewController = [self.viewControllers objectAtIndex:1];
            } else {
                // viewControllers.count > 2 mean the right viewcontroller will invisible.
                invisibleViewController = [self.viewControllers objectAtIndex:0];
            }
            [invisibleViewController beginAppearanceTransition:NO animated:NO];
            [invisibleViewController endAppearanceTransition];
        }
        // 2. re-layout viewcontroller's view
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
        // 1.From portrait to landscape mean  the left root viewcontroller will will visible again.
        if ([super lastOrientation] == MyDeviceOrientationPortrait) {
            // re-trigger invisible viewcontroller's life cycle
            UIViewController* visibleViewController = nil;
            if (self.viewControllers.count == 2) {
                // viewControllers.count == 2 mean the right root viewcontroller will visible again.
                visibleViewController = [self.viewControllers objectAtIndex:1];
            } else {
                // viewControllers.count > 2 mean the left root viewcontroller will visible again.
                visibleViewController = [self.viewControllers objectAtIndex:0];
            }
            [visibleViewController beginAppearanceTransition:YES animated:NO];
            [visibleViewController endAppearanceTransition];
        }
        // 2. re-layout viewcontroller's view
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
            //|            |       [2] |
            //|            |       [3] |
            //├┈┈┈┈┈┈┈┈┈┈┈┈|┈┈┈┈┈┈┈┈┈┈┈┤
            //|     n      | [0]   [1] |
            //|            |       [2] |
            //|            |       [..]|
            //|            |      [n-2]|
            //|            |      [n-1]|
            //└┈┈┈┈┈┈┈┈┈┈┈┈┴┈┈┈┈┈┈┈┈┈┈┈┘
            if (i == LEFT_VIEWCONTROLLER_INDEX) {
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
        NSAssert(false, @"undefined DeviceOrientation,%ld", (long)orientation);
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
    if (!animated) {
        [oldVC beginAppearanceTransition:NO animated:animated];
        [oldVC endAppearanceTransition];
        [self addRightView:newVC];
    } else {
        [oldVC beginAppearanceTransition:NO animated:animated];
        ParallelChildViewControllerWrapperView* newWrapperView =
            [self appendWrapperViewWithViewController:newVC
                                         wrapperFrame:[self newViewControllerBeginFrame]
                                               toView:self.view
                                             animated:animated];
        newVC.view.frame = [self childViewFrame];
        newWrapperView.delegate = self;
        [newWrapperView showNavigationBar:[self canShowNaigationBar:newVC]];
        [self addChildViewController:newVC];
        [UIView animateWithDuration:0.35
            animations:^{
              newWrapperView.frame = [super newViewControllerEndFrame];
              ;
            }
            completion:^(BOOL finished) {
              [oldVC endAppearanceTransition];
              [newVC didMoveToParentViewController:self];
            }];
    }
}

- (CGRect)newViewControllerBeginFrame {
    if ([self currentOrientation] == MyDeviceOrientationPortrait) {
        CGRect rect = [super fullScreenModeFrame];
        return CGRectMake(rect.size.width, rect.size.height, rect.size.width, rect.size.height);
    } else {
        return [super newViewStartFrame];
    }
}

#pragma mark ParallelChildViewContollerWrapperViewDelegate
- (void)onClickBack:(ParallelChildViewControllerWrapperView*)wrapperView
     viewController:(UIViewController*)viewController {
    [self popViewControllerAnimated:YES];
}
@end
