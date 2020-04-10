defmodule Pokerly.RankerTest do
  use ExUnit.Case
  doctest Pokerly.Ranker

  use Pokerly.Fixtures, [:hands]

  test "calculate proper weight" do
    assert Pokerly.Ranker.weights(@high_ace) == [
             {3, "♦"},
             {4, "♦"},
             {7, "♣"},
             {8, "♣"},
             {14, "♠"}
           ]

    assert Pokerly.Ranker.weights(@straight_flush) == [
             {7, "♣"},
             {8, "♣"},
             {9, "♣"},
             {10, "♣"},
             {11, "♣"}
           ]
  end

  test "categorize straight flush" do
    assert Pokerly.Ranker.categorize(@straight_flush) == {:straight_flush, {11}}
  end

  test "categorize straight flush, lesser rank" do
    assert Pokerly.Ranker.categorize(@lesser_straight_flush) == {:straight_flush, {5}}
  end

  test "categorize a four of a kind, lesser rank" do
    assert Pokerly.Ranker.categorize(@lesser_four_of_a_kind) == {:four_of_a_kind, {8, 2}}
  end

  test "categorize a four of a kind, higher rank" do
    assert Pokerly.Ranker.categorize(@higher_four_of_a_kind) == {:four_of_a_kind, {8, 10}}
  end

  test "categorize a full house, lesser rank" do
    assert Pokerly.Ranker.categorize(@lesser_full_house) == {:full_house, {6, 2}}
  end

  test "categorize a full house, higher rank" do
    assert Pokerly.Ranker.categorize(@higher_full_house) == {:full_house, {6, 10}}
  end

  test "categorize a flush" do
    assert Pokerly.Ranker.categorize(@flush) == {:flush, {11, 9, 8, 4, 3}}
  end

  test "categorize a straight" do
    assert Pokerly.Ranker.categorize(@straight) == {:straight, {11}}
  end

  test "categorize a low straight" do
    assert Pokerly.Ranker.categorize(@low_straight) == {:straight, {5}}
  end

  test "categorize a three of a kind, higher rank" do
    assert Pokerly.Ranker.categorize(@lesser_three_of_a_kind) == {:three_of_a_kind, {4, 3, 2}}
  end

  test "categorize a three of a kind, lesser rank" do
    assert Pokerly.Ranker.categorize(@higher_three_of_a_kind) == {:three_of_a_kind, {4, 10, 7}}
  end

  test "categorize a three of a kind, in the middle" do
    assert Pokerly.Ranker.categorize(@three_of_a_kind) == {:three_of_a_kind, {4, 10, 2}}
  end

  test "categorize a two pair, + a higher ranking card" do
    assert Pokerly.Ranker.categorize(@higher_two_pair) == {:two_pair, {4, 3, 11}}
  end

  test "categorize a two pair, + a lesser ranking card" do
    assert Pokerly.Ranker.categorize(@lesser_two_pair) == {:two_pair, {8, 7, 2}}
  end

  test "categorize a two pair, + a card ranking in the middle" do
    assert Pokerly.Ranker.categorize(@two_pair) == {:two_pair, {10, 7, 9}}
  end

  test "categorize an one pair, pair at the bottom" do
    assert Pokerly.Ranker.categorize(@bottom_one_pair) == {:one_pair, {7, 10, 9, 8}}
  end

  test "categorize an one pair, pair at the top" do
    assert Pokerly.Ranker.categorize(@top_one_pair) == {:one_pair, {7, 5, 4, 3}}
  end

  test "categorize an one pair, pair at mid bottom" do
    assert Pokerly.Ranker.categorize(@mid_bottom_one_pair) == {:one_pair, {6, 9, 8, 5}}
  end

  test "categorize an one pair, pair at mid top" do
    assert Pokerly.Ranker.categorize(@mid_top_one_pair) == {:one_pair, {6, 8, 5, 4}}
  end

  test "categorize a high card" do
    assert Pokerly.Ranker.categorize(@high_ace) == {:high_card, {14, 8, 7, 4, 3}}
  end

  test "three of a kind is higher than high Ace card" do
    assert Pokerly.Ranker.compare(@three_of_a_kind, @high_ace) == 1
  end

  test "high Ace card is lesser than three of a kind" do
    assert Pokerly.Ranker.compare(@high_ace, @three_of_a_kind) == -1
  end

  test "high Ace card is lesser than straigh flush" do
    assert Pokerly.Ranker.compare(@high_ace, @straight_flush) == -1
  end

  test "straigh flush is higher than high card" do
    assert Pokerly.Ranker.compare(@straight_flush, @high_ace) == 1
  end

  test "high Queen card is lesser than high Aces card" do
    assert Pokerly.Ranker.compare(@high_card, @high_ace) == -1
  end

  test "straight is higher than lesser straight" do
    assert Pokerly.Ranker.compare(@straight, @low_straight) == 1
  end

  test "high hand straight flush" do
    hands = [
      @high_ace,
      @straight_flush,
      @lesser_straight_flush
    ]

    assert Pokerly.Ranker.rank(hands) == [@straight_flush]
  end

  test "high hand pair with high card" do
    hands = [
      @top_one_pair,
      @mid_bottom_one_pair,
      @mid_top_one_pair,
      @bottom_one_pair
    ]

    assert Pokerly.Ranker.rank(hands) == [@bottom_one_pair]
  end

  test "equal high hands" do
    hands = [
      [
        %{"color" => "♦", "rank" => "7"},
        %{"color" => "♣", "rank" => "7"},
        %{"color" => "♠", "rank" => "10"},
        %{"color" => "♣", "rank" => "8"},
        %{"color" => "♠", "rank" => "9"}
      ],
      [
        %{"color" => "♠", "rank" => "7"},
        %{"color" => "♥", "rank" => "7"},
        %{"color" => "♥", "rank" => "10"},
        %{"color" => "♠", "rank" => "8"},
        %{"color" => "♣", "rank" => "9"}
      ],
      [
        %{"color" => "♣", "rank" => "6"},
        %{"color" => "♦", "rank" => "6"},
        %{"color" => "♠", "rank" => "8"},
        %{"color" => "♣", "rank" => "9"},
        %{"color" => "♦", "rank" => "5"}
      ]
    ]

    assert Pokerly.Ranker.rank(hands) == [
             [
               %{"color" => "♦", "rank" => "7"},
               %{"color" => "♣", "rank" => "7"},
               %{"color" => "♠", "rank" => "10"},
               %{"color" => "♣", "rank" => "8"},
               %{"color" => "♠", "rank" => "9"}
             ],
             [
               %{"color" => "♠", "rank" => "7"},
               %{"color" => "♥", "rank" => "7"},
               %{"color" => "♥", "rank" => "10"},
               %{"color" => "♠", "rank" => "8"},
               %{"color" => "♣", "rank" => "9"}
             ]
           ]
  end
end
