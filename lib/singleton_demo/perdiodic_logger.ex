defmodule SingletonDemo.PeriodicLogger do
  use GenServer
  require Logger

  def start_link(name) do
    Singleton.start_child(__MODULE__, [name], {:periodic_logger, name})
  end

  @impl true
  def init(opts) do
    Logger.info("[PeriodicLogger #{inspect(opts)}] initializing…")
    schedule_work()
    {:ok, opts}
  end

  @impl true
  def handle_info(:work, state) do
    schedule_work()
    {:noreply, work(state)}
  end

  defp work(state) do
    Logger.info("[PeriodicLogger #{inspect(state)}] working…")
    state
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 2000)
  end
end
