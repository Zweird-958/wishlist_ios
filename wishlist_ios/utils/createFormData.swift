//
//  createFormData.swift
//  wishlist_ios
//
//  Created by Julien on 04/08/2023.
//

import Foundation
import PhotosUI

func createFormData(parameters: [String: Any], boundary: String) -> Data {
    var body = Data()

    for (key, value) in parameters {
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        if let image = value as? UIImage {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                print("Error: Invalid image data for key \(key)")
                continue
            }
            body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
        } else {
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)".data(using: .utf8)!)
        }
        body.append("\r\n".data(using: .utf8)!)
    }

    body.append("--\(boundary)--\r\n".data(using: .utf8)!)
    return body
}
