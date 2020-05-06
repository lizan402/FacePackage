//
//  LZEmojiPreviewImageView.h
//  FacePackage
//
//  Created by zan Li on 2020/5/3.
//  Copyright © 2020 Moqipobing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZEmojiPreviewImageView : UIView

@property (nonatomic, assign) CGPoint sharpPoint;
@property (nonatomic, strong) UIImageView *emojiImageView;
@property (nonatomic, strong) UILabel *descriptionLabel;

@end

NS_ASSUME_NONNULL_END
