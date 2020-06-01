import FluentSQL
import WKCodable

extension QueryBuilder {
    @discardableResult
    public func filterGeometryDistance<F,V>(_ field: KeyPath<Model, F>, _ filter: V,
                                            _ method: SQLBinaryOperator, _ value: Double) -> Self
        where F: QueryableProperty, V: GeometryConvertible
    {
        return queryFilterGeometryDistance(QueryBuilder.path(field), QueryBuilder.queryExpressionGeometry(filter),
                                           method, SQLLiteral.numeric(String(value)))
    }
}

extension QueryBuilder {
    public func queryFilterGeometryDistance(_ path: String, _ filter: SQLExpression,
                                            _ method: SQLBinaryOperator, _ value: SQLExpression) -> Self {
        query.filters.append(.sql(SQLFunction("ST_Distance", args: [SQLColumn(path), filter]),
                                  method, value))
        return self
    }
}
