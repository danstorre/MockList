//
//   protocol URLFetcher
//
//  Created by Daniel Torres on 6/10/20.
//  Copyright © 2020 dansTeam. All rights reserved.
//

import Foundation

protocol URLFetcher {
    typealias DataHandler = (Data?, Error?) -> Void
    func fetchData(from: URL, completion: @escaping(DataHandler))
}
