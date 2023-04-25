//
//  MVVMViewController.swift
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

class MVVMViewController: UIViewController {

  let titleLabel = UILabel().then {
    $0.text = "MVVM"
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

  let viewModel = ViewModel()
  let disposeBag = DisposeBag()


  // MARK: Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    defineLayout()

    bind(with: viewModel)
  }


  // MARK: Binding

  private func bind(with viewModel: ViewModel) {

    // MARK: Input

    plusButton.rx.tap
      .subscribe(with: self) { `self`, _ in
        self.viewModel.plus()
      }
      .disposed(by: disposeBag)

    minusButton.rx.tap
      .subscribe(with: self) { `self`, _ in
        self.viewModel.minus()
      }
      .disposed(by: disposeBag)


    // MARK: Output

    viewModel.text
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
