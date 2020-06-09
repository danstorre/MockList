//
//  ItemManager.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 6/3/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

protocol PropertyObserver : class {
    func willChange(propertyName: String, newPropertyValue: Any?)
    func didChange(propertyName: String, oldPropertyValue: Any?)
}


enum ItemManagerKeys {
    static let arrayOfItems = "arrayOfItems"
}

class ItemManager<T: ItemProtocol>: ItemListHolder{
    
    var arrayOfItems: [ItemProtocol] {
        willSet(newValue) {
            observer?.willChange(propertyName: ItemManagerKeys.arrayOfItems, newPropertyValue: newValue)
        }
        didSet {
            observer?.didChange(propertyName: ItemManagerKeys.arrayOfItems, oldPropertyValue: oldValue)
        }
    }
    
    weak var observer:PropertyObserver?
    
    init(_ array: [T]) {
        self.arrayOfItems = array
    }
}

protocol ObserverCollection {
    func addObserver(observer: PropertyObserver)
    func removeAll()
}

protocol IObserverMediator: PropertyObserver & ObserverCollection {
}

final class ObserverMediator: IObserverMediator {
    
    var observers: [PropertyObserver]
    init(){
        self.observers = [PropertyObserver]()
    }
    
    func willChange(propertyName: String, newPropertyValue: Any?) {
        for observer in observers {
            observer.willChange(propertyName: propertyName,
                                newPropertyValue: newPropertyValue)
        }
    }
    
    func didChange(propertyName: String, oldPropertyValue: Any?) {
        for observer in observers {
            observer.didChange(propertyName: propertyName,
                               oldPropertyValue: oldPropertyValue)
        }
    }
    
    func addObserver(observer: PropertyObserver) {
        observers.append(observer)
    }
    
    func removeAll(){
        observers.removeAll()
    }
    
}

