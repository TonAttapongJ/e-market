//
//  OrderSuccessView.swift
//  e-market
//
//  Created by Ton Attapong on 25/4/2567 BE.
//

import SwiftUI

struct OrderSuccessView: View {
  @EnvironmentObject var router: Router
    var body: some View {
      VStack {
        Text("Order Successfully!")
          .fontWeight(.semibold)
          .font(.system(size: 28))
      }
      Button(action: {
        router.navigateToRoot()
      }) {
          Text("Back to Home")
              .font(.headline)
              .foregroundColor(.white)
              .padding()
              .background(Color.black)
              .cornerRadius(10)
      }
      .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    OrderSuccessView()
}
