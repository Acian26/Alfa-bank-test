require 'selenium-webdriver' #Импорт библиотеки selenium для контроля веб-браузера
driver = Selenium::WebDriver.for :chrome #Открываем браузер хром

Given('Im on the page') do
  driver.navigate.to 'https://calcus.ru/kalkulyator-ipoteki' #задаём ссылку на страницу, которая должна открываться
end

When('I enter something into the text field') do
  $stoimost = driver.find_element(:name, "cost").send_keys(12000000)
  $stoimost = driver.find_element(:name, "cost").attribute('value').gsub(/\s+/, "").to_f
  $dropdown = driver.find_element(:name, 'start_sum_type') #путь к выпадающему списку
  $option = Selenium::WebDriver::Support::Select.new($dropdown) #создание опции для выбора элементов списка
  $option.select_by(:value,'2') #задание варианта выбора по параметру value
  $dropdown = driver.find_element(:name, 'start_sum_type').attribute('value')
  $vznos = driver.find_element(:name, "start_sum").send_keys(20)
  $vznos = driver.find_element(:name, "start_sum").attribute('value').to_f
  $srok = driver.find_element(:xpath, "/html/body/div/div[2]/div[1]/form/div[6]/div[2]/div[1]/input").send_keys(20)
  $srok = driver.find_element(:xpath, "/html/body/div/div[2]/div[1]/form/div[6]/div[2]/div[1]/input").attribute('value').to_i
end

Then('The text field is populated') do
  expect($stoimost).to eq(12000000)
  expect($dropdown == 2)
  expect($vznos).to eq(20)
  expect($srok).to eq(20)
  driver.quit
end
