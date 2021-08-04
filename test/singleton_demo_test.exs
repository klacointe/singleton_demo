defmodule SingletonDemoTest do
  use ExUnit.Case
  doctest SingletonDemo

  test "greets the world" do
    assert SingletonDemo.hello() == :world
  end
end
