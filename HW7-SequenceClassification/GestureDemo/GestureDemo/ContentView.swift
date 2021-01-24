//
//  ContentView.swift
//  GestureDemo
//
//  Created by sicer on 2021/1/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var gesture = Gesture()
    var body: some View {
        VStack {
            Spacer()
            Text("上一动作: ")
            Text(gesture.lastMotionResult)
            Spacer()
            Text("当前动作: ")
            Text(gesture.motionResult)
            Spacer()
            Text("置信度: ")
            Text(gesture.motionConfidence)
            Spacer()
        }
        .padding()
        .font(.largeTitle)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
