require "test_helper"
require "open3"
require "ostruct"
require "fileutils"

# FR-005: prove SQLite-backed feedback survives a real process restart.
# Run locally: bin/rails test test/integration/restart_persistence_test.rb
class RestartPersistenceTest < ActionDispatch::IntegrationTest
  test "created feedback and category change survive a separate Rails process against the same database file" do
    db_dir = Rails.root.join("tmp", "restart_persistence")
    FileUtils.mkdir_p(db_dir)
    db_path = db_dir.join("persistence.sqlite3")
    FileUtils.rm_f(db_path)

    env = {
      "RAILS_ENV" => "test",
      "DATABASE_URL" => "sqlite3://#{db_path}",
      "DISABLE_SPRING" => "1"
    }

    prepare_status = run_rails(env, "db:prepare")
    assert_predicate prepare_status, :success?, "db:prepare failed: #{prepare_status}"

    seed_status = run_rails_runner(
      env,
      <<~RUBY
        feedback = Feedback.create!(title: "Restart seed", description: "Created before restart.")
        feedback.update!(category: "bug")
        puts feedback.id
      RUBY
    )
    assert_predicate seed_status, :success?, "seed runner failed: #{seed_status}"
    feedback_id = seed_status.stdout.strip

    verify_status = run_rails_runner(
      env,
      <<~RUBY
        feedback = Feedback.find(#{feedback_id})
        raise "missing record" unless feedback.title == "Restart seed"
        raise "category not persisted" unless feedback.category == "bug"
        puts "ok"
      RUBY
    )
    assert_predicate verify_status, :success?, "verify runner failed: #{verify_status}"
    assert_equal "ok", verify_status.stdout.strip
  end

  private

  def run_rails(env, task)
    stdout, stderr, status = Open3.capture3(env, "bin/rails", task, chdir: Rails.root.to_s)
    OpenStruct.new(stdout: stdout, stderr: stderr, success?: status.success?)
  end

  def run_rails_runner(env, script)
    stdout, stderr, status = Open3.capture3(env, "bin/rails", "runner", script, chdir: Rails.root.to_s)
    OpenStruct.new(stdout: stdout, stderr: stderr, success?: status.success?)
  end
end
