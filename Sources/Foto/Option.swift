//
//  File.swift
//  
//
//  Created by eyecatalina on 2020/02/07.
//

import Foundation
import Photos

public struct Option {
    public static let all: Option = .init()
    
    let fetchOptions: PHFetchOptions = .init()
    
    static func sort(by property: Property, ascending: Bool = true) -> Option {
        return Option().sort(by: property, ascending: ascending)
    }
    
    func sort(by property: Property, ascending: Bool = true) -> Option {
        var sorts = fetchOptions.sortDescriptors ?? []
        sorts.append(.by(property, ascending: ascending))
        self.fetchOptions.sortDescriptors = sorts
        return self
    }
    
    func predicate<Root: PHAsset, Value, To>(logical: NSCompoundPredicate.LogicalType = .and,
                                             left: KeyPath<Root, Value>,
                                             operator op: NSComparisonPredicate.Operator = .equalTo,
                                             modifier: NSComparisonPredicate.Modifier = .direct,
                                             to: To) -> Option {
        let predicator = comparisonPredicate(left: left, operator: op, to: to)
        fetchOptions.predicate = fetchOptions.predicate.flatMap({ NSCompoundPredicate(type: logical, subpredicates: [$0, predicator]) }) ?? predicator
        return self
    }
    
    private func comparisonPredicate<Root: PHAsset, Value, To>(left: KeyPath<Root, Value>,
                                     operator op: NSComparisonPredicate.Operator = .equalTo,
                                     modifier: NSComparisonPredicate.Modifier = .direct,
                                     to: To) -> NSPredicate {
        NSComparisonPredicate(leftExpression: .init(forKeyPath: left),
                              rightExpression: .init(forConstantValue: to),
                              modifier: modifier,
                              type: op)
    }
    
    static func fetchLimit(_ limit: Int) -> Option {
        return Option().fetchLimit(limit)
    }
    
    func fetchLimit(_ limit: Int) -> Option {
        let option = self
        option.fetchOptions.fetchLimit = limit
        return option
    }
    
    public enum Property: String {
        case creationDate
        case modificationDate
        case localIdentifier
        case mediaType
        case mediaSubtypes
        case duration
        case pixelWidth
        case pixelHeight
        case isFavorite
        case isHidden
        case burstIdentifier
    }
    
}

private extension NSSortDescriptor {
    static func by(_ property: Option.Property, ascending: Bool) -> NSSortDescriptor {
        return NSSortDescriptor(key: property.rawValue, ascending: ascending)
    }
}
