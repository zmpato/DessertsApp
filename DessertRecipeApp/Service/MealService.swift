//
//  MealService.swift
//  DessertRecipeApp
//
//  Created by Zak Mills on 9/4/24.
//

import Foundation
import UIKit

protocol MealService {
    func fetchMeals() async throws -> Meal
}

class RealMealService: MealService {
    func fetchMeals() async throws -> Meal {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else { fatalError("Invalid URL") }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            let decoder = JSONDecoder()
            let meals = try decoder.decode(Meal.self, from: data)
            return meals
        } catch {
            print("Error fetching meals \(error)")
            throw error
        }
    }
    
    func fetchMealInfo(for mealID: String) async throws -> MealInfo {
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(mealID)") else { fatalError("Invalid URL") }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            let decoder = JSONDecoder()
            let mealInfo = try decoder.decode(MealInfo.self, from: data)
            return mealInfo
        } catch {
            print("Error fetching meals \(error)")
            throw error
        }
    }
}
