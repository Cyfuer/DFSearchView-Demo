//
//  USSearchView.h
//  UponStarrySky
//
//  Created by Cyfuer on 2017/5/25.
//  Copyright © 2017年 cyfuer. All rights reserved.
//

#import <UIKit/UIKit.h>

#define USSearchView_W  ([UIScreen mainScreen].bounds.size.width - 16)
#define USSearchView_H  30

#define USSearchView_Margin_Right   16 // 右侧的空白间距
#define USSearchView_Circle_Radius  7
#define USSearchView_Circle_Bottom  4 //搜索图标圆圈部分底部距离把柄顶部的距离
#define USSearchView_SearchTF_Y     ((USSearchView_H - USSearchView_Circle_Radius * 2 - USSearchView_Circle_Bottom) / 2) // // 保证视图内容居中
#define USSearchView_Line_Y         (USSearchView_SearchTF_Y + USSearchView_Circle_Radius*2 + USSearchView_Circle_Bottom + 2)
#define USSearchView_SearchTF_Font  15
#define USSearchView_Cancle_Btn_W   42

typedef NS_ENUM(NSInteger ,USSearchViewState) {
    USSearchViewStateBeginInput = 0,
    USSearchViewStateEndInput,
    USSearchViewStateCancleInput
};

typedef void (^USSearchViewBlock)(USSearchViewState state, NSString *content);

@interface USSearchView : UIView

@property (copy, nonatomic) USSearchViewBlock block;

@end
