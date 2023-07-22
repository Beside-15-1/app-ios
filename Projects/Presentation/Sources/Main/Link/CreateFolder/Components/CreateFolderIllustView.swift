import UIKit

// MARK: - CreateFolderIllustView

protocol CreateFolderIllustViewDelegate: AnyObject {
  func illustView(_ illustView: CreateFolderIllustView , didSelectItemAt indexPath: IndexPath)
}

class CreateFolderIllustView: UIView, UICollectionViewDelegateFlowLayout {
  // MARK: UI

  private lazy var titleLabel = {
    let label = UILabel()
    label.text = "일러스트"
    label.font = .subTitleSemiBold
    return label
  }()

  var illustGrid: UICollectionView!

  weak var delegate: CreateFolderIllustViewDelegate?

  // MARK: Life Cycle

  override init(frame: CGRect) {
    super.init(frame: frame)

    setCollection()
    setView()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setCollection() {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 106, height: 106)
    layout.minimumInteritemSpacing = 8
    layout.minimumLineSpacing = 8

    illustGrid = UICollectionView(frame: bounds, collectionViewLayout: layout)
    illustGrid.backgroundColor = .clear
    illustGrid.register(
      CreateFolderIllustCell.self,
      forCellWithReuseIdentifier: CreateFolderIllustCell.identifier
    )
    illustGrid.dataSource = self
    illustGrid.delegate = self
  }

  private func setView() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(20)
      make.top.equalToSuperview().offset(16)
    }

    addSubview(illustGrid)
    illustGrid.snp.makeConstraints { make in
      make.width.equalToSuperview().offset(-40)
      make.centerX.equalToSuperview()
      make.top.equalTo(titleLabel.snp.bottom).offset(12)
      make.bottom.equalToSuperview().offset(-12)
    }
  }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource

extension CreateFolderIllustView: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    12
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: CreateFolderIllustCell.identifier,
      for: indexPath
    ) as? CreateFolderIllustCell else { return UICollectionViewCell() }


    return cell.then {
      $0.configure(number: indexPath.row)
    }
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    delegate?.illustView(self, didSelectItemAt: indexPath)
  }
}
