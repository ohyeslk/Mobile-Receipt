

#import <Foundation/Foundation.h>

@class RecieptItem;
@class PRTextParser;

@interface RecieptItemStore : NSObject

@property (nonatomic, readonly, copy) NSArray *allItems;

+ (instancetype)sharedStore;
- (void)createItemFromParser:(PRTextParser*)parser;
- (void)removeItem:(RecieptItem *)item;
- (void)moveItemAtIndex:(NSUInteger)fromIndex
                toIndex:(NSUInteger)toIndex;

@end