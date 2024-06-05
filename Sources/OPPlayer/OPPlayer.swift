// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
@_exported import OPPlayerObjC

public class PlayerController: NSObject, ObservableObject {
    
    // MARK: - Public Properties
    
    public let player: ZFPlayerController
    public let containerView: UIView
    public let controlView: ZFPlayerControlView
    
    // MARK: - Private Properties
    
    private let videoManager = ZFAVPlayerManager()
    
    // MARK: - Init
    
    public init(containerView: UIView, controlView: ZFPlayerControlView) {
        self.containerView = containerView
        self.controlView = controlView
        self.player = ZFPlayerController(playerManager: videoManager, containerView: containerView)
        self.player.controlView = controlView
    }
}
