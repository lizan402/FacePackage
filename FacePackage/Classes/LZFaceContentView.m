//
//  LZFaceContentView.m
//  FacePackage
//
//  Created by zan Li on 2020/5/3.
//  Copyright © 2020 Moqipobing. All rights reserved.
//

#import "LZFaceContentView.h"
#import "LZFaceContentLayout.h"
#import <Masonry/Masonry.h>
#import "LZFaceContentCell.h"
#import "LZFaceModel.h"
#import "LZEmojiPreviewView.h"
#import "LZEmojiPreviewImageView.h"
#import "LZFacePackageConfiguration.h"

#define kMargen 10
#define kimgPreviewkWidthHeight 150


@interface LZFaceContentView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) LZFaceContentLayout *layout;

@property (nonatomic, assign) NSInteger sectionCount;
@property (nonatomic, assign) NSInteger currentIndexOfPage;

@property (nonatomic, strong) LZEmojiPreviewView *emojiPreview;
@property (nonatomic, strong) LZEmojiPreviewImageView *emojiImagePreview;
@property (nonatomic, strong) NSTimer *deleteEmojiTimer;

@end

@implementation LZFaceContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        longPress.minimumPressDuration = 0.2;
        
        [self.collectionView addGestureRecognizer:longPress];
    }
    return self;
}

- (void)scrollToItem:(NSInteger)item {
    
    NSInteger kwidth = [LZFacePackageConfiguration shareInstance].faceConentWidth;

    NSInteger offPage = item - self.currentIndexOfPage;
    [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x + offPage*kwidth, 0)];
}


- (LZFaceContentLayout *)layout
{
    if (!_layout) {
        _layout = [[LZFaceContentLayout alloc] init];
    }
    return _layout;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView =  [[UICollectionView alloc] initWithFrame:CGRectMake(kMargen, 0,[LZFacePackageConfiguration shareInstance].faceConentWidth, [LZFacePackageConfiguration shareInstance].faceConentHeight) collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.clipsToBounds = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor grayColor];
        [_collectionView registerClass:[LZFaceContentCell class] forCellWithReuseIdentifier:NSStringFromClass([LZFaceContentCell class])];
    }
    return _collectionView;
}

//每个section对应的行数
- (NSInteger)maxRowWithSection:(NSInteger)section {
    
    if ([self  getCurFaceModelWithSection:section] == LZFaceType_Default) {
        return [LZFacePackageConfiguration shareInstance].defaultMaxRow;
    }else {
        return [LZFacePackageConfiguration shareInstance].imageMaxRow;
    }
}
//每个section对应的每行的个数
- (NSInteger)maxCountPerRowWithSection:(NSInteger)section {
    if ([self  getCurFaceModelWithSection:section] == LZFaceType_Default) {
        return [LZFacePackageConfiguration shareInstance].defaultMaxCount;
    }else {
        return [LZFacePackageConfiguration shareInstance].imageMaxCount;
    }
}

- (LZFaceType )getCurFaceModelWithSection:(NSInteger)section
{
    LZFaceType type =  [[LZFacePackageConfiguration shareInstance] getCurShowTypeSection:section];
    return type;
  
}

- (void)setDelegate:(id<LZFaceContentViewDelegate>)delegate {
    _delegate = delegate;
    //返回默认
    NSInteger pageCount = 0;
    if ([self.delegate respondsToSelector:@selector(allItemOfEmojiContentForClassesIndex:)]) {
        NSInteger count = [self.delegate allItemOfEmojiContentForClassesIndex:0].count;
        //全填充
        NSInteger maxRow = [self maxRowWithSection:0];
        NSInteger maxCountPerRow = [self maxCountPerRowWithSection:0];
        
        pageCount = (count + ((maxRow*maxCountPerRow) - (count % (maxRow*maxCountPerRow))))/(maxRow*maxCountPerRow);
    }

    if ([self.delegate respondsToSelector:@selector(currentSectionOfEmojiContent:)]) {
        [self.delegate currentSectionOfEmojiContent:0];
    }
    if ([self.delegate respondsToSelector:@selector(currentPageOfEmojiContent:)]) {
        [self.delegate currentPageOfEmojiContent:0];
    }
    if ([self.delegate respondsToSelector:@selector(pageCountOfEmojiContent:)]) {
        [self.delegate pageCountOfEmojiContent:pageCount];
    }
}

