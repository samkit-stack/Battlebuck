//
//  Extension.swift
//  Battlebuck
//
//  Created by Macbook Pro on 03/10/25.
//
import SwiftUI
extension Color {
    static func softColor(for id: Int) -> Color {
        let colors: [Color] = [
            Color.pink.opacity(0.25),
            Color.blue.opacity(0.25),
            Color.green.opacity(0.25),
            Color.orange.opacity(0.25),
            Color.purple.opacity(0.25),
            Color.teal.opacity(0.25),
            Color.yellow.opacity(0.25)
        ]
        return colors[id % colors.count]
    }
}

