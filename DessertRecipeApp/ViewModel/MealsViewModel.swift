//
//  MealsViewModel.swift
//  DessertRecipeApp
//
//  Created by Zak Mills on 9/4/24.
//

import Foundation
import UIKit

class MealsViewModel: ObservableObject {
    @Published var recipes: Meal? = nil
    @Published var selectedMeal: MealInfo?
    @Published var isLoading = true
    @Published var mealDetails: MealInformation?
    
    private let mealService: RealMealService
    
    init(mealService: RealMealService) {
        self.mealService = mealService
    }
    var allIngredients: [String] {
        let mirror = Mirror(reflecting: mealDetails)
        
        return mirror.children.compactMap { child in
            if let label = child.label, label.starts(with: "strIngredient"), let value = child.value as? String {
                return value
            }
            return nil
        }
    }
    
    func fetchRecipes() async {
        isLoading = true
        do {
            let meals = try await mealService.fetchMeals()
            recipes = meals
            isLoading = false
        } catch {
            print("Error fetching recipes")
            isLoading = false
        }
    }
    
    func fetchMealInformation(for meal: Meals) async {
        isLoading = true
        do {
            let meals = try await mealService.fetchMealInfo(for: meal.idMeal)
            selectedMeal = meals
            isLoading = false
        } catch {
            print("Error fetching recipes")
            isLoading = false
        }
    }
    
    func filteredDetails(from mealDetails: MealInformation, detail: String) -> [String] {
        let mirror = Mirror(reflecting: mealDetails)
        
        return mirror.children.compactMap { child in
            if let label = child.label,
               label.starts(with: detail),
               let value = child.value as? String,
               !value.isEmpty {
                return value
            }
            return nil
        }
    }
    
    func filteredIngredientsAndMeasurments(from mealDetails: MealInformation) -> [String: String] {
        let ingredients = filteredDetails(from: mealDetails, detail: "strIngredient")
        let measurements = filteredDetails(from: mealDetails, detail: "strMeasure")
        let uniqueIngredients = removeDuplicates(from: ingredients)
        
        let newDict = Dictionary(uniqueKeysWithValues: zip(uniqueIngredients, measurements))
        
        
        return newDict
    }
    
    func removeDuplicates(from array: [String]) -> [String] {
        var seen = Set<String>()
        return array.filter { element in
            if seen.contains(element) {
                return false
            } else {
                seen.insert(element)
                return true
            }
        }
    }
    
}
