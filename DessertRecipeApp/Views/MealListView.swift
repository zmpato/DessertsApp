//
//  MealListView.swift
//  DessertRecipeApp
//
//  Created by Zak Mills on 9/6/24.
//

import SwiftUI

struct MealListView: View {
    @StateObject private var viewModel = MealsViewModel(mealService: RealMealService())
    @State private var searchText = ""
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search Desserts", text: $searchText)
                    .fontDesign(.rounded)
                    .font(.subheadline)
                    .padding(12)
                    .background(customTan2)
                    .clipShape(.rect(cornerRadius: 12))
                    .padding(.horizontal, 24)
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 8) {
                        if let meals = viewModel.recipes?.meals.filter({ meal in
                            searchText.isEmpty || meal.strMeal.lowercased().contains(searchText.lowercased())
                        })
                            
                        {
                            ForEach(meals, id: \.self) { meal in
                                NavigationLink(destination: DetailView(meal: meal)) {
                                    VStack {
                                        VStack(spacing: 8) {
                                            AsyncImage(url: URL(string: meal.strMealThumb)) { image in
                                                if let image = image.image {
                                                    image
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .clipShape(Circle())
                                                        .frame(width: 100, height: 100)
                                                        .overlay(
                                                            Circle()
                                                                .stroke(Color.white, lineWidth: 3)
                                                        )
                                                    
                                                } else {
                                                    Image("defaultImage")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .clipShape(Circle())
                                                        .frame(width: 100, height: 100)
                                                }
                                            }
                                            Text(meal.strMeal)
                                                .fontDesign(.rounded)
                                                .fontWeight(.bold)
                                                .scaledToFit()
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.01)
                                                .padding(.leading, 8)
                                                .padding(.trailing, 8)
                                                .foregroundStyle(customGreen)
                                        }
                                        .padding(.top, 15)
                                        Spacer()
                                        HStack {
                                            Spacer()
                                            Image(systemName: "arrow.right.circle.fill")
                                                .resizable()
                                                .frame(width: 35, height: 35)
                                                .padding(10)
                                                .foregroundStyle(customGreen)
                                        }
                                    }
                                    .background(customTan2)
                                    .clipShape(.rect(cornerRadius: 12))
                                }
                            }
                        } else {
                            ProgressView()
                        }
                    }
                    .padding()
                }
                .background(customTan)
            }
            .background(customTan)
        }
        .task {
            await viewModel.fetchRecipes()
        }
    }
    
}

#Preview {
    MealListView()
}
