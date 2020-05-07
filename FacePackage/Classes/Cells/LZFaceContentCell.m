//
//  LZFaceContentCell.m
//  FacePackage
//
//  Created by zan Li on 2020/5/3.
//  Copyright © 2020 Moqipobing. All rights reserved.
//

#import "LZFaceContentCell.h"
#import "LZFaceModel.h"
#import <Masonry/Masonry.h>

@interface LZFaceContentCell()

@property (nonatomic) UILabel *emojiLabel;
@property (nonatomic) UIImageView *emojiImageView;

@end

@implementation LZFaceContentCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.emojiLabel];
        [self.emojiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
              make.left.equalTo(self.contentView).offset(2);
              make.right.equalTo(self.contentView).offset(-2);
              make.bottom.equalTo(self.contentView).offset(-2);
          }];
        [self.contentView addSubview:self.emojiImageView];
        [self.emojiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(4);
            make.right.equalTo(self.contentView).offset(-4);
            make.top.equalTo(self.contentView).offset(1);
            make.bottom.equalTo(self.emojiLabel.mas_top).offset(-2);
        }];
  
    }
    return self;
}

- (void)setFaceModel:(LZFaceModel *)faceModel
{
    _faceModel = faceModel;
      if (_faceModel.faceType == LZFaceType_Default) {
          self.emojiLabel.text = _faceModel.emojiName;
          self.emojiImageView.image = nil;
          [self.emojiLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
              make.left.equalTo(self.contentView).offset(2);
              make.right.equalTo(self.contentView).offset(-2);
              make.centerY.equalTo(self.contentView);
          }];
      } else {
          self.emojiLabel.text = _faceModel.emojiName;
          self.emojiImageView.image = [UIImage imageWithContentsOfFile:_faceModel.emojiImg];
          if([faceModel.emojiDescription isEqualToString:@"string_emoji_delete"]){
              self.emojiLabel.hidden = YES;
              [self.emojiImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                   make.left.equalTo(self.contentView).offset(2);
                   make.right.equalTo(self.contentView).offset(-2);
                   make.top.equalTo(self.contentView).offset(2);
                   make.bottom.equalTo(self.contentView).offset(-2);
              }];
          }else{
              [self.emojiLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                  make.left.equalTo(self.contentView).offset(2);
                  make.right.equalTo(self.contentView).offset(-2);
                  make.bottom.equalTo(self.contentView).offset(-2);
                  make.height.equalTo(@16);
              }];
             
              [self.emojiImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                 make.left.equalTo(self.contentView).offset(4);
                 make.right.equalTo(self.contentView).offset(-4);
                 make.top.equalTo(self.contentView).offset(1);
                 make.bottom.equalTo(self.emojiLabel.mas_top).offset(-2);
             }];
         }
      }
}

- (UILabel *)emojiLabel
{
    if (!_emojiLabel) {
        _emojiLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _emojiLabel.font = [UIFont systemFontOfSize:14];
        _emojiLabel.textColor = [UIColor blackColor];
        _emojiLabel.backgroundColor = [UIColor whiteColor];

        _emojiLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _emojiLabel;
}

- (UIImageView *)emojiImageView
{
    if (!_emojiImageView) {
        _emojiImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _emojiImageView.contentMode = UIViewContentModeScaleAspectFit;
        _emojiImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _emojiImageView.layer.borderWidth = 1.0f;
        _emojiImageView.layer.masksToBounds = YES;
    }
    return _emojiImageView;
}


@end
