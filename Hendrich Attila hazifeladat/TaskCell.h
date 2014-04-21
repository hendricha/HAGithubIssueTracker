//
//  TaskCell.h
//  Hendrich Attila hazifeladat
//
//  Created by user on 4/21/14.
//  Copyright (c) 2014 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskCell : UICollectionViewCell

@property (nonatomic , weak) IBOutlet UILabel* title;
@property (nonatomic) int type;
@end
