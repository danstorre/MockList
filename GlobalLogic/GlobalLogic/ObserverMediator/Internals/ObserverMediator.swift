//
//  ObserverMediator.swift
//  GlobalLogic
//
//  Created by Daniel Torres on 6/10/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation


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

