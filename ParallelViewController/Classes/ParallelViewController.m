//
//
//  ParallelViewController.m
//
//  Created by 肖湘 on 2021/10/18.
//  Copyright © 2021 xiaoxiang. All rights reserved.
//

#import "ParallelViewController.h"
#import <Masonry/Masonry.h>
#import <objc/runtime.h>
#import "UIViewController+ParallelViewControllerItem.h"

NSString* const ParallelViewControllerRotationChanged = @"ParallelViewControllerRotationChanged";
#define HingeWidth 5

@interface ParallelViewController () <ParallelChildViewContollerWrapperViewDelegate> {
    NSMutableArray<__kindof UIViewController*>* _internalViewControllers;
}
@end

@implementation ParallelViewController
- (instancetype)initWithLeftViewController:(UIViewController*)leftViewController
                       rightViewController:(UIViewController*)rightViewController {
    self = [super init];
    if (self) {
        _lastSize = [UIScreen mainScreen].bounds.size;
        _lastOrientation = [self currentOrientation];
        _internalViewControllers = [[NSMutableArray alloc] init];
        [self addViewController:leftViewController];
        [self addViewController:rightViewController];
    }
    return self;
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    // https://developer.apple.com/documentation/uikit/uiviewcontroller/1621389-shouldautomaticallyforwardappear
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self layoutInitLeftViewController:[self.viewControllers objectAtIndex:0]
                   rightViewController:[self.viewControllers objectAtIndex:1]
                           orientation:[self currentOrientation]];
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    // post ParallelViewControllerRotationChanged event and bring the new size.
    [[NSNotificationCenter defaultCenter] postNotificationName:ParallelViewControllerRotationChanged
                                                        object:[NSValue valueWithCGSize:size]];

    UIViewController* vc = [self.viewControllers objectAtIndex:1];
    // if RightViewController(index 1) has not present a viewcontroller
    // then does need to adjust
    BOOL hasNoPresentdViewController = vc.presentedViewController == nil;
    [self orientationDidChange:size
                          orientation:[self currentOrientation]
        autoAdjustRightViewController:hasNoPresentdViewController];
    _lastOrientation = [self currentOrientation];
    _lastSize = size;
}

- (void)reloadWithAutoAdjustRightViewController:(BOOL)autoAdjust {
    [self orientationDidChange:_lastSize
                          orientation:[self currentOrientation]
        autoAdjustRightViewController:autoAdjust];
}
#pragma mark - Event Methods
- (void)layoutInitLeftViewController:(UIViewController*)leftViewController
                 rightViewController:(UIViewController*)rightViewController
                         orientation:(MyDeviceOrientation)orientation {
    // do nothing here. Subclass must override this method
}

- (void)orientationDidChange:(CGSize)size
                      orientation:(MyDeviceOrientation)orientation
    autoAdjustRightViewController:(BOOL)autoAdjust {
    // do nothing here. Subclass must override this method
}
#pragma mark - Private Methods
- (MyDeviceOrientation)currentOrientation {
    CGRect bounds = [[UIScreen mainScreen] bounds];
    return bounds.size.height > bounds.size.width ? MyDeviceOrientationPortrait
                                                  : MyDeviceOrientationLandscape;
}

- (void)addViewController:(UIViewController*)viewController {
    viewController.parallelViewController = self;
    if (viewController && ![_internalViewControllers containsObject:viewController]) {
        [_internalViewControllers addObject:viewController];
    }
}

- (void)pushFullScreenModeChangeWithOldViewController:(UIViewController*)oldVC
                                    newViewController:(UIViewController*)newVC
                                             animated:(BOOL)animated {
    // do nothing here. Subclass must override this method
}

- (void)pushParallelModeChangeFromOldViewController:(UIViewController*)oldVC
                                  newViewController:(UIViewController*)newVC
                                           animated:(BOOL)animated {
    // do nothing here. Subclass must override this method
}

#pragma mark - Override Methods

- (nullable UIViewController*)popViewControllerAnimated:(BOOL)animated {
    UIViewController* last = [_internalViewControllers lastObject];
    [_internalViewControllers removeLastObject];
    return last;
}

- (void)pushViewController:(UIViewController*)viewController animated:(BOOL)animated {
    if ([self currentOrientation] == MyDeviceOrientationPortrait) {
        UIViewController* oldRight = self.viewControllers.lastObject;
        [self pushFullScreenModeChangeWithOldViewController:oldRight
                                          newViewController:viewController
                                                   animated:animated];
    } else {
        UIViewController* oldRight = self.viewControllers.lastObject;
        [self pushParallelModeChangeFromOldViewController:oldRight
                                        newViewController:viewController
                                                 animated:animated];
    }
    [self addViewController:viewController];
}

