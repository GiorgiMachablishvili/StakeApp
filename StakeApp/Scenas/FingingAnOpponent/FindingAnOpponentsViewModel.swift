//
//  FindingAnOpponentsViewModel.swift
//  StakeApp
//
//  Created by Gio's Mac on 04.02.25.
//

import Foundation

class FindingAnOpponentsViewModel {

    // Callback to update UI when dot animation changes
    var onDotsUpdated: ((String) -> Void)?

    // Callback when opponent is found
    var onOpponentFound: (() -> Void)?

    private var dotTimer: Timer?
    private var dotCount = 0
    private let maxDots = 3

    // Start the opponent search simulation
    func startFindingOpponent(after seconds: TimeInterval) {
        startDotAnimation()

        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [weak self] in
            self?.stopDotAnimation()
            self?.onOpponentFound?()
        }
    }

    // Start the animation for "Finding an opponent..."
    private func startDotAnimation() {
        dotTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateDots), userInfo: nil, repeats: true)
    }

    // Stop the animation
    private func stopDotAnimation() {
        dotTimer?.invalidate()
        dotTimer = nil
    }

    // Update dot animation and notify UI
    @objc private func updateDots() {
        dotCount = (dotCount + 1) % (maxDots + 1)
        let dots = String(repeating: ".", count: dotCount)
        onDotsUpdated?("Finding an opponent\(dots)")
    }

    // Cancel the opponent search
    func cancelFinding() {
        stopDotAnimation()
    }
}

