import UIKit

// MARK: - LinkBookColorView

class LinkBookColorView: UIView, UICollectionViewDelegateFlowLayout {
  private lazy var bgLabel = {
    let label = UILabel()
    label.text = "배경 컬러"
    label.font = .subTitleSemiBold
    return label
  }()

  private var backgroundColorGrid: UICollectionView!

  private lazy var titleLabel = {
    let label = UILabel()
    label.text = "제목 색상"
    label.font = .subTitleSemiBold
    return label
  }()

  private var titleColorGrid: UICollectionView!

  override init(frame: CGRect) {
    super.init(frame: frame)
    setView()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setView() {
    backgroundColor = .staticWhite

    let bgLayout = UICollectionViewFlowLayout()
    bgLayout.itemSize = CGSize(width: 50, height: 50)
    bgLayout.minimumInteritemSpacing = 8
    bgLayout.minimumLineSpacing = 8

    backgroundColorGrid = UICollectionView(frame: bounds, collectionViewLayout: bgLayout)
    backgroundColorGrid.backgroundColor = .clear
    backgroundColorGrid.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "BgCell")
    backgroundColorGrid.dataSource = self
    backgroundColorGrid.delegate = self

    let titleLayout = UICollectionViewFlowLayout()
    titleLayout.itemSize = CGSize(width: 50, height: 50)
    titleLayout.minimumInteritemSpacing = 8
    titleLayout.minimumLineSpacing = 8

    titleColorGrid = UICollectionView(frame: bounds, collectionViewLayout: titleLayout)
    titleColorGrid.backgroundColor = .clear
    titleColorGrid.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "TitleCell")
    titleColorGrid.dataSource = self
    titleColorGrid.delegate = self

    addSubview(bgLabel)
    bgLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(20)
      make.top.equalToSuperview().offset(16)
    }

    addSubview(backgroundColorGrid)
    backgroundColorGrid.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
      make.top.equalTo(bgLabel.snp.bottom).offset(12)
      make.height.equalTo(108)
    }

    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(20)
      make.top.equalTo(backgroundColorGrid.snp.bottom).offset(24)
    }

    addSubview(titleColorGrid)
    titleColorGrid.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
      make.top.equalTo(titleLabel.snp.bottom).offset(12)
      make.height.equalTo(108)
    }
  }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource

extension LinkBookColorView: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch collectionView {
    case backgroundColorGrid:
      return 12
    case titleColorGrid:
      return 2
    default:
      return 0
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch collectionView {
    case backgroundColorGrid:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BgCell", for: indexPath)
      cell.backgroundColor = .systemPink
      cell.layer.cornerRadius = 5
      return cell
    case titleColorGrid:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCell", for: indexPath)
      cell.backgroundColor = .systemBlue
      cell.layer.cornerRadius = 5
      return cell
    default:
      return collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
    }
  }
}
