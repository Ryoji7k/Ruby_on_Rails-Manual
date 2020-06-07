class Sample < ApplicationRecord
    validates :title, presence: true
    validates :body, presence: true

    # 名前付きスコープ
    scope :sample_where, -> { where(publish: 'sample') }
    scope :sample_order, -> { order(publish: :desc) }
    scope :sample_limit_10, -> { sample_order.limit(10) }
    scope :sample_where_param, -> (pub) {
        where(publish: pub).order(publish: :desc).limit(10)
    }
    ## 使用例
    Sample.sample_where.sample_limit_10
    Sample.sample_where_param('publish')

    # デフォルトのスコープを定義する（デフォルトで降順指定される）
    default_scope { order(updated_at: :desc) }

    # Active Record enumsの定義
    enum status: [:draft, :published, :deleted]
    enum status: { draft:0, published:1, deleted:2 }
end
