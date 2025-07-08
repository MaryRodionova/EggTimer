import UIKit
import AVFoundation

final class ViewController: UIViewController {

    private let eggTimes = ["Soft": 300, "Medium": 420, "Hard": 600]

    private var player: AVAudioPlayer!
    private var timer: Timer?

    private var secondsRemaining = 60
    private var totalTime = 0
    private var secondsPassed = 0

    private let label: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(35)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "How do you like your eggs?"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let horizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let buttonEggSoft = EggButton(
        image: UIImage(named: "soft_egg"),
        title: "Soft"
    )

    private let buttonEggMedium = EggButton(
        image: UIImage(named: "medium_egg"),
        title: "Medium"
    )

    private let buttonEggHard = EggButton(
        image: UIImage(named: "hard_egg"),
        title: "Hard"
    )

    private let progressBar: UIProgressView = {
        let view = UIProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(hex: "#9ED6DD")
        addSubviews()
        setupConstraints()
        setupButtons()
    }

    private func setupButtons() {
        buttonEggSoft.addTarget(
            self,
            action: #selector(buttonAction(_:)),
            for: .touchUpInside
        )

        buttonEggMedium.addTarget(
            self,
            action: #selector(buttonAction(_:)),
            for: .touchUpInside
        )

        buttonEggHard.addTarget(
            self,
            action: #selector(buttonAction(_:)),
            for: .touchUpInside
        )
    }

    @objc
    private func buttonAction(_ sender: EggButton) {
        timer?.invalidate()
        if sender == buttonEggSoft {
            buttonEggSoftTap()
        } else if sender == buttonEggMedium {
            buttonEggMediumTap()
        } else if sender == buttonEggHard {
            buttonEggHardTap()
        }
    }

    private func buttonEggSoftTap() {
        label.text = "Soft"
        startTimer(time: eggTimes["Soft"]!)
    }

    private func buttonEggMediumTap() {
        label.text = "Medium"
        startTimer(time: eggTimes["Medium"]!)
    }

    private func buttonEggHardTap() {
        label.text = "Hard"
        startTimer(time: eggTimes["Hard"]!)
    }

    private func startTimer(time: Int) {
        totalTime = time
        secondsPassed = 0
        progressBar.progress = 0.0
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(updateTimer),
            userInfo: nil,
            repeats: true
        )
    }

    private func playSound() {
        let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
    }

    @objc
    private func updateTimer() {
        if secondsPassed < totalTime {
            secondsPassed += 1
            let percentageProgress = Float(secondsPassed) / Float(totalTime)
            progressBar.progress = (percentageProgress)
        
        } else {
            label.text = "Done!"
            playSound()
        }
    }
}

// MARK: - Setup Constraints

private extension ViewController {
    func addSubviews() {
        view.addSubview(label)
        view.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(buttonEggSoft)
        horizontalStackView.addArrangedSubview(buttonEggMedium)
        horizontalStackView.addArrangedSubview(buttonEggHard)
        view.addSubview(progressBar)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
                label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                
                horizontalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 250),
                horizontalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                horizontalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                horizontalStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
                
                buttonEggSoft.widthAnchor.constraint(equalToConstant: 120),
                buttonEggSoft.heightAnchor.constraint(equalToConstant: 150),
                
                buttonEggMedium.widthAnchor.constraint(equalToConstant: 120),
                buttonEggMedium.heightAnchor.constraint(equalToConstant: 150),
                
                buttonEggHard.widthAnchor.constraint(equalToConstant: 120),
                buttonEggHard.heightAnchor.constraint(equalToConstant: 150),
                
                progressBar.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: 10),
                progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
            ]
        )
    }
}
