import StoreKit
import Utils

@available(macOS 10.15, *)
@available(iOS 13.0, *)
public class GOOStore: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    @Published public private(set) var myProducts: [SKProduct] = [SKProduct]()
    @Published public private(set) var transactionState: SKPaymentTransactionState?
    @Published public private(set) var lastBuy: (productId: String, quantity: Int) = ("", 0)
    private var request: SKProductsRequest!
    private var productsStore: [String: Int] = [:]

    public init(products: [String: Int]) {
        super.init()

        productsStore = products
        self.getProducts(productIDs: productsStore.map { $0.key })
        SKPaymentQueue.default().add(self)
    }

    // FETCH PRODUCTS

    private func getProducts(productIDs: [String]) {
        print("GOOStore - Start requesting products ...")
        let request = SKProductsRequest(productIdentifiers: Set(productIDs))
        request.delegate = self
        request.start()
    }

    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("GOOStore - Fetching products: Did receive response ...")

        if response.products.isNotEmpty {
            for fetchedProduct in response.products {
                DispatchQueue.main.async {
                    print(  """
                            GOOStore - Fetching '\(fetchedProduct.localizedTitle)'
                            \t'\(fetchedProduct.localizedDescription)'
                            \t\(fetchedProduct.localizedPrice ?? "0")
                            """
                    )
                    self.myProducts.append(fetchedProduct)
                }
            }
        }

        for invalidIdentifier in response.invalidProductIdentifiers {
            print("GOOStore - Invalid identifiers found: \(invalidIdentifier)")
        }
    }

    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("GOOStore - Request did fail: \(error)")
    }

    // PAY PRODUCT

    public func purchaseProduct(product: SKProduct) {
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
            print("GOOStore - User can't make payment")
        }
    }

    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                print("GOOStore - Payment Queue: Purchasing ...")
                transactionState = .purchasing
            case .purchased:
                print("GOOStore - Payment Queue: Purchased \(transaction.payment.productIdentifier)")
                lastBuy = (transaction.payment.productIdentifier, productsStore[transaction.payment.productIdentifier] ?? 0)
                queue.finishTransaction(transaction)
                transactionState = .purchased
            case .restored:
                print("GOOStore - Payment Queue: Restored \(transaction.payment.productIdentifier)")
                lastBuy = (transaction.payment.productIdentifier, productsStore[transaction.payment.productIdentifier] ?? 0)
                queue.finishTransaction(transaction)
                transactionState = .restored
            case .failed, .deferred:
                print("GOOStore - Payment Queue Error: \(String(describing: transaction.error))")
                queue.finishTransaction(transaction)
                transactionState = .failed
            default:
                queue.finishTransaction(transaction)
            }
        }
    }

    // RESTORE PRODUCT

    public func restoreProducts() {
        print("GOOStore - Restoring products ...")
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}
