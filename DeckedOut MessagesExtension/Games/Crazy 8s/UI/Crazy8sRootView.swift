//
//  Crazy8sRootView.swift
//  DeckedOut
//
//  Created by Sawyer Christensen on 2/23/26.
//

import Foundation
import SwiftUI

struct Crazy8sRootView: View {
    @ObservedObject var game: Crazy8sManager //Establishes GameManager as a single source of truth
    @State private var isJoining = false

    init(game: Crazy8sManager) {
        self.game = game
    }

    var body: some View {
        if game.needsToJoin || game.isSettlingAfterJoin {
            VStack(spacing: 30) {

                if game.needsToJoin && !isJoining { //we still need to join, and are not actively joining
                    JoinGameButton(game: game, isJoining: $isJoining)
                    
                } else { //we are currently joining!
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(1.5)
                    Text("Joining…")
                        .font(.system(.title2, design: .serif, weight: .semibold))
                        .foregroundStyle(.white)
                }

                Text("\(game.seats.filter { $0 != Crazy8sManager.unclaimedSeat }.count) / \(game.seats.count)")
                    .font(.system(.largeTitle, design: .serif, weight: .bold))
                    .foregroundStyle(.white)

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Image("feltBackgroundLight")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
            )

        } else { //we do not need to join. the game is loaded. display it
            Crazy8sGameView()
                .environmentObject(game)
        }
    }
}


struct JoinGameButton: View {
    @ObservedObject var game: Crazy8sManager
    @Binding var isJoining: Bool
    @State private var isPulsating = false
    
    var body: some View {
        Button {
            isJoining = true
            game.performJoin()
        } label: {
            Text("Join Game")
                .font(.system(.largeTitle, design: .serif, weight: .bold))
                .foregroundStyle(.white)
                .scaleEffect(isPulsating ? 1.05 : 1)
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                        isPulsating = true
                    }
                }
                .onDisappear {
                    isPulsating = false
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 14)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.black.opacity(0.3))
                            .offset(y: 4)
                        RoundedRectangle(cornerRadius: 15)
                            .fill(LinearGradient(colors: [Color(white: 0.3), Color(white: 0.1)], startPoint: .top, endPoint: .bottom))
                    }
                )
                .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white.opacity(0.2), lineWidth: 2))
                .shadow(color: .black.opacity(0.2), radius: 5, x: 5, y: 5)
        }
    }
}
