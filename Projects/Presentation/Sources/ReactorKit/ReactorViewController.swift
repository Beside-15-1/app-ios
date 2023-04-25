//
//  ReactorViewController.swift
//  Presentation
//
//  Created by 박천송 on 2023/04/25.
//

import Foundation

import UIKit
import Then
import PinLayout
import FlexLayout
import RxSwift
import RxCocoa
import ReactorKit

class ReactorViewController: UIViewController, StoryboardView {
  typealias Reactor = ReactorKit

  var disposeBag = DisposeBag()

  let titleLabel = UILabel().then {
    $0.text = "ReactorKit"
    $0.font = .systemFont(ofSize: 30)
  }

  let flexContainer = UIView()

  let plusButton = UIButton().then {
    $0.setImage(.init(systemName: "plus"), for: .normal)
  }

  let minusButton = UIButton().then {
    $0.setImage(.init(systemName: "minus"), for: .normal)
  }

  let countLabel = UILabel().then {
    $0.text = "0"
  }


  // MARK: Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    self.reactor = ReactorKit()

    defineLayout()
  }

  func bind(reactor: ReactorKit) {
    plusButton.rx.tap
      .map { Reactor.Action.plusButtonTapped }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    minusButton.rx.tap
      .map { Reactor.Action.minusButtonTapped }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    // ReactorKit은 State객체를 스트림으로 만들어요 그래서
    // 해당값이 바뀌지 않아도 이벤트가 발생해 distinctUntilChanged() 오퍼레이터를 사용해야해요
    reactor.state.map(\.text)
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, text in
        self.countLabel.text = text

        self.countLabel.flex.markDirty()
        self.view.setNeedsLayout()
      }
      .disposed(by: disposeBag)
  }


  // MARK: Layout

  private func defineLayout() {
    view.backgroundColor = .white
    view.addSubview(flexContainer)

    flexContainer.flex
      .alignItems(.center)
      .define { flex in
        flex.addItem(titleLabel)
          .marginTop(20.0)

        flex.addItem()
          .grow(1.0)
          .alignItems(.center)
          .direction(.row)
          .define { flex in
            flex.addItem(minusButton)
              .marginEnd(10.0)

            flex.addItem(countLabel)
              .marginEnd(10.0)

            flex.addItem(plusButton)
          }
      }
  }

  override func viewDidLayoutSubviews() {
    flexContainer.pin.all(view.pin.safeArea)
    flexContainer.flex.layout()
  }
}
