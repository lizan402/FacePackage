//
//  LZFaceViewModel.m
//  FacePackageDemo
//
//  Created by zan li on 2020/5/4.
//  Copyright © 2020 zan li. All rights reserved.
//

#import "LZFaceViewModel.h"
#import <FacePackage/LZFaceModel.h>
#import <FacePackage/LZFacePackageConfiguration.h>

#define kBundlePathImage(resource, extension, imgName, type) ([[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:resource withExtension:extension]] pathForResource:[NSString stringWithFormat:@"%@@2x", imgName] ofType:type] ? [[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:resource withExtension:extension]] pathForResource:[NSString stringWithFormat:@"%@@2x", imgName] ofType:type] : [[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:resource withExtension:extension]] pathForResource:[NSString stringWithFormat:@"%@@3x", imgName] ofType:type] ? [[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:resource withExtension:extension]] pathForResource:[NSString stringWithFormat:@"%@@3x", imgName] ofType:type] : [[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:resource withExtension:extension]] pathForResource:imgName ofType:type])


@interface LZFaceViewModel()

@property (nonatomic) NSArray <NSArray *>*allfaceArray;
@property (nonatomic) NSArray <LZFaceModel *>*tabBarFaceArray;

@end

@implementation LZFaceViewModel

- (instancetype) init
{
    self = [super init];
    if (self) {
        _allfaceArray = [NSArray array];
        [self loadReource];
    }
    return self;
}

- (void)loadReource
{
    NSArray *strFaceArray = [self loadLocalStringFace];
    self.allfaceArray  = [self.allfaceArray arrayByAddingObjectsFromArray:strFaceArray];
    NSArray *imageFaceArray = [self loadLocalImageFace];
    self.allfaceArray  = [self.allfaceArray arrayByAddingObjectsFromArray:imageFaceArray];
    self.tabBarFaceArray = [self handleTabBarItems];
}

// 可以单独设置bar的主题材料，这里不设置就取第一个
- (NSArray *)handleTabBarItems
{
    NSMutableArray *tabbarItemArray = [[NSMutableArray alloc] init];
    for (NSArray *faceArray in self.allfaceArray) {
        [tabbarItemArray addObject:faceArray.firstObject];
    }
    return [tabbarItemArray copy];
}

// 加载本地字符串表情
- (NSArray *)loadLocalStringFace
{
    NSString *path = [NSBundle.mainBundle pathForResource:@"EmojisList" ofType:@"plist"];
    if (path.length == 0) {
        return [NSArray array];
    }
    NSDictionary *sourceDict = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSMutableArray *allEmojisArr = [NSMutableArray array];
    [sourceDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSMutableArray *emojisArr  = [[NSMutableArray alloc] init];
        NSArray *objArray = (NSArray*)obj;
        for (NSString *emoji in objArray) {
            NSInteger  index = [objArray indexOfObject:emoji];
            NSInteger  countPerPage = [LZFacePackageConfiguration shareInstance].defaultMaxRow * [LZFacePackageConfiguration shareInstance].defaultMaxCount  - 1 ;
            if (index % countPerPage == 0 && index > 0) {//当是本页的最后一个元素时，填充删除图片。
                LZFaceModel *deleteModel = [[LZFaceModel alloc] init];
                deleteModel.faceType = LZFaceType_Image;
                //deleteModel.emojiImg = @"wb_emoji_keyboard_backspace_icon";
                NSString *emojiImg = @"bingbujiandan";
                NSString *path =  kBundlePathImage(@"Emojis", @"bundle", emojiImg, @"png");
                deleteModel.emojiImg = path;
                deleteModel.emojiDescription = @"string_emoji_delete";
                [emojisArr addObject:deleteModel];
            }
            LZFaceModel *myFace =  [[LZFaceModel alloc] init];
            myFace.faceType = LZFaceType_Default;
            myFace.emojiName = emoji;
            myFace.emojiDescription = (NSString *)key;
            [emojisArr addObject:myFace];
        }
        NSLog(@"key = %@,vaule = %@",key,obj);
        [allEmojisArr addObject:emojisArr];
    }];
    return [allEmojisArr copy];
 
}


- (NSArray *)loadLocalImageFace
{
   NSString *path = [NSBundle.mainBundle pathForResource:@"EmojisImages" ofType:@"plist"];
    if (path.length == 0) {
        return [NSArray array];
    }
    
    NSArray *sourceArray = [[NSArray alloc] initWithContentsOfFile:path];
    NSMutableArray *allEmojisArr = [NSMutableArray array];
    for (NSDictionary *dic in sourceArray) {
         NSString *name = dic[@"classes"];
        NSArray *emojiArr = dic[@"emoticons"];
        NSMutableArray<LZFaceModel *> *emojis = [NSMutableArray array];
        for (NSDictionary *emojiDict in emojiArr) {
            LZFaceModel *face = [[LZFaceModel alloc] init];
            face.emojiName = name;
            face.emojiDescription = emojiDict[@"desc"];
            face.faceType = LZFaceType_Image;
              NSString *emojiImg = emojiDict[@"image"];
            NSString *path =  kBundlePathImage(@"Emojis", @"bundle", emojiImg, @"png");
            face.emojiImg = path;
            
            [emojis addObject:face];
        }
        [allEmojisArr addObject:emojis];
    }
    return [allEmojisArr copy];
}

@end
