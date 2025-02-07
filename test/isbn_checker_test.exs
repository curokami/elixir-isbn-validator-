defmodule ISBNValidatorTest do
  use ExUnit.Case
  alias ISBNValidator

  describe "validate/1 for ISBN-10" do
    test "valid ISBN-10 (Japan) returns success" do
      assert ISBNValidator.validate("4061495089") == {:ok, "4061495089", "フォーマット、国コード、チェックディジットが正しい"}
    end

    test "invalid ISBN-10 checksum returns error" do
      assert ISBNValidator.validate("4061495080") == {:error, "4061495080", "チェックディジットが間違っています。"}
    end

    test "invalid ISBN-10 format returns error" do
      assert ISBNValidator.validate("406149508") == {:error, "406149508", "ISBNコードのフォーマットが間違っています。"}
    end

    test "ISBN-10 with non-Japan code returns country error" do
      assert ISBNValidator.validate("0306406152") == {:error, "0306406152", "このISBNは日本のものではなく、Unknown に属しています。"}
    end
  end

  describe "validate/1 for ISBN-13" do
    test "valid ISBN-13 (Japan) returns success" do
      assert ISBNValidator.validate("9784061495081") == {:ok, "9784061495081", "フォーマット、国コード、チェックディジットが正しい"}
    end

    test "invalid ISBN-13 checksum returns error" do
      assert ISBNValidator.validate("9784061495080") == {:error, "9784061495080", "チェックディジットが間違っています。"}
    end

    test "invalid ISBN-13 format returns error" do
      assert ISBNValidator.validate("978406149508") == {:error, "978406149508", "ISBNコードのフォーマットが間違っています。"}
    end

    test "ISBN-13 with non-Japan code returns country error" do
      assert ISBNValidator.validate("9780306406157") == {:error, "9780306406157", "このISBNは日本のものではなく、United States / English-speaking countries に属しています。"}
    end
  end
end
