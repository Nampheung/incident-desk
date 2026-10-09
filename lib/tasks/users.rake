namespace :users do
  desc "Create a user: bin/rails \"users:create[email,role]\". Password is read from PASSWORD or prompted for."
  task :create, %i[ email role ] => :environment do |_task, args|
    email = args[:email].to_s.strip.downcase
    role = args[:role].to_s

    abort "Usage: bin/rails \"users:create[email,role]\"" if email.blank?
    abort "Invalid role #{role.inspect}. Role must be one of: #{User::ROLES.join(", ")}." unless User::ROLES.include?(role)
    abort "A user with email #{email} already exists." if User.exists?(email_address: email)

    password = ENV["PASSWORD"].presence || begin
      require "io/console"
      abort "No password given. Set PASSWORD or run the task in an interactive terminal." unless $stdin.tty?
      entered = $stdin.getpass("Password: ")
      abort "Passwords do not match." unless entered == $stdin.getpass("Confirm password: ")
      entered
    end

    user = User.new(email_address: email, password: password, role: role)

    if user.save
      puts "Created #{role} #{user.email_address}."
    else
      abort "Could not create user: #{user.errors.full_messages.to_sentence}."
    end
  end
end
