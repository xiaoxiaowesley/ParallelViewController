//
//  MyModalViewController.m
//  ParallelViewController_Example
//
//  Created by 肖湘 on 2022/6/13.
//  Copyright © 2022 xiaoxiang. All rights reserved.
//

#import "MyModalViewController.h"
#import "ParallelPresentationController.h"

@interface MyModalViewController()<UIViewControllerTransitioningDelegate>


@end

@implementation MyModalViewController

-(instancetype)init{
    if(self = [super init]){
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    UILabel * titleLabel = [[UILabel alloc]init];
    [titleLabel setContentHuggingPriority:(UILayoutPriorityDefaultHigh) forAxis:(UILayoutConstraintAxisVertical)];
    titleLabel.font = [UIFont systemFontOfSize:25 weight:(UIFontWeightBold)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"Connect Something?";
    
    UILabel * messageLabel = [[UILabel alloc]init];
    [messageLabel setContentHuggingPriority:(UILayoutPriorityDefaultLow) forAxis:(UILayoutConstraintAxisVertical)];
    messageLabel.font = [UIFont systemFontOfSize:25 weight:(UIFontWeightMedium)] ;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines = 0;
    messageLabel.text = @"Connect your thing by tapping this button. Then we’ll get started!";

    UIButton * presentButton = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [presentButton setTitle:@"present" forState:(UIControlStateNormal)];
    [presentButton addTarget:self action:@selector(presentViewController) forControlEvents:(UIControlEventTouchUpInside)];
      
    UIButton * button = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [button setTitle:@"dismiss" forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(dismissViewController) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIStackView * stackView = [[UIStackView alloc]initWithArrangedSubviews:@[titleLabel,messageLabel,presentButton,button]];
    stackView.distribution = UIStackViewDistributionFill;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.spacing = 4;
    
    [self.view addSubview:stackView];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint * topAnchor = [[stackView topAnchor] constraintEqualToAnchor:[self.view topAnchor] constant:32];
    NSLayoutConstraint * bottomAnchor = [[stackView bottomAnchor] constraintEqualToAnchor:[self.view bottomAnchor] constant:-8];
    NSLayoutConstraint * leadingAnchor = [[stackView leadingAnchor] constraintEqualToAnchor:[self.view leadingAnchor] constant:32];
    NSLayoutConstraint * trailingAnchor = [[stackView trailingAnchor] constraintEqualToAnchor:[self.view trailingAnchor] constant:-32];

    [NSLayoutConstraint activateConstraints:@[
        topAnchor,
        bottomAnchor,
        leadingAnchor,
        trailingAnchor
    ]];
    
    NSLog(@"self.view:%p",self.view);
}
- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented
                                                               presentingViewController:(nullable UIViewController *)presenting
                                                                   sourceViewController:(UIViewController *)source{
    return [[ParallelPresentationController alloc]initWithPresentedViewController:presented
                                                     presentingViewController:presenting
                                                         sourceViewController:source];
}
-(void)dismissViewController{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
-(void)presentViewController{
    MyModalViewController * vc = [[MyModalViewController alloc] init];
    [self presentViewController:vc animated:YES completion:^{
        NSLog(@"complete!");
    }];
}
@end
