//
//  SoonPaymentViewController.m
//  SoonPayment
//
//  Created by Markus Bergh on 18/04/14.
//  Copyright (c) 2014 Markus Bergh. All rights reserved.
//

#import "SoonPaymentViewController.h"

@interface SoonPaymentViewController ()
- (NSInteger)calculateDifferenceBetweenTodayAndPaymentDay;
- (void)isTodayPayday:(BOOL)isPayday;
@end

@implementation SoonPaymentViewController

@synthesize contentView = _contentView;
@synthesize daysLeft = _daysLeft;
@synthesize paymentDueLabel = _paymentDueLabel;
@synthesize paymentTitleLabel = _paymentTitleLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    // Initialize content holder
    _contentView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_contentView];
    
}

- (void)setDaysLeftUntilPayment
{
    // Get days left
    _daysLeft = [self calculateDifferenceBetweenTodayAndPaymentDay];
    
    if (_daysLeft > 0) {
        [self isTodayPayday:NO];
    } else if (_daysLeft == 0) {
        [self isTodayPayday:YES];
    }
}

- (NSInteger)calculateDifferenceBetweenTodayAndPaymentDay
{
    NSInteger daysLeft = 0;

    // Get today
    NSDate *now = [NSDate date];
    
    // Create calendar
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    // Set timezone
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"CET"]];
    
    // Get components
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekdayCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date]];
    
    // Set and get 25th (payday)
    [components setDay:25];
    
    // Get pay day
    NSDate *payday = [calendar dateFromComponents:components];
    NSRange weekdayRange = [calendar maximumRangeOfUnit:NSWeekdayCalendarUnit];
    NSInteger weekday = [[calendar components:NSWeekdayCalendarUnit fromDate:payday] weekday];
    
    // If payday is in weekend (saturday or sunday) we set payday to friday before weekend
    if(weekday == weekdayRange.location || weekday == weekdayRange.length) {
        switch (weekday) {
            case 7:
                // Saturday
                payday = [payday dateByAddingTimeInterval:60 * 60 * 24 * -1];
                break;
            case 1:
                // Sunday
                payday = [payday dateByAddingTimeInterval:60 * 60 * 24 * -2];
                break;
            default:
                break;
        }
    }
    
    // Create and set date format
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setCalendar:calendar];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss z"];

    // Get days between
    daysLeft = [self daysBetweenDate:now andDate:payday];
    
    // Return result
    return daysLeft;
}

- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

- (void)isTodayPayday:(BOOL)isPayday
{
    if (!isPayday) {
        // Set text
        NSString *daysLeftString = nil;
        daysLeftString = [NSString stringWithFormat:@"%ld dagar", (long)_daysLeft];
        
        if(_paymentTitleLabel == nil && _paymentDueLabel == nil) {
            _paymentTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 35.0f)];
            _paymentTitleLabel.text = @"Dagar kvar till lön";
            _paymentTitleLabel.font = [UIFont fontWithName:@"SourceSansPro-BoldIt" size:30];
            _paymentTitleLabel.textColor = [UIColor whiteColor];
            _paymentTitleLabel.textAlignment = NSTextAlignmentCenter;
            [_contentView addSubview:_paymentTitleLabel];
            
            CALayer *bottomBorder = [CALayer layer];
            bottomBorder.borderColor = [UIColor colorWithRed:117.0/255.0f green:184.0/255.0f blue:164.0/255.0f alpha:1.0f].CGColor;
            bottomBorder.borderWidth = 1;
            bottomBorder.frame = CGRectMake(self.view.frame.size.width / 2.0f - 100.0f / 2.0f, _paymentTitleLabel.frame.size.height + 20.0f, 100.0f, 1.0f);
            [_paymentTitleLabel.layer addSublayer:bottomBorder];
            
            CGRect textRect = [daysLeftString boundingRectWithSize:CGSizeMake(320.0f, 50.0f)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{NSFontAttributeName:[UIFont fontWithName:@"SourceSansPro-ExtraLightIt" size:50]}
                                                           context:nil];
            
            CGSize size = textRect.size;
            
            _paymentDueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, bottomBorder.frame.origin.y + 5.0, 320.0f, size.height)];
            _paymentDueLabel.text = daysLeftString;
            _paymentDueLabel.font = [UIFont fontWithName:@"SourceSansPro-ExtraLightIt" size:50];
            _paymentDueLabel.textColor = [UIColor whiteColor];
            _paymentDueLabel.textAlignment = NSTextAlignmentCenter;
            [_contentView addSubview:_paymentDueLabel];

        } else {
            _paymentDueLabel.text = daysLeftString;
        }
        
        // Set size
        _contentView.frame = CGRectMake(0.0f, 0.0f, 320.0f, _paymentDueLabel.frame.origin.y + _paymentDueLabel.frame.size.height);
        
        // Center content
        CGRect frameContent = _contentView.frame;
        frameContent.origin = CGPointMake(0.0f, self.view.frame.size.height / 2.0f - _contentView.frame.size.height / 2.0f);
        
        // Set new frame
        _contentView.frame = frameContent;
        
        // Set badge..
        [UIApplication sharedApplication].applicationIconBadgeNumber = _daysLeft;
    } else {
        CGSize maximumLabelSize = CGSizeMake(self.view.frame.size.width, FLT_MAX);
        
        CGRect textRect = [@"Det är löning idag, cash is king!"
                                boundingRectWithSize:maximumLabelSize
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:[UIFont fontWithName:@"SourceSansPro-BoldIt" size:36]}
                                             context:nil];
        
        _paymentTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 35.0f)];
        _paymentTitleLabel.text = @"Det är löning idag, cash is king!";
        _paymentTitleLabel.font = [UIFont fontWithName:@"SourceSansPro-BoldIt" size:36];
        _paymentTitleLabel.textColor = [UIColor whiteColor];
        _paymentTitleLabel.textAlignment = NSTextAlignmentCenter;
        _paymentTitleLabel.numberOfLines = 0;
        
        CGRect labelFrame = _paymentTitleLabel.frame;
        labelFrame.size.height = textRect.size.height;
        _paymentTitleLabel.frame = labelFrame;
        
        [_contentView addSubview:_paymentTitleLabel];

        // Set size
        _contentView.frame = CGRectMake(0.0f, 0.0f, 320.0f, _paymentTitleLabel.frame.origin.y + _paymentTitleLabel.frame.size.height);
        
        // Center content
        CGRect frameContent = _contentView.frame;
        frameContent.origin = CGPointMake(0.0f, self.view.frame.size.height / 2.0f - _contentView.frame.size.height / 2.0f);
        
        // Set new frame
        _contentView.frame = frameContent;

        // Set badge..
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
