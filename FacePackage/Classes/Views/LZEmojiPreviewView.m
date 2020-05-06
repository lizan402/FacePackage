//
//  LZEmojiPreviewView.m
//  FacePackage
//
//  Created by zan Li on 2020/5/3.
//  Copyright © 2020 Moqipobing. All rights reserved.
//

#import "LZEmojiPreviewView.h"

static CGFloat LZEmojiPreviewImageTopPadding = 18.0;
static CGFloat LZEmojiPreviewImageLeftRightPadding = 22.0;
static CGFloat LZEmojiPreviewImageLength = 48.0;
static CGFloat LZEmojiPreviewImageBottomMargin = 2.0;

@implementation LZEmojiPreviewView

- (instancetype)init {
    if (self = [super init]) {
        self.image = [UIImage imageNamed:@"emoji-preview-bg"];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.emojiImageView.frame = CGRectMake(LZEmojiPreviewImageLeftRightPadding, LZEmojiPreviewImageTopPadding, LZEmojiPreviewImageLength, LZEmojiPreviewImageLength);
    self.descriptionLabel.frame = CGRectMake(10,CGRectGetMaxY(self.emojiImageView.frame) + LZEmojiPreviewImageBottomMargin, self.frame.size.width - 20, 20);
}

- (UIImageView *)emojiImageView {
    if (!_emojiImageView) {
        _emojiImageView = [[UIImageView alloc] init];
        [self addSubview:_emojiImageView];
    }
    return _emojiImageView;
}

- (UILabel *)descriptionLabel
{
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] init];
        [self addSubview:_descriptionLabel];
        _descriptionLabel.font = [UIFont systemFontOfSize:11.0];
        _descriptionLabel.textColor =  [UIColor grayColor];//[UIColor colorWithHexString:@"#4A4A4A"];
        _descriptionLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _descriptionLabel;
}

@end
