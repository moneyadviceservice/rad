Feature: Manage FCA Import

# Background
#   RAD, the Retirement Advisor Directory, requires a weekly import of data
#    from the FCA, to update the list of
#   authorized advisors. This data is emailed over to MAS as an encrypted file
#    every week.
#
#   Currently RAD maintenance requires a weekly back-end dev task to refactor
#    the FCA import file to be suitable to import into the tool.
#    This represents a significant time drain on the dev team so the more we can
#    do to automate the process, the better.
#
#   This ticket is to create a process by which a product owner can de-encrypt
#    the file, upload it to Amazon S3, and then commence a process using the
#    RAD Admin to process the data and import.

Background:
  Given that I am logged in as an admin

Scenario: view all available files for import
  Given the file 'Subsidiaries' have been uploaded
    And the file 'Firm' have been uploaded
    And the file 'Advisers' have been uploaded
   When I am on the FCA import page
   Then I should see the file 'Subsidiaries' ready for import
    And I should see the file 'Firm' ready for import
    And I should see the file 'Advisers' ready for import
