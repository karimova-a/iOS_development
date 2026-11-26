//
//  HeroService.swift
//  HeroApp
//
//  Network layer. Uses URLSession.shared.dataTask with completion handlers.
//  The completion handlers run on a BACKGROUND thread; callers must hop to the
//  main thread (DispatchQueue.main.async) before touching any UIKit object.
//

import UIKit

nonisolated enum HeroServiceError: LocalizedError {
    case invalidURL
    case badStatus(Int)
    case noData
    case decoding

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "The address of the server is not valid."
        case .badStatus(let code): return "The server answered with status \(code)."
        case .noData: return "The server returned no data."
        case .decoding: return "The hero data could not be read."
        }
    }
}

nonisolated enum HeroService {
    static let allHeroesURL = "https://akabab.github.io/superhero-api/api/all.json"

    /// Downloads and decodes the whole hero list.
    static func fetchHeroes(completion: @escaping (Result<[Hero], Error>) -> Void) {
        guard let url = URL(string: allHeroesURL) else {
            completion(.failure(HeroServiceError.invalidURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            // Safe cast instead of `as!`, so a strange response can never crash the app.
            guard let http = response as? HTTPURLResponse else {
                completion(.failure(HeroServiceError.badStatus(-1)))
                return
            }
            guard http.statusCode == 200 else {
                completion(.failure(HeroServiceError.badStatus(http.statusCode)))
                return
            }
            guard let data = data else {
                completion(.failure(HeroServiceError.noData))
                return
            }
            do {
                let heroes = try JSONDecoder().decode([Hero].self, from: data)
                completion(.success(heroes))
            } catch {
                completion(.failure(HeroServiceError.decoding))
            }
        }
        task.resume()
    }

    /// Downloads one picture with URLSession. Calls completion(nil) on any problem.
    static func fetchImage(from urlString: String?, completion: @escaping (UIImage?) -> Void) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil,
                  let http = response as? HTTPURLResponse,
                  http.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }
        task.resume()
    }
}
