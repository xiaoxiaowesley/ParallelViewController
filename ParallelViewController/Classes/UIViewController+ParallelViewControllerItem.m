//  UIViewController+ParallelViewControllerItem.m
//
//  Create by wesleyxiao on 2021/11/12
//  Copyright © 2021 xiaoxiang. All rights reserved.
//

#import <objc/runtime.h>
#import "UIViewController+ParallelViewControllerItem.h"

static void* ParallelViewControllerPropertyKey = &ParallelViewControllerPropertyKey;
static void* ParallelNavigationItemPropertyKey = &ParallelNavigationItemPropertyKey;
static void* ParallelIsRootViewControllerPropertyKey = &ParallelIsRootViewControllerPropertyKey;

@implementation UIViewController (ParallelViewControllerItem)

- (ParallelViewController*)parallelViewController {
    return objc_getAssociatedObject(self, ParallelViewControllerPropertyKey);
}

- (void)setParallelViewController:(ParallelViewController*)parallelViewController {
    objc_setAssociatedObject(self, ParallelViewControllerPropertyKey, parallelViewController,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UINavigationItem*)parallelNavigationItem {
    UINavigationItem* item = objc_getAssociatedObject(self, ParallelNavigationItemPropertyKey);
    if (!item) {
        item = [[UINavigationItem alloc] init];
        [self setParallelNavigationItem:item];
        return item;
    } else {
        return item;
    }
}

- (void)setParallelNavigationItem:(UINavigationItem*)parallelNavigationItem {
    objc_setAssociatedObject(self, ParallelNavigationItemPropertyKey, parallelNavigationItem,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
