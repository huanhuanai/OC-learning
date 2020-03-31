//
//  HHAImageStore.m
//  Homepwner
//
//  Created by 李欢 on 2020/3/13.
//  Copyright © 2020 huan. All rights reserved.
//

#import "HHAImageStore.h"

@interface HHAImageStore ()

@property(nonatomic, strong) NSMutableDictionary *dictionary;

- (NSString *)imagePathForKey:(NSString *)key;

@end

@implementation HHAImageStore

+ (instancetype)sharedStore {
    static HHAImageStore *sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    return sharedStore;
}

//不允许直接调用init方法
- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use + [HHAImageStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

//私有化初始化方法
- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(clearCache:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)clearCache:(NSNotification *)note {
    NSLog(@"flushing %lu images out of the cache", (unsigned long)[self.dictionary count]);
    [self.dictionary removeAllObjects];
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key {
    self.dictionary[key] = image;
    
    //获取保存图片的全路径
    NSString *imagePath = [self imagePathForKey:key];
    
    //从图片提取JPEG格式的数据
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    
    //将JPEG格式的数据写入文件
    [data writeToFile:imagePath atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)key {
    //先尝试痛殴字典对象获取图片
    UIImage *result = self.dictionary[key];
    
    if (!result) {
        NSString *imagePath = [self imagePathForKey:key];
        
        //通过文件创建UIImage对象
        result =[UIImage imageWithContentsOfFile:imagePath];
        
        //如果能够通过文件创建图片，就将其放入缓存
        if (result) {
            self.dictionary[key] = result;
        } else {
            NSLog(@"Error:unable to find %@", [self imagePathForKey:key]);
        }
    }
    return result;
}

- (void)deleteImageForKey:(NSString *)key {
    if (!key) {
        return;
    }
    [self.dictionary removeObjectForKey:key];
    
    NSString *imagePath = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
}

- (NSString *)imagePathForKey:(NSString *)key{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:key];
}

@end
