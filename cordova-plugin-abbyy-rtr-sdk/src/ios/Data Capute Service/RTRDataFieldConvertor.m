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
        @"dataFields" : [self arrayFromDataFields: dataFields],
        @"dataScheme": @{ @"id": @"BusinessCards", @"name": @"Business Cards" }
    };
    
    return finalDictionary;
}

// MARK: - Private

- (NSDictionary*) dictionaryFromDataField: (RTRDataField*) field
{
    return @{
        @"id" : field.id ?: @"",
        @"name" : field.name ?: @"",
        @"text" : field.text ?: @"",
        @"quadrangle" : [self quadrangleString: field.quadrangle],
        @"components" :[self arrayFromDataFields: field.components],
    };
}

- (NSArray*) arrayFromDataFields: (NSArray<RTRDataField*>*) dataFields {
    if(dataFields.count == 0) {
        return @[];
    }

    NSMutableArray* result = [NSMutableArray arrayWithCapacity:dataFields.count];
    for(RTRDataField* field in dataFields) {
        [result addObject: [self dictionaryFromDataField: field]];
    }

    return result;
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
