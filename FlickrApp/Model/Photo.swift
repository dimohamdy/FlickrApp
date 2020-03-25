//
//	Photo.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Photo: Codable {

    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let isPublic, isFriend, isFamily: Int

    var imagePath: String? {
        return "http://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg"
    }
	enum CodingKeys: String, CodingKey {
		case farm = "farm"
		case id = "id"
		case isFamily = "isfamily"
		case isFriend = "isfriend"
		case isPublic = "ispublic"
		case owner = "owner"
		case secret = "secret"
		case server = "server"
		case title = "title"
	}
    
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		farm = try values.decode(Int.self, forKey: .farm)
		id = try values.decode(String.self, forKey: .id)
		isFamily = try values.decode(Int.self, forKey: .isFamily)
		isFriend = try values.decode(Int.self, forKey: .isFriend)
		isPublic = try values.decode(Int.self, forKey: .isPublic)
		owner = try values.decode(String.self, forKey: .owner)
		secret = try values.decode(String.self, forKey: .secret)
		server = try values.decode(String.self, forKey: .server)
		title = try values.decode(String.self, forKey: .title)
	}

}
