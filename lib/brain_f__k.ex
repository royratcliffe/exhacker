defmodule BrainF__k do
  @type tape :: {list(), list()}

  @spec fetch(tape()) :: any
  def fetch({_, [h | _]}), do: h

  @spec store(tape(), any) :: tape()
  def store({t0, [_ | t]}, h), do: {t0, [h | t]}

  @spec forward(tape()) :: tape()
  def forward({t0, [h | t]}), do: {[h | t0], t}

  @spec reverse(tape()) :: tape()
  def reverse({[h | t0], t}), do: {t0, [h | t]}

  @doc """
  Forwards by one, extending the tape as necessary with a given default.
  """
  @spec forward_inf(tape(), any) :: tape()
  def forward_inf({t, [h0]}, h), do: {[h0 | t], [h]}
  def forward_inf(t, _), do: forward(t)

  @doc """
  Fast-forwards the tape until matching fetch.
  Fails with error if no match.
  """
  @spec forward(tape(), any) :: tape()
  def forward(t0, h) do
    t = forward(t0)

    case fetch(t) do
      ^h -> t
      _ -> forward(t, h)
    end
  end

  @spec reverse(tape(), any) :: tape()
  def reverse(t0, h) do
    t = reverse(t0)

    case fetch(t) do
      ^h -> t
      _ -> reverse(t, h)
    end
  end

  def f__k(i), do: f__k({[], i}, {[], [0]}, 0)

  def f__k({code, []}, data, ops), do: {:ok, {code, []}, data, ops}

  def f__k(i, d, x) do
    {i, d} = f__k_(fetch(i), i, d)
    x = x + 1
    if x == 1_000_000, do: {:error, i, d, x}, else: f__k(i, d, x)
  end

  defp f__k_(?<, i, d), do: {forward(i), reverse(d)}
  defp f__k_(?>, i, d), do: {forward(i), forward_inf(d, 0)}

  defp f__k_(?[, i, d) do
    {case fetch(d) do
       0 -> forward(i, ?])
       _ -> forward(i)
     end, d}
  end

  defp f__k_(?], i, d) do
    {case fetch(d) do
       0 -> forward(i)
       _ -> reverse(i, ?[)
     end, d}
  end

  defp f__k_(?+, i, d) do
    {forward(i),
     store(
       d,
       case fetch(d) do
         255 -> 0
         x -> x + 1
       end
     )}
  end

  defp f__k_(?-, i, d) do
    {forward(i),
     store(
       d,
       case fetch(d) do
         0 -> 255
         x -> x - 1
       end
     )}
  end

  defp f__k_(?., i, d) do
    :ok = IO.write(to_string([fetch(d)]))
    {forward(i), d}
  end

  defp f__k_(?,, i, d) do
    [xx] =
      IO.read(1)
      |> to_charlist()

    {forward(i), store(d, xx)}
  end

  defp f__k_(_, i, d), do: {forward(i), d}
end