#pragma mark -  ----------CollectionView--delegate----------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.sectionCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger maxRow = [self maxRowWithSection:section];
    NSInteger maxCountPerRow = [self maxCountPerRowWithSection:section];
    
    if ([self.delegate respondsToSelector:@selector(allItemOfEmojiContentForClassesIndex:)]) {
        NSInteger count = [self.delegate allItemOfEmojiContentForClassesIndex:section].count;
        
        //全填充 要不然layout布局有问题
        NSInteger newCount = count + (maxRow*maxCountPerRow - (count % (maxRow*maxCountPerRow)));
        return newCount;
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LZFaceContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LZFaceContentCell class]) forIndexPath:indexPath];
    NSArray<LZFaceModel *> *allItemArr = [self.delegate allItemOfEmojiContentForClassesIndex:indexPath.section];
    if (allItemArr.count > indexPath.item) {
        LZFaceModel *faceModel = allItemArr[indexPath.item];
        cell.faceModel = faceModel;
    } else {
        //第一个section最后一个显示删除
             NSInteger count = [self maxCountPerRowWithSection:0] * [self maxRowWithSection:0];
             if (indexPath.section == 0 && allItemArr.count%count > 0 && indexPath.item == count*(ceilf((CGFloat)allItemArr.count/count)) - 1) {
                 LZFaceModel *faceModel =  [[LZFaceModel alloc] init];
                 cell.faceModel = faceModel;
             }else {
                 cell.faceModel = nil;
             }
    }

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger maxRow = [self maxRowWithSection:indexPath.section];
    NSInteger maxCountPerRow = [self maxCountPerRowWithSection:indexPath.section];
    
    return CGSizeMake([LZFacePackageConfiguration shareInstance].faceConentWidth / maxCountPerRow, [LZFacePackageConfiguration shareInstance].faceConentHeight/maxRow );
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LZFaceContentCell *cell = (LZFaceContentCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (cell.faceModel) {
        if ([self.delegate respondsToSelector:@selector(didSelectWithIndexPath:faceModel:isDelete:)]) {
            BOOL isDelete = NO;
            NSInteger maxRow = [self maxRowWithSection:indexPath.section];
            NSInteger maxCountPerRow = [self maxCountPerRowWithSection:indexPath.section];

            if ((indexPath.item + 1) %(maxRow * maxCountPerRow) == 0 && indexPath.item != 0 && indexPath.section == 0) {
                isDelete = YES;
            }else {
//                LZEmojiModel *model = [[self.delegate allItemOfEmojiContentForClassesIndex:indexPath.section] objectAtIndex:indexPath.item];
//
//                path = kBundlePathImage(@"Emojis", @"bundle", model.emojiName, @"png");
            }
            
            [self.delegate didSelectWithIndexPath:indexPath faceModel:cell.faceModel isDelete:isDelete];
        }
    }
}



- (void)scrollToSection:(NSInteger)section {
    
    NSInteger pageCount = 0;
    NSInteger offset = 0;
    self.currentIndexOfPage = 0;
    NSInteger maxRow = 0;
    NSInteger maxCountPerRow = 0;
    
    for (int i = 0; i < section; i++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:i];
        maxCountPerRow = [self maxCountPerRowWithSection:i];
        maxRow = [self maxRowWithSection:i];
        
        pageCount = itemCount/(maxRow*maxCountPerRow);
        
        offset += pageCount * ((KScreenWidth - kMargen - kMargen));
    }
    [self.collectionView setContentOffset:CGPointMake(offset, 0)];
    
    if ([self.delegate respondsToSelector:@selector(pageCountOfEmojiContent:)]) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        maxCountPerRow = [self maxCountPerRowWithSection:section];
        maxRow = [self maxRowWithSection:section];

        pageCount = itemCount/(maxRow*maxCountPerRow);

        [self.delegate pageCountOfEmojiContent:pageCount];
    }
    if ([self.delegate respondsToSelector:@selector(currentPageOfEmojiContent:)]) {
        [self.delegate currentPageOfEmojiContent:0];
    }
}

