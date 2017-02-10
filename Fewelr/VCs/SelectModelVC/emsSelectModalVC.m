//
//  emsSelectModalVC.m
//  Fewelr
//
//  Created by developer on 26/10/15.
//  Copyright © 2015 ErmineSoft. All rights reserved.
//

#import "emsSelectModalVC.h"
#import "emsModel.h"
#import "emsYear.h"
#import "ModalClass.h"
@interface emsSelectModalVC ()<UITableViewDataSource, UITableViewDelegate>
@property(retain,nonatomic) IBOutlet UITableView* modelTableView;

@property (retain, nonatomic) NSMutableArray *modelArray;
@end

@implementation emsSelectModalVC

- (void)viewDidLoad {
    [super viewDidLoad];

}



-(id)initWithModelsArray:(NSArray *)modelsArray{
    
    
    self = [super init];
    
    if (self) {
        
       self.modelArray = [[NSMutableArray alloc] initWithArray:modelsArray];
    }
    
    return self;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.modelArray count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell"];
   
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"eventCell"];
    }
    
    emsModel * model = [self.modelArray objectAtIndex:indexPath.row];
    cell.textLabel.text = model.modelName;
   
 return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    emsModel * model = [self.modelArray objectAtIndex:indexPath.row];

    [ModalClass sharedInstance].carModel =  model.modelName;
    [ModalClass sharedInstance].carModelNiceName = model.modelNiceName ;
    [ModalClass sharedInstance].selectedModelIndex = indexPath.row;
        
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



@end
