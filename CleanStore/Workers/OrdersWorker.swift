import Foundation

class OrdersWorker
{
  var ordersStore: OrdersStoreProtocol
  
  init(ordersStore: OrdersStoreProtocol) {
    self.ordersStore = ordersStore
  }
  
  func fetchOrders(completionHandler: @escaping ([Order]) -> Void) {
    ordersStore.fetchOrders { (fetchOrderResult) in
      switch fetchOrderResult {
      case .Success(let orders):
        completionHandler(orders)
      case .Failure(_):
        completionHandler([])
      }
    }
  }
  
  func createOrder(orderToCreate: Order, completionHandler: @escaping (Order?) -> Void) {
    ordersStore.createOrder(orderToCreate: orderToCreate) { (createOrderResult) in
      switch createOrderResult {
      case .Success(let order):
        completionHandler(order)
      case .Failure(_):
        completionHandler(nil)
      }
    }
  }
  
  func updateOrder(orderToUpdate: Order, completionHandler: @escaping (Order?) -> Void) {
    ordersStore.updateOrder(orderToUpdate: orderToUpdate) { (updateOrderResult) in
      switch updateOrderResult {
      case .Success(let order):
        completionHandler(order)
      case .Failure(_):
        completionHandler(nil)
      }
    }
  }
}

protocol OrdersStoreUtilityProtocol {}

extension OrdersStoreUtilityProtocol
{
  func generateOrderID(order: inout Order)
  {
    guard order.id == nil else { return }
    order.id = "\(arc4random())"
  }
  
  func calculateOrderTotal(order: inout Order)
  {
    guard order.total == NSDecimalNumber.notANumber else { return }
    order.total = NSDecimalNumber.one
  }
}

protocol OrdersStoreProtocol {
  // MARK: CRUD operations - Generic enum result type
  
  func fetchOrders(completionHandler: @escaping OrdersStoreFetchOrdersCompletionHandler)
  func fetchOrder(id: String, completionHandler: @escaping OrdersStoreFetchOrderCompletionHandler)
  func createOrder(orderToCreate: Order, completionHandler: @escaping OrdersStoreCreateOrderCompletionHandler)
  func updateOrder(orderToUpdate: Order, completionHandler: @escaping OrdersStoreUpdateOrderCompletionHandler)
  func deleteOrder(id: String, completionHandler: @escaping OrdersStoreDeleteOrderCompletionHandler)
}

// MARK: - Orders store CRUD operation results

typealias OrdersStoreFetchOrdersCompletionHandler = (OrdersStoreResult<[Order]>) -> Void
typealias OrdersStoreFetchOrderCompletionHandler = (OrdersStoreResult<Order>) -> Void
typealias OrdersStoreCreateOrderCompletionHandler = (OrdersStoreResult<Order>) -> Void
typealias OrdersStoreUpdateOrderCompletionHandler = (OrdersStoreResult<Order>) -> Void
typealias OrdersStoreDeleteOrderCompletionHandler = (OrdersStoreResult<Order>) -> Void

enum OrdersStoreResult<T>
{
  case Success(result: T)
  case Failure(error: OrdersStoreError)
}

// MARK: - Orders store CRUD operation errors

enum OrdersStoreError: Equatable, Error
{
  case CannotFetch(String)
  case CannotCreate(String)
  case CannotUpdate(String)
  case CannotDelete(String)
}

func ==(lhs: OrdersStoreError, rhs: OrdersStoreError) -> Bool
{
  switch (lhs, rhs) {
  case (.CannotFetch(let a), .CannotFetch(let b)) where a == b: return true
  case (.CannotCreate(let a), .CannotCreate(let b)) where a == b: return true
  case (.CannotUpdate(let a), .CannotUpdate(let b)) where a == b: return true
  case (.CannotDelete(let a), .CannotDelete(let b)) where a == b: return true
  default: return false
  }
}