#pragma  mark ----- scrollViewDidScroll


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGPoint point = scrollView.contentOffset;
    NSInteger pageCount = 0;
    NSInteger currentPage = 0;
    NSInteger currentSection = 0;
    NSInteger offset = point.x;
    
    NSInteger maxRow = 0;
    NSInteger maxCountPerRow = 0;
    
    NSInteger kwidth = (KScreenWidth - kMargen - kMargen);
    
    for (int i = 0; i < self.sectionCount; i++) {
        
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:i];
        maxCountPerRow = [self maxCountPerRowWithSection:i];
        maxRow = [self maxRowWithSection:i];
        
        pageCount = itemCount/(maxRow*maxCountPerRow);

        if (pageCount * kwidth > offset) {
            currentPage = (NSInteger)(offset/kwidth)%pageCount;
            self.currentIndexOfPage = currentPage;
            currentSection = i;
            break;
        }else {
            offset = offset - (pageCount*kwidth);
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(currentSectionOfEmojiContent:)]) {
        NSLog(@"currentSectionOfEmojiContent currentSection---- %@",@(currentSection));
        [self.delegate currentSectionOfEmojiContent:currentSection];
    }
    if ([self.delegate respondsToSelector:@selector(pageCountOfEmojiContent:)]) {
        NSLog(@"pageCountOfEmojiContent  pageCount---- %@",@(pageCount));

        [self.delegate pageCountOfEmojiContent:pageCount];
    }
    if ([self.delegate respondsToSelector:@selector(currentPageOfEmojiContent:)]) {
        [self.delegate currentPageOfEmojiContent:currentPage];
    }
}



#pragma mark -  ----------lazyLoading----------
- (NSInteger)sectionCount {
    if (!_sectionCount) {
        if ([self.delegate respondsToSelector:@selector(allClassesOfEmojiContent)]) {
            _sectionCount = [self.delegate allClassesOfEmojiContent];
        }else {
            _sectionCount = 1;
        }
    }
    return _sectionCount;
}

- (LZEmojiPreviewView *)emojiPreview {
    if (!_emojiPreview) {
        _emojiPreview = [[LZEmojiPreviewView alloc] init];
    }
    return _emojiPreview;
}

- (LZEmojiPreviewImageView *)emojiImagePreview {
    if (!_emojiImagePreview) {
        _emojiImagePreview = [[LZEmojiPreviewImageView alloc] init];
    }
    return _emojiImagePreview;
}



#pragma mark -  ----------UILongPressGestureRecognizer----------

