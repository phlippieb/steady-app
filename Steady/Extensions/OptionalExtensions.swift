public protocol UnitProviding {
    static var unit: Self { get }
}

extension Optional: Identifiable where Wrapped: Identifiable, Wrapped: UnitProviding {
    public var id: Wrapped.ID {
        self?.id ?? Wrapped.unit.id
    }
}
