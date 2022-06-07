defmodule BrainF__kTest do
  use ExUnit.Case
  doctest BrainF__k

  import ExUnit.CaptureIO

  test "fetches head" do
    assert BrainF__k.fetch({[], [:a, :b]}) == :a

    assert_raise FunctionClauseError, fn ->
      BrainF__k.fetch({[], []})
    end
  end

  test "stores head" do
    assert BrainF__k.store({[], [0]}, 1) == {[], [1]}
  end

  test "forwards infinitely" do
    assert BrainF__k.forward_inf({[], [0]}, 0) == {[0], [0]}
  end

  test "skips" do
    assert BrainF__k.f__k([1, 2, 3]) == {:ok, {[3, 2, 1], []}, {[], [0]}, 0}
    assert BrainF__k.f__k('hello') == {:ok, {'olleh', []}, {[], [0]}, 0}
  end

  test "hello world" do
    assert capture_io(fn ->
             BrainF__k.f__k(to_charlist(hello_world()))
           end) == "Hello World!"
  end

  def hello_world do
    """
    +++++ +++++             initialize counter (cell #0) to 10
    [                       use loop to set the next four cells to 70/100/30/10
    > +++++ ++              add  7 to cell #1
    > +++++ +++++           add 10 to cell #2
    > +++                   add  3 to cell #3
    > +                     add  1 to cell #4
    <<<< -                  decrement counter (cell #0)
    ]
    > ++ .                  print 'H'
    > + .                   print 'e'
    +++++ ++ .              print 'l'
    .                       print 'l'
    +++ .                   print 'o'
    > ++ .                  print ' '
    << +++++ +++++ +++++ .  print 'W'
    > .                     print 'o'
    +++ .                   print 'r'
    ----- - .               print 'l'
    ----- --- .             print 'd'
    > + .                   print '!'
    """
  end

  test "input" do
    assert capture_io(
             <<"a", "b", "c">>,
             fn ->
               ',>,>,.<.<.'
               |> BrainF__k.f__k()
             end
           ) == "cba"
  end

  test "error" do
    {:error, _, _, _} = BrainF__k.f__k('+[]')
  end

  def abcxyz do
    """
    ,+. This program will 6 characters
    ,+. For first 3 characters it will
    ,+. print its successor
    ,-. For last 3 characters it will
    ,-. print its predicissor
    ,-.
    """
  end

  test "abcxyz" do
    assert capture_io(
             "abcxyz",
             fn ->
               abcxyz()
               |> to_charlist()
               |> BrainF__k.f__k()
             end
           ) == "bcdwxy"
  end

  test "British empire" do
    assert capture_io(
             "Conqueror of British Empire (CWE). All hail Idi Amin!!!",
             fn ->
               {:ok, _, _, 100_000} =
                 british_empire()
                 |> to_charlist()
                 |> BrainF__k.f__k()
             end
           ) == "Co"
  end

  def british_empire do
    """
    This will contain excatly 10^5 operations
    +++++
    [>
        ++++++++
        [>
            ++++++++++
            [
                >
                ++++++++++++
                >
                ++++++++++++
                >
                ++++++++++++
                >
                +++++++++++
                >
                +++++++++++
                <<<<<
                -
            ]
            >
            [
                -
            ]
            >
            [
                -
            ]
            >
            [
                -
            ]
            >
            [
                -
            ]
            >
            [
                -
            ]
            <<<<<
            <-
        ]
        <-
    ]

    ++++++++++++++
    [
        >
        +++++++++++++++
        <-
    ]
    >
    [
        -
    ]
    <
    ,.,.
    """
  end

  test "input 11" do
    assert capture_io(
      "abcdeghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
      fn ->
        {:error, _, _, 100_001} =
          input11()
          |> to_charlist()
          |> BrainF__k.f__k()
      end
    ) == "nopqrtuvwxyzabcdefghijklmN"
  end

  def input11 do
    """
    ROT13 as mentioned in wiki brainfuck page (a little modified)
    -,[+                         Read first character and start outer character reading loop
        -[                       Skip forward if character is 0
            >>++++[>++++++++<-]  Set up divisor (32) for division loop
                                  (MEMORY LAYOUT: dividend copy remainder divisor quotient zero zero)
            <+<-[                Set up dividend (x minus 1) and enter division loop
                >+>+>-[>>>]      Increase copy and remainder / reduce divisor / Normal case: skip forward
                <[[>+<-]>>+>]    Special case: move remainder back to divisor and increase quotient
                <<<<<-           Decrement dividend
            ]                    End division loop
        ]>>>[-]+                 End skip loop; zero former divisor and reuse space for a flag
        >--[-[<->+++[-]]]<[         Zero that flag unless quotient was 2 or 3; zero quotient; check flag
            ++++++++++++<[       If flag then set up divisor (13) for second division loop
                                  (MEMORY LAYOUT: zero copy dividend divisor remainder quotient zero zero)
                >-[>+>>]         Reduce divisor; Normal case: increase remainder
                >[+[<+>-]>+>>]   Special case: increase remainder / move it back to divisor / increase quotient
                <<<<<-           Decrease dividend
            ]                    End division loop
            >>[<+>-]             Add remainder back to divisor to get a useful 13
            >[                   Skip forward if quotient was 0
                -[               Decrement quotient and skip forward if quotient was 1
                    -<<[-]>>     Zero quotient and divisor if quotient was 2
                ]<<[<<->>-]>>    Zero divisor and subtract 13 from copy if quotient was 1
            ]<<[<<+>>-]          Zero divisor and add 13 to copy if quotient was 0
        ]                        End outer skip loop (jump to here if ((character minus 1)/32) was not 2 or 3)
        <[-]                     Clear remainder from first division if second division was skipped
        <.[-]                    Output ROT13ed character from copy and clear it
        <-,                     Read next character
    ]                            End character reading loop
    """
  end

  test "input 13" do
    assert capture_io(
             "Conqueror of British Empire (CWE). All hail Idi Amin!!!",
             fn ->
               {:error, _, _, 100_001} =
                 input13()
                 |> to_charlist()
                 |> BrainF__k.f__k()
             end
           ) == "Cp"
  end

  def input13 do
    """
    This will contain excatly 100001 operations
    Should result into proess kill
    +++++
    [>
        ++++++++
        [>
            ++++++++++
            [
                >
                ++++++++++++
                >
                ++++++++++++
                >
                ++++++++++++
                >
                +++++++++++
                >
                +++++++++++
                <<<<<
                -
            ]
            >
            [
                -
            ]
            >
            [
                -
            ]
            >
            [
                -
            ]
            >
            [
                -
            ]
            >
            [
                -
            ]
            <<<<<
            <-
        ]
        <-
    ]

    ++++++++++++++
    [
        >
        +++++++++++++++
        <-
    ]
    >
    [
        -
    ]
    <
    ,.,+.
    """
  end
end
