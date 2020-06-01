import FluentSQL
import WKCodable

extension QueryBuilder {
    /// Applies an ST_Equals filter to this query. Usually you will use the filter operators to do this.
    ///
    ///     let users = try User.query(on: conn)
    ///         .filterGeometryEquals(\.area, path)
    ///         .all()
    ///
    /// - parameters:
    ///     - key: Swift `KeyPath` to a field on the model to filter.
    ///     - value: Geometry value to filter by.
    /// - returns: Query builder for chaining.
    @discardableResult
    public func filterGeometryEquals<F, V>(_ field: KeyPath<Model, F>, _ value: V) -> Self
        where F: QueryableProperty, V: GeometryConvertible
    {
        return queryGeometryEquals(QueryBuilder.path(field),
                                   QueryBuilder.queryExpressionGeometry(value))
    }
}

extension QueryBuilder {
    /// Creates an instance of `QueryFilter` for ST_Equals from a field and value.
    ///
    /// - parameters:
    ///     - field: Field to filter.
    ///     - value: Value type.
    public func queryGeometryEquals(_ path: String, _ value: SQLExpression) -> Self {
        applyFilter(function: "ST_Equals", path: path, value: value)
        return self
    }
}
