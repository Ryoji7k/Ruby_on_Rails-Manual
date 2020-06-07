class SampleController < ApplicationController
    def index
        Sample.find([2, 5, 10])
        Sample.find_by(column: 'sample', column_2: 'sample')
        # プレイスホルダーによる条件式の生成
        Sample.where('publish = ? AND price >= ?', params[:publish], params[:price]).order(publish: :desc)
        Sample.where('publish = :publish AND price >= :price', publish: params[:publish], price: params[:price])
        # 否定の条件式
        Sample.where.not(sample: params[:id])
        # 条件式を論理和で結合する
        Sample.where(publish: 'sample').or(Sample.where('price > 200'))
        # 重複のないレコードを取得する
        Sample.select(:publish).distinct.order(:publish)

        # 特定範囲のレコードだけを取得する(5件目から最大3件を取得する)
        Sample.order(publish: :desc).limit(3).offset(4)
        ## 簡易的なページネーション
        page_size = 3 # 表示件数
        page_num = params[:id == nil] ? 0: params[:id].to_i - 1 # 現在のページ数
        @sample = Sample.order(publish: desc).limit(page_size).offset(page_size * page_num) 

        # 先頭/末尾のレコードを取得する
        Sample.order(publish: :desc).first
        Sample.order(publish: :desc).last

        # データ集計（例）出版社ごとの平均価格を求める
        Sample.select('publish, AVG(price) AS avg_price').group(:publish)

        # 集計結果をもとにデータを絞りこむ（例）平均価格が2500円以上の出版社を絞り込む
        Sample.select('publish, AVG(price) AS avg_price').group(:publish).having('AVG(price) >= ?', 2500)
        
        # 指定列を配列化
        Sample.where(publish: 'sample').pluck(:title, :price)
        # [
        #     ['sample_title', 200]
        # ]

        # データの存在を確認する
        Sample.where(publish: 'sample').exists?

        # 検索結果の行数を取得する
        Sample.where(publish: 'sample').count

        # 特定条件に合致するレコードの平均や最大/最小を求める
        Sample.where(publish: 'sample').average(:price)
        Sample.group(:publish).average(:price)

        # 生のSQLを直接指定する
        Sample.find_by_sql(['SELECT publish, AVG(price) AS avg_price FROM "samples" GRPUP BY publish HAVING AVG(price) >= ?', 2500])
    end

    def update
        # 複数のレコードをまとめて更新する
        Sample.where(publish: 'sample').update_all(publish: 'サンプル')
        ## 文字列（式）で指定する場合
        Sample.order(:publish).limit(5).update_all('price = price * 0.8')
    end

    def destory
        # SELECT -> DELETEの順で削除
        Sample.destory(params[:id])
        # DELETEで削除
        Sample.delete(params[:id])
        # 複数のレコードをまとめて削除（条件式はwhereメソッドで分離）
        Sample.where.not(publish: 'sample').destory_all
        Sample.where.not(publish: 'sample').delete_all
    end

    def transact
        Sample.trasaction do
            s1 = Sample.new(samaple_params)
            s1.save!
        end
        render plain: '成功'
    rescue => e
        render plain: e.messege
    end
end
