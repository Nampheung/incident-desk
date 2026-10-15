# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Demo users. Passwords come from environment variables and are never stored in code.
# A demo user is skipped when its password variable is not set.
{
  "customer" => { email: ENV.fetch("DEMO_CUSTOMER_EMAIL", "customer@example.com"), password_var: "DEMO_CUSTOMER_PASSWORD" },
  "agent" => { email: ENV.fetch("DEMO_AGENT_EMAIL", "agent@example.com"), password_var: "DEMO_AGENT_PASSWORD" }
}.each do |role, demo|
  password = ENV[demo[:password_var]]

  if password.blank?
    puts "Skipping demo #{role}: set #{demo[:password_var]} to create it."
    next
  end

  User.find_or_create_by!(email_address: demo[:email]) do |user|
    user.password = password
    user.role = role
  end
end
