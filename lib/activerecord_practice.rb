require 'sqlite3'
require 'active_record'
require 'byebug'


ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'customers.sqlite3')
# Show queries in the console.
# Comment this line to turn off seeing the raw SQL queries.
ActiveRecord::Base.logger = Logger.new(STDOUT)

class Customer < ActiveRecord::Base
  def to_s
    "  [#{id}] #{first} #{last}, <#{email}>, #{birthdate.strftime('%Y-%m-%d')}"
  end

  #  NOTE: Every one of these can be solved entirely by ActiveRecord calls.
  #  You should NOT need to call Ruby library functions for sorting, filtering, etc.

  def self.any_candice
    # YOUR CODE HERE to return all customer(s) whose first name is Candice
    # probably something like:  Customer.where(....)
    where(first: 'Candice')
  end

  def self.with_valid_email
    # YOUR CODE HERE to return only customers with valid email addresses (containing '@')
    where("email LIKE ?", "%@%")
  end
  
  # Find customers with .org email addresses
  def self.with_dot_org_email
    where("email LIKE ?", "%.org%")
  end

  # Find customers with invalid but non-blank emails (those that don't contain '@')
  def self.with_invalid_email
    where("email NOT LIKE ? AND email != ''", "%@%")
  end

  # Find customers with blank emails
  def self.with_blank_email
    where(email: [nil, ''])
  end

  # Find customers born before 1 Jan 1980
  def self.born_before_1980
    where("birthdate < ?", Date.new(1980, 1, 1))
  end

  # Find customers with valid email and born before 1 Jan 1980
  def self.with_valid_email_and_born_before_1980
    with_valid_email.merge(born_before_1980)
  end

  # Find customers whose last names start with "B"
  def self.last_names_starting_with_b
    where("last LIKE ?", "B%").order(:birthdate)
  end

  # Return the 20 youngest customers
  def self.twenty_youngest
    order(birthdate: :desc).limit(20)
  end

  # Update the birthdate of a customer named "Gussie Murray" to February 8, 2004.
  def self.update_gussie_murray_birthdate
    gussie = Customer.find_by(first: 'Gussie', last: 'Murray')
    gussie.update(birthdate: Date.new(2004, 2, 8))
  end

  # Update all customers with invalid emails (those not containing '@') to have blank email addresses.
  def self.change_all_invalid_emails_to_blank
    where("email != '' AND email IS NOT NULL AND email NOT LIKE '%@%'").update_all(email: '')
  end

  # Delete the customer named "Meggie Herman" from the database.
  def self.delete_meggie_herman
    where(first: 'Meggie', last: 'Herman').destroy_all
  end

  # Delete all customers born on or before December 31, 1977.
  def self.delete_everyone_born_before_1978
    where('birthdate <= ?', Date.new(1977, 12, 31)).destroy_all
  end
end
