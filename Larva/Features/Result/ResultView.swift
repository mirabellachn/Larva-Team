import Foundation
import SwiftUI

struct ResultView: View {
    var body: some View {
        VStack(spacing: 24) {
            VStack {
                // Title
                HStack() {
                    Text("Hi Mate!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.bottom, 8)
                // SubTitle
                HStack {
                    Text("This is your skin color analysis result ✨")
                        .font(.title3)
                    Spacer()
                }
            }
            HStack(spacing: 45) {
                // Skintone
                VStack(alignment: .center, spacing: 8) {
                    Text("Skintone")
                        .font(.system(size: 16))
                    Circle()
                        .fill(Color.white)
                        .stroke(Color.black, lineWidth: 1)    .frame(width: 100, height: 100)
                    Text("Light")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                    Text("Kulit kamu terang")
                        .font(.system(size: 16))
                    
                }
                //Undertone
                VStack(alignment: .center, spacing: 8) {
                    Text("Undertone")
                        .font(.system(size: 16))
                    Circle()
                        .fill(Color.white)
                        .stroke(Color.black, lineWidth: 1)    .frame(width: 100, height: 100)
                    Text("Cool")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                    Text("Kulit kamu cool")
                        .font(.system(size: 16))
                    
                }
            }
            VStack {
                // Complextion Shade
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.white)
                        .stroke(Color.black, lineWidth: 1)    .frame(width: 24, height: 24)
                    Text("Complexion Shade")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                    
                    Spacer()
                }
                HStack {
                    Text("Check this recommendation out! ")
                        .font(.title3)
                    Spacer()
                }
            }
            Spacer()
            
        }
        .padding(.leading, 16)
        .padding(.trailing, 16)
        .padding(.top, 32)
        
    }
}

#Preview {
    ResultView()
}
