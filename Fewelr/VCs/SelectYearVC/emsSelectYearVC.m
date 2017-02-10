//
//  emsSelectYearVC.m
//  Fewelr
//
//  Created by developer on 26/10/15.
//  Copyright © 2015 ErmineSoft. All rights reserved.
//

#import "emsSelectYearVC.h"
#import "emsModel.h"
#import "emsYear.h"
#import "ModalClass.h"
@interface emsSelectYearVC ()<UITableViewDataSource, UITableViewDelegate>
@property(retain,nonatomic) IBOutlet UITableView* YearTableView;

@property (retain, nonatomic) NSMutableArray *yearArray;
@end

@implementation emsSelectYearVC




-(id)initWithYearsArray:(NSArray *)yearsArray{
    
    
    self = [super init];
    
    if (self) {
        
        self.yearArray = [[NSMutableArray alloc] initWithArray:yearsArray];
    }
    
    return self;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.yearArray count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell"];
    
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"eventCell"];
    }
    emsYear * emsYear = [self.yearArray objectAtIndex:indexPath.row];
    cell.textLabel.text =[NSString stringWithFormat:@"%@",emsYear.modelYear];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    emsYear * emsYear = [self.yearArray objectAtIndex:indexPath.row];
    
    [ModalClass sharedInstance].carYear = [NSString stringWithFormat:@"%@",emsYear.modelYear];
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];

}



-(IBAction)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
   
}




@end
