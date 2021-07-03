//
//  ImageProvider.swift
//  SocialFood
//
//  Created by Thịnh Nguyễn on 03/07/2021.
//

import Foundation
import SwiftUI

func imageToBase64(image: UIImage) -> String {
    
    let imageData = image.jpegData(compressionQuality: 1)
    let imageBase64String = imageData?.base64EncodedString() ?? ""
    return imageBase64String
}
