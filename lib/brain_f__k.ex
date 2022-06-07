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
  @spec forward(tape(), any, any, number) :: tape()
  def forward(t0, h, nest, skip \\ 0) do
    t = forward(t0)

    case fetch(t) do
      ^h ->
        case skip do
          0 -> t
          _ -> forward(t, h, nest, skip - 1)
        end

      ^nest ->
        forward(t, h, nest, skip + 1)

      _ ->
        forward(t, h, nest, skip)
    end
  end

  @spec reverse(tape(), any, any, number) :: tape()
  def reverse(t0, h, nest, skip \\ 0) do
    t = reverse(t0)

    case fetch(t) do
      ^h ->
        case skip do
          0 -> t
          _ -> reverse(t, h, nest, skip - 1)
        end

      ^nest ->
        reverse(t, h, nest, skip + 1)

      _ ->
        reverse(t, h, nest, skip)
    end
  end

  @max_ops 100_000

  @doc """
  Runs `code` of type `t:list/0` of code points using the Brain F**k virtual machine.
  """
  def f__k(code), do: f__k({[], code}, {[], [0]}, 0)

  def f__k({code, []}, data, ops), do: {:ok, {code, []}, data, ops}

  def f__k(code, data, ops) when ops > @max_ops, do: {:error, code, data, ops}

  def f__k(code, data, ops) do
    {code, data, ops} = f__k_(fetch(code), code, data, ops)
    f__k(code, data, ops)
  end

  defp f__k_(?<, code, data, ops), do: {forward(code), reverse(data), ops + 1}
  defp f__k_(?>, code, data, ops), do: {forward(code), forward_inf(data, 0), ops + 1}

  defp f__k_(?[, code, data, ops) do
    {case fetch(data) do
       0 -> forward(code, ?], ?[)
       _ -> forward(code)
     end, data, ops + 1}
  end

  defp f__k_(?], code, data, ops) do
    {case fetch(data) do
       0 -> forward(code)
       _ -> reverse(code, ?[, ?])
     end, data, ops + 1}
  end

  defp f__k_(?+, code, data, ops) do
    {forward(code),
     store(
       data,
       case fetch(data) do
         255 -> 0
         xx -> xx + 1
       end
     ), ops + 1}
  end

  defp f__k_(?-, code, data, ops) do
    {forward(code),
     store(
       data,
       case fetch(data) do
         0 -> 255
         xx -> xx - 1
       end
     ), ops + 1}
  end

  defp f__k_(?., code, data, ops) do
    :ok =
      [fetch(data)]
      |> to_string()
      |> IO.write()

    {forward(code), data, ops + 1}
  end

  defp f__k_(?,, code, data, ops) do
    [xx] =
      IO.read(1)
      |> to_charlist()

    {forward(code), store(data, xx), ops + 1}
  end

  defp f__k_(_, code, data, ops), do: {forward(code), data, ops}
end
