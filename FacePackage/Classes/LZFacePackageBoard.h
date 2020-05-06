//
//  LZFacePackageBoard.h
//  Masonry
//
//  Created by zan Li on 2020/5/3.
//  Copyright © 2020 Moqipobing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LZFaceModel;

@protocol LZFacePackageBoardDelegate <NSObject>

@required
// 多少种表情包
- (NSInteger)allClassesContentOfFacePackage;

// 当前index表情包所有元素
- (NSArray<LZFaceModel *> *)allItemOfFacePackageClassesIndex:(NSInteger)index;

//每种表情在底部显示元素的列表
- (NSArray<LZFaceModel *> *)arrayForTabBarSegment;

@optional
// 点击删除键
- (void)deleteBtnClickFecePackageBorad;

// 选中表元素
- (void)didSelectWithFaceModel:(LZFaceModel *)faceModel;

//返回两个view的

@end

@interface LZFacePackageBoard : UIView

- (instancetype)initWithDelegate:(id<LZFacePackageBoardDelegate>)delegate;


- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
