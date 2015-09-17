//
//  SoonPaymentViewController.h
//  SoonPayment
//
//  Created by Markus Bergh on 18/04/14.
//  Copyright (c) 2014 Markus Bergh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SoonPaymentViewController : UIViewController

@property (nonatomic, assign) NSInteger daysLeft;

@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) UILabel *paymentTitleLabel;
@property (nonatomic, retain) UILabel *paymentDueLabel;

- (void)setDaysLeftUntilPayment;

@end
