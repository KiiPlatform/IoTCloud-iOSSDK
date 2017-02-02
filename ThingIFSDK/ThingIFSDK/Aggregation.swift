//
//  Aggregation.swift
//  ThingIFSDK
//
//  Created on 2017/01/27.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

/** Aggregation. */
open class Aggregation: NSCoding {

    /** Field types to count. */
    public enum FieldType: String {

        /** A type of a int field. */
        case integer = "INTEGER"

        /** A type of a decimal field. */
        case decimal = "DECIMAL"

        /** A type of a boolean field. */
        case bool = "BOOL"

        /** A type of a object field. */
        case object = "OBJECT"

        /** A type of a array field. */
        case array = "ARRAY"
    }

    /** Functions used aggregation. */
    public enum FunctionType: String {

        /** A function to calculate max of a field of queried objects. */
        case max

        /** A function to calculate sum of a field of queried objects. */
        case sum

        /** A function to calculate min of a field of queried objects. */
        case min

        /** A function to calculate mean of a field of queried objects. */
        case mean

        /** A function to count queried objects. */
        case count

    }

    /** Name of a target field. */
    let field: String
    /** Field type. */
    let fieldType: FieldType
    /** Function type. */
    let function: FunctionType


    private init?(
      _ function: FunctionType,
      field: String,
      fieldType: FieldType)
    {
        if function == .max || function == .sum || function == .min ||
             function == .mean {
            if fieldType != .integer && fieldType != .decimal {
                return nil
            }
        }
        self.function = function
        self.field = field
        self.fieldType = fieldType
    }

    /** Make aggregation.

     - Parameter function: Type of aggregation function.
     - Parameter field: Name of a field to be aggregated.
     - Parameter: fieldType type of a field to be aggregated.
     - Returns: An instance of `Aggregation`. Returns nil in following cases:
       - Function type is `Aggregation.FunctionType.max` and field
         type not is `Aggregation.FieldType.integer` or
         `Aggregation.FieldType.decimal`
       - Function type is `Aggregation.FunctionType.min` and field
         type not is `Aggregation.FieldType.integer` or
         `Aggregation.FieldType.decimal`
       - Function type is `Aggregation.FunctionType.sum` and field
         type not is `Aggregation.FieldType.integer` or
         `Aggregation.FieldType.decimal`
       - Function type is `Aggregation.FunctionType.mean` and field
         type not is `Aggregation.FieldType.integer` or
         `Aggregation.FieldType.decimal`
     */
    public static func makeAggregation(
      _ function: FunctionType,
      field: String,
      fieldType: FieldType) -> Aggregation?
    {
        return Aggregation(function, field: field, fieldType: fieldType)
    }

    /** Make aggregation.

     - Parameter field: Name of a field to be aggregated.
     - Parameter: fieldType type of a field to be aggregated.
     - Returns: An instance of `Aggregation` for count function.
     */
    public static func makeCountAggregation(
      _ field: String,
      fieldType: FieldType) -> Aggregation
    {
        return Aggregation(.count, field: field, fieldType: fieldType)!
    }

    /** Make mean aggregation.

     - Parameter field: Name of a field to be aggregated.
     - Parameter: fieldType type of a field to be aggregated.
     - Returns: An instance of `Aggregation` for mean. If field type
       not is `Aggregation.FieldType.integer` or
       `Aggregation.FieldType.decimal`
     */
    public static func makeMeanAggregation(
      _ field: String,
      fieldType: FieldType) -> Aggregation?
    {
        return Aggregation(.mean, field: field, fieldType: fieldType)
    }

    /** Make max aggregation.

     - Parameter field: Name of a field to be aggregated.
     - Parameter: fieldType type of a field to be aggregated.
     - Returns: An instance of `Aggregation` for max. If field type
       not is `Aggregation.FieldType.integer` or
       `Aggregation.FieldType.decimal`
     */
    public static func makeMaxAggregation(
      _ field: String,
      fieldType: FieldType) -> Aggregation?
    {
        return Aggregation(.max, field: field, fieldType: fieldType)
    }

    /** Make min aggregation.

     - Parameter field: Name of a field to be aggregated.
     - Parameter: fieldType type of a field to be aggregated.
     - Returns: An instance of `Aggregation` for min. If field type
       not is `Aggregation.FieldType.integer` or
       `Aggregation.FieldType.decimal`
     */
    public static func makeMinAggregation(
      _ field: String,
      fieldType: FieldType) -> Aggregation?
    {
        return Aggregation(.min, field: field, fieldType: fieldType)
    }

    /** Make sum aggregation.

     - Parameter field: Name of a field to be aggregated.
     - Parameter: fieldType type of a field to be aggregated.
     - Returns: An instance of `Aggregation` for sum. If field type
       not is `Aggregation.FieldType.integer` or
       `Aggregation.FieldType.decimal`
     */
    public static func makeSumAggregation(
      _ field: String,
      fieldType: FieldType) -> Aggregation?
    {
        return Aggregation(.sum, field: field, fieldType: fieldType)
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(
          FunctionType(
            rawValue: aDecoder.decodeObject(forKey: "function") as! String)!,
          field: aDecoder.decodeObject(forKey: "field") as! String,
          fieldType: FieldType(
            rawValue: aDecoder.decodeObject(forKey: "fieldType") as! String)!)
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.function.rawValue, forKey: "function")
        aCoder.encode(self.field, forKey: "field")
        aCoder.encode(self.fieldType.rawValue, forKey: "fieldType")
    }

}
