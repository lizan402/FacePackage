//
//  LZFacePageControl.m
//  FacePackage
//
//  Created by zan Li on 2020/5/3.
//  Copyright © 2020 Moqipobing. All rights reserved.
//

#import "LZFacePageControl.h"
#import <Masonry/Masonry.h>
#import "UIColor+LZAdd.h"

@interface LZFacePageControl()

@property (nonatomic, strong) UIPageControl *pageControl;


@end

@implementation LZFacePageControl

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor lz_colorWithHexString:@"#FFFFFF"];
        self.pageControl = [[UIPageControl alloc] init];
            self.pageControl.pageIndicatorTintColor = [UIColor lz_colorWithHexString:@"#C0C0C0"];
        self.pageControl.currentPageIndicatorTintColor = [UIColor lz_colorWithHexString:@"#808080"];
        [self.pageControl addTarget:self action:@selector(pageControlClick:) forControlEvents:(UIControlEventValueChanged)];
        [self addSubview:self.pageControl];
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        UIPanGestureRecognizer *panG = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureClick:)];
        [self.pageControl addGestureRecognizer:panG];
    }
    return self;
}

- (void)panGestureClick:(UIPanGestureRecognizer *)sender {

    CGPoint point = [sender locationInView:self.pageControl];
    
    for (UIView *subV in self.pageControl.subviews) {
        if (subV.frame.origin.x <= point.x && point.x <= subV.frame.origin.x + subV.frame.size.width) {
            self.pageControl.currentPage = [self.pageControl.subviews indexOfObject:subV];
            if ([self.delegate respondsToSelector:@selector(emojiPageControlSelectIndex:)]) {
                [self.delegate emojiPageControlSelectIndex:self.pageControl.currentPage];
            }
        }
    }

}

- (void)pageControlClick:(UIPageControl *)pageControl {
    if ([self.delegate respondsToSelector:@selector(emojiPageControlSelectIndex:)]) {
        [self.delegate emojiPageControlSelectIndex:pageControl.currentPage];
    }
}

- (void)setPageCount:(NSInteger)pageCount {
    _pageCount = pageCount;
    
    _pageControl.numberOfPages = pageCount;
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    
    _pageControl.currentPage = currentPage;
}


@end
