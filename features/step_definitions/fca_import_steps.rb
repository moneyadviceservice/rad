Given(/^that I am logged in as an admin$/) do
  login_as(admin)
end

Given(/^the file '(.+)' have been uploaded$/) do |file_name|
  upload file_name
end

When(/^I am on the FCA import page$/) do
  goto_listing_page
end

Then(/^I should see the file '(.+)' ready for import$/) do |file_name|
  expect(page).to have_content "#{file_name} is ready to be imported."
end
