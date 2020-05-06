//
//  LZFaceViewController.m
//  FacePackageDemo
//
//  Created by yongqiang li on 2020/5/3.
//  Copyright © 2020 yongqiang li. All rights reserved.
//

#import "LZFaceViewController.h"
#import <Masonry/Masonry.h>
#import "LZFaceViewModel.h"
#import <FacePackage/LZFacePackageBoard.h>
#import <FacePackage/LZFacePackageConfiguration.h>

@interface LZFaceViewController ()<UITextViewDelegate,LZFacePackageBoardDelegate>

@property (nonatomic) UITextView *textView;
@property (nonatomic) UIButton *faceButton;
@property (nonatomic) LZFaceViewModel *faceViewModel;
@property (nonatomic) LZFacePackageBoard *facePackageBoard;

@end

@implementation LZFaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
}

- (void)setUpUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(24);
        make.right.equalTo(self.view).offset(-24);
        make.height.equalTo(@44);
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(20);
    }];
    [self.view addSubview:self.faceButton];
    [self.faceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(24);
        make.right.equalTo(self.view).offset(-24);
        make.height.equalTo(@44);
        make.top.equalTo(self.textView.mas_bottom).offset(20);
    }];
    
}

- (void)onTapGestureEvent
{
    [self.view endEditing:YES];
}

- (void)onClickFaceButtonEvent:(UIButton *)sender
{
    if (sender.selected) {
        [self hideFacePackageBoard];
        sender.selected = NO;
    } else {
        [self showFacePackageBoard];
        sender.selected = YES;
    }
}

- (void)showFacePackageBoard
{
    [self.view addSubview:self.facePackageBoard];
    [self.facePackageBoard mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat bottom = 0.0f;
        if (@available(iOS 11.0, *)) {
            bottom =  [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom ;
        }
        make.bottom.equalTo(self.view).offset(-bottom);
        make.left.right.equalTo(self.view);
//        make.width.equalTo(@(KScreenWidth));

    }];
    [self.facePackageBoard reloadData];
}

- (void)hideFacePackageBoard
{
    [self.facePackageBoard removeFromSuperview];
    _facePackageBoard = nil;
}

- (UIButton *)faceButton
{
    if (!_faceButton) {
        _faceButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _faceButton.layer.borderColor = [UIColor grayColor].CGColor;
        _faceButton.layer.borderWidth = 0.5;
        [_faceButton addTarget:self action:@selector(onClickFaceButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_faceButton setTitle:@"输入表情" forState:UIControlStateNormal];
        [_faceButton setTitle:@"隐藏表情" forState:UIControlStateSelected];
        [_faceButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

    }
    return _faceButton;
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectZero];
        _textView.layer.borderColor = [UIColor grayColor].CGColor;
        _textView.layer.borderWidth = 0.5;
        _textView.delegate = self;
        _textView.text = @"请输入文字";
    }
    return _textView;
}

- (LZFaceViewModel *)faceViewModel
{
    if (!_faceViewModel) {
        _faceViewModel = [[LZFaceViewModel alloc] init];
    }
    return _faceViewModel;
}

- (LZFacePackageBoard *)facePackageBoard
{
    if (!_facePackageBoard) {
        // 可以在LZFacePackageConfiguration 设置其他属性
        [LZFacePackageConfiguration shareInstance].contentSize = CGSizeMake(KScreenWidth, 220);
        _facePackageBoard = [[LZFacePackageBoard alloc] initWithDelegate:self];
//        _facePackageBoard.backgroundColor = [UIColor redColor];
    }
    return _facePackageBoard;
}

#pragma mark --------LZFacePackageBoardDelegate

// 多少种表情包
- (NSInteger)allClassesContentOfFacePackage
{
    return self.faceViewModel.allfaceArray.count;
}

// 当前index表情包所有元素
- (NSArray<LZFaceModel *> *)allItemOfFacePackageClassesIndex:(NSInteger)index
{
    
    return self.faceViewModel.allfaceArray[index];
}

//每种表情在底部显示元素的列表
- (NSArray<LZFaceModel *> *)arrayForTabBarSegment
{
    return self.faceViewModel.tabBarFaceArray;
}

- (void)didSelectWithFaceModel:(LZFaceModel *)faceModel
{
    NSLog(@"didSelectWithFaceModel ==emojiName %@ --emojiDescription- %@ =---path--%@",faceModel.emojiName,faceModel.emojiDescription,faceModel.emojiImg);
}


@end
