// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftUI
import OPPlayerObjC

public class PlayerController: NSObject, ObservableObject {
    
    // MARK: - Public Properties
    
    public let player: ZFPlayerController
    public let containerView: UIView
    public let controlView: ZFPlayerControlView
    @Published public var assetURL: URL? {
        didSet {
            player.assetURL = assetURL
            player.currentPlayerManager.shouldAutoPlay = true
        }
    }
    
    // MARK: - Private Properties
    
    private let videoManager = ZFAVPlayerManager()
    
    // MARK: - Init
    
    public init(containerView: UIView, controlView: ZFPlayerControlView) {
        containerView.addSubview(controlView)
        
        self.containerView = containerView
        self.controlView = controlView
        self.player = ZFPlayerController(playerManager: videoManager, containerView: containerView)
        self.player.controlView = controlView
    }
    
    public func play() {
        player.currentPlayerManager.play()
    }
    
    public func pause() {
        player.currentPlayerManager.pause()
    }
}

public struct VideoPreview: UIViewRepresentable {
    
    // MARK: - Public Properties
    
    public let playerController: PlayerController
    
    // MARK: - Init
    
    public init(playerController: PlayerController) {
        self.playerController = playerController
    }
    
    // MARK: - UIViewRepresentable
    
    public func makeUIView(context: Context) -> UIView {
        return playerController.containerView
    }
    
    public func updateUIView(_ uiView: UIView, context: Context) {
        // Do nothing
    }
}
