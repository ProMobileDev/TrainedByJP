//
//  HomeController.h
//  TrainedByJP
//
//  Created by Muhammad Umar on 24/07/2016.
//  Copyright © 2016 Neberox Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForumCellModel.h"
#import <MediaPlayer/MediaPlayer.h>

@interface HomeController : BaseController <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *myTable;

@property (nonatomic, strong) NSMutableArray *videosArray;
@property (nonatomic, strong) NSMutableArray *topicsArray;

@property (nonatomic, strong) ForumCellModel *videoCell;

@property (nonatomic) long totalTopics;

@property (nonatomic, strong) NSTimer *mTimer;

@end
