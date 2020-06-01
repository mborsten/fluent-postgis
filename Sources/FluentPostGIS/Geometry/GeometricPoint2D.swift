import Foundation
import FluentKit
import WKCodable

public struct GeometricPoint2D: Codable, Equatable, CustomStringConvertible {
    /// The point's x coordinate.
    public var x: Double
    
    /// The point's y coordinate.
    public var y: Double
    
    /// Create a new `GISGeometricPoint2D`
    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}

extension GeometricPoint2D: GeometryConvertible, GeometryCollectable {
    /// Convertible type
    public typealias GeometryType = Point

    public init(geometry point: GeometryType) {
        self.init(x: point.x, y: point.y)
    }
    
    public var geometry: GeometryType {
        return .init(vector: [self.x, self.y], srid: FluentPostGISSrid)
    }
    
    public var baseGeometry: Geometry {
        return self.geometry
    }
}

extension GeometricPoint2D: PostGISDataType {
    public static var dataType: DatabaseSchema.DataType { return PostGISDataTypeList.geometricPoint }
}
