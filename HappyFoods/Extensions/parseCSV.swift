//
//  parseCSV.swift
//  HappyFoods
//
//  Created by Kate Roberts on 09/03/2019.
//  Copyright © 2019 Kate Roberts. All rights reserved.
//

import Foundation

func parseCSV(contentsOfURL: NSURL, encoding: String.Encoding) -> [(image_file_name: String, name: String, rating: Int)]?
{
    /// load CSV function
    let delimiter = ","
    var items:[(image_file_name: String, name: String, rating: Int)]?
    
    let optContent = try? String(contentsOf: contentsOfURL as URL)
    guard let content = optContent
        else
    {
        print("That didn't work!")
        return items
    }
    
    items = []
    
    let lines:[String] = content.components(separatedBy: NSCharacterSet.newlines)
    
    for line in lines{
        var values:[String] = []
        if line != ""
        {
            if line.range( of: "\"" ) != nil
            {
                var textToScan: String = line
                var value:NSString?
                var textScanner:Scanner = Scanner(string: textToScan)
                while textScanner.string != ""
                {
                    if (textScanner.string as NSString).substring(to: 1) == "\"" {
                        textScanner.scanLocation += 1
                        textScanner.scanUpTo("\"", into: &value)
                        textScanner.scanLocation += 1
                    } else {
                        textScanner.scanUpTo(delimiter, into: &value)
                    }
                    
                    // Store the value into the values array
                    values.append(value! as String)
                }
                
                // Retrieve the unscanned remainder of the string
                if textScanner.scanLocation < textScanner.string.count {
                    textToScan = (textScanner.string as NSString).substring(from: textScanner.scanLocation + 1)
                } else {
                    textToScan = ""
                }
                textScanner = Scanner(string: textToScan)
            }
            else  {
                values = line.components(separatedBy: delimiter)
            }
            
            ///image_file_name: String, name: String, rating: Int
            // Put the values into the tuple and add it to the items array
            let item = (image_file_name: values[0], name: values[1], rating: Int(values[2]) ?? 0 )
            items?.append(item )
        }
    }
    return items
}
    
