import FluentSQL
import WKCodable

extension QueryBuilder {

    static func queryExpressionGeometryCasted<T: GeometryConvertible>(_ geometry: T) -> SQLExpression {
        let geometryText = WKTEncoder().encode(geometry.geometry)
        return SQLFunctionCast("ST_GeomFromEWKT", args: [SQLLiteral.string(geometryText)])
    }

    static func queryExpressionGeometry<T: GeometryConvertible>(_ geometry: T) -> SQLExpression {
        let geometryText = WKTEncoder().encode(geometry.geometry)
        return SQLFunction("ST_GeomFromEWKT", args: [SQLLiteral.string(geometryText)])
    }
    
    private static func key(_ key: FieldKey) -> String {
        switch key {
        case .id:
            return "id"
        case .string(let name):
            return name
        case .aggregate:
            return key.description
        case .prefix:
            return key.description
        }
    }
    
    static func path<F: QueryableProperty>(_ field: KeyPath<Model, F>) -> String {
        return Model.path(for: field).map(Self.key).joined(separator: "_")
    }
}

extension QueryBuilder {
    func applyFilter(function: String, args: [SQLExpression]) {
        query.filters.append(.custom(SQLFunction(function, args: args)))
    }
    
    func applyFilter(function: String, path: String, value: SQLExpression) {
        applyFilter(function: function, args: [SQLColumn(path), value])
    }
    
    func applyFilter(function: String, value: SQLExpression, path: String) {
        applyFilter(function: function, args: [value, SQLColumn(path)])
    }
}

public struct SQLFunctionCast: SQLExpression {
    public let name: String
    public let args: [SQLExpression]


    public init(_ name: String, args: String...) {
        self.init(name, args: args.map { SQLIdentifier($0) })
    }

    public init(_ name: String, args: [String]) {
        self.init(name, args: args.map { SQLIdentifier($0) })
    }

    public init(_ name: String, args: SQLExpression...) {
        self.init(name, args: args)
    }

    public init(_ name: String, args: [SQLExpression] = []) {
        self.name = name
        self.args = args
    }

    public func serialize(to serializer: inout SQLSerializer) {
        serializer.write(self.name)
        SQLGroupExpression(self.args).serialize(to: &serializer)
        serializer.write("::geography")
    }
}
