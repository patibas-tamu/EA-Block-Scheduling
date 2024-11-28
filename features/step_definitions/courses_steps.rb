Given('the following courses exist:') do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  table.hashes.each do |row|
    Course.create row
  end
end

Given('I am on the courses page to see courses with an active storage id of {int}') do |id|
  visit "/course_uploads/#{id}"
end

Then('I should see {string} in the table') do |term|
  expect(page).to have_content term
end

Then('I should get an error for invalid course {string}') do |course_id|
  helper = Object.new
  helper.extend(CoursesHelper)
  
  # Mock the flash method
  def helper.flash
    @flash ||= {}
  end  
  # Call the method
  result = helper.validate_courses(course_id)
  
  # Verify expectations
  expect(result).to eq("Courses not found: 0")
  expect(helper.flash[:error]).to eq("Courses not found: 0")
end

Then('I should get {string} for blank prerequisites') do |expected|
  helper = Object.new
  helper.extend(CoursesHelper)
  expect(helper.get_prerequisite_names("")).to eq(expected)
end

Then('the base code for {string} should be {string}') do |sec_name, expected|
  helper = Object.new
  helper.extend(CoursesHelper)
  expect(helper.extract_base_code(sec_name)).to eq(expected)
end

Then('the type for {string} should be {string}') do |sec_name, expected|
  helper = Object.new
  helper.extend(CoursesHelper)
  expect(helper.extract_type(sec_name)).to eq(expected)
end

Then('I should see correct course mappings') do
  helper = Object.new
  helper.extend(CoursesHelper)
  
  # Test corequisites
  expect(helper.corequisites["ENGR-102"]).to eq(%w[MATH-2412 MATH-2413])
  expect(helper.corequisites["ENGR-216"]).to eq(["PHYS-2425"])
  
  # Test prerequisites
  expect(helper.prerequisites["MATH-2413"]).to eq(["MATH-2412"])
  expect(helper.prerequisites["PHYS-2425"]).to eq(["MATH-2413"])
  
  # Test categories
  expect(helper.categories["MATH"]).to eq("Math")
  expect(helper.categories["PHYS"]).to eq("Science")
  expect(helper.categories["ENGR"]).to eq("Engineering")
end

Then('I should get prerequisite list for {string}') do |prereq_string|
  helper = Object.new
  helper.extend(CoursesHelper)
  result = helper.get_prerequisite_names("MATH-2413, PHYS-2425")
  expect(result).to eq("MATH-2413, PHYS-2425")  # Adjust expected result based on your implementation
end

