require 'selenium-webdriver' #Импорт библиотеки selenium для контроля веб-браузера
driver = Selenium::WebDriver.for :chrome #Открываем браузер хром

Given('I m on the page') do
  driver.navigate.to 'https://calcus.ru/kalkulyator-ipoteki' #задаём ссылку на страницу, которая должна открываться
  driver.find_element(:name, "cost").send_keys(12000000)
  dropdown = driver.find_element(:name, 'start_sum_type') #путь к выпадающему списку
  option = Selenium::WebDriver::Support::Select.new(dropdown) #создание опции для выбора элементов списка
  option.select_by(:value,'2') #задание варианта выбора по параметру value
  driver.find_element(:name, "start_sum").send_keys(20)
end

When ('I enter inputs into the text field') do
  $check1 = driver.find_element(:xpath, "/html/body/div/div[2]/div[1]/form/div[3]/div[2]/div[3]").text() == '(2 400 000 руб.)' and driver.find_element(:xpath, "/html/body/div/div[2]/div[1]/form/div[3]/div[2]/div[3]").displayed?
end

Then('Check text on the page') do
  expect($check1).to eq(true)
  driver.quit
end