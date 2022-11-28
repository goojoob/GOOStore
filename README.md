# GOOStore
Store Manager for SwiftUI and In-App Purchases

<br/>

## 💶 About GOOStore

_GOOStore is a Library prepared to use In-App Purchases in `iOS` and `macOS` developments with SwiftUI_

<br/>

## ⚙️ Installation

#### Setup your XCode Project and App Store Connect

_First of all you need to add In-App Purchases capabilities in your app_

* In Xcode select your Target and change to the *Signing & Capabilites* tab.
* Add In-App Purchase capability.

_Add your In-App Purchases in App Store Connect_

* `Consumable purchases` - for example dev.goojoob.MyApp.10lives and dev.goojoob.MyApp.50lives
* `Non-Consumable` - for example dev.goojoob.MyApp.ProUser

<br/>

#### Setup with Swift Package Manager

* In Xcode select *File > Add Packages*.
* Enter this project's URL: https://github.com/goojoob/GOOStore.git

<br/>

## 🔧 Usage

_Declare your available products id's and quantity as a Dictionary._

* Consumable items need a quantity you may treat when the purchase is done
* Non-Consumable items don't need a quantity, so you may use a number to identify it

```swift
let myProducts: [String: Int] = ["dev.goojoob.MyApp.10lives": 10, "dev.goojoob.MyApp.50lives": 50, "dev.goojoob.MyApp.ProUser": 999]
```

_Create a StateObject var in your View with your products:_

```swift
import GOOStore

//...

@StateObject private var storeManager: GOOStore = GOOStore(products: myProducts)
```

_Show your products in a View (this design is up to you):_

```swift
ForEach(storeManager
    .myProducts
    .sorted(by: { $0.price.floatValue < $1.price.floatValue }), id: \.self) { product in
        HStack {
            VStack(alignment: .leading) {
                Text(product.localizedTitle)
                Text(product.localizedDescription)
            }

            Spacer()

            Button {
                storeManager.purchaseProduct(product: product)
            } label: {
                HStack {
                    Text("\(product.localizedPrice ?? "00")")
                    Image(systemName: "creditcard")
                }
            }
        }
    }
```

_Let Restore Purchases available (for example in the toolbar):_

```swift
.toolbar {
    ToolbarItem(placement: .navigationBarTrailing) {
        Button {
            storeManager.restoreProducts()
        } label: {
            Text("Restore Purchases")
        }
    }
}
```

_Process the purchase/restore in a View:_

* Variable lastBuy is a tuple containing the las item purchased, its productId and quantity

```swift
.onChange(of: storeManager.transactionState) { transactionState in
    switch transactionState {
    case .purchased:
        print("StoreManager - Purchased: '\(storeManager.lastBuy.productId)' Quantity: \(storeManager.lastBuy.quantity)")
        //treat your purchase
    case .restored:
        //treat your restored purchases
    default:
        break
    }
}
```

<br/>

## 👨‍💻 Compatibility

* macOS 10.15+
* iOS 13.0+

<br/>

## 🛠️ Created with

* [XCode 14.1](https://developer.apple.com/xcode/)
* [Swift 5.7.1](https://swift.org/)

<br/>

## ✒️ Author

<img src ="https://goojoob.dev/images/logo.svg" width=30 /> **Goojoob.dev** - *Original development* - [goojoob](https://twitter.com/goojoobdev) 

<br/>

## 📄 License

<a rel="license" target="_blank" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International license (CC BY 4.0)</a>.

<br/>

## 🎁 Thank You

* Talk to others about this project 📢
* We can have a ☕ whenever you want

<br/>
