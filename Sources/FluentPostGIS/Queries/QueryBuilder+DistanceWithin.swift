import FluentSQL
import WKCodable

extension QueryBuilder {
    @discardableResult
    public func filterGeometryDistanceWithin<F,V>(_ field: KeyPath<Model, F>, _ filter: V, _ value: Double) -> Self
        where F: QueryableProperty, V: GeometryConvertible
    {
        return queryFilterGeometryDistanceWithin(QueryBuilder.path(field),
                                                 QueryBuilder.queryExpressionGeometry(filter),
                                                 SQLLiteral.numeric(String(value)))
    }
}

extension QueryBuilder {
    func queryFilterGeometryDistanceWithin(_ path: String, _ filter: SQLExpression, _ value: SQLExpression) -> Self {
        applyFilter(function: "ST_DWithin", args: [SQLColumn(path), filter, value])
        return self
    }
}
