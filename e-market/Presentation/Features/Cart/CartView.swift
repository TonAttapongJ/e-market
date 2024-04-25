//
//  CartView.swift
//  e-market
//
//  Created by Ton Attapong on 24/4/2567 BE.
//

import SwiftUI
import SDWebImageSwiftUI

struct CartView: View {
  @StateObject var viewModel: CartViewModel
  @EnvironmentObject var router: Router
  @State private var showingConfirmation = false
  
  let imageSize = UIScreen.main.bounds.width * 0.2
  
  public init(viewModel: CartViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .center) {
        VStack {
          ProgressView("Loading...")
            .progressViewStyle(CircularProgressViewStyle())
        }
        .frame(width: geometry.size.width / 3,
               height: geometry.size.height / 6)
        .background(Color.secondary.colorInvert())
        .foregroundColor(Color.primary)
        .cornerRadius(20)
        .opacity(self.viewModel.isUpdating ? 1 : 0)

        VStack(alignment: .leading) {
          switch viewModel.viewState {
          case .start:
            EmptyView()
          case .loading:
            Spacer()
            ProgressView("Loading...")
              .progressViewStyle(CircularProgressViewStyle())
              .padding()
            Spacer()
          case .success:
            ScrollView {
              VStack(alignment: .leading) {
                ForEach(viewModel.productModels, id: \.name) { item in
                  HStack {
                    WebImage(url: URL(string: item.imageUrl))
                      .resizable()
                      .frame(width: imageSize, height: imageSize)
                      .padding(.top, 0)
                    VStack(alignment: .leading) {
                      Text(item.name)
                        .fontWeight(.semibold)
                        .font(.system(size: 18))
                        .lineLimit(2)
                      
                      HStack {
                        Text("Quantity")
                        Spacer()
                        Button {
                          if (item.quantity - 1) == 0 {
                            showingConfirmation = true
                          } else {
                            viewModel.updateProduct(product: item, quantity: item.quantity - 1)
                          }
                        } label: {
                          Text("-")
                            .foregroundColor(.black)
                            .padding(.horizontal, 5)
                        }
                        .padding(.all, 4)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                          RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.black, lineWidth: 2)
                        )
                        
                        Text("\(item.quantity)")
                          .padding(.horizontal, 8)
                        
                        Button {
                          viewModel.updateProduct(product: item, quantity: item.quantity + 1)
                        } label: {
                          Text("+")
                            .foregroundColor(.black)
                            .padding(.horizontal, 4)
                        }
                        .padding(.all, 4)
                        .background(Color.white)
                        .overlay(
                          RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.black, lineWidth: 2)
                        )
                      }
                      
                      HStack {
                        Text("Price: ")
                        Spacer()
                        Text("\(item.price * Double(item.quantity), specifier: "%.2f")")
                      }
                    }
                  }
                  .alert(isPresented: $showingConfirmation) {
                    Alert(
                      title: Text("Confirmation"),
                      message: Text("Are you sure you want to remove this item?"),
                      primaryButton: .destructive(Text("Remove")) {
                        viewModel.updateProduct(product: item, quantity: 0)
                      },
                      secondaryButton: .cancel()
                    )
                  }
                  
                  .alert(isPresented: $viewModel.isShowError) {
                    Alert(
                      title: Text("Error occure"),
                      message: Text("\(viewModel.errorMessage), Please try again later"),
                      dismissButton: .default(Text("OK"))
                    )
                  }
                }
              }.padding(16)
            }
          case .failed:
            Text("There is no product")
          }
        }
        .navigationTitle("Cart")
      }
    }
  }
}

#Preview {
  CartView(viewModel: CartViewModel())
}
