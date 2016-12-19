//
//  ReceipeCellModel.h
//  TrainedByJP
//
//  Created by Muhammad Umar on 24/07/2016.
//  Copyright © 2016 Neberox Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceipeCellModel : UITableViewCell

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *miniIndicator;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *maxIndicator;

@property (nonatomic, weak) IBOutlet UIButton *commentBtn;
@property (nonatomic, weak) IBOutlet UILabel *commentCount;

@property (nonatomic, weak) IBOutlet UILabel *authorName;
@property (nonatomic, weak) IBOutlet UILabel *receipeText;
@property (nonatomic, weak) IBOutlet UILabel *timeText;

@property (nonatomic, weak) IBOutlet UIView *userView;

@property (nonatomic, weak) IBOutlet UIImageView *authorImg;
@property (nonatomic, weak) IBOutlet UIImageView *receipeImg;

@end
