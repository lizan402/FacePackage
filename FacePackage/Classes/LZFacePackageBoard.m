//
//  LZFacePackageBoard.m
//  Masonry
//
//  Created by zan Li on 2020/5/3.
//  Copyright © 2020 Moqipobing. All rights reserved.
//

#import "LZFacePackageBoard.h"
#import "LZTabBarSegmentView.h"
#import "LZFaceContentView.h"
#import "LZFacePageControl.h"
#import <Masonry/Masonry.h>
#import "LZFacePackageConfiguration.h"

@interface LZFacePackageBoard()<LZFaceContentViewDelegate,LZFacePageControlDelegate,LZTabBarSegmentViewDelegate>

@property (nonatomic) LZTabBarSegmentView *tabBarSegmentView;
@property (nonatomic) LZFacePageControl *facePageControl;
@property (nonatomic) LZFaceContentView *faceContentView;
@property (nonatomic,weak) id<LZFacePackageBoardDelegate>delegate;

@end

@implementation LZFacePackageBoard

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (instancetype)initWithDelegate:(id<LZFacePackageBoardDelegate>)delegate
{
    self = [super initWithFrame:CGRectMake(0, 0, [LZFacePackageConfiguration shareInstance].contentSize.width, [LZFacePackageConfiguration shareInstance].contentSize.height)];
    if (self) {
        self.delegate = delegate;
        [self setUpUI];
    }
    return self;
}

- (void)reloadData
{
    [self.tabBarSegmentView reloadData];
}

// 设置 大小
- (CGSize)intrinsicContentSize
{
    return [LZFacePackageConfiguration shareInstance].contentSize;
}

- (void)setUpUI
{
    
    [self addSubview:self.tabBarSegmentView];
    [self.tabBarSegmentView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.right.equalTo(self);
           make.height.mas_equalTo(40);
           make.bottom.equalTo(self.mas_bottom);
       }];

     [self addSubview:self.faceContentView];
     [self.faceContentView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.right.equalTo(self);
         make.top.equalTo(self);
         make.height.mas_equalTo(160);
     }];
    [self addSubview:self.facePageControl];
    [self.facePageControl mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.right.equalTo(self);
         make.top.equalTo(self.faceContentView.mas_bottom);
         make.height.mas_equalTo(20);
     }];
//    _facePageControl.backgroundColor = [UIColor yellowColor];
   
}

#pragma  mark  load  ----

- (LZFaceContentView *)faceContentView
{
     if (!_faceContentView) {
          _faceContentView = [[LZFaceContentView alloc] initWithFrame:CGRectZero];
         _faceContentView.delegate = self;
      }
      return _faceContentView;
}

- (LZFacePageControl *)facePageControl
{
    if (!_facePageControl) {
        _facePageControl = [[LZFacePageControl alloc] initWithFrame:CGRectZero];
        _facePageControl.delegate = self;
    }
    return _facePageControl;
}

- (LZTabBarSegmentView *)tabBarSegmentView
{
    if (!_tabBarSegmentView) {
        _tabBarSegmentView = [[LZTabBarSegmentView alloc] initWithFrame:CGRectZero];
        _tabBarSegmentView.deleagate = self;
    }
    return _tabBarSegmentView;
}

#pragma  mark ------ LZFaceContentViewDelegate

// 多少种表情包
- (NSInteger)allClassesOfEmojiContent
{
    if(self.delegate  && [self.delegate respondsToSelector:@selector(allClassesContentOfFacePackage)]){
        return [self.delegate allClassesContentOfFacePackage];
    }
    return 0;
}
//当前index表情包所有元素
- (NSArray<LZFaceModel *> *)allItemOfEmojiContentForClassesIndex:(NSInteger)ClassesIndex
{
    if(self.delegate  && [self.delegate respondsToSelector:@selector(allItemOfFacePackageClassesIndex:)]){
        return [self.delegate allItemOfFacePackageClassesIndex:ClassesIndex];
      }
    return [NSArray array];
}

- (void)currentSectionOfEmojiContent:(NSInteger)section
{
    self.tabBarSegmentView.selectIndex = section;

}
- (void)currentPageOfEmojiContent:(NSInteger)page
{
    self.facePageControl.currentPage = page;

}
- (void)pageCountOfEmojiContent:(NSInteger)count
{
    self.facePageControl.pageCount = count;

}
- (void)emojiDeleteBtnClick
{
    
}
- (void)didSelectWithIndexPath:(NSIndexPath *)indexP faceModel:(LZFaceModel *)faceModel isDelete:(BOOL)isDelete
{
    if (!isDelete) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectWithFaceModel:)]) {
            [self.delegate didSelectWithFaceModel:faceModel];
        }
    }
}

#pragma  mark ------ LZFacePageControlDelegate

- (void)emojiPageControlSelectIndex:(NSInteger)index
{
    [self.faceContentView scrollToItem:index];

}

#pragma  mark ------ LZTabBarSegmentViewDelegate

- (NSArray<LZFaceModel *> *)arrayForTabBarSegmentView:(LZTabBarSegmentView *)segmentView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(arrayForTabBarSegment)]) {
        NSArray *faceArray = [self.delegate arrayForTabBarSegment];
        [[LZFacePackageConfiguration shareInstance] updateTabarShowWithArray:faceArray];
        return faceArray;
    }
    return [NSArray array];
}

- (void)didselectWithIndex:(NSInteger)index tabBarSegmentView:(LZTabBarSegmentView *)segmentView
{
    [self.faceContentView scrollToSection:index];
}

- (UIButton *)leftButtonOnSegmentView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(leftButtonOnSegmentView)]) {
        return [self.delegate leftButtonOnSegmentView];
    }
    return nil;
}

- (UIButton *)rightButtonOnSegmentView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(rightButtonOnSegmentView)]) {
        return [self.delegate rightButtonOnSegmentView];
    }
    return nil;
}
@end
