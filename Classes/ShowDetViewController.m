//
//  ShowDetViewController.m
//  MapSearch
//
//  Created by Nidhi on 08/03/15.
//
//

#import "ShowDetViewController.h"

@interface ShowDetViewController ()

@end

@implementation ShowDetViewController

@synthesize detailsTextView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString * finalStr = [[NSString alloc]init];
    //detailsTextView.text = [detailsTextView.text stringByAppendingString:@"sowmya"];
    for (NSUInteger i=0; i<[self.detailArray count]; i++) {
        NSString * str = [self.detailArray objectAtIndex:i];
        
        finalStr = [finalStr stringByAppendingString:str];
        finalStr = [finalStr stringByAppendingString:@" \n"];

        NSDictionary * dict = [self.distanceArray objectAtIndex:i];
        str = [dict objectForKey:@"text"];
        
        finalStr = [finalStr stringByAppendingString:[NSString stringWithFormat:@"- distance -%@",str]];
        finalStr = [finalStr stringByAppendingString:@" \n"];

        dict = [self.durationArray objectAtIndex:i];
        str = [dict objectForKey:@"text"];
        finalStr = [finalStr stringByAppendingString:[NSString stringWithFormat:@"- duration -%@",str]];
        finalStr = [finalStr stringByAppendingString:@" \n"];

       // detailsTextView.text = [detailsTextView.text stringByAppendingString:@"\n"];
    }

   // detailsTextView.text =[detailsTextView.text stringByAppendingString:finalStr];

    
    NSString * detailsStr = [self convertHTML:finalStr];


    detailsTextView.text = detailsStr;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSString *)convertHTML:(NSString *)html {
    
    NSScanner *myScanner;
    NSString *text = nil;
    myScanner = [NSScanner scannerWithString:html];
    
    while ([myScanner isAtEnd] == NO) {
        
        [myScanner scanUpToString:@"<" intoString:NULL] ;
        
        [myScanner scanUpToString:@">" intoString:&text] ;
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@" "];
    }
    //
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return html;
}


@end
