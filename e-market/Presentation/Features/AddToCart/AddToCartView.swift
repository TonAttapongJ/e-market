//
//  AddToCartView.swift
//  e-market
//
//  Created by Ton Attapong on 24/4/2567 BE.
//

import SwiftUI

struct AddToCartView: View {
  @StateObject var viewModel: AddToCartViewModel
  @Binding var isAddToCartViewPresented: Bool
  
  let disableColor = Color(red: 0.8, green: 0.8, blue: 0.8)
  
  public init(viewModel: AddToCartViewModel, isAddToCartViewPresented: Binding<Bool>) {
    _viewModel = StateObject(wrappedValue: viewModel)
    _isAddToCartViewPresented = isAddToCartViewPresented
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text("Product name: ")
        Text(viewModel.productModel.name)
          .fontWeight(.semibold)
          .font(.system(size: 18))
          .lineLimit(2)
      }
      HStack {
        Text("Quantity")
        Spacer()
        Button {
          if viewModel.quantity > 1 {
            viewModel.quantity -= 1
          }
        } label: {
          Text("-")
            .foregroundColor(viewModel.quantity <= 1 ? .white : .black)
            .padding(.horizontal, 8)
        }
        .disabled(viewModel.quantity <= 1)
        .padding()
        .background(viewModel.quantity <= 1 ? disableColor : Color.white)
        .cornerRadius(10)
        .overlay(
          RoundedRectangle(cornerRadius: 10)
            .stroke(viewModel.quantity <= 1 ? disableColor : Color.black, lineWidth: 2)
        )
        
        Text("\(viewModel.quantity)")
          .padding(.horizontal, 8)
        
        Button {
          viewModel.quantity += 1
        } label: {
          Text("+")
            .foregroundColor(.black)
            .padding(.horizontal, 8)
        }
        .padding()
        .background(Color.white)
        .overlay(
          RoundedRectangle(cornerRadius: 10)
            .stroke(Color.black, lineWidth: 2)
        )
        
      }
      
      Button(action: {
        viewModel.addToCart()
      }) {
        Text("Add to cart")
          .font(.headline)
          .foregroundColor(.white)
          .frame(maxWidth: .infinity)
      }
      .padding()
      .background(Color.black)
      .cornerRadius(10)
      
    }
    .padding(.all, 16)
    .alert(isPresented: $viewModel.addToCartSuccess) {
      Alert(
        title: Text("Success"),
        message: Text("Product added successfully"),
        dismissButton: .default(
          Text("OK"),
          action: {
            isAddToCartViewPresented = false
          }
        )
      )
    }
  }
}

#Preview {
  AddToCartView(viewModel: AddToCartViewModel(productModel: ProductModel(name: "a", price: 12, imageUrl: "")), isAddToCartViewPresented: .constant(false))
}
