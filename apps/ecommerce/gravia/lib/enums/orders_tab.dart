/// The two segments of `OrdersSegmentedTabBar`. Used purely in-memory
/// (chosen on the Orders screen, never crosses a JSON boundary), so it
/// needs no wire-string conversion.
enum OrdersTab { upcoming, past }