- (nullable NSArray<__kindof UIViewController*>*)popToViewController:
                                                     (UIViewController*)viewController
                                                            animated:(BOOL)animated {
    NSMutableArray<__kindof UIViewController*>* popedViewControllers =
        [[NSMutableArray alloc] init];
    while (viewController != [self topViewController]) {
        // TODO:disable animated
        UIViewController* popedViewController = [self popViewControllerAnimated:NO];
        if (popedViewController) {
            [popedViewControllers addObject:popedViewController];
        }
    }
    return popedViewControllers;
}

- (nullable NSArray<__kindof UIViewController*>*)popToRootViewControllerAnimated:(BOOL)animated {
    NSMutableArray<__kindof UIViewController*>* popedViewControllers =
        [[NSMutableArray alloc] init];
    while (self.viewControllers.count > 2) {
        // TODO:disable animated
        UIViewController* popedViewController = [self popViewControllerAnimated:NO];
        if (popedViewController) {
            [popedViewControllers addObject:popedViewController];
        }
    }
    return popedViewControllers;
}

- (NSArray<__kindof UIViewController*>*)viewControllers {
    return _internalViewControllers;
}

- (UIViewController*)topViewController {
    return [_internalViewControllers lastObject];
}

- (void)setViewControllers:(NSArray<UIViewController*>*)viewControllers animated:(BOOL)animated {
    // TODO: animated = NO need impliment.
    animated = NO;

    NSMutableArray* removeVCs = [[NSMutableArray alloc] init];
    NSMutableArray* addVCs = [[NSMutableArray alloc] init];

    // Find all removed ViewControllers
    for (int j = 0; j < _internalViewControllers.count; j++) {
        UIViewController* existVC = [_internalViewControllers objectAtIndex:j];
        BOOL hasRemoved = YES;
        for (int i = 0; i < viewControllers.count; i++) {
            UIViewController* newSetVC = [viewControllers objectAtIndex:i];
            if (existVC == newSetVC) {
                hasRemoved = NO;
            }
        }
        if (hasRemoved) {
            [removeVCs addObject:existVC];
        }
    }

    // Find add new ViewControllers
    for (int i = 0; i < viewControllers.count; i++) {
        UIViewController* newSetVC = [viewControllers objectAtIndex:i];
        BOOL isNew = YES;
        for (int j = 0; j < _internalViewControllers.count; j++) {
            UIViewController* existVC = [_internalViewControllers objectAtIndex:j];
            if (existVC == newSetVC) {
                isNew = NO;
            }
        }
        if (isNew) {
            [addVCs addObject:newSetVC];
        }
    }

    for (int i = 0; i < removeVCs.count; i++) {
        UIViewController* vc = [removeVCs objectAtIndex:i];
        [self _removeViewController:vc animated:animated];
        [_internalViewControllers removeObject:vc];
    }

    for (int i = 0; i < addVCs.count; i++) {
        UIViewController* vc = [addVCs objectAtIndex:i];
        [self pushViewController:vc animated:animated];
    }
    //    [_internalViewControllers removeAllObjects];
    //    [_internalViewControllers addObjectsFromArray:viewControllers];
}

- (void)setViewControllers:(NSArray<__kindof UIViewController*>*)viewControllers {
    [self setViewControllers:viewControllers animated:NO];
}

#pragma mark - Public Methods

- (ParallelChildViewControllerWrapperView*)getWrapperViewByViewController:(UIViewController*)vc {
    NSInteger tag = (NSInteger)vc;
    return (ParallelChildViewControllerWrapperView*)[self.view viewWithTag:tag];
}

- (NSInteger)getWrapperViewTagByViewController:(UIViewController*)vc {
    return (NSInteger)vc;
}

- (ParallelChildViewControllerWrapperView*)appendWrapperViewWithViewController:(UIViewController*)vc
                                                                  wrapperFrame:(CGRect)wrapperFrame
                                                                        toView:(UIView*)superView
                                                                      animated:(BOOL)animated {
    ParallelChildViewControllerWrapperView* wrapperView = [self getWrapperViewByViewController:vc];
    if (wrapperView == nil) {
        wrapperView = [[ParallelChildViewControllerWrapperView alloc] initWithFrame:wrapperFrame
                                                                     viewController:vc];
    } else {
        NSLog(@"reuse wrapperView of %p", vc);
    }
    // convert pointer to NSInteger record tag
    wrapperView.tag = [self getWrapperViewTagByViewController:vc];
    [superView addSubview:wrapperView];
    [wrapperView addSubview:vc.view];
    [vc beginAppearanceTransition:YES animated:animated];
    [vc endAppearanceTransition];
    return wrapperView;
}
#pragma mark - Private Methods
- (UIViewController*)_removeViewController:(UIViewController*)vc animated:(BOOL)animated {
    if ([_internalViewControllers containsObject:vc]) {
        UIView* wrapper = [self getWrapperViewByViewController:vc];
        [vc willMoveToParentViewController:nil];
        [wrapper removeFromSuperview];
        [vc beginAppearanceTransition:NO animated:animated];
        [vc endAppearanceTransition];
        [vc removeFromParentViewController];
        return vc;
    } else {
        NSLog(@"remove error: Can not remove the viewcontroller:%p", vc);
        return nil;
    }
}

