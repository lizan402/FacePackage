//
//  LZTabBarSegmentView.h
//  FacePackage
//
//  Created by zan Li on 2020/5/3.
//  Copyright © 2020 Moqipobing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LZFaceModel;
@class LZTabBarSegmentView;

@protocol LZTabBarSegmentViewDelegate <NSObject>

@required
- (NSArray<LZFaceModel *> *)arrayForTabBarSegmentView:(LZTabBarSegmentView *)segmentView;

@optional
- (void)didselectWithIndex:(NSInteger)index tabBarSegmentView:(LZTabBarSegmentView *)segmentView;

@end



@interface LZTabBarSegmentView : UIView


@property (nonatomic,weak)  id<LZTabBarSegmentViewDelegate>deleagate;
@property (nonatomic, assign) NSInteger selectIndex;

- (void)reloadData;


@end

NS_ASSUME_NONNULL_END
