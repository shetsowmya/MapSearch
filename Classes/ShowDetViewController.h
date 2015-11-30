//
//  ShowDetViewController.h
//  MapSearch
//
//  Created by Nidhi on 08/03/15.
//
//

#import <UIKit/UIKit.h>

@interface ShowDetViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *detailsTextView;
@property (nonatomic,retain) NSMutableArray * detailArray;
@property (nonatomic,retain) NSMutableArray * distanceArray;
@property (nonatomic,retain) NSMutableArray * durationArray;
@end
