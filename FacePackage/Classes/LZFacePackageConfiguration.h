//
//  LZFacePackageConfiguration.h
//  FacePackage
//
//  Created by zan Li on 2020/5/3.
//  Copyright © 2020 Moqipobing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZFaceModel.h"

#define KScreenWidth ([[UIScreen mainScreen] bounds].size.width)

NS_ASSUME_NONNULL_BEGIN

@interface LZFacePackageConfiguration : NSObject

// 设置整个表情盘的高度 default（KScreenWidth , 220）
@property (nonatomic, assign) CGSize contentSize;

// 表情左右的边距 default 10.0f
@property (nonatomic, assign) CGFloat kMargen;

//  底部  tabbar 高度  为 40
@property (nonatomic, assign) CGFloat tabBarbottomHeight;
//  底部  tabbar 高度  为 20
@property (nonatomic, assign) CGFloat pageControlHeight;

// 默认是字符串表情 最大显示多3 行
@property (nonatomic, assign) NSInteger defaultMaxRow;

// 图片表情 2行
@property (nonatomic, assign) NSInteger imageMaxRow;

// 默认是字符串表情 每个行显示 8个
@property (nonatomic, assign) NSInteger defaultMaxCount;

// 图片表情  每个行显示 4个
@property (nonatomic, assign) NSInteger imageMaxCount;

@property (nonatomic, readonly) CGFloat faceConentWidth;

@property (nonatomic, readonly) CGFloat faceConentHeight;


+ (instancetype)shareInstance;

// 当前section 显示图片类型 还是 字符类型
- (LZFaceType)getCurShowTypeSection:(NSInteger)section;

- (void)updateTabarShowWithArray:(NSArray <LZFaceModel *>*)faceModelArray;

@end

NS_ASSUME_NONNULL_END
