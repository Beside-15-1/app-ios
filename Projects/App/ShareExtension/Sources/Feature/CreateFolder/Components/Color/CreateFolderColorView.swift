import UIKit

import SnapKit
import Then

protocol CreateFolderColorViewDelegate: AnyObject {
  func backgroundColorDidTap(at row: Int)
  func titleColorDidTap(at row: Int)
}

// MARK: - CreateFolderColorView

class CreateFolderColorView: UIView, UICollectionViewDelegateFlowLayout {

  // MARK: UI

  private let scrollView = UIScrollView().then {
    $0.showsVerticalScrollIndicator = false
    $0.showsHorizontalScrollIndicator = false
  }

  private lazy var bgLabel = {
    let label = UILabel()
    label.text = "배경"
    label.font = .subTitleSemiBold
    return label
  }()

  private var backgroundColorGrid: UICollectionView!

  private lazy var titleLabel = {
    let label = UILabel()
    label.text = "제목"
    label.font = .subTitleSemiBold
    return label
  }()

  private var titleColorGrid: UICollectionView!


  // MARK: Properties

  weak var delegate: CreateFolderColorViewDelegate?

  private var backgroundColors: [String] = []
  private var titleColors: [String] = []

  // MARK: Life Cycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .staticWhite

    setCollection()
    setView()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Configuring

  func configureBackground(colors: [String], selectedColor: String) {
    self.backgroundColors = colors
    backgroundColorGrid.reloadData()

    if let row = colors.firstIndex(of: selectedColor) {
      backgroundColorGrid.selectItem(
        at: IndexPath(item: row, section: 0),
        animated: true,
        scrollPosition: .centeredHorizontally
      )
    }
  }

  func configureTitleColor(colors: [String], selectedColor: String) {
    self.titleColors = colors
    titleColorGrid.reloadData()

    if let row = colors.firstIndex(of: selectedColor) {
      titleColorGrid.selectItem(
        at: IndexPath(item: row, section: 0),
        animated: true,
        scrollPosition: .centeredHorizontally
      )
    }
  }

  private func setCollection() {
    let bgLayout = UICollectionViewFlowLayout()
    bgLayout.itemSize = CGSize(width: 50, height: 50)
    bgLayout.minimumInteritemSpacing = 8
    bgLayout.minimumLineSpacing = 8

    backgroundColorGrid = UICollectionView(frame: bounds, collectionViewLayout: bgLayout)
    backgroundColorGrid.backgroundColor = .clear
    backgroundColorGrid.dataSource = self
    backgroundColorGrid.delegate = self
    backgroundColorGrid.register(
      CreateFolderBackgroundColorCell.self,
      forCellWithReuseIdentifier: CreateFolderBackgroundColorCell.identifier
    )

    let titleLayout = UICollectionViewFlowLayout()
    titleLayout.itemSize = CGSize(width: 50, height: 50)
    titleLayout.minimumInteritemSpacing = 8
    titleLayout.minimumLineSpacing = 8

    titleColorGrid = UICollectionView(frame: bounds, collectionViewLayout: titleLayout)
    titleColorGrid.backgroundColor = .clear
    titleColorGrid.dataSource = self
    titleColorGrid.delegate = self
    titleColorGrid.register(
      CreateFolderTitleColorCell.self,
      forCellWithReuseIdentifier: CreateFolderTitleColorCell.identifier
    )
  }

  private func setView() {
    addSubview(scrollView)
    scrollView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.left.right.equalToSuperview().inset(20.0)
    }

    scrollView.addSubview(bgLabel)
    bgLabel.snp.makeConstraints { make in
      make.width.left.right.equalToSuperview()
      make.top.equalToSuperview().offset(16)
    }

    scrollView.addSubview(backgroundColorGrid)
    backgroundColorGrid.snp.makeConstraints { make in
      make.width.left.right.equalToSuperview()
      make.top.equalTo(bgLabel.snp.bottom).offset(12)
      make.height.equalTo(108)
    }

    scrollView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.width.left.right.equalToSuperview()
      make.top.equalTo(backgroundColorGrid.snp.bottom).offset(24)
    }

    scrollView.addSubview(titleColorGrid)
    titleColorGrid.snp.makeConstraints { make in
      make.width.left.right.equalToSuperview()
      make.top.equalTo(titleLabel.snp.bottom).offset(12)
      make.height.equalTo(50)
      make.bottom.equalToSuperview()
    }
  }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource

extension CreateFolderColorView: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch collectionView {
    case backgroundColorGrid:
      return backgroundColors.count
    case titleColorGrid:
      return titleColors.count
    default:
      return 0
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch collectionView {
    case backgroundColorGrid:
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: CreateFolderBackgroundColorCell.identifier, for: indexPath
      ) as? CreateFolderBackgroundColorCell else { return UICollectionViewCell() }

      cell.layer.cornerRadius = 5
      cell.backgroundColor = UIColor(hexString: backgroundColors[indexPath.row])
      return cell
    case titleColorGrid:
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: CreateFolderTitleColorCell.identifier, for: indexPath
      ) as? CreateFolderTitleColorCell else { return UICollectionViewCell() }

      if indexPath.row == 0 {
        cell.layer.borderColor = UIColor.gray300.cgColor
        cell.layer.borderWidth = 1
        cell.checkImage.image = cell.checkImage.image?.withTintColor(.black)
      } else {
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1
      }
      cell.layer.cornerRadius = 5
      cell.backgroundColor = UIColor(hexString: titleColors[indexPath.row])
      return cell
    default:
      return collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
    }
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch collectionView {
    case backgroundColorGrid:
      delegate?.backgroundColorDidTap(at: indexPath.row)

    case titleColorGrid:
      delegate?.titleColorDidTap(at: indexPath.row)

    default:
      break
    }
  }
}
