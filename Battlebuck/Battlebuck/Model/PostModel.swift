//
//  PostModel.swift
//  Battlebuck
//
//  Created by Macbook Pro on 03/10/25.
//
// MARK: - Basic Post Model
struct Post: Codable, Identifiable, Equatable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
