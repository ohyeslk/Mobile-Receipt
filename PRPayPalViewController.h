

#import <UIKit/UIKit.h>

@interface PRPayPalViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *itemsArray;
@property (nonatomic, copy) NSString *subtotal;
@property (nonatomic, copy) NSString *total;
@property (nonatomic, copy) NSString *tax;
@property (nonatomic, copy) NSString *paymentType;
@end
