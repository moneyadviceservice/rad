Given(/^that I am logged in as an admin$/) do
  login_as('admin')
end

Given(/^the file '(.+)' have been uploaded$/) do |file_name|
  upload_to_azure file_name
end

When(/^I am on the FCA import page$/) do
  pending
  # goto_listing_page
end

Then(/^I should see the file '.*' ready for import$/) do |file_name|
  pending
  # expect(list_azure_files).to include(file_name)
end
