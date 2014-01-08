require 'io/console'

namespace :mmd do
  desc "Create user"
  task :create_user => :environment do
    email = ''
    STDOUT.puts "Email:"
    email = STDIN.gets.chomp
    raise "Email is required" if email.blank?

    password = ''
    STDOUT.puts "Password:"
    password = STDIN.noecho(&:gets).chomp
    raise "Password is required" if password.blank?

    password_confirmation = ''
    STDOUT.puts "Password Confirmation:"
    password_confirmation = STDIN.noecho(&:gets).chomp
    raise "Passwords do not match" if password != password_confirmation

    user = User.new
    user.email = email
    user.password = password
    user.password_confirmation = password_confirmation
    user.skip_confirmation!
    user.save!
    user.confirm!

    puts "User #{user.id} created"
  end
end