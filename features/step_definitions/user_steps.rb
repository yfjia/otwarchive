Given /^I have no users$/ do
  User.delete_all
end

Given /the following activated users? exists?/ do |table|
  table.hashes.each do |hash|
    user = Factory.create(:user, hash)
    user.activate
  end
end

Given /the following activated tag wranglers? exists?/ do |table|
  table.hashes.each do |hash|
    user = Factory.create(:user, hash)
    user.activate
    user.tag_wrangler = '1'
  end
end

Given /^I am logged in as "([^\"]*)" with password "([^\"]*)"$/ do |login, password|
  user = User.find_by_login(login)
  if user.blank?
    user = Factory.create(:user, {:login => login, :password => password})
    user.activate
  end
  visit login_path
  fill_in "User name", :with => login
  fill_in "Password", :with => password
  check "Remember me"
  click_button "Log in"
  Then "I should see \"Successfully logged in\""
end

Given /^I am logged in as a random user$/ do
  name = "testuser#{User.count + 1}"
  user = Factory.create(:user, :login => name, :password => "password")
  user.activate
  visit login_path
  fill_in "User name", :with => name
  fill_in "Password", :with => "password"
  check "Remember me"
  click_button "Log in"
  Then "I should see \"Successfully logged in\""
end

Given /^I am logged out$/ do
  visit logout_path
  Then "I should see \"Successfully logged out\""
end

When /^"([^\"]*)" creates the pseud "([^\"]*)"$/ do |username, newpseud|
  visit user_pseuds_path(username)
  click_link("New Pseud")
  fill_in "Name", :with => newpseud
  click_button "Create"
end

When /^"([^\"]*)" creates the default pseud "([^\"]*)"$/ do |username, newpseud|
  visit user_pseuds_path(username)
  click_link("New Pseud")
  fill_in "Name", :with => newpseud
  # TODO: this isn't currently working
  check "Is default"
  click_button "Create"
end