- (void)longPressAction:(UILongPressGestureRecognizer *)sender {
    
    CGPoint touchPoint = [sender locationInView:self.collectionView];
    
    NSIndexPath *indexP = [self.collectionView indexPathForItemAtPoint:touchPoint];
    
    LZFaceContentCell *cell = (LZFaceContentCell *)[self.collectionView cellForItemAtIndexPath:indexP];
    if (indexP.section == 0 && (indexP.item + 1) %24 == 0 && indexP.item != 0) {
        if (self.emojiPreview.superview) {
            self.emojiPreview.frame = CGRectZero;
            self.emojiPreview.emojiImageView.image = nil;
            self.emojiPreview.descriptionLabel.text = @"";
            [self.emojiPreview removeFromSuperview];
        }
        if (sender.state == UIGestureRecognizerStateBegan) {
            
            if (self.deleteEmojiTimer) {
                [self.deleteEmojiTimer invalidate];
                self.deleteEmojiTimer = nil;
            }
            
            self.deleteEmojiTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(delegateDeleteEmoji) userInfo:nil repeats:YES];
        
        }else if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateFailed || sender.state == UIGestureRecognizerStateCancelled) {

            if (self.deleteEmojiTimer) {
                [self.deleteEmojiTimer invalidate];
                self.deleteEmojiTimer = nil;
            }
        
            if ([self.delegate respondsToSelector:@selector(emojiDeleteBtnClick)]) {
                [self.delegate emojiDeleteBtnClick];
            }
        }else {
            //从别的emoji长按滑动回来 会进这里 如果需要执行删除 把began里代码copy过来即可
        }
        return;
    }
    
    //滑动后 是没释放的
    if (self.deleteEmojiTimer) {
        [self.deleteEmojiTimer invalidate];
        self.deleteEmojiTimer = nil;
    }
    
    CGRect rect = [cell convertRect:cell.emojiImageView.frame toView:[UIApplication sharedApplication].keyWindow];
    //section = 0 显示emoji预览 别的显示img预览
    if (indexP) {
        if (indexP.section == 0) {
            [self showEmojiPreviewWith:rect gesture:sender cell:cell];
        }else {
            [self showImgPreviewWith:rect gesture:sender cell:cell];
        }
    }else {
        //防止手势区域滑出 获取到indexP为null 视图不会消失
        self.emojiImagePreview.frame = CGRectZero;
        self.emojiImagePreview.emojiImageView.image = nil;
        self.emojiImagePreview.descriptionLabel.text = @"";
        [self.emojiImagePreview removeFromSuperview];
        self.emojiPreview.frame = CGRectZero;
        self.emojiPreview.emojiImageView.image = nil;
        self.emojiPreview.descriptionLabel.text = @"";
        [self.emojiPreview removeFromSuperview];
    }
}

#pragma mark -  ----------删除emoji 代理----------
- (void)delegateDeleteEmoji {
    if ([self.delegate respondsToSelector:@selector(emojiDeleteBtnClick)]) {
        [self.delegate emojiDeleteBtnClick];
        NSLog(@"--------delegateDeleteEmoji");
    }
}

#pragma mark -  ----------emoji的长按展示----------
- (void)showEmojiPreviewWith:(CGRect)rect gesture:(UILongPressGestureRecognizer *)sender cell:(LZFaceContentCell *)cell {
    
    if (self.emojiImagePreview.superview) {
        self.emojiImagePreview.frame = CGRectZero;
        self.emojiImagePreview.emojiImageView.image = nil;
        self.emojiImagePreview.descriptionLabel.text = @"";
        [self.emojiImagePreview removeFromSuperview];
    }
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (cell.emojiImageView.image) {
            self.emojiPreview.emojiImageView.image = cell.emojiImageView.image;
            self.emojiPreview.descriptionLabel.text = cell.emojiLabel.text;
            self.emojiPreview.frame = CGRectZero;
            if (!self.emojiPreview.superview) {
                UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
                [window addSubview:self.emojiPreview];
            }
            self.emojiPreview.frame = CGRectMake(rect.origin.x - 90/2.0 + rect.size.width/2.0, rect.origin.y + rect.size.height/2.0 - 140, 90, 140);
        }else {
            self.emojiPreview.frame = CGRectZero;
            self.emojiPreview.emojiImageView.image = nil;
            self.emojiPreview.descriptionLabel.text = @"";
            [self.emojiPreview removeFromSuperview];
        }
    }else if (sender.state == UIGestureRecognizerStateChanged) {
        if (cell.emojiImageView.image) {
            if (!self.emojiPreview.superview) {
                UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
                [window addSubview:self.emojiPreview];
            }
            self.emojiPreview.frame = CGRectMake(rect.origin.x - 90/2.0 + rect.size.width/2.0, rect.origin.y + rect.size.height/2.0 - 140, 90, 140);
            self.emojiPreview.emojiImageView.image = cell.emojiImageView.image;
            self.emojiPreview.descriptionLabel.text = cell.emojiLabel.text;
        }else {
            self.emojiPreview.frame = CGRectZero;
            self.emojiPreview.emojiImageView.image = nil;
            self.emojiPreview.descriptionLabel.text = @"";
            [self.emojiPreview removeFromSuperview];
        }
    }else {
        self.emojiPreview.frame = CGRectZero;
        self.emojiPreview.emojiImageView.image = nil;
        self.emojiPreview.descriptionLabel.text = @"";
        [self.emojiPreview removeFromSuperview];
    }
}

