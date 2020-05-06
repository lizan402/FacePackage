//
//  LZFacePackageConfiguration.m
//  FacePackage
//
//  Created by zan Li on 2020/5/3.
//  Copyright © 2020 Moqipobing. All rights reserved.
//

#import "LZFacePackageConfiguration.h"

@interface LZFacePackageConfiguration()

@property (nonatomic) NSDictionary *faceTypeDcit;

@end

@implementation LZFacePackageConfiguration

static LZFacePackageConfiguration *instance = nil;

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _contentSize = CGSizeMake(KScreenWidth, 220);
        _kMargen = 10.0f;
        _pageControlHeight = 20.0f;
        _tabBarbottomHeight = 40.0f;
        _defaultMaxRow = 3;
        _imageMaxRow = 2;
        _defaultMaxCount = 8;
        _imageMaxCount = 4;
    }
    return self;
}

- (CGFloat)faceConentWidth
{
  return self.contentSize.width - self.kMargen * 2;
}

- (CGFloat)faceConentHeight
{
  return self.contentSize.height - self.pageControlHeight -  self.tabBarbottomHeight;
}

- (LZFaceType)getCurShowTypeSection:(NSInteger)section
{
    NSNumber *type = self.faceTypeDcit[@(section)];
    return [type integerValue];
}

- (void)updateTabarShowWithArray:(NSArray <LZFaceModel *>*)faceModelArray
{
    NSMutableDictionary *dict =  [[NSMutableDictionary alloc] init];
    for (NSInteger i = 0; i < faceModelArray.count; i++) {
        LZFaceModel *faceModel = faceModelArray[i];
        dict[@(i)] = @(faceModel.faceType);
    }
    self.faceTypeDcit = [dict copy];
}

@end
