// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftUI
import OPPlayerObjC

public class PlayerController: NSObject, ObservableObject {
    
    // MARK: - Injected Properties
    
    @Published public var assetURL: URL? {
        didSet {
            player.assetURL = assetURL
            player.currentPlayerManager.shouldAutoPlay = true
        }
    }
    @Published public var isMuted: Bool = false {
        didSet {
            player.currentPlayerManager.isMuted = isMuted
        }
    }
    @Published public var isPlaying: Bool = false
    @Published public var isLoading: Bool = false
    
    @Published public var currentTime: Double = .zero
    @Published public var totalTime: Double = .zero
    
    // MARK: - Public Properties
    
    public let player: ZFPlayerController
    public let containerView: UIView
    public let controlView: ZFPlayerControlView
    
    // MARK: - Private Properties
    
    private let videoManager = ZFAVPlayerManager()
    
    // MARK: - Init
    
    public init(containerView: UIView, controlView: ZFPlayerControlView) {
        containerView.addSubview(controlView)
        
        self.containerView = containerView
        self.controlView = controlView
        self.player = ZFPlayerController(playerManager: videoManager, containerView: containerView)
        self.player.controlView = controlView
        
        super.init()
        
        self.setupPlayer()
    }
    
    public func play() {
        isPlaying = true
        player.currentPlayerManager.play()
    }
    
    public func pause() {
        isPlaying = false
        player.currentPlayerManager.pause()
    }
    
    public func stop() {
        isPlaying = false
        player.currentPlayerManager.stop()
    }
}

// MARK: - Supporting Methods

private extension PlayerController {
    
    func setupPlayer() {
        player.playerLoadStateChanged = { [weak self] (player, state) in
            guard let `self` = self else { return }
            
            switch state {
            case .playthroughOK, .playable:
                self.isLoading = false
            default:
                self.isLoading = true
            }
        }
        
        player.playerPlayTimeChanged = { [weak self] (player, currentTime, totalTime) in
            guard let `self` = self else { return }
            
            self.currentTime = currentTime
            self.totalTime = totalTime
        }
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

extension TimeInterval {
        
    var timeString: String {
        let seconds = Int(self) % 60
        let minutes = Int(self) / 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

public class TimeScrubber: UIView {
    
    // MARK: - Public Properties
    
    public var currentTime: TimeInterval = 0 {
        didSet {
            currentTimeLabel.text = currentTime.timeString
        }
    }
    public var duration: TimeInterval = 0 {
        didSet {
            durationLabel.text = duration.timeString
        }
    }
    
    // MARK: - Private Properties
    
    private let currentTimeLabel = UILabel()
    private let durationLabel = UILabel()
    private let scrubber = UISlider()
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        
        currentTimeLabel.text = "00:00"
        currentTimeLabel.font = .systemFont(ofSize: 12)
        currentTimeLabel.textColor = .white
        stackView.addArrangedSubview(currentTimeLabel)
        
        scrubber.minimumValue = 0
        scrubber.maximumValue = 1
        scrubber.value = 0
        stackView.addArrangedSubview(scrubber)
        
        durationLabel.text = "00:00"
        durationLabel.font = .systemFont(ofSize: 12)
        durationLabel.textColor = .white
        stackView.addArrangedSubview(durationLabel)
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
