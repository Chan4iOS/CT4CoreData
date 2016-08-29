//
//  ViewController.m
//  CT4CoreData
//
//  Created by 陈世翰 on 16/8/29.
//  Copyright © 2016年 chan. All rights reserved.
//

#import "ViewController.h"
#import "CT4CoreData.h"
#import "Person.h"
#import "Phone.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
    [Person CTA_save:^(NSManagedObjectContext *currentContext) {
        for (int i = 0; i<10; i++) {
             NSDictionary *dic = @{@"Name":[NSString stringWithFormat:@"陈小翰%d",i],@"phones":@[@{@"phoneVersion":@"7"},@{@"phoneVersion":@"8"}]};
         Person *person = [Person CTA_newOrUpdateWithJSON:dic inContext:currentContext];
            NSLog(@"%@",person.description);
            
        }
    } completion:^(NSError *error) {
        NSArray *arr = [Person CTA_all];
        for (Person *person in arr) {
            NSLog(@"%@,%ld",person.name,person.phones.count);
        }
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
