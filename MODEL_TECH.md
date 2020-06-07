## クエリメソッド

- メソッド集

```
where              [条件でフィルタリング]
not                [否定の条件式を表す]
or                 [OR条件を表す]
order              [並べ替え]
reorder            [ソート式を上書き]
select             [列の指定]
distinct           [重複のないレコードを取得]
limit              [抽出するレコード数を指定]
offset             [抽出を開始する数を指定]
group              [特定のキーで結果をグループ化]
having             [GROUP BYにさらに制約をつける]
joins              [他のテーブルと結合]
left_outer_joins   [他のテーブルと左外部結合]
includes           [関連するモデルをまとめて取得]
readonly           [取得したオブジェクトを読み取り専用に変換]
none               [空の結果セットを取得]
```

## トランザクション

- 分離レベルについて

```
非コミット読み込み ... 見コミット状態のデータを他のトランザクションから読み込んでしまう
反復不能読み込み ... あるトランザクションが複数回にわたって、同一のデータを読み込んだ場合に、他のトランザクションからの変更によって読み込む値が変化してしまう
幻像読み込み ... あるトランザクションが複数回にわたって、同一のデータを読み込んだ場合に、他のトランザクションからの挿入/変更によって初回読み込みでは見えなかったデータが現れたり、存在していたデータが消えてしまう
```

```
:read_uncommitted  [非コミット読み込み、反復不能読み込み、幻像読み込み]
:read_committed    [反復不能読み込み、幻像読み込み]
:repeatable_read   [幻像読み込み]
:serializable
```

```
Sample.transaction(isolation: :repeatable_read) do
    @sample = Sample.find(1)
    @sample.update(price: 3000)
end
```

## オプティミスティック同時実行制御について  

- テーブルにlock_version列を追加  

```
[create_samples.rb]

class Samples < ActiveRecord::Migration[5.0]
    def change
        create_table :samples do |t|
            t.string :name
            t.integer :lock_version, default: 0

            t.timestamps
        end
    end
end
```

- 隠しフィールドとしてフォーム内に追加
- config.active_record.lock_optimistically パラメーターがtrueになっているか確認

## Active Record enums

- フィールドの初期値を設定

```
[create_samples.rb]

class Samples < ActiveRecord::Migration[5.0]
    def change
        create_table :samples do |t|
            t.string :name
            t.integer :status, default 0, null: false
            t.timestamps
        end
    end
end
```

- statusフィールドに列挙体を定義する

```
[sample.rb]

class Sample < ApplicationRecord
    enum status: { draft:0, published:1, deleted:2 }
    #配列表記 enum status: [:draft, :published, :deleted]
end
```

- Active Record enumsを利用してstatusフィールドにアクセス

```
[sample_controller.rb]

def index
    @sample = Sample.find(params[:id])
    @sample.published!
end

[結果： id=1のレコードのstatusが1に更新される]
```

- 列挙値をスコープとして利用する

```
@sample = Sample.pubished

[結果: statusがpublishedのレコードを取得]
```

```
@sample = Sample.published.where('updated_at < ?', 6.months.ago)

[結果: statusがpublishedであるかつ、更新日が6か月前より古い日時のレコードを取得]
```

## 更新系メソッド

```
increment(attr, num)    [指定された列をインクリメント]
decrement(attr, num)    [指定された列をデクリメント]
new_record?             [現在のオブジェクトは未保存か（新規レコード）]
persisted?              [現在のオブジェクトは保存済みか]
toggle(attr)            [指定されたbool型列の値を反転]
touch([name])           [update_at/on列を現在時刻で更新]
changed                 [取得してから変更された列名の配列]
changed?                [取得してから何らかの変更がされたか]
changed_attributes      [変更された列の情報（例名 => 変更目の値）]
changes                 [変更された列の情報（列名 => 変更目の値,変更後の値）]
previous_changes        [保存前の変更情報（列名 => 変更目の値,変更後の値）]
destoryed?              [現在のオブジェクトが削除済か]
lock                    [オブジェクトをロック]
```
