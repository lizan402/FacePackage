//
//  LZFaceContentView.h
//  FacePackage
//
//  Created by zan Li on 2020/5/3.
//  Copyright © 2020 Moqipobing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LZFaceModel;

@protocol LZFaceContentViewDelegate <NSObject>

/**
 总共有几种表情包
 */
- (NSInteger)allClassesOfEmojiContent;
//当前index表情包所有元素
- (NSArray<LZFaceModel *> *)allItemOfEmojiContentForClassesIndex:(NSInteger)ClassesIndex;

@optional
- (void)currentSectionOfEmojiContent:(NSInteger)section;
- (void)currentPageOfEmojiContent:(NSInteger)page;
- (void)pageCountOfEmojiContent:(NSInteger)count;
- (void)emojiDeleteBtnClick;
- (void)didSelectWithIndexPath:(NSIndexPath *)indexP faceModel:(LZFaceModel *)faceModel isDelete:(BOOL)isDelete;

@end

@interface LZFaceContentView : UIView

@property (nonatomic, weak) id<LZFaceContentViewDelegate> delegate;

- (void)scrollToSection:(NSInteger)section;
- (void)scrollToItem:(NSInteger)item;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
