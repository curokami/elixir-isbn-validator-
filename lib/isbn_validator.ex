defmodule ISBNValidator do
  @moduledoc """
  ISBN validation module with structured case handling.

  ISBN-10 の国コードについて:
  - ISBN-10 の **最初の1桁** が国コード（Group Identifier）を表す。
  - 例:
    - `0` または `1` → 英語圏（アメリカ、イギリス）
    - `4` → **日本**
    - `3` → ドイツ語圏（ドイツ、オーストリア、スイス）
    - `5` → ロシア
    - `7` → 中国

  ISBN-13 の国コードについて:
  - ISBN-13 の **最初の3桁** が国コード（Group Identifier）を表す。
  - 例:
    - `978-0`, `978-1` → 英語圏（アメリカ、イギリス）
    - `978-2` → フランス
    - `978-3` → ドイツ
    - `978-4` → **日本**
    - `978-5` → ロシア
    - `978-7` → 中国
  """

  @spec validate(binary()) :: {:error, binary(), <<_::64, _::_*8>>} | {:ok, binary(), <<_::600>>}
  def validate(isbn) when is_binary(isbn) do
    case String.length(isbn) do
      13 -> validate_isbn13(isbn)
      10 -> validate_isbn10(isbn)
      _ -> {:error, isbn, "ISBNコードのフォーマットが間違っています。"}
    end
  end

  defp validate_isbn13(isbn) do
    if valid_isbn13_format?(isbn) do
      case country_code_13(isbn) do
        "Japan" ->
          if verify_checksum_13(isbn) do
            {:ok, isbn, "フォーマット、国コード、チェックディジットが正しい"}
          else
            {:error, isbn, "チェックディジットが間違っています。"}
          end
        country -> {:error, isbn, "このISBNは日本のものではなく、#{country} に属しています。"}
      end
    else
      {:error, isbn, "ISBNコードのフォーマットが間違っています。"}
    end
  end

  defp validate_isbn10(isbn) do
    if valid_isbn10_format?(isbn) do
      case country_code_10(isbn) do
        "Japan" ->
          if verify_checksum_10(isbn) do
            {:ok, isbn, "フォーマット、国コード、チェックディジットが正しい"}
          else
            {:error, isbn, "チェックディジットが間違っています。"}
          end
        country -> {:error, isbn, "このISBNは日本のものではなく、#{country} に属しています。"}
      end
    else
      {:error, isbn, "ISBNコードのフォーマットが間違っています。"}
    end
  end

  defp valid_isbn13_format?(isbn) do
    String.match?(isbn, ~r/^\d{13}$/)
  end

  defp valid_isbn10_format?(isbn) do
    String.match?(isbn, ~r/^\d{9}[\dX]$/)
  end

  defp country_code_13(isbn) do
    prefix = String.slice(isbn, 0, 4)
    case prefix do
      "9784" -> "Japan"
      "9780" -> "United States / English-speaking countries"
      "9781" -> "United Kingdom"
      "9783" -> "Germany"
      "9785" -> "Russia"
      "9787" -> "China"
      _ -> "Unknown"
    end
  end

  defp country_code_10(isbn) do
    case String.first(isbn) do
      "0" -> "Unknown"  # United States ではなく Unknown に変更
      "1" -> "United Kingdom"
      "3" -> "Germany"
      "4" -> "Japan"
      "5" -> "Russia"
      "7" -> "China"
      _ -> "Unknown"
    end
  end

  defp verify_checksum_13(isbn) do
    digits = isbn |> String.graphemes() |> Enum.map(&String.to_integer/1)

    checksum =
      digits
      |> Enum.take(12)
      |> Enum.with_index()
      |> Enum.reduce(0, fn {digit, index}, acc ->
        if rem(index, 2) == 0, do: acc + digit, else: acc + (digit * 3)
      end)

    expected_check_digit = rem(10 - rem(checksum, 10), 10)
    actual_check_digit = List.last(digits)

    expected_check_digit == actual_check_digit
  end

  defp verify_checksum_10(isbn) do
    digits =
      isbn
      |> String.graphemes()
      |> Enum.map(fn
        "X" -> 10
        digit -> String.to_integer(digit)
      end)

    checksum =
      digits
      |> Enum.take(9)
      |> Enum.with_index(1)
      |> Enum.reduce(0, fn {digit, index}, acc -> acc + digit * index end)

    expected_check_digit = rem(checksum, 11)
    actual_check_digit = List.last(digits)

    expected_check_digit == actual_check_digit
  end
end
