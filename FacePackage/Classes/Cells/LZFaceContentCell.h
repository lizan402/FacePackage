//
//  LZFaceContentCell.h
//  FacePackage
//
//  Created by zan Li on 2020/5/3.
//  Copyright © 2020 Moqipobing. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class  LZFaceModel;

@interface LZFaceContentCell : UICollectionViewCell

@property (nonatomic,readonly) UILabel *emojiLabel;
@property (nonatomic,readonly) UIImageView *emojiImageView;


@property (nonatomic) LZFaceModel *faceModel;

@end

NS_ASSUME_NONNULL_END
