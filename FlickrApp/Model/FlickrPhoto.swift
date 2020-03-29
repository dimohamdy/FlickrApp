//
//	PhotosResult.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct FlickrPhoto: Codable {

	let photos: Photos?
	let stat: String?

	enum CodingKeys: String, CodingKey {
		case photos
		case stat
	}
    
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        photos = try? values.decodeIfPresent(Photos.self, forKey: .photos)
		stat = try? values.decodeIfPresent(String.self, forKey: .stat)
	}

}
