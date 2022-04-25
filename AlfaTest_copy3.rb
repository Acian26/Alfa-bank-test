require 'selenium-webdriver' #Импорт библиотеки selenium для контроля веб-браузера
options = Selenium::WebDriver::Chrome::Options.new(args: ['log-level=3'])#log-level = 3 выводит только фатальные ошибки
#Объявляем driver глобальной переменной, чтобы её было видно в методе
$driver = Selenium::WebDriver.for(:chrome, capabilities: options) #Открываем браузер хром
$driver.navigate.to 'https://calcus.ru/kalkulyator-ipoteki' #задаём ссылку на страницу, которая должна открываться
#$driver.manage.window.maximize #открыть страницу на полный экран

#Добавим возможность вводить различные значения с клавиатуры

puts('Введите значение Стоимости недвижимости:')
stoimost = gets.chomp
#Проверка чтобы не было пустых значений
while stoimost.empty? do
  puts "Вы ничего не ввели!!!"
  puts('Введите значение Стоимости недвижимости:')
  stoimost = gets.chomp
end

puts('Введите значение Первоначального взноса в %:')
vznos = gets.chomp
#Проверка чтобы не было пустых значений
while vznos.empty? do
  puts "Вы ничего не ввели!!!"
  puts('Введите значение Первоначального взноса в %:')
  vznos = gets.chomp
end

puts('Введите значение Срока кредита (лет):')
srok = gets.chomp
#Проверка чтобы не было пустых значений
while srok.empty? do
  puts "Вы ничего не ввели!!!"
  puts('Введите значение Срока кредита (лет):')
  srok = gets.chomp
end
puts('------------------------')

#Метод проверки наличия элементов
def proverit_element_na_str(a1, a2, txt)
  if $driver.find_elements(a1, a2).size() !=0
    puts("#{txt} на месте")
  else
    puts("#{txt} отсутствует")
  end
end

#Вызов метода для каждого эл-та
proverit_element_na_str(:css, 'body > div > h1', "Заголовок 'Ипотечный калькулятор'")
proverit_element_na_str(:link, "По стоимости недвижимости", "Ссылка 'По стоимости недвижимости'")
proverit_element_na_str(:link, "По сумме кредита", "Ссылка 'По сумме кредита'")
proverit_element_na_str(:xpath, "/html/body/div/div[2]/div[1]/form/div[2]/div[1]", "Текст 'Стоимость недвижимости'")
proverit_element_na_str(:xpath, "/html/body/div/div[2]/div[1]/form/div[3]/div[1]", "Текст 'Первоначальный взнос'")
proverit_element_na_str(:xpath, "/html/body/div/div[2]/div[1]/form/div[4]/div[1]", "Текст 'Сумма кредита'")
proverit_element_na_str(:xpath, "/html/body/div/div[2]/div[1]/form/div[6]/div[1]", "Текст 'Срок кредита'")
proverit_element_na_str(:xpath, "/html/body/div/div[2]/div[1]/form/div[8]/div[1]", "Текст 'Процентная ставка'")
proverit_element_na_str(:xpath, "/html/body/div/div[2]/div[1]/form/div[9]/div[1]", "Текст 'Тип ежемесячных платежей'")
puts('------------------------')

#Заполнение поля "Стоимость недвижимости"
$driver.find_element(:name, "cost").send_keys(stoimost)

#Выбор Первоначального взноса (выпадающий список) в %
dropdown = $driver.find_element(:name, 'start_sum_type') #путь к выпадающему списку
option = Selenium::WebDriver::Support::Select.new(dropdown) #создание опции для выбора элементов списка
option.select_by(:value,'2') #задание варианта выбора по параметру value

#Заполнение поля "Первоначальный взнос"
$driver.find_element(:name, "start_sum").send_keys(vznos)

#Проверка правильно рассчитанного первоначального взноса и отображения его на экране
vznos_so_stranichy = $driver.find_element(:xpath, "/html/body/div/div[2]/div[1]/form/div[3]/div[2]/div[3]").text().gsub(/\s+/, "").gsub(/\руб.+/, "").gsub(/\(+/, "").gsub(/\)+/, "").to_i

