//
//
//  ParallelViewController.h
//
//  Create by wesleyxiao on 2021/11/12
//  Copyright © 2021 xiaoxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParallelChildViewControllerWrapperView.h"

NS_ASSUME_NONNULL_BEGIN

/// Here we define my own orientation instead of UIDeviceOrientation
/// that's because we don't care about whether is the home button on the right or left
/// and if the device is unside down or not.We just care about if is Portrait or Landscape.
typedef NS_ENUM(NSInteger, MyDeviceOrientation) {
    MyDeviceOrientationPortrait,   // Device oriented vertically
    MyDeviceOrientationLandscape,  // Device oriented horizontally
    MyDeviceOrientationUndefined,  // Device oriented horizontally
} API_UNAVAILABLE(tvos);

#define LEFT_VIEWCONTROLLER_INDEX 0
#define RIGHT_VIEWCONTROLLER_INDEX 1

extern NSString* const ParallelViewControllerRotationChanged;

@interface ParallelViewController : UINavigationController
- (instancetype)initWithLeftViewController:(UIViewController*)leftViewController
                       rightViewController:(UIViewController*)rightViewController;
- (void)addViewController:(UIViewController*)viewController;
@property(nonatomic, copy) NSArray<__kindof UIViewController*>* viewControllers;

- (void)pushViewController:(UIViewController*)viewController animated:(BOOL)animated;
- (nullable UIViewController*)popViewControllerAnimated:(BOOL)animated;

- (nullable NSArray<__kindof UIViewController*>*)
    popToViewController:(UIViewController*)viewController
               animated:(BOOL)animated;  // Pops view controllers until the one specified is on top.
                                         // Returns the popped controllers.
- (nullable NSArray<__kindof UIViewController*>*)popToRootViewControllerAnimated:
    (BOOL)animated;  // Pops until there's only a single view controller left on the stack. Returns
                     // the popped controllers.

- (void)setViewControllers:(NSArray<UIViewController*>*)viewControllers animated:(BOOL)animated;

@property(nonatomic, readonly) MyDeviceOrientation currentOrientation;
@property(nonatomic, readonly) MyDeviceOrientation lastOrientation;
@property(nonatomic, readonly) CGSize lastSize;

- (void)reloadWithAutoAdjustRightViewController:(BOOL)autoAdjust;

- (ParallelChildViewControllerWrapperView*)getWrapperViewByViewController:(UIViewController*)vc;

- (ParallelChildViewControllerWrapperView*)appendWrapperViewWithViewController:(UIViewController*)vc
                                                                  wrapperFrame:(CGRect)wrapperFrame
                                                                        toView:(UIView*)superView
                                                                      animated:(BOOL)animated;

- (void)addLeftView:(UIViewController*)vc;

- (void)addRightView:(UIViewController*)vc;

- (void)pushFullScreenModeChangeWithOldViewController:(UIViewController*)oldVC
                                    newViewController:(UIViewController*)newVC
                                             animated:(BOOL)animated;

- (void)pushParallelModeChangeFromOldViewController:(UIViewController*)oldVC
                                  newViewController:(UIViewController*)newVC
                                           animated:(BOOL)animated;
/// Parallel mode
- (CGFloat)hingeWidth;

- (CGFloat)halfWidth;

- (CGRect)childViewFrame;

- (CGRect)leftViewFrame;

- (CGRect)rightViewFrame;

- (CGRect)newViewStartFrame;

- (CGRect)newViewEndFrame;

- (CGRect)oldViewEndFrame;

- (CGRect)oldViewStartFrame;

- (CGRect)fullScreenModeFrame;

- (CGRect)splitModeRightFrame;

- (CGRect)splitModeLeftFrame;

- (CGRect)newViewControllerEndFrame;

/// Full Screen
- (CGRect)fullScreenModeNewViewStartFrame;

- (CGRect)fullScreenNewViewEndFrame;

- (CGRect)fullScreenModeChildViewFrame;

- (CGRect)fullScreenModeExitEndViewFrame;

- (ParallelChildViewControllerWrapperView*)
    layoutLeftViewController:(UIViewController*)vc
                    delegate:(id<ParallelChildViewContollerWrapperViewDelegate>)delegate
            showNaigationBar:(BOOL)showNavigationBar;

- (ParallelChildViewControllerWrapperView*)
    layoutRightViewController:(UIViewController*)vc
                     delegate:(id<ParallelChildViewContollerWrapperViewDelegate>)delegate
             showNaigationBar:(BOOL)showNavigationBar;

// called when initialed two viewcontrollers
- (void)layoutInitLeftViewController:(UIViewController*)leftViewController
                 rightViewController:(UIViewController*)rightViewController
                         orientation:(MyDeviceOrientation)orientation;

- (void)orientationDidChange:(CGSize)size
                      orientation:(MyDeviceOrientation)orientation
    autoAdjustRightViewController:(BOOL)autoAdjust;

- (BOOL)canShowNaigationBar:(UIViewController*)controller;
@end

NS_ASSUME_NONNULL_END
