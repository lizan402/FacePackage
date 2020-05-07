//
//  LZTabBarSegmentView.m
//  FacePackage
//
//  Created by zan Li on 2020/5/3.
//  Copyright © 2020 Moqipobing. All rights reserved.
//

#import "LZTabBarSegmentView.h"
#import "LZTabbarSegmentCell.h"
#import <Masonry/Masonry.h>
#import "LZFaceModel.h"
#import "LZFacePackageConfiguration.h"

@interface LZTabBarSegmentView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) UIButton *leftButton;
@property (nonatomic) UIButton *rightButton;

@property (nonatomic) NSArray *faceModelArray;


@end

@implementation LZTabBarSegmentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self addSubview:self.leftButton];
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(40);
            make.right.equalTo(self).offset(-42);
            make.top.bottom.equalTo(self);
            
        }];
//        [self addSubview:self.rightButton];
//        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self).offset(-2);
//            make.width.equalTo(@40);
//            make.top.bottom.equalTo(self);
//        }];
    }
    return self;
}

- (void)reloadData
{
    if (self.deleagate && [self.deleagate respondsToSelector:@selector(arrayForTabBarSegmentView:)]) {
        _faceModelArray = [self.deleagate  arrayForTabBarSegmentView:self];
    }
    [self updateSelectFaceModelWithIndex:self.selectIndex];
}


- (void)updateSelectFaceModelWithIndex:(NSInteger)index
{
    NSLog(@"updateSelectFaceModelWithIndex, === %@",@(index));
    for (NSInteger i = 0 ;i < self.faceModelArray.count; i++){
        LZFaceModel *faceModel = self.faceModelArray[i];
        if (i == index) {
             faceModel.isSelect = YES;
        }else {
             faceModel.isSelect = NO;
        }
    }
}

- (UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_rightButton setTitle:@"发送" forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(onClickRightButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}


- (void)onClickRightButtonEvent
{
    NSLog(@"---onClickRightButtonEvent--");

}

- (UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_leftButton setTitle:@"+" forState:UIControlStateNormal];
        [_leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(onClickLeftButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (void)onClickLeftButtonEvent
{
    NSLog(@"---onClickLeftButtonEvent--");
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    if (selectIndex == _selectIndex) {
        return;
    }
    _selectIndex = selectIndex;
    if (self.faceModelArray.count > selectIndex) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:selectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [self updateSelectFaceModelWithIndex:selectIndex];
        [self.collectionView reloadData];
    }
    
}

- (void)setDeleagate:(id<LZTabBarSegmentViewDelegate>)deleagate
{
    _deleagate = deleagate;
    if (_deleagate && [_deleagate respondsToSelector:@selector(leftButtonOnSegmentView)]) {
        self.leftButton = [self.deleagate leftButtonOnSegmentView];
    }
    [self addSubview:self.leftButton];
    
    if (_deleagate && [_deleagate respondsToSelector:@selector(rightButtonOnSegmentView)]) {
        self.rightButton = [self.deleagate rightButtonOnSegmentView];
    }
    [self addSubview:self.rightButton];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.right.equalTo(self).offset(-2);
      make.width.equalTo(@40);
      make.top.bottom.equalTo(self);
   }];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout =  [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0.0f;
        flowLayout.minimumInteritemSpacing = 0.0f;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(40.0f, 40.0f);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[LZTabbarSegmentCell class] forCellWithReuseIdentifier:NSStringFromClass([LZTabbarSegmentCell class])];
    }
    return _collectionView;
}

#pragma  mark ---------UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _faceModelArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LZTabbarSegmentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LZTabbarSegmentCell class]) forIndexPath:indexPath];
    if (self.faceModelArray.count > indexPath.item) {
        LZFaceModel *faceModel = self.faceModelArray[indexPath.item];
        cell.faceModel = faceModel;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectItemAtIndexPath---");
    [self updateSelectFaceModelWithIndex:indexPath.item];
    [collectionView reloadData];
    if (self.deleagate && [self.deleagate respondsToSelector:@selector(didselectWithIndex:tabBarSegmentView:)]) {
        [self.deleagate didselectWithIndex:indexPath.item tabBarSegmentView:self];
    }
}

@end


