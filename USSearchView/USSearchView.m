//
//  USSearchView.m
//  UponStarrySky
//
//  Created by Cyfuer on 2017/5/25.
//  Copyright © 2017年 cyfuer. All rights reserved.
//

#import "USSearchView.h"

@interface USSearchView () <UITextFieldDelegate>

@property (strong, nonatomic) UIButton *cancleBtn;// 点击取消输入框
@property (strong, nonatomic) UIButton *searchBtn;// 点击启动输入框
@property (strong, nonatomic) UITextField *searchTF;// 输入框

@property (strong, nonatomic) CAShapeLayer *searchIconLayer;
@property (strong, nonatomic) CAShapeLayer *lineLayer;

@end

@implementation USSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    CGRect rect = CGRectMake(frame.origin.x, frame.origin.y, USSearchView_W, USSearchView_H);
    self = [super initWithFrame:rect];
    if (self) {
        
        [self.layer addSublayer:self.lineLayer];
        [self.layer addSublayer:self.searchIconLayer];
        [self addSubview:self.searchBtn];
        [self addSubview:self.searchTF];
        [self addSubview:self.cancleBtn];
        
        // 视图配置
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (CAShapeLayer *)shaperLayerWithPath:(UIBezierPath *)path {
    CAShapeLayer *shapeLayer=[CAShapeLayer layer];
    shapeLayer.lineWidth = 2;
    shapeLayer.path = path.CGPath;
    shapeLayer.lineCap = @"round";
    shapeLayer.fillColor = [UIColor clearColor].CGColor;//填充颜色
    shapeLayer.strokeColor = [UIColor blackColor].CGColor;//边框颜色
    return shapeLayer;
}

- (void)beginInput {
    if (self.block) {
        self.block(USSearchViewStateBeginInput, nil);
    }
    
    if (!self.cancleBtn.alpha) {
        [self unfold];
    }
    
}

- (void)endInput {
    if (self.block) {
        self.block(USSearchViewStateEndInput, self.searchTF.text);
    }
}

- (void)cancleInput {
    self.searchTF.text = nil;
    if (self.block) {
        self.block(USSearchViewStateCancleInput, nil);
    }
    [self fold];
}

- (void)unfold {
    CABasicAnimation *lineAnimation = [self pathAnimationWithFromValue:0 toValue:1];
    [self.lineLayer addAnimation:lineAnimation forKey:nil];
    
    CABasicAnimation *searchIconAnimation = [self pathAnimationWithFromValue:1 toValue:0];
    [self.searchIconLayer addAnimation:searchIconAnimation forKey:nil];
    
    self.cancleBtn.hidden = NO;
    [UIView animateWithDuration:0.35 animations:^{
        self.cancleBtn.alpha = 1;
    }];
    
    self.searchBtn.hidden = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.searchTF.hidden = NO;
        [self.searchTF becomeFirstResponder];
    });
}

- (void)fold {
    [self.searchTF resignFirstResponder];
    self.searchTF.hidden = YES;
    
    CABasicAnimation *lineAnimation = [self pathAnimationWithFromValue:1 toValue:0];
    [self.lineLayer addAnimation:lineAnimation forKey:nil];
    
    CABasicAnimation *searchIconAnimation = [self pathAnimationWithFromValue:0 toValue:1];
    [self.searchIconLayer addAnimation:searchIconAnimation forKey:nil];
    
    [UIView animateWithDuration:0.35 animations:^{
        self.cancleBtn.alpha = 0;
    }completion:^(BOOL finished) {
        self.cancleBtn.hidden = YES;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.32 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.searchBtn.hidden = NO;
    });
}



- (CABasicAnimation *)pathAnimationWithFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue {
    CABasicAnimation *pathAniamtion = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    // 时间
    pathAniamtion.duration = 0.35;
    pathAniamtion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    pathAniamtion.fromValue = [NSNumber numberWithFloat:fromValue];
    pathAniamtion.toValue = [NSNumber numberWithFloat:toValue];
    pathAniamtion.fillMode = kCAFillModeForwards;
    pathAniamtion.removedOnCompletion = NO;
    return pathAniamtion;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self endInput];
    return YES;
}

#pragma mark - Getter
- (CAShapeLayer *)lineLayer {
    if (!_lineLayer) {
        // 底部线条
        CGPoint line_start = CGPointMake(USSearchView_W - USSearchView_Margin_Right, USSearchView_Line_Y);
        CGPoint line_end = CGPointMake(USSearchView_Cancle_Btn_W, USSearchView_Line_Y);
        
        UIBezierPath *line_path = [UIBezierPath bezierPath];
        [line_path moveToPoint:line_start];
        [line_path addLineToPoint:line_end];
        
        _lineLayer = [self shaperLayerWithPath:line_path];
        _lineLayer.strokeEnd = 0;
    }
    return _lineLayer;
}

- (CAShapeLayer *)searchIconLayer {
    if (!_searchIconLayer) {
        // 搜索图标
        CGPoint searchIcon_center_start = CGPointMake(USSearchView_W - USSearchView_Margin_Right, USSearchView_Line_Y);
        CGPoint searchIcon_center = CGPointMake(USSearchView_W  - USSearchView_Margin_Right- USSearchView_Circle_Radius - USSearchView_Circle_Bottom, USSearchView_Line_Y - USSearchView_Circle_Radius - USSearchView_Circle_Bottom);
        
        UIBezierPath *searchIcon_path = [UIBezierPath bezierPath];
        [searchIcon_path moveToPoint:searchIcon_center_start];
        [searchIcon_path addArcWithCenter:searchIcon_center radius:USSearchView_Circle_Radius startAngle:0.25 * M_PI endAngle:- 1.6 * M_PI clockwise:NO];
        
        _searchIconLayer = [self shaperLayerWithPath:searchIcon_path];
    }
    return _searchIconLayer;
}

- (UIButton *)searchBtn {
    if (!_searchBtn) {
        // 响应按钮
        _searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(USSearchView_W - USSearchView_H -  USSearchView_Margin_Right, 0, USSearchView_H, USSearchView_H)];
        [_searchBtn addTarget:self action:@selector(beginInput) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

- (UIButton *)cancleBtn {
    if (!_cancleBtn) {
        // 响应按钮
        _cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, USSearchView_Cancle_Btn_W, USSearchView_H)];
        [_cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancleBtn.adjustsImageWhenHighlighted = NO;
        _cancleBtn.alpha = 0;
        _cancleBtn.hidden = YES;
        _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleBtn addTarget:self action:@selector(cancleInput) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
}

- (UITextField *)searchTF {
    if (!_searchTF) {
        _searchTF = [[UITextField alloc] initWithFrame:CGRectMake(USSearchView_Cancle_Btn_W, USSearchView_SearchTF_Y, USSearchView_W - USSearchView_Margin_Right - USSearchView_Cancle_Btn_W, USSearchView_Circle_Bottom + USSearchView_Circle_Radius * 2)];
        _searchTF.tintColor = [UIColor blackColor];
        _searchTF.placeholder = @"输入星星的名称";
        _searchTF.textColor = [UIColor blackColor];
        _searchTF.delegate = self;
        _searchTF.font = [UIFont systemFontOfSize:USSearchView_SearchTF_Font];
        _searchTF.hidden = YES;
        
    }
    return _searchTF;
}

@end
