//
//  DemoViewController.m
//  ParallelViewController_Example
//
//  Create by wesleyxiao on 2021/11/12
//  Copyright © 2021 xiaoxiang. All rights reserved.


#import "DemoViewController.h"
#import "UIViewController+ParallelViewControllerItem.h"
#import "ParallelShoppingModeViewController.h"
#import "AppDelegate.h"
#import "MyModalViewController.h"

static int count = 0;

@interface DemoViewController ()
{
    int _count;
}
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIView *content;
@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _count = count++;
    self.label.text = @"this is a native viewcontroller";
    
    NSLog(@"DemoViewController frame x:%f,y:%f,width:%f,height:%f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
    
    UIColor * color = [UIColor colorWithHue:drand48() saturation:1.0 brightness:1.0 alpha:1.0];
    ;
    self.view.backgroundColor = color;
    self.parallelNavigationItem.title = @"DemoViewController";
}

-(void)viewWillLayoutSubviews{
    NSLog(@"COUNT:%d,[%s]",_count,__FUNCTION__);
    [super viewWillLayoutSubviews];
}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"COUNT:%d,[%s]",_count,__FUNCTION__);
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"COUNT:%d,[%s]",_count,__FUNCTION__);
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"COUNT:%d,[%s]",_count,__FUNCTION__);
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"COUNT:%d,[%s]",_count,__FUNCTION__);
    [super viewDidDisappear:animated];
}

- (IBAction)onClickPush:(id)sender {
    DemoViewController * vc = [[DemoViewController alloc]initWithNibName:@"DemoViewController" bundle:[NSBundle mainBundle]];
    NSLog(@"COUNT:%d,[%s]",_count,__FUNCTION__);
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onClickPop:(id)sender {
    [self.parallelViewController popViewControllerAnimated:YES];
}
- (IBAction)onClickPushFlutterViewController:(id)sender {
    if (self.parallelViewController.viewControllers.count > 5) {
        UIViewController * vc = [self.parallelViewController.viewControllers objectAtIndex:1];
        [self.parallelViewController popToViewController:vc animated:NO];
    }
}
- (IBAction)present:(id)sender {

//    DemoViewController * viewControllerToPresent = [[DemoViewController alloc]initWithNibName:@"DemoViewController" bundle:[NSBundle mainBundle]];
//    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:viewControllerToPresent];
//
//    [self presentViewController:navigation animated:YES completion:^{
//        NSLog(@"complete!");
//    }];
    MyModalViewController * vc = [[MyModalViewController alloc] init];

    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    
    nav.transitioningDelegate = vc;
    nav.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:nav animated:YES completion:^{
        NSLog(@"complete!");
    }];
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"complete!");
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark -Override ViewController Methods

-(void)loadView{
    [super loadView];
}
- (void)willMoveToParentViewController:(nullable UIViewController *)parent{
    [super willMoveToParentViewController:parent];
}
- (void)didMoveToParentViewController:(nullable UIViewController *)parent{
    [super didMoveToParentViewController:parent];
};


@end
