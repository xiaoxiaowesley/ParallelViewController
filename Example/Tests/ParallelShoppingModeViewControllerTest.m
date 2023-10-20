//
//  ParallelShoppingModeViewControllerTest.m
//  ParallelViewController_Tests
//
//  Created by 肖湘 on 2022/5/18.
//  Copyright © 2022 xiaoxiang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

@import ParallelViewController;

@interface ParallelShoppingModeViewControllerTest : XCTestCase

@end

@implementation ParallelShoppingModeViewControllerTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}


- (void)testViewDidLoad {
    UIViewController * left = [[UIViewController alloc]init];
    UIViewController * right = [[UIViewController alloc]init];
    ParallelShoppingModeViewController * viewController = [[ParallelShoppingModeViewController alloc]initWithLeftViewController:left rightViewController:right];
    UIView* view = viewController.view;
    XCTAssertTrue(view!=nil);
    OCMVerify([viewController viewDidLoad]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