vznos = $driver.find_element(:name, "start_sum").attribute('value').to_f
stoimost = $driver.find_element(:name, "cost").attribute('value').gsub(/\s+/, "").to_f
resultat_vznosa = (vznos * stoimost)/100
resultat_vznosa = resultat_vznosa.round
if vznos_so_stranichy == resultat_vznosa and $driver.find_element(:xpath, "/html/body/div/div[2]/div[1]/form/div[3]/div[2]/div[3]").displayed? == true
  print('Первоначальный взнос рассчитан и отображен верно = ', resultat_vznosa, ' руб.')
  puts('')
else
  print('Первоначальный взнос рассчитан или отображен с ошибкой')
  puts('')
end

#Проверка правильности рассчитанной суммы кредита и его отображения на экране
summa_so_stranichy = $driver.find_element(:xpath, "/html/body/div/div[2]/div[1]/form/div[4]/div[2]/span[1]").text().gsub(/\s+/, "").to_i
resultat_summa = $driver.find_element(:name, "cost").attribute('value').gsub(/\s+/, "").to_i - resultat_vznosa
if summa_so_stranichy == resultat_summa and $driver.find_element(:xpath, "/html/body/div/div[2]/div[1]/form/div[4]/div[2]/span[1]").displayed? == true
  print('Сумма кредита рассчитана и отображена верно = ', resultat_summa, ' руб.')
  puts('')
else
  print('Сумма кредита рассчитана или отображена с ошибкой')
  puts('')
end
puts('------------------------')

#Заполнение поля "Срок кредита"
$driver.find_element(:xpath, "/html/body/div/div[2]/div[1]/form/div[6]/div[2]/div[1]/input").send_keys(srok)

#Генерация рандомного числа от 5 до 12
rnd = rand(5..12)
print('Сгенерированное число для процентной ставки: ', rnd)
puts('')
puts('------------------------')
#Добавление сгенерированного числа в поле "Процентная ставка"
$driver.find_element(:xpath, "/html/body/div/div[2]/div[1]/form/div[8]/div[2]/div[1]/input").send_keys(rnd)

aut = $driver.find_element(:xpath, "//*[@id='payment-type-1']").selected? #проверка нажатия радиобаттон 1
deff = $driver.find_element(:xpath, "//*[@id='payment-type-2']").selected? #проверка, что радиобаттон 2 не нажата
print('Состояние радиобаттон "Аннуитетные": ', aut)
puts('')
print('Состояние радиобаттон "Дифференцированные": ', deff)
puts('')
puts('------------------------')

#Проверка ежемесячного платежа по формуле

i = (rnd/100.0)/12.0 #рассчёт процентной ставки в месяц
#Получить значение из поля "срок кредита" и перевод из str в int
n = $driver.find_element(:name, 'period').attribute('value').to_i
numerator = (i*(1+i)**(n*12)) #числитель формулы
denominater = (1+i)**(n*12) -1 #знаменатель формулы
platezh = resultat_summa*(numerator/denominater) #формула
result = platezh.round(2) #округление до 2-х знаков
print('Рассчитаная сумма ежемесячного платежа: ', result, ' руб.')
puts('')

#Нажатие на кнопку "Рассчитать"
$driver.find_element(:xpath, "/html/body/div/div[2]/div[1]/form/div[11]/div/input").click

wait = Selenium::WebDriver::Wait.new(timeout: 10) #задержка на странице, чтобы прогрузились данные "ежемесячный платёж"
#Ожидание пока число Ежемесячного платежа не появится на странице
wait.until { $driver.find_element(css: 'body > div > div.columns-container > div.content-column > form > div.row.no-gutters.split > div:nth-child(1) > div:nth-child(1) > div.calc-fright > div').displayed?}

#Получение числа из Ежемесячного платежа
price1 = $driver.find_element(css: 'body > div > div.columns-container > div.content-column > form > div.row.no-gutters.split > div:nth-child(1) > div:nth-child(1) > div.calc-fright > div').attribute("innerHTML")
price2 = price1.gsub(/\s+/, "").gsub(/\,+/, ".")
print('Сумма платежа с сайта: ', price2, ' руб.')
puts('')
puts('------------------------')

print('Соответствует ли значение с сайта значению, рассчитанному по формуле?')
if price2.to_f.round(2)==result
  puts(' Да')
else
  print(' Нет')
end

sleep(4) #Задержка положения на экране на 4 сек.