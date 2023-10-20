//
//  BoostDelegate.m
//  ParallelViewController_Example
//
//  Created by 肖湘 on 2021/12/28.
//  Copyright © 2021 xiaoxiang. All rights reserved.
//

//#import "BoostDelegate.h"
//#import "DemoViewController.h"
//#import <flutter_boost/FBMultiAppFlutterViewContainer.h>
//@implementation BoostDelegate
//
/////多引擎
/////如果框架发现您输入的路由表在flutter里面注册的路由表中找不到，那么就会调用此方法来push一个纯原生页面
//- (void) pushMultiAppNativeRoute:(NSString *) pageName arguments:(NSDictionary *) arguments{
//    //TODO: use pageName and arguments to new different viewcontroller
//    DemoViewController * demo = [[DemoViewController alloc]initWithNibName:@"DemoViewController" bundle:[NSBundle mainBundle]];
//    if (self.navigationController) {
//        [self.navigationController pushViewController:demo animated:YES];
//    }
//}
//
/////当框架的withContainer为true的时候，会调用此方法来做原生的push
//- (void) pushMultiAppFlutterRoute:(MultiAppRouteOptions *)options{
//    
//    NSAssert(options.pageName!=nil, @"options.pageName can not nil");
//    NSAssert(options.arguments!=nil, @"options.arguments can not nil");
//        
//    FBMultiAppFlutterViewContainer * targetViewController = [[FBMultiAppFlutterViewContainer alloc]initWithEntrypoint:nil libraryURI:nil initialRoute:nil options:options];
//    
//    //TODO:options.opaque
//    [targetViewController setName:options.pageName uniqueId:options.uniqueId params:options.arguments opaque:YES];
//    if (self.navigationController) {
//        [self.navigationController pushViewController:targetViewController animated:YES];
//    }
//}
//
/////当pop调用涉及
//- (void) popMultiAppRoute{
//    if (self.navigationController) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}
//
/////当remove调用
//- (void) removeMultiAppRoute:(NSDictionary *) arguments{
//    //TODO:移除
//}
//@end
