//
//  ViewController.m
//  DFSearchView-Demo
//
//  Created by Cyfuer on 2019/3/14.
//  Copyright © 2019 Cyfuer. All rights reserved.
//

#import "ViewController.h"
#import "USSearchView.h"

@interface ViewController ()

@property (strong, nonatomic) USSearchView *searchView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSearchView];
}

- (void)setupSearchView {
    USSearchView *searchView = [[USSearchView alloc] initWithFrame:CGRectMake(0, 100, 100, 100)];
    searchView.block = ^(USSearchViewState state, NSString *content) {
        if (state == USSearchViewStateBeginInput) {
            
        } else if (state == USSearchViewStateEndInput) {
            
            
        } else if (state == USSearchViewStateCancleInput) {
            
        }
    };
    [self.view addSubview:searchView];
}


@end
