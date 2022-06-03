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
    assert BrainF__k.f__k([1, 2, 3]) == {:ok, {[3, 2, 1], []}, {[], [0]}, 3}
    assert BrainF__k.f__k('hello') == {:ok, {'olleh', []}, {[], [0]}, 5}
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
end
