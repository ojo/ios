//
//  Promise+UIImage.swift
//  ojo
//
//  Created by Brian Tiger Chow on 1/2/17.
//  Copyright © 2017 TTRN. All rights reserved.
//

import PromiseKit
import UIKit
import AlamofireImage

enum ImageDownloadError: Error {
    case invalidURL
    case unknown
}

func fetchImage(_ url: String) -> Promise<UIImage> {
    return Promise { fulfill, reject in
        guard let url = URL(string: url) else {
            reject(ImageDownloadError.invalidURL)
            return
        }
        let req = URLRequest(url: url)
        ImageDownloader.default.download(req) { response in
            guard let image = response.result.value else {
                reject(response.result.error ?? ImageDownloadError.unknown)
                return
            }
            fulfill(image)
        }
    }
}
