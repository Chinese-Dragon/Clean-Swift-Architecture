import Foundation

class OrdersWorker
{
  var ordersStore: OrdersStoreProtocol
  
  init(ordersStore: OrdersStoreProtocol) {
    self.ordersStore = ordersStore
  }
  
  func fetchOrders(completionHandler: @escaping ([Order]) -> Void) {
    ordersStore.fetchOrders { (orders: () throws -> [Order]) in
      do {
        let orders = try orders()
        DispatchQueue.main.async {
          completionHandler(orders)
        }
      } catch {
        DispatchQueue.main.async {
          completionHandler([])
        }
      }
    }
  }
}


protocol OrdersStoreProtocol {
  // MARK: CRUD operations - Inner closure
  
  func fetchOrders(completionHandler: @escaping (() throws -> [Order]) -> Void)
}