#pragma mark - Helper Methods
- (CGFloat)hingeWidth {
    return HingeWidth;
}

- (CGFloat)halfWidth {
    return (self.view.bounds.size.width - HingeWidth) / 2.0;
}

- (CGRect)childViewFrame {
    return CGRectMake(0, 0, [self halfWidth], self.view.bounds.size.height);
}

- (CGRect)leftViewFrame {
    return CGRectMake(0, 0, [self halfWidth], self.view.bounds.size.height);
}

- (CGRect)rightViewFrame {
    return CGRectMake([self halfWidth] + HingeWidth, 0, self.view.bounds.size.width / 2.0,
                      self.view.bounds.size.height);
}

- (CGRect)newViewStartFrame {
    return CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width / 2.0,
                      self.view.bounds.size.height);
}

- (CGRect)fullScreenModeNewViewStartFrame {
    return CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width,
                      self.view.bounds.size.height);
}

- (CGRect)fullScreenModeChildViewFrame {
    return CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}

- (CGRect)fullScreenNewViewEndFrame {
    return CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}

- (CGRect)fullScreenModeExitEndViewFrame {
    return CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width,
                      self.view.bounds.size.height);
}

- (CGRect)newViewEndFrame {
    return [self rightViewFrame];
}

- (CGRect)oldViewEndFrame {
    return [self leftViewFrame];
}

- (CGRect)oldViewStartFrame {
    return [self rightViewFrame];
}

- (void)addLeftView:(UIViewController*)vc {
    /// https://developer.apple.com/library/archive/featuredarticles/ViewControllerPGforiPhoneOS/ImplementingaContainerViewController.html
    [self appendWrapperViewWithViewController:vc
                                 wrapperFrame:[self leftViewFrame]
                                       toView:self.view
                                     animated:NO];
    [self addChildViewController:vc];
    [vc didMoveToParentViewController:self];
}

- (void)addRightView:(UIViewController*)newVC {
    ParallelChildViewControllerWrapperView* newWrapperView =
        [self appendWrapperViewWithViewController:newVC
                                     wrapperFrame:[self newViewControllerEndFrame]
                                           toView:self.view
                                         animated:NO];
    newVC.view.frame = [self childViewFrame];
    newWrapperView.delegate = self;
    [newWrapperView showNavigationBar:[self canShowNaigationBar:newVC]];
    [self addChildViewController:newVC];
    [newVC didMoveToParentViewController:self];
}

- (ParallelChildViewControllerWrapperView*)
    layoutLeftViewController:(UIViewController*)vc
                    delegate:(id<ParallelChildViewContollerWrapperViewDelegate>)delegate
            showNaigationBar:(BOOL)showNavigationBar {
    ParallelChildViewControllerWrapperView* wrapper =
        [self appendWrapperViewWithViewController:vc
                                     wrapperFrame:[self leftViewFrame]
                                           toView:self.view
                                         animated:NO];
    vc.view.frame = [self childViewFrame];
    [self addChildViewController:vc];
    [vc didMoveToParentViewController:self];
    wrapper.delegate = delegate;
    [wrapper showNavigationBar:showNavigationBar];
    return wrapper;
}

- (ParallelChildViewControllerWrapperView*)
    layoutRightViewController:(UIViewController*)vc
                     delegate:(id<ParallelChildViewContollerWrapperViewDelegate>)delegate
             showNaigationBar:(BOOL)showNavigationBar {
    ParallelChildViewControllerWrapperView* wrapper =
        [self appendWrapperViewWithViewController:vc
                                     wrapperFrame:[self rightViewFrame]
                                           toView:self.view
                                         animated:NO];
    vc.view.frame = [self childViewFrame];
    [self addChildViewController:vc];
    [vc didMoveToParentViewController:self];
    wrapper.delegate = delegate;
    [wrapper showNavigationBar:showNavigationBar];
    return wrapper;
}

- (CGRect)fullScreenModeFrame {
    return self.view.bounds;
}

- (CGRect)splitModeRightFrame {
    return [self rightViewFrame];
}

- (CGRect)splitModeLeftFrame {
    return [self leftViewFrame];
}

- (BOOL)canShowNaigationBar:(UIViewController*)controller {
    if (self.navigationBar.hidden) {
        return NO;
    }
    NSUInteger index = [self.viewControllers indexOfObject:controller];
    // the root 2 viewcontroller will not show the navigationBar
    if (index < 2) {
        return NO;
    } else {
        return YES;
    }
}
- (CGRect)newViewControllerEndFrame {
    if (MyDeviceOrientationPortrait == [self currentOrientation]) {
        return [self fullScreenModeFrame];
    } else {
        return [self splitModeRightFrame];
    }
}
@end
