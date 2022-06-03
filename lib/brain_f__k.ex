defmodule BrainF__k do
  @moduledoc """
  Implements the foul-mouthed Brain F**k interpreter by HackerRank.
  """

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
  Forwards by one, extending the tape as necessary with a given default. The old
  head becomes the new reverse head ready for a subsequent reverse.
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

  @doc """
  Runs `code` of type `t:list/0` of code points using the Brain F**k virtual machine.
  """
  def f__k(code), do: f__k({[], code}, {[], [0]}, 0)

  def f__k({code, []}, data, ops), do: {:ok, {code, []}, data, ops}

  def f__k(code, data, ops) do
    {code, data} = f__k_(fetch(code), code, data)
    ops = ops + 1
    if ops == 1_000_000, do: {:error, code, data, ops}, else: f__k(code, data, ops)
  end

  defp f__k_(?<, code, data), do: {forward(code), reverse(data)}
  defp f__k_(?>, code, data), do: {forward(code), forward_inf(data, 0)}

  defp f__k_(?[, code, data) do
    {case fetch(data) do
       0 -> forward(code, ?])
       _ -> forward(code)
     end, data}
  end

  defp f__k_(?], code, data) do
    {case fetch(data) do
       0 -> forward(code)
       _ -> reverse(code, ?[)
     end, data}
  end

  defp f__k_(?+, code, data) do
    {forward(code),
     store(
       data,
       case fetch(data) do
         255 -> 0
         xx -> xx + 1
       end
     )}
  end

  defp f__k_(?-, code, data) do
    {forward(code),
     store(
       data,
       case fetch(data) do
         0 -> 255
         xx -> xx - 1
       end
     )}
  end

  defp f__k_(?., code, data) do
    :ok =
      [fetch(data)]
      |> to_string()
      |> IO.write()

    {forward(code), data}
  end

  defp f__k_(?,, code, data) do
    [xx] =
      IO.read(1)
      |> to_charlist()

    {forward(code), store(data, xx)}
  end

  defp f__k_(_, i, d), do: {forward(i), d}
end
