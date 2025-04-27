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

    // Add a cache property
    private var cache: [String: Any] = [:]

    private func getCachedData<T>(forKey key: String) -> T? {
        return cache[key] as? T
    }

    private func setCachedData<T>(_ data: T, forKey key: String) {
        cache[key] = data
    }

    func fetchDeals(
        active: Bool = true,
        featured: Bool? = nil
    ) async throws -> [Deal] {
        let cacheKey = "deals_\(active)_\(featured ?? false)"
        
        // Check cache first
        if let cachedDeals: [Deal] = getCachedData(forKey: cacheKey) {
            return cachedDeals
        }

        // Fetch from API if not cached
        return try await withCheckedThrowingContinuation { continuation in
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
                        // Cache the data
                        self.setCachedData(deals, forKey: cacheKey)
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

    func fetchDeal(id: String) async throws -> Deal {
        let cacheKey = "deal_\(id)"
        
        // Check cache first
        if let cachedDeal: Deal = getCachedData(forKey: cacheKey) {
            return cachedDeal
        }

        // Fetch from API if not cached
        return try await withCheckedThrowingContinuation { continuation in
            let url = Config.apiBaseURL.appendingPathComponent("deals/\(id)")

            session.request(url)
                .validate()
                .responseData { resp in
                    if let data = resp.data {
                        do {
                            let deal = try Config.jsonDecoder.decode(
                                Deal.self,
                                from: data
                            )
                            // Cache the data
                            self.setCachedData(deal, forKey: cacheKey)
                            continuation.resume(returning: deal)
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

    func fetchDealsByVendor(
        vendorId: String,
        active: Bool? = nil
    ) async throws -> [Deal] {
        let cacheKey = "deals_vendor_\(vendorId)_\(active ?? false)"
        
        // Check cache first
        if let cachedDeals: [Deal] = getCachedData(forKey: cacheKey) {
            return cachedDeals
        }

        // Fetch from API if not cached
        return try await withCheckedThrowingContinuation { continuation in
            let url = Config.apiBaseURL.appendingPathComponent("deals")

            var params: [String: String] = ["vendor": vendorId]
            if let isActive = active {
                params["active"] = isActive ? "true" : "false"
            }

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
                        // Cache the data
                        self.setCachedData(deals, forKey: cacheKey)
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

    func fetchVendor(id: String) async throws -> Vendor {
        let cacheKey = "vendor_\(id)"
        
        // Check cache first
        if let cachedVendor: Vendor = getCachedData(forKey: cacheKey) {
            return cachedVendor
        }

        // Fetch from API if not cached
        return try await withCheckedThrowingContinuation { continuation in
            let url = Config.apiBaseURL.appendingPathComponent("vendors/\(id)")

            session.request(url)
                .validate()
                .responseData { resp in
                    if let data = resp.data {
                        do {
                            let vendor = try Config.jsonDecoder.decode(
                                Vendor.self,
                                from: data
                            )
                            // Cache the data
                            self.setCachedData(vendor, forKey: cacheKey)
                            continuation.resume(returning: vendor)
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

    func fetchNearbyVendors(
        longitude: Double,
        latitude: Double,
        distance: Double = 100000,
        category: String = ""
    ) async throws -> [NearbyVendor] {
        let cacheKey = "nearby_vendors_\(longitude)_\(latitude)_\(distance)_\(category)"
        
        // Check cache first
        if let cachedVendors: [NearbyVendor] = getCachedData(forKey: cacheKey) {
            return cachedVendors
        }

        // Fetch from API if not cached
        return try await withCheckedThrowingContinuation { continuation in
            let url = Config.apiBaseURL.appendingPathComponent("vendors/nearby")

            let params: [String: String] = [
                "longitude": String(longitude),
                "latitude": String(latitude),
                "distance": String(distance),
                "category": category,
            ]

            session.request(
                url,
                parameters: params,
                encoding: URLEncoding.default
            )
            .validate()
            .responseData { resp in
                if let data = resp.data {
                    do {
                        let vendors = try Config.jsonDecoder.decode(
                            [NearbyVendor].self,
                            from: data
                        )
                        // Cache the data
                        self.setCachedData(vendors, forKey: cacheKey)
                        continuation.resume(returning: vendors)
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
