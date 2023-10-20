//
//  ParallelPresentationController.h
//
//  Created by 肖湘 on 2022/6/13.
//  Copyright © 2022 xiaoxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString* const kParallelPresentationPresentationTransitionWillBegin;
extern NSString* const kParallelPresentationPresentationTransitionDidEnd;
extern NSString* const kParallelPresentationDismissalTransitionWillBegin;
extern NSString* const kParallelPresentationDismissalTransitionDidEnd;

@class ParallelPresentationController;

typedef CGRect (^FetchContainerFrameCallback)(
    ParallelPresentationController* parallelPresentationController,
    UIView* containerView);

@interface ParallelPresentationController : UIPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController*)presentedViewController
                       presentingViewController:(nullable UIViewController*)presentingViewController
                           sourceViewController:(UIViewController*)sourceViewController;

+ (void)setFetchContainerFrameCallback:(FetchContainerFrameCallback)callback;

@end

NS_ASSUME_NONNULL_END