#pragma mark -  ----------img的长按展示----------
- (void)showImgPreviewWith:(CGRect)rect gesture:(UILongPressGestureRecognizer *)sender cell:(LZFaceContentCell *)cell {
 
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (cell.emojiImageView.image) {
            self.emojiImagePreview.emojiImageView.image = cell.emojiImageView.image;
            self.emojiImagePreview.descriptionLabel.text = cell.emojiLabel.text;
            self.emojiImagePreview.frame = CGRectZero;
            if (!self.emojiImagePreview.superview) {
                UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
                [window addSubview:self.emojiImagePreview];
            }

            CGFloat originX = rect.origin.x - kimgPreviewkWidthHeight/2.0 + rect.size.width/2.0;
            if (originX + kimgPreviewkWidthHeight > KScreenWidth) {
                originX = KScreenWidth - kimgPreviewkWidthHeight - 10;
            }
            if (rect.origin.x - kimgPreviewkWidthHeight/2.0 + rect.size.width/2.0 < 10) {
                originX = 10;
            }
            
            self.emojiImagePreview.frame = CGRectMake(originX, rect.origin.y - kimgPreviewkWidthHeight, kimgPreviewkWidthHeight, kimgPreviewkWidthHeight);
            
            self.emojiImagePreview.sharpPoint = CGPointMake((rect.origin.x - kimgPreviewkWidthHeight/2.0 + rect.size.width/2.0) + kimgPreviewkWidthHeight/2, rect.origin.y);
            [self.emojiImagePreview setNeedsDisplay];

        }else {
            self.emojiImagePreview.frame = CGRectZero;
            self.emojiImagePreview.emojiImageView.image = nil;
            self.emojiImagePreview.descriptionLabel.text = @"";
            [self.emojiImagePreview removeFromSuperview];
        }
    }else if (sender.state == UIGestureRecognizerStateChanged) {
        if (cell.emojiImageView.image) {
            if (!self.emojiImagePreview.superview) {
                UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
                [window addSubview:self.emojiImagePreview];
            }
            self.emojiImagePreview.emojiImageView.image = cell.emojiImageView.image;
            self.emojiImagePreview.descriptionLabel.text = cell.emojiLabel.text;
            
            CGFloat originX = rect.origin.x - kimgPreviewkWidthHeight/2.0 + rect.size.width/2.0;
            if (originX + kimgPreviewkWidthHeight > KScreenWidth) {
                originX = KScreenWidth - kimgPreviewkWidthHeight - 10;
            }
            if (rect.origin.x - kimgPreviewkWidthHeight/2.0 + rect.size.width/2.0 < 10) {
                originX = 10;
            }
            
            self.emojiImagePreview.frame = CGRectMake(originX, rect.origin.y - kimgPreviewkWidthHeight, kimgPreviewkWidthHeight, kimgPreviewkWidthHeight);
            
            self.emojiImagePreview.sharpPoint = CGPointMake((rect.origin.x - kimgPreviewkWidthHeight/2.0 + rect.size.width/2.0) + kimgPreviewkWidthHeight/2, rect.origin.y);
            [self.emojiImagePreview setNeedsDisplay];
        }else {
            self.emojiImagePreview.frame = CGRectZero;
            self.emojiImagePreview.frame = CGRectZero;
            self.emojiImagePreview.emojiImageView.image = nil;
            self.emojiImagePreview.descriptionLabel.text = @"";
            [self.emojiImagePreview removeFromSuperview];
        }
    }else {
        self.emojiImagePreview.frame = CGRectZero;
        self.emojiImagePreview.emojiImageView.image = nil;
        self.emojiImagePreview.descriptionLabel.text = @"";
        [self.emojiImagePreview removeFromSuperview];
    }
}


@end
