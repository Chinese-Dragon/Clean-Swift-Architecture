import Foundation

class OrdersMemStore: OrdersStoreProtocol, OrdersStoreUtilityProtocol
{
  // MARK: - Data
  static var billingAddress = Address(street1: "1 Infinite Loop", street2: "", city: "Cupertino", state: "CA", zip: "95014")
  static var shipmentAddress = Address(street1: "One Microsoft Way", street2: "", city: "Redmond", state: "WA", zip: "98052-7329")
  static var paymentMethod = PaymentMethod(creditCardNumber: "1234-123456-1234", expirationDate: Date(), cvv: "999")
  static var shipmentMethod = ShipmentMethod(speed: .OneDay)
  
  static var orders = [
    Order(firstName: "Amy", lastName: "Apple", phone: "111-111-1111", email: "amy.apple@clean-swift.com", billingAddress: billingAddress, paymentMethod: paymentMethod, shipmentAddress: shipmentAddress, shipmentMethod: shipmentMethod, id: "abc123", date: Date(), total: NSDecimalNumber(string: "1.23")),
    Order(firstName: "Bob", lastName: "Battery", phone: "222-222-2222", email: "bob.battery@clean-swift.com", billingAddress: billingAddress, paymentMethod: paymentMethod, shipmentAddress: shipmentAddress, shipmentMethod: shipmentMethod, id: "def456", date: Date(), total: NSDecimalNumber(string: "4.56"))
  ]
  
  func fetchOrders(completionHandler: @escaping OrdersStoreFetchOrdersCompletionHandler) {
    completionHandler(.Success(result: type(of: self).orders))
  }
  
  func fetchOrder(id: String, completionHandler: @escaping OrdersStoreFetchOrderCompletionHandler) {
  }
  
  func createOrder(orderToCreate: Order, completionHandler: @escaping OrdersStoreCreateOrderCompletionHandler) {
    var order = orderToCreate
    generateOrderID(order: &order)
    calculateOrderTotal(order: &order)
    type(of: self).orders.append(order)
    completionHandler(.Success(result: order))
  }
  
  func updateOrder(orderToUpdate: Order, completionHandler: @escaping OrdersStoreUpdateOrderCompletionHandler) {
    if let index = indexOfOrderWithID(id: orderToUpdate.id) {
      type(of: self).orders[index] = orderToUpdate
      let order = type(of: self).orders[index]
      completionHandler(.Success(result: order))
    } else {
      completionHandler(.Failure(error: OrdersStoreError.CannotUpdate("Cannot update order with id \(String(describing: orderToUpdate.id)) to update")))
    }
  }
  
  func deleteOrder(id: String, completionHandler: @escaping OrdersStoreDeleteOrderCompletionHandler) {
    
  }
  
  // MARK: - Convenience methods
  
  private func indexOfOrderWithID(id: String?) -> Int?
  {
    return type(of: self).orders.index { return $0.id == id }
  }
}
