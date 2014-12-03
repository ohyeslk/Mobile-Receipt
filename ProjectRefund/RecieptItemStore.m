

#import "RecieptItemStore.h"
#import "RecieptItem.h"
#import "PRTextParser.h"

@interface RecieptItemStore()

@property (nonatomic) NSMutableArray *privateItems;

@end

@implementation RecieptItemStore

+ (instancetype)sharedStore
{
    static RecieptItemStore *sharedStore;
    
    // Do I need to create a sharedStore?
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

- (instancetype)init
{
    [NSException raise:@"Singleton" format:@"Use +[BNRItemStore sharedStore]"];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    
    if(self) {
        _privateItems = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSArray *)allItems
{
    return [self.privateItems copy];
}

- (void)createItemFromParser:(PRTextParser*)parser
{
    RecieptItem *item = [[RecieptItem alloc] initTest];
    [self.privateItems addObject:item];
    
}
//FIX IMAGE STORE
- (void)removeItem:(RecieptItem *)item
{
    //NSString *key = item.recieptItemKey;
    
    //[[RecieptItemStore sharedStore] deleteImageForKey:key];
    
    [self.privateItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if (fromIndex == toIndex) {
        return;
    }
    
    RecieptItem *fromItem = self.privateItems[fromIndex];
    [self.privateItems removeObjectAtIndex:fromIndex];
    [self.privateItems insertObject:fromItem
                            atIndex:toIndex];
    
}


@end
