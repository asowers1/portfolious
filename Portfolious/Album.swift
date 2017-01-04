//
//  Album.swift
//  Portfolious
//
//  Created by Andrew Sowers on 7/30/16.
//  Copyright © 2016 Andrew Sowers. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

struct Album {
    let id: Int
    let userID: Int
    let title: String
    
    init(id: Int, userID: Int, title: String) {
        self.id = id
        self.userID = userID
        self.title = title
    }
}

extension Album: Decodable {
    static func decode(_ json: JSON) -> Decoded<Album> {
        return curry(self.init)
            <^> json <| "id"
            <*> json <| "userId"
            <*> json <| "title"
    }
}

extension Album: Equatable {}

func ==(lhs: Album, rhs: Album) -> Bool {
    return lhs.id == rhs.id && lhs.userID == rhs.userID && lhs.title == rhs.title ? true : false
}

struct Photo {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
    
    init(albumId: Int, id: Int, title: String, url: String, thumbnailUrl: String) {
        self.albumId = albumId
        self.id = id
        self.title = title
        self.url = url
        self.thumbnailUrl = thumbnailUrl
    }
}

extension Photo: Decodable {
    static func decode(_ json: JSON) -> Decoded<Photo> {
        return curry(self.init)
            <^> json <| "albumId"
            <*> json <| "id"
            <*> json <| "title"
            <*> json <| "url"
            <*> json <| "thumbnailUrl"
    }
}

extension Photo: Equatable { }

func ==(lhs: Photo, rhs: Photo) -> Bool {
    return lhs.albumId == rhs.albumId && lhs.id == rhs.id && lhs.title == rhs.title && lhs.url == rhs.url && lhs.thumbnailUrl == rhs.thumbnailUrl ? true : false
}
