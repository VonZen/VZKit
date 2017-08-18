//
//  VZBaseViewController.m
//  VZKit
//
//  Created by VonZen on 2017/7/21.
//

#import "VZBaseViewController.h"

@interface VZBaseViewController ()

@end

@implementation VZBaseViewController


- (instancetype)initWithViewModel:(__kindof VZBaseViewModel *)viewModel
{
    if (self = [super init]) {
        _viewModel = viewModel;
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addSingleTapGesture];
    
    [self createNavigationBarItem];
    [self createSubview];
    [self bindViewModel];
} 

- (void)back
{
    if (self.navigationController.topViewController == self) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)bindViewModel
{
    self.title = self.viewModel.title;
}

- (void)createNavigationBarItem{}
- (void)createSubview{}

#pragma mark - gesture handle endEditing
- (void)addSingleTapGesture
{
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(fingerTapped)];
    [singleTap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:singleTap];
}

- (void)fingerTapped
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
@end
