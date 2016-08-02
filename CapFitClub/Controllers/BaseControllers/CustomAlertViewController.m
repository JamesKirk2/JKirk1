//
//  CustomAlertViewController.m
//  CapFitClub
//
//  Created by Sumit Sancheti on 21/04/16.
//  Copyright © 2016 Capgemini. All rights reserved.
//

#import "CustomAlertViewController.h"

@interface CustomAlertViewController ()

@end

@implementation CustomAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGRect frame = self.view.frame;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width/2 - 60.0/2), 20.0, 60.0, 60.0)];
    [imageView setImage:[UIImage imageNamed:@"thumb"]];
    [self.view addSubview:imageView];
    
//    CustomAlertViewController *customAlert = [CustomAlertViewController alertControllerWithTitle:@"\n\n\n" message:@"Congratulations you have won Marathon Runner badge." preferredStyle:UIAlertControllerStyleAlert];
//    [customAlert addAction:[CommonFunctions getCancelAlertAction:nil]];
//    [self presentViewController:customAlert animated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
