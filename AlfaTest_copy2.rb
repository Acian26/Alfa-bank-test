require 'selenium-webdriver' #Импорт библиотеки selenium для контроля веб-браузера
options = Selenium::WebDriver::Chrome::Options.new(args: ['log-level=3'])#log-level = 3 выводит только фатальные ошибки
#Объявляем driver глобальной переменной, чтобы её было видно а методе
$driver = Selenium::WebDriver.for(:chrome, capabilities: options) #Открываем браузер хром
$driver.navigate.to 'https://calcus.ru/kalkulyator-ipoteki' #задаём ссылку на страницу, которая должна открываться
#$driver.manage.window.maximize #открыть страницу на полный экран

#Метод проверки наличия элементов
def proverit_element_na_str(a1, a2, txt)
  if $driver.find_elements(a1, a2).size() !=0
    puts("#{txt} на месте")
  else
    puts("#{txt} отсутствует")
  end
end

#Вызов метода для каждого эл-та
proverit_element_na_str(:xpath, "/html/body/div/h1", "Заголовок 'Ипотечный калькулятор'")
proverit_element_na_str(:xpath, "/html/body/div/div[2]/div[1]/form/div[1]/div[2]/a[1]", "Ссылка 'По стоимости недвижимости'")
proverit_element_na_str(:xpath, "/html/body/div/div[2]/div[1]/form/div[1]/div[2]/a[2]", "Ссылка 'По сумме кредита'")
proverit_element_na_str(:xpath, "/html/body/div/div[2]/div[1]/form/div[2]/div[1]", "Текст 'Стоимость недвижимости'")
proverit_element_na_str(:xpath, "/html/body/div/div[2]/div[1]/form/div[3]/div[1]", "Текст 'Первоначальный взнос'")
proverit_element_na_str(:xpath, "/html/body/div/div[2]/div[1]/form/div[4]/div[1]", "Текст 'Сумма кредита'")
proverit_element_na_str(:xpath, "/html/body/div/div[2]/div[1]/form/div[6]/div[1]", "Текст 'Срок кредита'")
proverit_element_na_str(:xpath, "/html/body/div/div[2]/div[1]/form/div[8]/div[1]", "Текст 'Процентная ставка'")
proverit_element_na_str(:xpath, "/html/body/div/div[2]/div[1]/form/div[9]/div[1]", "Текст 'Тип ежемесячных платежей'")
puts('------------------------')

#Заполнение поля "Стоимость недвижимости" = 12.000.000
$driver.find_element(:name, "cost").send_keys(12000000)

#Выбор Первоначального взноса (выпадающий список) в %
dropdown = $driver.find_element(:name, 'start_sum_type') #путь к выпадающему списку
option = Selenium::WebDriver::Support::Select.new(dropdown) #создание опции для выбора элементов списка
option.select_by(:value,'2') #задание варианта выбора по параметру value

#Заполнение поля "Первоначальный взнос"
$driver.find_element(:name, "start_sum").send_keys(20)

#Проверка правильно рассчитанного первоначального взноса и отображения его на экране
if $driver.find_element(:xpath, "/html/body/div/div[2]/div[1]/form/div[3]/div[2]/div[3]").text() == '(2 400 000 руб.)' and $driver.find_element(:xpath, "/html/body/div/div[2]/div[1]/form/div[3]/div[2]/div[3]").displayed? == true
  puts('Первоначальный взнос рассчитан и отображен верно')
else
  puts('Первоначальный взнос рассчитан или отображен с ошибкой')
end

#Проверка правильности рассчитанной суммы кредита и его отображения на экране
if $driver.find_element(:xpath, "/html/body/div/div[2]/div[1]/form/div[4]/div[2]/span[1]").text() == '9 600 000' and $driver.find_element(:xpath, "/html/body/div/div[2]/div[1]/form/div[4]/div[2]/span[1]").displayed? == true
  puts('Сумма кредита рассчитана и отображена верно')
else
  puts('Сумма кредита рассчитана или отображена с ошибкой')
end
puts('------------------------')

#Заполнение поля "Срок кредита"
$driver.find_element(:xpath, "/html/body/div/div[2]/div[1]/form/div[6]/div[2]/div[1]/input").send_keys(20)

#Генерация рандомного числа от 5 до 12
rnd = rand(5..12)
puts('Сгенерированное число для процентной ставки: ', rnd)
puts('------------------------')
#Добавление сгенерированного числа в поле "Процентная ставка"
$driver.find_element(:xpath, "/html/body/div/div[2]/div[1]/form/div[8]/div[2]/div[1]/input").send_keys(rnd)

aut = $driver.find_element(:xpath, "//*[@id='payment-type-1']").selected? #проверка нажатия радиобаттон 1
deff = $driver.find_element(:xpath, "//*[@id='payment-type-2']").selected? #проверка, что радиобаттон 2 не нажата
puts('Состояние радиобаттон "Аннуитетные": ', aut)
puts('Состояние радиобаттон "Дифференцированные": ', deff)
puts('------------------------')

#Проверка ежемесячного платежа по формуле
i = (rnd/100.0)/12.0 #рассчёт процентной ставки в месяц
numerator = (i*(1+i)**240) #числитель формулы
denominater = (1+i)**240 -1 #знаменатель формулы
platezh = 9600000*(numerator/denominater) #формула
result = platezh.round(2) #округление до 2-х знаков
puts('Рассчитаная сумма ежемесячного платежа: ', result)

#Нажатие на кнопку "Рассчитать"
$driver.find_element(:xpath, "/html/body/div/div[2]/div[1]/form/div[10]/div/input").click

wait = Selenium::WebDriver::Wait.new(timeout: 10) #задержка на странице, чтобы прогрузились данные "ежемесячный платёж"
#Ожидание пока число Ежемесячного платежа не появится на странице
wait.until { $driver.find_element(css: 'body > div > div.columns-container > div.content-column > form > div.row.no-gutters.split > div:nth-child(1) > div:nth-child(1) > div.calc-fright > div').displayed?}
#Получение числа из Ежемесячного платежа
price1 = $driver.find_element(css: 'body > div > div.columns-container > div.content-column > form > div.row.no-gutters.split > div:nth-child(1) > div:nth-child(1) > div.calc-fright > div').attribute("innerHTML")
price2 = price1.gsub(/\s+/, "").gsub(/\,+/, ".")
puts('Сумма платежа с сайта: ', price2)
puts('------------------------')
puts('Соответствует ли значение с сайта значению, рассчитанному по формуле? ', price2.to_f.round(2)==result)

sleep(10) #Задержка положения на экране на 10 сек.