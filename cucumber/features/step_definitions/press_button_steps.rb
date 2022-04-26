require 'selenium-webdriver' #Импорт библиотеки selenium для контроля веб-браузера
driver = Selenium::WebDriver.for :chrome #Открываем браузер хром

Given('I am on the main page') do
  driver.navigate.to 'https://calcus.ru/kalkulyator-ipoteki' #задаём ссылку на страницу, которая должна открываться
  driver.find_element(:name, "cost").send_keys(12000000)
  #Выбор Первоначального взноса (выпадающий список) в %
  dropdown = driver.find_element(:name, 'start_sum_type') #путь к выпадающему списку
  option = Selenium::WebDriver::Support::Select.new(dropdown) #создание опции для выбора элементов списка
  option.select_by(:value,'2') #задание варианта выбора по параметру value
  #Заполнение поля "Первоначальный взнос"
  driver.find_element(:name, "start_sum").send_keys(20)
  #Заполнение поля "Срок кредита"
  driver.find_element(:xpath, "/html/body/div/div[2]/div[1]/form/div[6]/div[2]/div[1]/input").send_keys(20)
  #Генерация рандомного числа от 5 до 12
  rnd = rand(5..12)
  #Добавление рандомного числа в % ставку
  driver.find_element(:xpath, "/html/body/div/div[2]/div[1]/form/div[8]/div[2]/div[1]/input").send_keys(rnd)
  $aut = driver.find_element(:xpath, "//*[@id='payment-type-1']").selected? #проверка нажатия радиобаттон 1
  $deff = driver.find_element(:xpath, "//*[@id='payment-type-2']").selected? #проверка, что радиобаттон 2 не нажата
  #Проверка ежемесячного платежа по формуле
  i = (rnd/100.0)/12.0 #рассчёт процентной ставки в месяц
  numerator = (i*(1+i)**240) #числитель формулы
  denominater = (1+i)**240 -1 #знаменатель формулы
  platezh = 9600000*(numerator/denominater) #формула
  $result = platezh.round(2) #округление до 2-х знаков
end

When('I click the Result button') do
  driver.find_element(css: "body > div > div.columns-container > div.content-column > form > div.calc-frow.button-row > div > input").click
  wait = Selenium::WebDriver::Wait.new(timeout: 10) #задержка на странице, чтобы прогрузились данные "ежемесячный платёж"
  #Ожидание пока число Ежемесячного платежа не появится на странице
  wait.until { driver.find_element(css: 'body > div > div.columns-container > div.content-column > form > div.row.no-gutters.split > div:nth-child(1) > div:nth-child(1) > div.calc-fright > div').displayed?}
  $price = driver.find_element(css: 'body > div > div.columns-container > div.content-column > form > div.row.no-gutters.split > div:nth-child(1) > div:nth-child(1) > div.calc-fright > div').attribute("innerHTML").gsub(/\s+/, "").gsub(/,+/, ".")
end

Then('Monthly payment calculates') do

  expect($price.to_f.round(2)).to eq($result)
  expect($aut).to eq(true)
  expect($deff).to eq(false)
  sleep(4) #Задержка положения на экране на 4 сек.
end