require "test_helper"

class SeedsTest < ActiveSupport::TestCase
  test "creates a demo customer and a demo agent with passwords from the environment" do
    with_demo_env(customer_password: "customer-#{fixture_password}", agent_password: "agent-#{fixture_password}") do
      load_seeds
    end

    customer = User.find_by!(email_address: "demo.customer@example.com")
    agent = User.find_by!(email_address: "demo.agent@example.com")

    assert customer.customer?
    assert customer.authenticate("customer-#{fixture_password}")
    assert agent.agent?
    assert agent.authenticate("agent-#{fixture_password}")
  end

  test "running the seeds twice does not duplicate the demo users" do
    with_demo_env(customer_password: fixture_password, agent_password: fixture_password) do
      load_seeds
      assert_no_difference("User.count") { load_seeds }
    end
  end

  test "skips a demo user whose password is not set" do
    with_demo_env(customer_password: fixture_password, agent_password: nil) do
      assert_output(/Skipping demo agent: set DEMO_AGENT_PASSWORD/) { load_seeds }
    end

    assert User.exists?(email_address: "demo.customer@example.com")
    assert_not User.exists?(email_address: "demo.agent@example.com")
  end

  private
    def with_demo_env(customer_password:, agent_password:)
      env = {
        "DEMO_CUSTOMER_EMAIL" => "demo.customer@example.com",
        "DEMO_AGENT_EMAIL" => "demo.agent@example.com",
        "DEMO_CUSTOMER_PASSWORD" => customer_password,
        "DEMO_AGENT_PASSWORD" => agent_password
      }
      previous = env.keys.index_with { |key| ENV[key] }
      env.each { |key, value| ENV[key] = value }
      yield
    ensure
      previous.each { |key, value| ENV[key] = value }
    end

    def load_seeds
      Rails.application.load_seed
    end
end
