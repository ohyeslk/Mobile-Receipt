

#import "RecieptDetailViewController.h"
#import "RecieptItem.h"
#import "RecieptItemStore.h"
#import "PRTextParser.h"

@interface RecieptDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *paymentTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *subtotalTextField;
@property (weak, nonatomic) IBOutlet UITextField *taxTextField;
@property (weak, nonatomic) IBOutlet UITextField *totalTextField;
@property (weak, nonatomic) IBOutlet UITextField *item2TextField;
@property (weak, nonatomic) IBOutlet UITextField *item1TextField;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@end

@implementation RecieptDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"Receipt"];
    
    if (self.isFromScanner) {
        NSLog(@"yes");
        //[self.navigationController setNavigationBarHidden:NO animated:YES];
        
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                               target:self
                                                                               action:@selector(cancelImage)];
        
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                      target:self
                                                                                      action:@selector(saveImage)];
        
        [self.navigationItem setLeftBarButtonItem:cancelButton];
        [self.navigationItem setRightBarButtonItem:saveButton];
    }
    else {
        
    }
    
    //self.parser = [[PRTextParser alloc] init];
    //self.parser = self.holdParser;
    
    [self updateFromParser];
}

- (void)updateFromParser
{
    self.subtotalTextField.text = self.subtotal;
    self.taxTextField.text = self.tax;
    self.totalTextField.text = self.total;
    self.paymentTypeTextField.text = self.paymentType;
    
    for (int i = 0; i < [self.itemsArray count]; i++) {
        NSMutableArray *item = [self.itemsArray objectAtIndex:i];
        
        NSMutableString *newItem = [[NSMutableString alloc] init];
        for (int j = [item count] - 1; j > 0; j--) {
            NSString *itemPart = item[j];
            [newItem appendString:itemPart];
        }
        
        if (i == 0) {
            self.item1TextField.text = newItem;
        }
        else {
            self.item2TextField.text = newItem;
        }
        
        NSLog(@"%@", newItem);
    }
}

- (void)cancelImage
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)saveImage
{
    if (self.isFromScanner) {
        //[[RecieptItemStore sharedStore] createItemFromParser:self.parser];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}




@end

