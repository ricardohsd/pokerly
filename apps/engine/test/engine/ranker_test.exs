defmodule Engine.RankerTest do
  use ExUnit.Case
  doctest Engine.Ranker

  alias Engine.Data.Card

  use Engine.Fixtures, [:hands]

  describe "weights/1" do
    test "calculate proper weight" do
      assert Engine.Ranker.weights(@high_ace) == [
               {3, "♦"},
               {4, "♦"},
               {7, "♣"},
               {8, "♣"},
               {14, "♠"}
             ]

      assert Engine.Ranker.weights(@straight_flush) == [
               {7, "♣"},
               {8, "♣"},
               {9, "♣"},
               {10, "♣"},
               {11, "♣"}
             ]
    end
  end

  describe "categorize/1" do
    test "categorize straight flush" do
      assert Engine.Ranker.categorize(@straight_flush) == {:straight_flush, {11}}
    end

    test "categorize straight flush, lesser rank" do
      assert Engine.Ranker.categorize(@lesser_straight_flush) == {:straight_flush, {5}}
    end

    test "categorize a four of a kind, lesser rank" do
      assert Engine.Ranker.categorize(@lesser_four_of_a_kind) == {:four_of_a_kind, {8, 2}}
    end

    test "categorize a four of a kind, higher rank" do
      assert Engine.Ranker.categorize(@higher_four_of_a_kind) == {:four_of_a_kind, {8, 10}}
    end

    test "categorize a full house, lesser rank" do
      assert Engine.Ranker.categorize(@lesser_full_house) == {:full_house, {6, 2}}
    end

    test "categorize a full house, higher rank" do
      assert Engine.Ranker.categorize(@higher_full_house) == {:full_house, {6, 10}}
    end

    test "categorize a flush" do
      assert Engine.Ranker.categorize(@flush) == {:flush, {11, 9, 8, 4, 3}}
    end

    test "categorize a straight" do
      assert Engine.Ranker.categorize(@straight) == {:straight, {11}}
    end

    test "categorize a low straight" do
      assert Engine.Ranker.categorize(@low_straight) == {:straight, {5}}
    end

    test "categorize a three of a kind, higher rank" do
      assert Engine.Ranker.categorize(@lesser_three_of_a_kind) == {:three_of_a_kind, {4, 3, 2}}
    end

    test "categorize a three of a kind, lesser rank" do
      assert Engine.Ranker.categorize(@higher_three_of_a_kind) == {:three_of_a_kind, {4, 10, 7}}
    end

    test "categorize a three of a kind, in the middle" do
      assert Engine.Ranker.categorize(@three_of_a_kind) == {:three_of_a_kind, {4, 10, 2}}
    end

    test "categorize a two pair, + a higher ranking card" do
      assert Engine.Ranker.categorize(@higher_two_pair) == {:two_pair, {4, 3, 11}}
    end

    test "categorize a two pair, + a lesser ranking card" do
      assert Engine.Ranker.categorize(@lesser_two_pair) == {:two_pair, {8, 7, 2}}
    end

    test "categorize a two pair, + a card ranking in the middle" do
      assert Engine.Ranker.categorize(@two_pair) == {:two_pair, {10, 7, 9}}
    end

    test "categorize an one pair, pair at the bottom" do
      assert Engine.Ranker.categorize(@bottom_one_pair) == {:one_pair, {7, 10, 9, 8}}
    end

    test "categorize an one pair, pair at the top" do
      assert Engine.Ranker.categorize(@top_one_pair) == {:one_pair, {7, 5, 4, 3}}
    end

    test "categorize an one pair, pair at mid bottom" do
      assert Engine.Ranker.categorize(@mid_bottom_one_pair) == {:one_pair, {6, 9, 8, 5}}
    end

    test "categorize an one pair, pair at mid top" do
      assert Engine.Ranker.categorize(@mid_top_one_pair) == {:one_pair, {6, 8, 5, 4}}
    end

    test "categorize a high card" do
      assert Engine.Ranker.categorize(@high_ace) == {:high_card, {14, 8, 7, 4, 3}}
    end
  end

  describe "compare/2" do
    test "three of a kind is higher than high Ace card" do
      assert Engine.Ranker.compare(@three_of_a_kind, @high_ace) == 1
    end

    test "high Ace card is lesser than three of a kind" do
      assert Engine.Ranker.compare(@high_ace, @three_of_a_kind) == -1
    end

    test "high Ace card is lesser than straigh flush" do
      assert Engine.Ranker.compare(@high_ace, @straight_flush) == -1
    end

    test "straigh flush is higher than high card" do
      assert Engine.Ranker.compare(@straight_flush, @high_ace) == 1
    end

    test "high Queen card is lesser than high Aces card" do
      assert Engine.Ranker.compare(@high_card, @high_ace) == -1
    end

    test "straight is higher than lesser straight" do
      assert Engine.Ranker.compare(@straight, @low_straight) == 1
    end

    test "two high Aces card are equals" do
      assert Engine.Ranker.compare(@high_card, @high_card) == 0
    end
  end

  describe "rank/1" do
    test "high hand straight flush" do
      hands = [
        @high_ace,
        @straight_flush,
        @lesser_straight_flush
      ]

      assert Engine.Ranker.rank(hands) == [@straight_flush]
    end

    test "high hand pair with high card" do
      hands = [
        @top_one_pair,
        @mid_bottom_one_pair,
        @mid_top_one_pair,
        @bottom_one_pair
      ]

      assert Engine.Ranker.rank(hands) == [@bottom_one_pair]
    end

    test "equal high hands" do
      first_hand = [
        %Card{color: "♦", rank: "7"},
        %Card{color: "♣", rank: "7"},
        %Card{color: "♠", rank: "10"},
        %Card{color: "♣", rank: "8"},
        %Card{color: "♠", rank: "9"}
      ]

      second_hand = [
        %Card{color: "♠", rank: "7"},
        %Card{color: "♥", rank: "7"},
        %Card{color: "♥", rank: "10"},
        %Card{color: "♠", rank: "8"},
        %Card{color: "♣", rank: "9"}
      ]

      third_hand = [
        %Card{color: "♣", rank: "6"},
        %Card{color: "♦", rank: "6"},
        %Card{color: "♠", rank: "8"},
        %Card{color: "♣", rank: "9"},
        %Card{color: "♦", rank: "5"}
      ]

      hands = [first_hand, second_hand, third_hand]
      assert Engine.Ranker.rank(hands) == [first_hand, second_hand]
    end
  end
end
