defmodule SingletonDemo.Application do
  use Application

  def start(_, _) do
    Supervisor.start_link(children(), strategy: :one_for_one, name: SingletonDemo.Supervisor)
  end

  defp children() do
    [
      Supervisor.child_spec({SingletonDemo.PeriodicLogger, :one}, id: :singleton_debugger_one),
      Supervisor.child_spec({SingletonDemo.PeriodicLogger, :two}, id: :singleton_debugger_two),
      Supervisor.child_spec({SingletonDemo.PeriodicLogger, :three}, id: :singleton_debugger_three),
      Supervisor.child_spec({SingletonDemo.PeriodicLogger, :four}, id: :singleton_debugger_four)
    ]
  end
end
