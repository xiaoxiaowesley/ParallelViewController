//
//
//  ParallelWrapperView.m
//
//  Create by wesleyxiao on 2021/11/12
//  Copyright © 2021 xiaoxiang. All rights reserved.
//

#import "ParallelChildViewControllerWrapperView.h"
#import "ParallelShoppingModeViewController.h"
#import "UIViewController+ParallelViewControllerItem.h"

#define navigationBarHeight 44
#define navigationBarTop 24
#define leftNavigationBarLeading 0

@interface BackBarButton : UIBarButtonItem
- (instancetype)initWithTitle:(NSString*)titile target:(id)target selector:(SEL)selector;
@end
@implementation BackBarButton
- (instancetype)initWithTitle:(NSString*)titile target:(id)target selector:(SEL)selector {
    // Create UIButton
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectZero];
    [button setTitle:titile forState:(UIControlStateNormal)];
    [button setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17];

    if (@available(iOS 13.0, *)) {
        UIImageSymbolConfiguration* config =
            [UIImageSymbolConfiguration configurationWithPointSize:19.0
                                                            weight:UIImageSymbolWeightSemibold
                                                             scale:(UIImageSymbolScaleLarge)];
        UIImage* image = [UIImage systemImageNamed:@"chevron.left" withConfiguration:config];
        [button setImage:image forState:UIControlStateNormal];
    } else {
        // Fallback on earlier versions
        UIImage* backImage = [UIImage imageNamed:@"backBtn"];
        [button setImage:backImage forState:UIControlStateNormal];
        [button setImage:backImage forState:UIControlStateNormal];
    }
    [button addTarget:target action:selector forControlEvents:(UIControlEventTouchUpInside)];
    self = [super initWithCustomView:button];
    return self;
}
@end
@interface ParallelChildViewControllerWrapperView () {
    UINavigationBar* _navigationBar;
}
@end

@implementation ParallelChildViewControllerWrapperView

- (instancetype)initWithFrame:(CGRect)frame viewController:(UIViewController*)vc {
    self = [super initWithFrame:frame];
    if (self) {
        _viewController = vc;
    }
    return self;
}

- (void)showNavigationBar:(BOOL)should {
    if (should) {
        if (_navigationBar.superview == nil) {
            // initial _navigationBar
            CGFloat navigationBarWidth = self.bounds.size.width;

            _navigationBar = [[UINavigationBar alloc]
                initWithFrame:CGRectMake(0, navigationBarTop, navigationBarWidth,
                                         navigationBarHeight)];

            // set the background to transparent
            [_navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
            _navigationBar.shadowImage = [UIImage new];
            _navigationBar.translucent = YES;

            UINavigationItem* navigItem = [_viewController parallelNavigationItem];
            navigItem.leftBarButtonItem =
                [[BackBarButton alloc] initWithTitle:@"back"
                                              target:self
                                            selector:@selector(onClickBackAction:)];
            _navigationBar.items = @[ navigItem ];
            ;
            [self addSubview:_navigationBar];
        }
        // update the contraints
        [self.navigationBar.topAnchor constraintEqualToAnchor:self.topAnchor constant:navigationBarTop].active = YES;
        [self.navigationBar.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:leftNavigationBarLeading].active = YES;
        [self.navigationBar.heightAnchor constraintEqualToConstant:navigationBarHeight].active = YES;
        [self.navigationBar.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
    } else {
        if (_navigationBar.superview != nil) {
            [_navigationBar removeFromSuperview];
        }
    }
}

- (void)hiddenNavigationBar:(BOOL)hidden {
    if (_navigationBar) {
        _navigationBar.hidden = YES;
    }
}
#pragma mark - Override View Methods
- (void)layoutSubviews {
    [super layoutSubviews];
    // only when the _navigationBar.superview not nil will bring to front
    if (_navigationBar.superview) {
        [self bringSubviewToFront:_navigationBar];
    }
}

#pragma mark - Private Method
- (void)onClickBackAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(onClickBack:viewController:)]) {
        [_delegate onClickBack:self viewController:_viewController];
    }
}
@end
