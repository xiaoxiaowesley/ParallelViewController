# ParallelViewController

[切换中文](README_CN.md)

[![CI Status](https://img.shields.io/travis/xiaoxiang/ParallelViewController.svg?style=flat)](https://travis-ci.org/xiaoxiang/ParallelViewController)
[![Version](https://img.shields.io/cocoapods/v/ParallelViewController.svg?style=flat)](https://cocoapods.org/pods/ParallelViewController)
[![License](https://img.shields.io/cocoapods/l/ParallelViewController.svg?style=flat)](https://cocoapods.org/pods/ParallelViewController)
[![Platform](https://img.shields.io/cocoapods/p/ParallelViewController.svg?style=flat)](https://cocoapods.org/pods/ParallelViewController)

A left-right split-screen iOS Implement for foldable Android devices.


## Installation

ParallelViewController is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ParallelViewController'
```



## Example

Similar to initializing a UINavigationController with a RootViewController, we need to pass in two ViewControllers for the left and right screens.


Navigation Mode

```objetive-c

DemoViewController * left = [[DemoViewController alloc]initWithNibName:@"DemoViewController" bundle:[NSBundle mainBundle]];

DemoViewController * right = [[DemoViewController alloc]initWithNibName:@"DemoViewController" bundle:[NSBundle mainBundle]];

ParallelNavigationModeViewController * containerController = [[ParallelNavigationModeViewController alloc]initWithLeftViewController:left rightViewController:right];

```


Shopping mode:


```Objective-c
DemoViewController * left = [[DemoViewController alloc]initWithNibName:@"DemoViewController" bundle:[NSBundle mainBundle]];

DemoViewController * right = [[DemoViewController alloc]initWithNibName:@"DemoViewController" bundle:[NSBundle mainBundle]];

ParallelShoppingModeViewController * containerController = [[ParallelShoppingModeViewController alloc]initWithLeftViewController:left rightViewController:right];

```


**Push**


```
DemoViewController * newVC = [[DemoViewController alloc]initWithNibName:@"DemoViewController" bundle:[NSBundle mainBundle]];

[containerController pushViewController:newVC animated:YES];
```

**Pop**

```
[containerController popViewControllerAnimated:YES];
```



## Shoping Mode

The newest view is displayed on the right screen while the second newest view is displayed on the left screen. This scenario is suitable for comparing multiple products.


Taking push four ABCD pages for the example.

![stack](img/stack.jpg)

In portrait mode, it behaves like a regular UINavigationController, with the screens evenly distributed.

![normal_mode](img/normal_mode.jpg)

In landscape mode, the newest view is displayed on the right screen while the second newest view is displayed on the left screen.


Push

![normal_mode](img/shop_mode_push.jpg)

Pop

![normal_mode](img/shop_mode_pop.jpg)


## Navigation Mode

In portrait mode, it behaves like a regular UINavigationController.

![normal_mode](img/normal_mode.jpg)


In landscape mode, the left page remains fixed, while the newest and second newest views stack on the right side. This scenario is suitable for having a list page on the left and opening multiple products on the right side. The goal is to have the newest views all open on the right side.

Push

![normal_mode](img/navigation_push.jpg)

Pop

![normal_mode](img/navigation_pop.jpg)


## Author

xiaoxiang, xiaoxiaowesley@gmail.com

## License

ParallelViewController is available under the MIT license. See the LICENSE file for more info.