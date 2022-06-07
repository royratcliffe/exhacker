defmodule ExHacker do
  def mat_dim([]), do: {0, 0}
  def mat_dim([v0 | v]), do: mat_dim(v, length(v0), 1)

  @doc """
  Dimensions of M-by-N matrix.

  Matrix is a two-dimensional list of lists of elements. Fails with
  `FunctionClauseError` when the lengths of the minor lists mismatch.
  """
  def mat_dim([], m, n), do: {m, n}
  def mat_dim([h | t], m, n) when length(h) == m, do: mat_dim(t, m, n + 1)
end
