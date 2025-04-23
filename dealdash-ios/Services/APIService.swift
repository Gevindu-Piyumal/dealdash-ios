//
//  APIService.swift
//  dealdash-ios
//
//  Created by Gevindu Piyumal on 2025-04-23.
//

import Alamofire
import Foundation

class APIService {
    static let shared = APIService()
    private init() {}

    private let session: Session = {
        let cfg = URLSessionConfiguration.default
        cfg.timeoutIntervalForRequest = Config.requestTimeout
        return Session(configuration: cfg)
    }()

    func fetchDeals(
        active: Bool = true,
        featured: Bool? = nil
    ) async throws -> [Deal] {
        try await withCheckedThrowingContinuation { continuation in
            let url = Config.apiBaseURL.appendingPathComponent("deals")
            var params: [String: String] = ["active": active ? "true" : "false"]
            if let f = featured { params["featured"] = f ? "true" : "false" }

            session.request(
                url,
                parameters: params,
                encoding: URLEncoding.default
            )
            .validate()
            .responseData { resp in
                if let data = resp.data {
                    do {
                        let deals = try Config.jsonDecoder.decode(
                            [Deal].self,
                            from: data
                        )
                        continuation.resume(returning: deals)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                } else if let error = resp.error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(
                        throwing: NSError(
                            domain: "APIService",
                            code: -1,
                            userInfo: [
                                NSLocalizedDescriptionKey: "Unknown error"
                            ]
                        )
                    )
                }
            }
        }
    }
}
