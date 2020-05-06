//
//  LZFaceViewModel.h
//  FacePackageDemo
//
//  Created by yongqiang li on 2020/5/4.
//  Copyright © 2020 yongqiang li. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LZFaceModel;
NS_ASSUME_NONNULL_BEGIN

@interface LZFaceViewModel : NSObject

@property (nonatomic,readonly) NSArray <NSArray *>*allfaceArray;

@property (nonatomic,readonly) NSArray <LZFaceModel *>*tabBarFaceArray;


@end

NS_ASSUME_NONNULL_END
