//
//  DetailController.h
//  TrainedByJP
//
//  Created by Muhammad Umar on 26/07/2016.
//  Copyright © 2016 Neberox Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailController : UIViewController <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *titleText;
@property (nonatomic, weak) IBOutlet UITableView *mTable;

@property (nonatomic, strong) NSMutableArray *commentsArray;
@property (nonatomic, strong) NSString *htmlString;
@property (nonatomic, strong) UIWebView *mWebView;

@property (nonatomic, strong) NSDictionary *mainDict;

@end
