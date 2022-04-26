require 'selenium-webdriver' #Импорт библиотеки selenium для контроля веб-браузера
driver = Selenium::WebDriver.for :chrome #Открываем браузер хром

Given('I am not on the page') do
  driver.navigate.to 'https://calcus.ru/kalkulyator-ipoteki' #задаём ссылку на страницу, которая должна открываться
end

When('I am on the page') do
  $first = driver.find_element(:css, 'body > div > h1').displayed?
  $second = driver.find_element(:link, "По стоимости недвижимости").displayed?
  $third = driver.find_element(:link, "По сумме кредита").displayed?
  $fourth = driver.find_element(:xpath, "/html/body/div/div[2]/div[1]/form/div[2]/div[1]").displayed?
  $fifth = driver.find_element(:xpath, "/html/body/div/div[2]/div[1]/form/div[3]/div[1]").displayed?
  $sixth = driver.find_element(:xpath, "/html/body/div/div[2]/div[1]/form/div[4]/div[1]").displayed?
  $seventh = driver.find_element(:xpath, "/html/body/div/div[2]/div[1]/form/div[6]/div[1]").displayed?
  $eighth = driver.find_element(:xpath, "/html/body/div/div[2]/div[1]/form/div[8]/div[1]").displayed?
  $ninth = driver.find_element(:xpath, "/html/body/div/div[2]/div[1]/form/div[9]/div[1]").displayed?
end

Then('I check if the elements are on the page') do
  expect($first).to eq(true)
  expect($second).to eq(true)
  expect($third).to eq(true)
  expect($fourth).to eq(true)
  expect($fifth).to eq(true)
  expect($sixth).to eq(true)
  expect($seventh).to eq(true)
  expect($eighth).to eq(true)
  expect($ninth).to eq(true)
  driver.quit
end