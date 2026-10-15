require "test_helper"
require "rake"

class UsersRakeTest < ActiveSupport::TestCase
  setup do
    unless Rake::Task.task_defined?("users:create")
      Rake::Task.define_task(:environment)
      load Rails.root.join("lib/tasks/users.rake")
    end
    @task = Rake::Task["users:create"]
    @task.reenable
  end

  test "creates a user with the given email and role, reading the password from PASSWORD" do
    with_password(fixture_password) do
      assert_output(/Created agent new.agent@example.com/) { @task.invoke("New.Agent@example.com", "agent") }
    end

    user = User.find_by!(email_address: "new.agent@example.com")
    assert user.agent?
    assert user.authenticate(fixture_password)
  end

  test "fails with a clear message for an invalid role" do
    error = assert_aborts { @task.invoke("someone@example.com", "admin") }

    assert_match(/Invalid role "admin"\. Role must be one of: customer, agent/, error)
    assert_not User.exists?(email_address: "someone@example.com")
  end

  test "fails with a clear message when the email is taken" do
    error = assert_aborts { @task.invoke("CUSTOMER@example.com", "customer") }

    assert_match(/already exists/, error)
  end

  test "fails when no password is given and there is no terminal" do
    $stdin.define_singleton_method(:tty?) { false }

    error = assert_aborts { @task.invoke("someone@example.com", "customer") }
    assert_match(/No password given/, error)
  ensure
    $stdin.singleton_class.remove_method(:tty?)
  end

  private
    def with_password(password)
      ENV["PASSWORD"] = password
      yield
    ensure
      ENV.delete("PASSWORD")
    end

    def assert_aborts(&block)
      error = nil
      _out, err = capture_io { error = assert_raises(SystemExit, &block) }
      assert_not error.success?
      err
    end
end
