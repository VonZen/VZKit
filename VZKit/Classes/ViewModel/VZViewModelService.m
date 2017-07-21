//
//  VZViewModelService.m
//  VZKit
//
//  Created by VonZen on 2017/7/21.
//

#import "VZViewModelService.h"
#import "VZBaseViewController.h"
#import "VZViewModelRouter.h"

@interface VZViewModelService ()

@property (nonatomic, weak) UINavigationController *navigationController;

@property (nonatomic) NSMutableArray<UIViewController *> *presentedVCs;

@end

@implementation VZViewModelService

- (instancetype)initWithNavigation:(UINavigationController *)navigationController
{
    if (self = [super init]) {
        _navigationController = navigationController;
        _presentedVCs = [NSMutableArray array];
    }
    
    return self;
}

- (void)pushViewModel:(__kindof VZBaseViewModel *)viewModel
{
    VZBaseViewController *baseViewController = [self getVC:viewModel];
    
    if (baseViewController) {
        [self.navigationController pushViewController:baseViewController animated:YES];
    }
}

- (void)popViewModelWithAnimated:(BOOL)animated
{
    if (_navigationController) {
        [self.navigationController popViewControllerAnimated:animated];
    }
}

- (void)popToRootViewModel
{
    if (_navigationController) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)presentViewModel:(__kindof VZBaseViewModel *)viewModel
{
    VZBaseViewController *baseViewController = [self getVC:viewModel];
    
    if (baseViewController) {
        if (self.presentedVCs.count > 0) {
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:baseViewController];
            [self.presentedVCs.lastObject presentViewController:nc animated:YES completion:nil];
        }else{
            [self.navigationController presentViewController:baseViewController animated:YES completion:nil];
        }
        [self.presentedVCs addObject:baseViewController];
    }
}

- (void)dismissViewModelWithAnimated:(BOOL)animated
{ 
    NSUInteger count = self.presentedVCs.count;
    if (count == 1) {
        [self.navigationController dismissViewControllerAnimated:animated completion:nil];
    }else{
        [self.presentedVCs[count -1] dismissViewControllerAnimated:animated completion:nil];
    }
    [self.presentedVCs removeLastObject];
}

- (VZBaseViewController *)getVC:(__kindof VZBaseViewModel *)viewModel
{
    if (!_navigationController) {
        return nil;
    }
    
    VZBaseViewController *baseViewController = [[VZViewModelRouter sharedInstance] viewControllerForViewModel:viewModel];
    
    return baseViewController;
}
@end
