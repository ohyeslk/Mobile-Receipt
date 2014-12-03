#import "RecieptItem.h"

@implementation RecieptItem

- (instancetype)initWithItems:(NSMutableArray *)itemsArray
                  subtotal:(NSString *)subtotal
                    total:(NSString *)total
                          tax:(NSString *)tax
{
    
    // call the superclass's designated initializer
    self = [super init];
    
    // did the super initializer succeed?
    if (self){
        _itemsArray = itemsArray;
        _subtotal = subtotal;
        _total = total;
        _tax = tax;
        
    }
    
    return self;
}

- (instancetype)initTest
{
    return [self initWithItems:nil subtotal:nil total:@"$100.00" tax:nil];
}

- (NSString *)description
{
    NSString *descriptionString = [[NSString alloc] initWithFormat:@"Total: %@", self.total];
    
    return descriptionString;
}

@end
