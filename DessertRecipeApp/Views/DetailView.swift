//
//  DetailView.swift
//  DessertRecipeApp
//
//  Created by Zak Mills on 9/4/24.
//

import SwiftUI

struct DetailView: View {
    @StateObject private var viewModel = MealsViewModel(mealService: RealMealService())
    @Environment(\.dismiss) var dismiss
    let meal: Meals
    var body: some View {
        ScrollView {
            AsyncImage(url: URL(string: meal.strMealThumb)) { image in
                if let image = image.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                } else {
                    Image("defaultImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                }
            }
            VStack(alignment: .leading, spacing: 10) {
                Text(meal.strMeal)
                    .fontDesign(.rounded)
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .foregroundStyle(customGreen)
                Spacer()
                if let mealDetails = viewModel.selectedMeal?.meals {
                    ForEach(mealDetails, id: \.self) { ingredients in
                        let combinedDict = viewModel.filteredIngredientsAndMeasurments(from: ingredients)
                        ForEach(Array(combinedDict.keys), id: \.self) { ingredient in
                            if let measurement = combinedDict[ingredient] {
                                VStack(spacing: 5) {
                                    HStack {
                                        Text("\(ingredient) : ")
                                            .fontDesign(.rounded)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(customGreen)
                                        Text("\(measurement)")
                                            .fontDesign(.rounded)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(customGreen)
                                    }
                                }
                            }
                        }
                        Spacer()
                        VStack(spacing: 15) {
                            Text("Instructions:")
                                .fontDesign(.rounded)
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .foregroundStyle(customGreen)
                            Text("\(ingredients.strInstructions ?? "")")
                                .fontDesign(.rounded)
                                .fontWeight(.medium)
                                .foregroundStyle(customGreen)
                        }
                    }
                }
            }
            .padding(.leading, 10)
            .task {
                await viewModel.fetchMealInformation(for: meal)
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .foregroundStyle(customGreen)
                    .onTapGesture {
                        dismiss()
                    }
            }
        }
        .toolbarBackground(customTan, for: .navigationBar)
        .background(customTan)
    }
}

#Preview {
    DetailView(meal: Meals(idMeal: "", strMeal: "hi", strMealThumb: ""))
}
