//
//  ACConstant.m
//  accedoCardGame
//
//  Created by Nouman on 08/01/17.
//  Copyright © 2017 Nouman Pervez. All rights reserved.
//

#import "ACConstant.h"
#import <UIKit/UIKit.h>

@implementation ACConstant

+(void)showAlert :(NSString *)message inViewController:(ACDashBoardCollectionViewController *)vc{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    [vc presentViewController:alertController animated:YES completion:nil];
}

@end
