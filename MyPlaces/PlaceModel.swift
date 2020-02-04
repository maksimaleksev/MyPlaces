//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by Maxim Alekseev on 04.02.2020.
//  Copyright © 2020 Maxim Alekseev. All rights reserved.
//

import Foundation

struct Place {
    var name: String
    var location: String
    var type: String
    var image: String
    
   static let restaurantNames = [
        "Burger Heroes", "Kitchen", "Bonsai", "Дастархан",
        "Индокитай", "X.O", "Балкан Гриль", "Sherlock Holmes",
        "Speak Easy", "Morris Pub", "Вкусные истории",
        "Классик", "Love&Life", "Шок", "Бочка"
    ]
    
   static func getPlaces() -> [Place] {
        
        var places = [Place] ()
        
        for name in restaurantNames {
            places.append(Place (name: name, location: "Уфа", type: "Ресторан", image: name))
        }
        
        return places
    }
}
