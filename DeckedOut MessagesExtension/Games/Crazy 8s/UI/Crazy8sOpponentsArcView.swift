//
//  Crazy8sOpponentsArcView.swift
//  DeckedOut
//
//  Created by Sawyer Christensen on 5/5/26.
//

import SwiftUI

struct Crazy8sOpponentsArcView: View {
    @EnvironmentObject var game: Crazy8sManager

    let discardPileZone: CGRect
    let deckZone: CGRect

    private var opponentCount: Int { max(game.seats.count - 1, 1) }

    // All opponent seats in clockwise order starting from the player's left
    private var opponentSeats: [Int] {
        guard game.seats.count > 2 else { return [] }
        var result: [Int] = []
        for i in 1..<game.seats.count {
            result.append((game.mySeatIndex + i) % game.seats.count)
        }
        return result
    }

    private var handScale: CGFloat { return 1.0 / sqrt(CGFloat(opponentCount)) } // 1 = 1.0, 2 = 0.71, 3 = 0.58, 4 = 0.5, 5 = 0.45...
    private var scaledCardHeight: CGFloat { 145 * handScale }
    private var arcDepth: CGFloat { opponentCount <= 2 ? 0 : CGFloat(opponentCount) * 5 }
    private var totalSpread: CGFloat {
        let screenWidth = UIDevice.current.userInterfaceIdiom == .pad ? game.extensionWidth : UIScreen.main.bounds.width
        switch opponentCount {
        case 1: return 0
        case 2: return screenWidth * 0.45
        case 3: return screenWidth * 0.55
        default: return screenWidth * 0.65
        }
    }

    // MARK: 1v1 view
    var body: some View {
        if game.isSinglePlayer || game.seats.count <= 2 {
            Crazy8sOpponentHandView(
                cards: game.opponentHand,
                discardPileZone: discardPileZone,
                deckZone: deckZone
            )
        } else {
            multiOpponentArc
        }
    }
    
    // MARK: Groupchat view
    private var multiOpponentArc: some View {
        let seats = opponentSeats
        let count = seats.count
        let showAnimatedActive = (game.phase == .animationPhase || game.phase == .mainPhase || game.isAnimatingOpponentTurn)

        return ZStack {
            ForEach(Array(seats.enumerated()), id: \.element) { index, seatIndex in
                let xOff = xOffset(index: index, count: count)
                let yOff = arcYOffset(index: index, count: count)
                let isActive = showAnimatedActive && seatIndex == game.animatingOpponentSeat

                Group {
                    if isActive {
                        Crazy8sOpponentHandView(
                            cards: game.opponentHand,
                            discardPileZone: discardPileZone,
                            deckZone: deckZone,
                            sizeScale: handScale
                        )
                    } else if seatIndex < game.allHands.count {
                        staticOpponentHand(cards: game.allHands[seatIndex])
                    }
                }
                .offset(x: xOff, y: yOff)
                .zIndex(isActive ? 1 : 0)
            }
        }
        .frame(height: scaledCardHeight + arcDepth + 10)
    }

    private func xOffset(index: Int, count: Int) -> CGFloat {
        guard count > 1 else { return 0 }
        let t = CGFloat(index) / CGFloat(count - 1) - 0.5
        return t * totalSpread
    }

    // Parabolic arc: center is highest, edges curve down
    private func arcYOffset(index: Int, count: Int) -> CGFloat {
        guard count > 2 else { return 0 }
        let t = CGFloat(index) / CGFloat(count - 1) - 0.5
        return t * t * 4 * arcDepth
    }

    @ViewBuilder
    private func staticOpponentHand(cards: [Card]) -> some View {
        let cardW: CGFloat = (cards.count >= 10 ? 98 : 101.5) * handScale
        let cardH: CGFloat = (cards.count >= 10 ? 140 : 145) * handScale
        let sp: CGFloat = (cards.count >= 10 ? -72 : -66) * handScale
        let center = Double(cards.count - 1) / 2.0
        let fan: Double = 4
        let yMult = 5.0 * Double(handScale)

        HStack(spacing: sp) {
            ForEach(cards) { card in
                let idx = cards.firstIndex(of: card)!
                let angle = Angle.degrees((Double(idx) - center) * -fan)
                let yOff = -abs((Double(idx) - center) * yMult)
                let reveal: Double = game.isGameOver ? 360 : 180

                CardView(frontImage: card.imageName, cardHeight: cardH, rotation: reveal)
                    .rotationEffect(angle)
                    .offset(y: yOff)
                    .shadow(color: .black.opacity(0.25), radius: 8)
                    .animation(
                        .spring(response: 0.6, dampingFraction: 0.7).delay(Double(idx) * 0.1),
                        value: game.isGameOver
                    )
            }
            .frame(width: cardW, height: cardH)
        }
        .frame(height: cardH)
    }
}
