//
//  RTRDataFieldConvertor.m
//  CoreAPI
//
//  Created by Ostap Kyselytsia on 04.11.2019.
//  Copyright © 2019 ABBYY. All rights reserved.
//

#import "RTRDataFieldConvertor.h"

@interface RTRDataFieldConvertor()

@end

@implementation RTRDataFieldConvertor

// MARK: - Appearance

-(NSDictionary*) convertToDictionary: (NSArray<RTRDataField*>*)dataFields {
    NSDictionary* finalDictionary = @{
        @"dataFields" : [self convertDataFieldToArrayMap: dataFields],
        @"dataScheme": @{ @"id": @"BusinessCards", @"name": @"Business Cards" }
    };
    
    return finalDictionary;
}

// MARK: - Private

-(NSArray*) convertDataFieldToArrayMap: (NSArray<RTRDataField*>*)dataFields {
    NSMutableArray<NSDictionary*>* array = [NSMutableArray new];
    
    for (RTRDataField* data in dataFields) {
        NSMutableDictionary* object = [self rtrDataFieldObject: data];
        // components
        if (data.components != nil) {
            NSMutableArray<NSDictionary*>* subArray = [NSMutableArray new];
            
            for (RTRDataField* subData in data.components) {
                [subArray addObject: (NSDictionary*)[self rtrDataFieldObject: subData]];
            }
            
            if (subArray.count > 0)
            [object setObject: subArray forKey:@"components"];
        }

        [array addObject: object];
    }
    
    return array;
}

-(NSMutableDictionary*) rtrDataFieldObject: (RTRDataField*) field {
    NSMutableDictionary* dictionary = [NSMutableDictionary new];
    
    if (field.name.length != 0)
    [dictionary setObject: field.name forKey: @"name"];
    
    if (field.id.length != 0)
    [dictionary setObject: field.id forKey: @"id"];
    
    if (field.text.length != 0)
    [dictionary setObject: field.text forKey: @"text"];
    
    NSString* quadrangleString = [self quadrangleString: field.quadrangle];
    
    if (quadrangleString.length != 0)
    [dictionary setObject: quadrangleString forKey: @"quadrangle"];

    return dictionary;
}

-(NSString*) quadrangleString: (NSArray<NSValue*>*) quadrangle {
    if (quadrangle == nil) return @"";
    NSMutableString *result = [NSMutableString string];
    
    for (NSValue* value in quadrangle) {
        [result appendString: [NSString stringWithFormat:@"%ld", (long)value.CGPointValue.x]];
        [result appendString:@" "];
        [result appendString: [NSString stringWithFormat:@"%ld", (long)value.CGPointValue.y]];
        
        if (value != quadrangle.lastObject) {
            [result appendString:@" "];
        }
    }
    
    return result;
}

@end
