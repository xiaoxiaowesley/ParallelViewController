//
//  ParallelWrapperView.h
//
//  Create by wesleyxiao on 2021/11/12
//  Copyright © 2021 xiaoxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ParallelChildViewControllerWrapperView;
@protocol ParallelChildViewContollerWrapperViewDelegate <NSObject>
- (void)onClickBack:(ParallelChildViewControllerWrapperView*)wrapperView
     viewController:(UIViewController*)viewController;
@end

@interface ParallelChildViewControllerWrapperView : UIView
- (instancetype)initWithFrame:(CGRect)frame viewController:(nonnull UIViewController*)vc;
- (void)showNavigationBar:(BOOL)should;
- (void)hiddenNavigationBar:(BOOL)hidden;
@property(nonatomic, readonly, strong) UINavigationBar* navigationBar;
@property(nonatomic, weak) UIViewController* viewController;
@property(nullable, nonatomic, weak) id<ParallelChildViewContollerWrapperViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
