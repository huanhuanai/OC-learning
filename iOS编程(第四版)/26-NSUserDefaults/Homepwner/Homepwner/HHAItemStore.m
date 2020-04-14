//
//  HHAItemStore.m
//  Homepwner
//
//  Created by 李欢 on 2020/3/8.
//  Copyright © 2020 huan. All rights reserved.
//

#import "HHAItemStore.h"
#import "HHAItem+CoreDataClass.h"
#import "HHAImageStore.h"
#import "HHAAppDelegate.h"
#import <CoreData/CoreData.h>

@interface HHAItemStore ()

@property (nonatomic, strong) NSManagedObjectContext *contex;
@property (nonatomic, strong) NSManagedObjectModel *model;

@end

@implementation HHAItemStore

+ (instancetype)sharedStore {
    static HHAItemStore *sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    return sharedStore;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use + [HHAItemStore sharedStore]" userInfo:nil];
    return nil;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        //设置SQLite文件路径
        NSString *path = [self itemArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error = nil;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeURL
                                     options:nil
                                       error:&error]) {
            @throw [NSException exceptionWithName:@"OpenFailure"
                                           reason:[error localizedDescription]
                                         userInfo:nil];
        }
        
        //创建NSManagedObjectContext对象
        _contex = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _contex.persistentStoreCoordinator = psc;
        
        [self loadAllItems];
    }
    return self;
}

- (NSArray *)allItems {
    return self.privateItems;
}

- (HHAItem *)createItem {
    double order;
    if ([self.allItems count] == 0) {
        order = 1.0;
    } else {
        order = [[self.privateItems lastObject] orderingValue] + 1.0;
    }
    NSLog(@"Adding after %lu items, order = %.2f", [self.privateItems count], order);
    HHAItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"HHAItem" inManagedObjectContext:self.contex];
    item.orderingValue = order;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    item.valueInDollars = [defaults integerForKey:HHANextItemValuePrefsKey];
    item.itemName = [defaults objectForKey:HHANextItemNamePrefsKey];
    
    //查看NSUserDefaults中存储了哪些数据
    NSLog(@"defaults = %@", [defaults dictionaryRepresentation]);
    
    [self.privateItems addObject:item];
    return item;
}

- (void)removeItem:(HHAItem *)item {
    NSString *key = item.itemKey;
    [[HHAImageStore sharedStore] deleteImageForKey:key];
    
    [self.contex deleteObject:item];
    [self.privateItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(NSUInteger)fromIndex
                toIndex:(NSUInteger)toIndex {
    if (fromIndex == toIndex) {
        return;
    }
    //得到要移动对象的指针，以便稍后能将其插入新的位置
    HHAItem *item = self.privateItems[fromIndex];
    
    //将item从allItems数组中移除
    [self.privateItems removeObjectAtIndex:fromIndex];
    
    //根据新的索引位置，将item插回allItems数组
    [self.privateItems insertObject:item atIndex:toIndex];
    
    //为移动的HHAItem对象计算新的orderValue
    double lowerBound = 0.0;
    
//    在数组中，该对象之前是否有其他对象？
    if (toIndex > 0) {
        lowerBound = [self.privateItems[(toIndex - 1)] orderingValue];
    } else {
        lowerBound = [self.privateItems[1] orderingValue] - 2.0;
    }
    double upperBound = 0.0;
    
    //在数组中，该对象之后是否有其他对象？
    if (toIndex < [self.privateItems count] - 1) {
        upperBound = [self.privateItems[(toIndex + 1)] orderingValue];
    } else {
        upperBound = [self.privateItems[(toIndex - 1)] orderingValue] + 2.0;
    }
    double newOrderValue = (lowerBound + upperBound) / 2.0;
    
    NSLog(@"moving to order %f", newOrderValue);
    item.orderingValue = newOrderValue;
}

- (NSString *)itemArchivePath {
    //注意第一个参数是NSDocumentDirectory而不是NSDocumentationDirectory
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //从documentDirectories数组获取第一个，也是唯一文档目录路径
    NSString *documentDirectory = [documentDirectories firstObject];
    NSString *itemPath = [documentDirectory stringByAppendingPathComponent:@"store.data"];
    return itemPath;
}

- (BOOL)saveChanges {
//    NSString *path = [self itemArchivePath];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSError *error;
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:(NSArray<HHAItem *> *)self.privateItems requiringSecureCoding:YES error:&error];
//
//    [fileManager createFileAtPath:path contents:data attributes:nil];
//    NSLog(@"");
//    return YES;
    NSError *error;
    BOOL successful = [self.contex save:&error];
    if (!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    return successful;
}

- (void)loadAllItems {
    if (!self.privateItems) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"HHAItem" inManagedObjectContext:self.contex];
        request.entity = e;
        
        NSSortDescriptor *sd = [NSSortDescriptor  sortDescriptorWithKey:@"orderingValue" ascending:YES];
        
        request.sortDescriptors = @[sd];
        
        NSError *error;
        NSArray *result = [self.contex executeFetchRequest:request error:&error];
        
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        self.privateItems = [[NSMutableArray alloc] initWithArray:result];
    }
}

- (NSArray *)allAssetTypes {
    if (!_allAssetTypes) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"HHAAssetType" inManagedObjectContext:self.contex];
        request.entity = e;
        
        NSError *error = nil;
        NSArray *result = [self.contex executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        _allAssetTypes = [result mutableCopy];
    }
    //第一次运行？
    if ([_allAssetTypes count] == 0) {
        NSManagedObject *type;
        type = [NSEntityDescription insertNewObjectForEntityForName:@"HHAAssetType" inManagedObjectContext:self.contex];
        [type setValue:@"Furniture" forKey:@"label"];
        [_allAssetTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"HHAAssetType" inManagedObjectContext:self.contex];
        [type setValue:@"Jewelry" forKey:@"label"];
        [_allAssetTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"HHAAssetType" inManagedObjectContext:self.contex];
        [type setValue:@"Electronics" forKey:@"label"];
        [_allAssetTypes addObject:type];
    }
    return _allAssetTypes;
}

@end
