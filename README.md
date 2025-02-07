# Elixir ISBN Validator

## 概要
Elixir ISBN Validator は、日本の出版流通に関わる個人や組織向けの **ISBN（国際標準図書番号）検証ツール** です。本モジュールは、ISBN-10 および ISBN-13 のフォーマット、国コード、チェックディジットの正確性を検証し、誤った ISBN の使用を防ぎます。

このモジュールを使用することで、
- 書籍の ISBN が正しいかを瞬時に判定
- ISBN の国別コードを特定
- チェックディジットによるエラー検出

が可能になります。

## 動作環境
本モジュールを使用するには、以下の環境が必要です。

- **OS**: Windows, macOS, Linux
- **Elixir**: 1.12 以上
- **Erlang/OTP**: 24 以上
- **Mix**: Elixir に標準搭載

以下のコマンドで Elixir のバージョンを確認できます：

```sh
elixir -v
```

Elixir や Erlang が未インストールの場合は、[Elixir公式サイト](https://elixir-lang.org/install.html) を参照してください。

## プロジェクトのセットアップ
このモジュールをプロジェクトに組み込むには、以下の手順を実施してください。

### **1. 新しい Elixir プロジェクトを作成**
まず、新規の Mix プロジェクトを作成します。

```sh
mix new my_project
cd my_project
```

これにより、以下のようなファイル・フォルダ構成のプロジェクトが作成されます。

```
my_project/
├── config/
│   ├── config.exs
├── lib/
│   ├── my_project.ex
├── test/
│   ├── test_helper.exs
│   ├── my_project_test.exs
├── mix.exs
├── README.md
```

### **2. 依存関係として追加**
`mix.exs` の `deps` に以下を追加します。

```elixir
defp deps do
  [
    {:isbn_validator, git: "https://github.com/curokami/elixir-isbn-validator.git"}
  ]
end
```

その後、依存関係を取得します。

```sh
mix deps.get
```

### **3. 動作確認**
以下のコマンドを実行し、プロジェクトが正しく動作するか確認します。

```sh
mix compile
mix test
```

また、インタラクティブシェルで `ISBNValidator` を試すこともできます。

```sh
iex -S mix
```

## 使用方法
モジュールを `ISBNValidator` として使用し、ISBN のバリデーションを行います。

### **ISBNが正しい場合の出力**
#### **ISBN-10 の場合**
```elixir
iex> ISBNValidator.validate("4061495089")
{:ok, "4061495089", "フォーマット、国コード、チェックディジットが正しい"}
```

#### **ISBN-13 の場合**
```elixir
iex> ISBNValidator.validate("9784061495081")
{:ok, "9784061495081", "フォーマット、国コード、チェックディジットが正しい"}
```

### **ISBNが誤っている場合の出力**
#### **チェックディジットが間違っている場合**
```elixir
iex> ISBNValidator.validate("4061495080")
{:error, "4061495080", "チェックディジットが間違っています。"}
```

```elixir
iex> ISBNValidator.validate("9784061495080")
{:error, "9784061495080", "チェックディジットが間違っています。"}
```

#### **国コードが日本でない場合**
```elixir
iex> ISBNValidator.validate("9780306406157")
{:error, "9780306406157", "このISBNは日本のものではなく、United States / English-speaking countries に属しています。"}
```

#### **フォーマットが間違っている場合**
```elixir
iex> ISBNValidator.validate("40614950")
{:error, "40614950", "ISBNコードのフォーマットが間違っています。"}
```

```elixir
iex> ISBNValidator.validate("97840614950")
{:error, "97840614950", "ISBNコードのフォーマットが間違っています。"}
```

## ライセンス
本モジュールは **MITライセンス** のもとで公開されています。

MITライセンスは **誰でも自由に利用・改変・配布できる** ライセンスです。
- **商用利用もOK**
- **個人・企業・団体を問わず利用可能**
- **クレジット表記不要（ただし歓迎！）**
- **法的責任は負いません**

安心してご利用ください！

詳細は `LICENSE` ファイルを参照してください。

## 問い合わせ
バグ報告や機能追加のリクエストがありましたら、GitHub の Issues に投稿してください。

GitHub: [https://github.com/curokami/elixir-isbn-validator](https://github.com/curokami/elixir-isbn-validator)

