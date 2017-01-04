//
//  User.swift
//  Portfolious
//
//  Created by Andrew Sowers on 7/30/16.
//  Copyright © 2016 Andrew Sowers. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

struct User {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: Address
    let phone: String
    let website: String
    let company: Company
}

extension User: Decodable {
    static func decode(_ json: JSON) -> Decoded<User> {
        return curry(self.init)
            <^> json <| "id"
            <*> json <| "name"
            <*> json <| "username"
            <*> json <| "email"
            <*> json <| "address"
            <*> json <| "phone"
            <*> json <| "website"
            <*> json <| "company"
    }
}

extension User: Equatable { }
func ==(lhs: User, rhs: User) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name && lhs.username == rhs.username && lhs.email == rhs.email && lhs.address == rhs.address && lhs.phone == rhs.phone && lhs.website == rhs.website && lhs.company == rhs.company ? true : false
}

struct Address {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    
}

extension Address: Decodable {
    static func decode(_ json: JSON) -> Decoded<Address> {
        return curry(self.init)
            <^> json <| "street"
            <*> json <| "suite"
            <*> json <| "city"
            <*> json <| "zipcode"
    }
}

extension Address: Equatable { }
func ==(lhs: Address, rhs: Address) -> Bool {
    return lhs.street == rhs.street && lhs.suite == rhs.suite && lhs.city == rhs.city && lhs.zipcode == rhs.zipcode ? true : false
}

struct Geo {
    let lat: Double
    let lon: Double
}

extension Geo: Decodable {
    static func decode(_ json: JSON) -> Decoded<Geo> {
        return curry(self.init)
            <^> json <| "lat"
            <*> json <| "lon"
    }
}

extension Geo: Equatable { }
func ==(lhs: Geo, rhs: Geo) -> Bool {
    return lhs.lat == rhs.lat && lhs.lon == rhs.lon ? true : false
}

struct Company {
    let name: String
    let catchPhrase: String
    let bs: String
}

extension Company: Decodable {
    static func decode(_ json: JSON) -> Decoded<Company> {
        return curry(self.init)
            <^> json <| "name"
            <*> json <| "catchPhrase"
            <*> json <| "bs"
    }
}

extension Company: Equatable { }
func ==(lhs: Company, rhs: Company) -> Bool {
    return lhs.name == rhs.name && lhs.catchPhrase == rhs.catchPhrase && lhs.bs
    == rhs.bs ? true : false
}
