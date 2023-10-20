//
//  ParallelPresentationController.m
//
//  Created by 肖湘 on 2022/6/13.
//  Copyright © 2022 xiaoxiang. All rights reserved.
//

#import "ParallelPresentationController.h"

NSString* const kParallelPresentationPresentationTransitionWillBegin =
    @"ParallelPresentationControllerPresentationTransitionWillBegin";
NSString* const kParallelPresentationPresentationTransitionDidEnd =
    @"ParallelPresentationControllerPresentationTransitionDidEnd";
NSString* const kParallelPresentationDismissalTransitionWillBegin =
    @"ParallelPresentationControllerDismissalTransitionWillBegin";
NSString* const kParallelPresentationDismissalTransitionDidEnd =
    @"ParallelPresentationControllerDismissalTransitionDidEnd";
FetchContainerFrameCallback globalCallback;

@interface ParallelPresentationController ()
@property(nullable, nonatomic, weak) UIViewController* sourceViewController;
@end

@implementation ParallelPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController*)presentedViewController
                       presentingViewController:(nullable UIViewController*)presentingViewController
                           sourceViewController:(UIViewController*)sourceViewController {
    if (self = [super initWithPresentedViewController:presentedViewController
                             presentingViewController:presentingViewController]) {
        _sourceViewController = sourceViewController;
    }
    return self;
}

- (BOOL)shouldPresentInFullscreen {
    return NO;
}
- (CGRect)frameOfPresentedViewInContainerView {
    return self.containerView.bounds;
}

- (void)containerViewDidLayoutSubviews {
    [super containerViewDidLayoutSubviews];

    if (_sourceViewController) {
        UIView* rootView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
        CGRect sourceVCInWindow =
            [_sourceViewController.view.superview convertRect:_sourceViewController.view.bounds
                                                       toView:rootView];
        CGRect rectInWindow = [rootView convertRect:sourceVCInWindow
                                             toView:self.containerView.superview];
        self.containerView.frame = rectInWindow;
    } else if (globalCallback) {
        CGRect rectInWindow = globalCallback(self, self.containerView);
        self.containerView.frame = rectInWindow;
    }
    self.presentedView.frame = [self frameOfPresentedViewInContainerView];
}

- (void)presentationTransitionWillBegin {
    [super presentationTransitionWillBegin];

    [[NSNotificationCenter defaultCenter]
        postNotificationName:kParallelPresentationPresentationTransitionWillBegin
                      object:nil];
}
- (void)presentationTransitionDidEnd:(BOOL)completed {
    [super presentationTransitionDidEnd:completed];
    if (completed) {
        [[NSNotificationCenter defaultCenter]
            postNotificationName:kParallelPresentationPresentationTransitionDidEnd
                          object:nil];
    }
}
- (void)dismissalTransitionWillBegin {
    [super dismissalTransitionWillBegin];
    [[NSNotificationCenter defaultCenter]
        postNotificationName:kParallelPresentationDismissalTransitionWillBegin
                      object:nil];
}
- (void)dismissalTransitionDidEnd:(BOOL)completed {
    [super dismissalTransitionDidEnd:completed];
    if (completed) {
        [[NSNotificationCenter defaultCenter]
            postNotificationName:kParallelPresentationDismissalTransitionDidEnd
                          object:nil];
    }
}

+ (void)setFetchContainerFrameCallback:(FetchContainerFrameCallback)callback {
    globalCallback = callback;
}
@end
